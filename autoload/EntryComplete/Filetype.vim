" EntryComplete/Filetype.vim: Supply filetype-specific entries from a base directory.
"
" DEPENDENCIES:
"   - ingo/collections.vim autoload script
"   - ingo/compat.vim autoload script
"
" Copyright: (C) 2014-2017 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>
"
" REVISION	DATE		REMARKS
"   1.20.003	25-Aug-2017	Expose
"				EntryComplete#Filetype#GetEntriesFilespecs().
"   1.20.002	09-Mar-2017	CHG: Use *.txt file extension for default entry
"				files. This allows to put backups in the same
"				directory without having them picked up.
"				ENH: By default, also look into
"				.../entries/{filetype}/*.txt for entries. This
"				allows to easily use multiple entry sources for
"				a filetype.
"   1.00.001	19-Dec-2014	file creation
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
