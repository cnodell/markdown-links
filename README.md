markdown-links
==============

VIM plugin that allows easy linking between files.

"Markdown Links" is a VIM plugin which eases the navigation between markdown
files in a wiki like fashion. Every word in a file becomes a potential link
that, when selected, will load or create the corresponding file.

Installation
------------

- Copy the plugin/markdown-links.vim file into the $HOME/.vim/plugin/ directory
- Copy the syntax/markdown-links.vim file to the $HOME/.vim/syntax/ directory
- Copy the ftdetect/markdown-links.vim file to the $HOME/.vim/ftdetect/ directory

Usage
-----

- Start with a *.mdl file
- Hit the ENTER key when the cursor is on a word you want to link
- The corresponding file is loaded/created in the current buffer and saved
- Hit Shift + ENTER to go back

New files are created in the same directory as the current file and
will have the same extension as the current file. This means that linked files
all end up together.

Notes
-----

- plugin only works with files with the .mdl extension
- for multi word links, just use CamelCase or under_scores
- It is best to avoid using _ for emphasis and instead use *
- When a new or existing page is opened it is immediatly saved
- syntax/mardown-links.vim simply underlines links in addition to default
  markdown syntax highlighting
  - Links that are also headings or emphasized do not get underlined
    but still work (unless _ is used for emphasis)
  - Links will only be underlined in .mdl files
- files created via links are named after the word one linked from but in
  lowercase
- Link words in the text will link to the same file regardless of case

Contribute
----------

You can fork this project on Github : https://github.com/cnodell/markdown_links

Credits
-------

This plugin is a modified version of Henri Bourcereau's WikiLink plugin
which can be found on Github: https://github.com/mmai/wikilink
