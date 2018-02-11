" Test completion of entries.

set completefunc=EntryComplete#EntryComplete

source ../helpers/completetest.vim
call vimtest#StartTap()
call vimtap#Plan(9)
call IsMatchesInIsolatedLine('', ['default text'], 'any match for no filetype')
call IsMatchesInIsolatedLine('doesnotexist', [], 'no match for doesnotexist')

setfiletype text
call IsMatchesInIsolatedLine('The', ['The quick brown fox jumps over the lazy dog.', 'They got upset.'], 'begin matches for The')
call IsMatchesInIsolatedLine('brown', ['brown sugar'], 'begin match for brown')
call IsMatchesInIsolatedLine('quick', ['The quick brown fox jumps over the lazy dog.'], 'anywhere match for quick')
call IsMatchesInIsolatedLine('Hey', ['-- "Hey, fox!" --'], 'non-keyword begin match for Hey')
call IsMatchesInIsolatedLine('laz', ['The quick brown fox jumps over the lazy dog.', 'Don''t be lazy!'], 'anywhere matches for laz')
call IsMatchesInIsolatedLine('dog', ['The quick brown fox jumps over the lazy dog.', ' My dog is Lucky. '], 'anywhere matches for dog')
call IsMatchesInIsolatedLine('My', [' My dog is Lucky. '], 'non-keyword begin match for My')

call vimtest#Quit()
