" File: markdown-links.vim
" Author: Charles Nodell

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
  nnoremap <bs> :b#<cr>
endif
