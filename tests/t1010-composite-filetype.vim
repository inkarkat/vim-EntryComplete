" Test completion of entries with a composite filetype.

set completefunc=EntryComplete#EntryComplete

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(3)

setfiletype vim.text
call IsMatchesInIsolatedLine('jump', ['jumps | version'], 'begin match for jump')
call IsMatchesInIsolatedLine('The', ['The quick brown fox jumps over the lazy dog.', 'They got upset.'], 'begin matches for The')
call IsMatchesInIsolatedLine('fox', ["let l:foxIdx = stridx(a:text, 'fox')", 'The quick brown fox jumps over the lazy dog.', '-- "Hey, fox!" --'], 'anywhere matches for fox')

call vimtest#Quit()
