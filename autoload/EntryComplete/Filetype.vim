" EntryComplete/Filetype.vim: Supply filetype-specific entries from a base directory.
"
" DEPENDENCIES:
"   - ingo/collections.vim autoload script
"   - ingo/compat.vim autoload script
"
" Copyright: (C) 2014-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
let s:save_cpo = &cpo
set cpo&vim

function! EntryComplete#Filetype#Sources()
    return ingo#collections#Flatten1(
    \   map(s:GetFiletypes(), 'EntryComplete#Filetype#GetEntriesFilespecs(v:val)')
    \)
endfunction

function! s:GetFiletypes()
    return split(s:GetFiletype(&filetype), '\.')
endfunction
function! s:GetFiletype( filetype )
    return (empty(a:filetype) ? 'default' : a:filetype)
endfunction

function! EntryComplete#Filetype#GetEntriesFilespecs( filetype )
    return
    \   EntryComplete#Filetype#GetDefaultEntriesFilespecs(a:filetype) +
    \   EntryComplete#Filetype#GetNamedEntriesFilespecs(a:filetype, '*')
endfunction
function! EntryComplete#Filetype#GetDefaultEntriesFilespecs( filetype )
    return
    \   ingo#compat#globpath(s:CustomPath(), a:filetype . '.txt', 0, 1) +
    \   ingo#compat#globpath(&runtimepath, 'entries/' . a:filetype . '.txt', 0, 1)
endfunction
function! EntryComplete#Filetype#GetNamedEntriesFilespecs( filetype, entryGlob )
    return
    \   ingo#compat#globpath(s:CustomPath(), a:filetype . '/' . a:entryGlob . '.txt', 0, 1) +
    \   ingo#compat#globpath(&runtimepath, 'entries/' . a:filetype . '/' . a:entryGlob . '.txt', 0, 1)
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
