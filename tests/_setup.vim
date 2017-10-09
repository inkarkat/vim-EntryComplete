call vimtest#AddDependency('vim-ingo-library')
call vimtest#AddDependency('vim-CompleteHelper')

runtime plugin/EntryComplete.vim
let &runtimepath = expand('<sfile>:p:h') . ',' . &runtimepath
