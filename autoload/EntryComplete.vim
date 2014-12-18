" EntryComplete.vim: Insert mode completion based on lines in designated files or buffers.
"
" DEPENDENCIES:
"   - CompleteHelper/Abbreviate.vim autoload script
"   - ingo/msg.vim autoload script
"   - ingo/plugin/setting.vim autoload script
"
" Copyright: (C) 2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.001	18-Dec-2014	file creation
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
	let l:sources = ingo#plugin#setting#GetFromScope('EntryComplete_Sources', ['w', 'b', 'g'], [])
	if empty(l:sources)
	    call ingo#msg#ErrorMsg('No sources defined')
	    return []
	endif

	" Find matches starting with a:base.
	let l:matches = []
	let l:pattern = '^\%(\k\@!.\)*\V' . escape(a:base, '\')
	for l:source in l:sources
	    let l:matches += s:GetMatches(l:source, l:pattern)
	endfor

	if empty(l:matches)
	    echohl ModeMsg
	    echo '-- User defined completion (^U^N^P) -- Anywhere search...'
	    echohl None

	    let l:pattern = '\<\V' . escape(a:base, '\')
	    for l:source in l:sources
		let l:matches += s:GetMatches(l:source, l:pattern)
	    endfor
	endif

	return l:matches
    endif
endfunction
function! s:GetMatches( source, pattern )
    if type(a:source) == type(0)
	let l:lines = getbufline(a:source, 1, '$')
	let l:menu = '' . a:source
    else
	try
	    let l:lines = readfile(a:source)
	    let l:menu = fnamemodify(a:source, ':t')
	catch /^Vim\%((\a\+)\)\=:/
	    call ingo#msg#VimExceptionMsg()
	    let l:lines = []
	endtry
    endif

    return map(
    \   filter(l:lines, 'v:val =~ a:pattern'),
    \   'CompleteHelper#Abbreviate#Word({"word": v:val, "menu": l:menu})'
    \)
endfunction

function! EntryComplete#Expr()
    set completefunc=EntryComplete#EntryComplete
    return "\<C-x>\<C-u>"
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
