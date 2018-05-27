" EntryComplete.vim: Insert mode completion based on lines in designated files or buffers.
"
" DEPENDENCIES:
"   - Requires Vim 7.0 or higher.
"   - EntryComplete.vim autoload script
"
" Copyright: (C) 2014-2018 Ingo Karkat
"   The VIM LICENSE applies to this script; see ':help copyright'.
"
" Maintainer:	Ingo Karkat <ingo@karkat.de>

" Avoid installing twice or when in unsupported Vim version.
if exists('g:loaded_EntryComplete') || (v:version < 700)
    finish
endif
let g:loaded_EntryComplete = 1

"- configuration ---------------------------------------------------------------

if ! exists('g:EntryComplete_Sources')
    if v:version < 702 | runtime autoload/EntryComplete/Filetype.vim | endif  " The Funcref doesn't trigger the autoload in older Vim versions.
    let g:EntryComplete_Sources = [function('EntryComplete#Filetype#Sources')]
endif


"- mappings --------------------------------------------------------------------

inoremap <silent> <expr> <Plug>(EntryComplete) EntryComplete#Expr()
if ! hasmapto('<Plug>(EntryComplete)', 'i')
    imap <C-x><C-e> <Plug>(EntryComplete)
endif

" vim: set ts=8 sts=4 sw=4 noexpandtab ff=unix fdm=syntax :
