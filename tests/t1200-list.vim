" Test completion from list of words.

let s:completions = ['listed', 'likewise', 'another from list']
let g:EntryComplete_Sources = [s:completions]
set completefunc=EntryComplete#EntryComplete

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(2)

call IsMatchesInIsolatedLine('li', ['listed', 'likewise'], 'begin matches for li')
call IsMatchesInIsolatedLine('', s:completions, 'any match for all')

call vimtest#Quit()
