if exists("b:current_syntax")
  finish
endif

runtime! syntax/markdown.vim syntax/markdown/*.vim

:syntax case ignore

let cur_file_name = bufname("%")
let dir = fnamemodify(cur_file_name, ":p:h")
if !empty(dir)
  if (dir ==# ".")
    let dir = ""
  else
    let dir = dir."/"
  endif
endif
let filelist = split(globpath(dir, '*'))
let g:wordlinks = "syntax keyword wordlinksLink"

for f in filelist
  let g:wordlinks = g:wordlinks." ".fnamemodify(f, ":t:r")
endfor

exec wordlinks
highligh link wordlinksLink Underlined

let b:current_syntax = "markdown-links"
