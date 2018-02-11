" Test completion from buffer.

let s:completions = ['default one', 'next one', 'designed']
split source
call setline(1, s:completions)
wincmd p

let g:EntryComplete_Sources = [bufnr('source')]
set completefunc=EntryComplete#EntryComplete

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(3)
call IsMatchesInIsolatedLine('d', ['default one', 'designed'], 'begin matches for d')
call IsMatchesInIsolatedLine('one', ['default one', 'next one'], 'anywhere matches for one')
call IsMatchesInIsolatedLine('', s:completions, 'any match for all')

call vimtest#Quit()
