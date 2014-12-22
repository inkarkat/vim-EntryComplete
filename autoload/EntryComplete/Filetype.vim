" EntryComplete/Filetype.vim: Supply filetype-specific entries from a base directory.
"
" DEPENDENCIES:
"
" Copyright: (C) 2014 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.00.001	19-Dec-2014	file creation
let s:save_cpo = &cpo
set cpo&vim

function! EntryComplete#Filetype#Sources()
    return ingo#collections#Flatten1(
    \   map(s:GetFiletypes(), 's:GetEntriesFilespecs(v:val)')
    \)
endfunction

function! s:GetFiletypes()
    return split(s:GetFiletype(&filetype), '\.')
endfunction
function! s:GetFiletype( filetype )
    return (empty(a:filetype) ? 'default' : a:filetype)
endfunction

function! s:GetEntriesFilespecs( filetype )
    return
    \   ingo#compat#globpath(s:CustomPath(), a:filetype, 0, 1) +
    \   ingo#compat#globpath(&runtimepath, 'entries/' . a:filetype, 0, 1)
endfunction
function! s:CustomPath()
    let l:path = ''

    if exists('g:EntryComplete_FiletypeEntriesPath') && ! empty(g:EntryComplete_FiletypeEntriesPath)
	let l:path = g:EntryComplete_FiletypeEntriesPath
    endif

    if exists('b:EntryComplete_FiletypeEntriesPath') && ! empty(b:EntryComplete_FiletypeEntriesPath)
	let l:path = b:EntryComplete_FiletypeEntriesPath . (empty(l:path) ? '' : ',' . l:path)
    endif

    return l:path
endfunction

let &cpo = s:save_cpo
unlet s:save_cpo
" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
