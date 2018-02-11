" Test completion of mixed-separator completion objects.

set completefunc=EntryComplete#EntryComplete

runtime tests/helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(4)

setfiletype headermix
call IsMatchesInIsolatedLine('My', ['My bonnie is over the ocean', 'My funny valentine'], 'begin matches for My')
call IsMatchesInIsolatedLine('I', ['I''m singing in the rain'], 'begin match for I')
call IsMatchesInIsolatedLine('ocean', ['My bonnie is over the ocean'], 'anywhere match for ocean')
call IsMatchesInIsolatedLine('doesnotexist', [], 'no match for doesnotexist')

call vimtest#Quit()
