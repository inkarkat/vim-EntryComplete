" EntryComplete.vim: Insert mode completion based on lines in designated files or buffers.
"
" DEPENDENCIES:
"   - CompleteHelper.vim plugin
"   - ingo-library.vim plugin
"
" Copyright: (C) 2014-2021 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! EntryComplete#EntryComplete( findstart, base )
    if a:findstart
	" Locate the start of the keyword.
	let l:startCol = searchpos('\k*\%#', 'bn', line('.'))[1]
	if l:startCol == 0
	    let l:startCol = col('.')
	endif
	return l:startCol - 1 " Return byte index, not column.
    else
	let l:Sources = ingo#plugin#setting#GetFromScope('EntryComplete_Sources', ['w', 'b', 'g'], [])
	if empty(l:Sources)
	    call ingo#msg#ErrorMsg('No sources defined')
	    return []
	endif

	" Find matches starting with a:base.
	let l:matches = []
	let l:pattern = '^\%(\k\@!.\)*\V' . escape(a:base, '\')
	for l:Source in l:Sources
	    let l:matches += s:GetMatches(l:Source, l:pattern)
	    unlet l:Source
	endfor

	if empty(l:matches)
	    echohl ModeMsg
	    echo '-- User defined completion (^U^N^P) -- Anywhere search...'
	    echohl None

	    let l:pattern = '\<\V' . escape(a:base, '\')
	    for l:Source in l:Sources
		let l:matches += s:GetMatches(l:Source, l:pattern)
		unlet l:Source
	    endfor
	endif

	return l:matches
    endif
endfunction
function! s:GetMatches( Source, pattern )
    if type(a:Source) == type(0)
	let l:lines = getbufline(a:Source, 1, '$')
	let l:menu = '' . a:Source
    elseif type(a:Source) == type(function('tr'))
	" Resolve the available filespecs for entries, and turn those into
	" matches by recursively invoking this function.
	let l:matches = []
	for l:ResolvedSource in call(a:Source, [])
	    let l:matches += call('s:GetMatches', [l:ResolvedSource, a:pattern])
	endfor
	return l:matches
    elseif type(a:Source) == type([])
	return filter(
	\   map(copy(a:Source), 's:MakeCompleteEntry(v:val)'),
	\   'v:val.word =~ a:pattern'
	\)
    else
	try
	    let l:lines = readfile(a:Source)
	    let l:menu = fnamemodify(a:Source, ':t:r')
	catch /^Vim\%((\a\+)\)\=:/
	    call ingo#msg#VimExceptionMsg()
	    let l:lines = []
	endtry
    endif

    let [l:parseExpr, l:headerMapping] = s:GetHeaderLine(get(l:lines, 0, ''))
    if empty(l:headerMapping)
	return map(
	\   filter(l:lines, 'v:val =~ a:pattern'),
	\   'CompleteHelper#Abbreviate#Word({"word": v:val, "menu": l:menu})'
	\)
    else
	return filter(
	\   map(l:lines[1:], 's:ApplyHeaderMapping(v:val, l:parseExpr, l:headerMapping, l:menu)'),
	\   'v:val.word =~ a:pattern'
	\)
    endif
endfunction
function! s:MakeCompleteEntry( item )
    let l:matchObj = (type(a:item) == type({}) ? a:item : {'word': a:item})
    if empty(get(l:matchObj, 'abbr', ''))
	call CompleteHelper#Abbreviate#Word(l:matchObj)
    endif
    return l:matchObj
endfunction

function! s:GetHeaderLine( line )
    let [l:separators, l:items] = ingo#collections#SeparateItemsAndSeparators(a:line, 'word\|abbr\|menu\|info\|kind\|icase\|equal\|dup\|empty\|user_data')
    return [
    \   '\V\^' .
    \   join([''] + map(l:separators, 'escape(v:val, "\\")') + [''], '\(\.\{-}\)') .
    \   '\$',
    \   l:items
    \]
endfunction
function! s:ApplyHeaderMapping( line, parseExpr, headerMapping, defaultMenu )
    let l:matches = matchlist(a:line, a:parseExpr)
    if empty(l:matches)
	return CompleteHelper#Abbreviate#Word({"word": a:line, "menu": a:defaultMenu})
    endif

    let l:matchObj = {'menu': a:defaultMenu}
    for l:idx in range(len(a:headerMapping))
	let l:matchObj[a:headerMapping[l:idx]] = l:matches[l:idx + 1]
    endfor
    return s:MakeCompleteEntry(l:matchObj)
endfunction

function! EntryComplete#Expr()
    set completefunc=EntryComplete#EntryComplete
    return "\<C-x>\<C-u>"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
