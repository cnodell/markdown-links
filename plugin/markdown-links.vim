" File: markdown-links.vim
" Author: Charles Nodell
" Version: 0.1
" Last Modified: October 27, 2015
"
" "Markdown Links" is a Vim plugin which eases the navigation between imarkdown
" files in a wiki like fashion. Every word in a file becomes a potential link
" that, when selected, will load or create the corresponding file.
"
" Installation
" ------------
" Copy the plugin/markdown-links.vim file into the $HOME/.vim/plugin/ directory
" Copy the syntax/markdown-links.vim file to the $HOEM/.vim/syntax/ directory
" Copy the ftdetect/markdown-links.vim file to the $HOEM/.vim/ftdetect/ directory
"
" Usage
" -----
" Start with a *.mdl file
" Hit the ENTER key when the cursor is on a word you want to link
" The corresponding file is loaded/created in the current buffer and saved
" Hit Shift + ENTER to go back
"
" New files are created in the same directory as the current file and
" will have the same extension as the current file. This means that linked files
" all end up together.
"
" Notes
" -----
"
" - plugin only works with files with the .mdl extension
" - for multi word links, justuse CamelCase or under_scores
" - It is best to avoid using _ for emphasis and instead use *
" - When a new or existing page is opened it is immediatly saved
" - syntax/mardown-links.vim simply underlines links in addition to default
"   markdown syntax highlighting
"   - Links that are also headings or emphasized do not get underlined
"     but still work (unless _ is used for emphasis)
"   - Links will only be underlined in .mdl files
" - files created via links are namerds after the word one linked from in
"   lowercase
" - Link words in the text will link to the same file regardless of case
"
" Contribute
" ----------
" You can fork this project on Github : https://github.com/cnodell/markdown_links
"
" Credits
" -------
" This plugin is a modified version of Henri Bourcereau's WikiLink plugin
" which can be found on Github: https://github.com/mmai/wikilink

function! MarkdownLinkGetWord()
  let word = expand("<cword>")
  " strip leading and trailing spaces
  let word = substitute(word, '^\s*\(.\{-}\)\s*$', '\1', '')
  " make word lowercase
  let word = tolower(word)
  return word
endfunction

function! MarkdownLinkWordFilename(word)
  let file_name = ''
  "Same directory and same extension as the current file
  if !empty(a:word)
    let cur_file_name = bufname("%")
    let dir = fnamemodify(cur_file_name, ":h")
    if !empty(dir)
      if (dir ==# ".")
        let dir = ""
      else
        let dir = dir."/"
      endif
    endif
    let extension = fnamemodify(cur_file_name, ":e")
    if !empty(extension)
      let file_name = dir.a:word.".".extension
    else
      if (match(fnamemodify(cur_file_name, ":t"), '\.') != -1)
        let  file_name = dir.a:word."."
      else
        let file_name = dir.a:word
      endif
    endif
  endif
  return file_name
endfunction

function! MarkdownLinkGotoLink()
  let link = MarkdownLinkWordFilename(MarkdownLinkGetWord())
  if !empty(link)
    "Search in subdirectories
    let mypath =  fnamemodify(bufname("%"), ":p:h")."/**"
    let existing_link = findfile(link, mypath)
    if !empty(existing_link)
      let link = existing_link
    endif
    exec "edit " . link
    exec "write"
    exec "syntax off"
    exec "syntax on"
  endif
endfunction

"search file in the current directory and its ancestors
function! MarkdownLinkFindFile(afile)
  "XXX does not work : return findfile(a:afile, '.;')
  let afile = fnamemodify(a:afile, ":p")
  if filereadable(afile)
    return afile
  else
    let filename = fnamemodify(afile, ":t")
    let file_parentdir = fnamemodify(afile, ":h:h")
    if file_parentdir ==# "//"
      "We've reached the root, no more parents
      return ""
    else
      return MarkdownLinkFindFile(file_parentdir . "/" . filename)
    endif
  endif
endfunction

function! MarkdownLinkDetectFile(word)
  return MarkdownLinkFindFile(MarkdownLinkWordFilename(a:word))
endfunction

if fnamemodify(bufname("%"), ":e") ==? "mdl"
  command! MarkdownLinkGotoLink call MarkdownLinkGotoLink()
  nnoremap <script> <Plug>MarkdownLinkGotoLink :MarkdownLinkGotoLink<CR>
  if !hasmapto('<Plug>MarkdownLinkGotoLink')
    nmap <silent> <CR> <Plug>MarkdownLinkGotoLink
  endif
  "Shift+Return to return to the previous buffer 
"  nmap <S-CR> :b#<CR>
endif
