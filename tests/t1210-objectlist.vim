" Test completion from list of match objects.

let g:EntryComplete_Sources = [[
\   {'word': 'listed object'},
\   {'word': 'likewise', 'abbr': 'lw', 'menu': 'from variable', 'info': 'This is additional information potentially shown in the preview window'},
\   {'word': 'another from objects'}
\]]
set completefunc=EntryComplete#EntryComplete

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(3)
call IsMatchesInIsolatedLine('li', ['listed object', 'likewise'], 'begin matches for li')
call IsMatchesInIsolatedLine('', ['listed object', 'likewise', 'another from objects'], 'any match for all')
call IsMatchesInIsolatedLine('obj', ['listed object', 'another from objects'], 'anywhere matches for obj')

call vimtest#Quit()
