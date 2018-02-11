" Test completion from mixed sources.

let s:bufferCompletions = ['default one', 'next one', 'designed']
split source
call setline(1, s:bufferCompletions)
wincmd p
let s:listCompletions = ['listed', {'word': 'likewise', 'menu': 'full object'}, 'another from list']

let g:EntryComplete_Sources = [function('EntryComplete#Filetype#Sources'), bufnr('source'), s:listCompletions]
setfiletype vim
set completefunc=EntryComplete#EntryComplete

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(2)
call IsMatchesInIsolatedLine('', ['another from list', 'default one', 'designed', 'jumps | version', 'let l:foxIdx = stridx(a:text, ''fox'')', 'likewise', 'listed', 'next one'], 'any match for no filetype')
call IsMatchesInIsolatedLine('doesnotexist', [], 'no match for doesnotexist')

call vimtest#Quit()
