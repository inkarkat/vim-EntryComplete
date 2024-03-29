ENTRY COMPLETE
===============================================================================
_by Ingo Karkat_

DESCRIPTION
------------------------------------------------------------------------------

Cheat sheets that contain a single phrase, formula, or function invocation per
line can be very helpful and are used by many people. Using such as a
completion source is difficult, though. The full line completion
(i\_CTRL-X\_CTRL-L) considers other buffers, but cannot be restricted to a
single one. And to trigger the completion, the base has to be written on a new
line; you cannot recall a phrase from within an existing one. All of this can
be avoided by using a snippet plugin, but the syntax to define them usually is
more complex (so one cannot directly use one's cheat sheet), and the
additional features interfere with easy definition. Also, not every snippet
plugin offers the popup selection aspect of insert-mode completion, so you may
have to remember the snippet name to recall it.

This plugin provides a highly configurable completion of lines found in
designated files or buffers, triggered by a keyword in front of the cursor.
With its flexibility, you can use custom cheat sheets for a project, filetype,
or particular buffer or window as well as global ones.

### SOURCE

- [Inspiration for this plugin](http://stackoverflow.com/questions/27539429/vim-snippet-phrase-dropdown-menu)

### SEE ALSO

- Check out the CompleteHelper.vim plugin page ([vimscript #3914](http://www.vim.org/scripts/script.php?script_id=3914)) for a full
  list of insert mode completions powered by it.

USAGE
------------------------------------------------------------------------------

    In insert mode, invoke the entry completion via CTRL-X CTRL-E
    You can then search forward and backward via CTRL-N / CTRL-P, as usual.

    CTRL-X CTRL-E           Find matches for entries (i.e. entire lines) from the
                            designated sources configured by
                            g:EntryComplete_Sources.

INSTALLATION
------------------------------------------------------------------------------

The code is hosted in a Git repo at
    https://github.com/inkarkat/vim-EntryComplete
You can use your favorite plugin manager, or "git clone" into a directory used
for Vim packages. Releases are on the "stable" branch, the latest unstable
development snapshot on "master".

This script is also packaged as a vimball. If you have the "gunzip"
decompressor in your PATH, simply edit the \*.vmb.gz package in Vim; otherwise,
decompress the archive first, e.g. using WinZip. Inside Vim, install by
sourcing the vimball or via the :UseVimball command.

    vim EntryComplete*.vmb.gz
    :so %

To uninstall, use the :RmVimball command.

### DEPENDENCIES

- Requires Vim 7.0 or higher.
- Requires the ingo-library.vim plugin ([vimscript #4433](http://www.vim.org/scripts/script.php?script_id=4433)), version 1.019 or
  higher.
- Requires the CompleteHelper.vim plugin ([vimscript #3914](http://www.vim.org/scripts/script.php?script_id=3914)), version 1.50 or
  higher.

CONFIGURATION
------------------------------------------------------------------------------

For a permanent configuration, put the following commands into your vimrc:

This completion uses designated files or buffers as completion sources. You
can configure window-local, buffer-local, or global Lists of sources. A Number
is taken as a Vim buffer, a String specifies a filespec, a List directly
specifies matches (either as simple strings, or match objects as described
under complete-items), a Funcref is invoked without arguments and should
return a List of filespecs / Numbers / Lists:

    let g:EntryComplete_Sources = [bufnr('lines.txt'), expand('~/.vimrc'),
    \   ['foo', 'bar', {'word': 'baz', 'menu': 'my favorite'}]
    \]

Files and buffers can consist of a header line. This must be the first line,
and only contain the words from complete-items. The separators in between
are then used to parse the remaining lines into completion objects. For
example:
```
    word|abbr|menu
    myxomatosis|mixi|A usually fatal viral disease of rabbits.
```

The default global configuration checks for entries in entries/{filetype}.txt
and entries/{filetype}/\*.txt in each 'runtimepath' directory, usually in your
user's configuration in ~/.vim/entries/.
You can add additional directories to be checked via
g:EntryComplete\_FiletypeEntriesPath or b:EntryComplete\_FiletypeEntriesPath.

If you want to use a different mapping, map your keys to the
&lt;Plug&gt;(EntryComplete) mapping target _before_ sourcing the script
(e.g. in your vimrc):

    imap <C-x><C-e> <Plug>(EntryComplete)

CONTRIBUTING
------------------------------------------------------------------------------

Report any bugs, send patches, or suggest features via the issue tracker at
https://github.com/inkarkat/vim-EntryComplete/issues or email (address below).

HISTORY
------------------------------------------------------------------------------

##### 1.21    RELEASEME
- Adapt: Minor: Support new completion attributes "equal" and "user\_data" in
  entry header.

##### 1.20    27-May-2018
- CHG: Use \*.txt file extension for default entry files. This allows to put
  backups in the same directory without having them picked up.
- ENH: By default, also look into .../entries/{filetype}/\*.txt for entries.
  This allows to easily use multiple entry sources for a filetype.
- ENH: Support parsing of files and buffers into complete match objects via a
  header line.
- Expose EntryComplete#Filetype#GetEntriesFilespecs(); it can be useful for
  customizations.

##### 1.10    09-Mar-2017
- ENH: Support Lists of matches / match objects.

##### 1.00    23-Dec-2014
- First published version.

##### 0.01    18-Dec-2014
- Started development.

------------------------------------------------------------------------------
Copyright: (C) 2014-2021 Ingo Karkat -
The [VIM LICENSE](http://vimdoc.sourceforge.net/htmldoc/uganda.html#license) applies to this plugin.

Maintainer:     Ingo Karkat &lt;ingo@karkat.de&gt;
