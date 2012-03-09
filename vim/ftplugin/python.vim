" Vim filetype plugin file
" Language:	python
" Maintainer:	Johannes Zellner <johannes@zellner.org>
" Last Change:	Wed, 21 Apr 2004 13:13:08 CEST

if exists("b:did_ftplugin") | finish | endif
let b:did_ftplugin = 1

setlocal cinkeys-=0#
setlocal indentkeys-=0#
setlocal include=\s*\\(from\\\|import\\)
setlocal includeexpr=substitute(v:fname,'\\.','/','g')
setlocal suffixesadd=.py
setlocal comments-=:%
setlocal commentstring=#%s

setlocal omnifunc=pythoncomplete#Complete

" Quelques recommandations PEP8
"
" nombre d'espaces par tab
setlocal tabstop=4

" nombre de caracteres utilise pour l'indentation:
setlocal shiftwidth=4

" pour convertir les tabs en espaces
setlocal expandtab

" pour que backspace supprime 4 espaces:
setlocal softtabstop=4

" met en surbrillance les espaces et les tabs en trop
" pas reellement pour le python mais j'aime bien
" highlight RedundantSpaces ctermbg=red guibg=#592929
" match RedundantSpaces /\s\+$\| \+\ze\t\|\t/

" sur pression de la touche F3, highlight les caracteres qui depassent la 80eme colonne
"map <silent> <F3> "<Esc>:match ErrorMsg '\%>80v.\+'<CR>"
" mieux mais en conflit avec ci-dessus:
"highlight OverLength ctermbg=red ctermfg=white guibg=#592929
"match OverLength /\%81v.\+/
" encore mieux (vim >= 7.3 seulement)
set colorcolumn=80
hi ColorColumn ctermbg=lightgrey guibg=#592929

" Pour executer le script python que l'on est en train d'editer, en appuyant sur la touche F4: 
map <silent> <F4> "<Esc>:w!<cr>:!python %<cr>"

" pour utiliser quickfix: taper :make <fichier>
set efm=%C\ %.%#,%A\ \ File\ \"%f\"\\,\ line\ %l%.%#,%Z%[%^\ ]%\\@=%m
set makeprg=python

set foldmethod=indent

set wildignore+=*.pyc

map  ]#   :call PythonCommentSelection()<CR>
vmap ]#   :call PythonCommentSelection()<CR>
map  ]u   :call PythonUncommentSelection()<CR>
vmap ]u   :call PythonUncommentSelection()<CR>

nnoremap <silent> <buffer> ]] :call <SID>Python_jump('/^\(class\\|def\)')<cr>
nnoremap <silent> <buffer> [[ :call <SID>Python_jump('?^\(class\\|def\)')<cr>
nnoremap <silent> <buffer> ]m :call <SID>Python_jump('/^\s*\(class\\|def\)')<cr>
nnoremap <silent> <buffer> [m :call <SID>Python_jump('?^\s*\(class\\|def\)')<cr>

" Comment out selected lines
" commentString is inserted in non-empty lines, and should be aligned with
" the block
function! PythonCommentSelection()  range
  let commentString = "#"
  let cl = a:firstline
  let ind = 1000    " I hope nobody use so long lines! :)

  " Look for smallest indent
  while (cl <= a:lastline)
    if strlen(getline(cl))
      let cind = indent(cl)
      let ind = ((ind < cind) ? ind : cind)
    endif
    let cl = cl + 1
  endwhile
  if (ind == 1000)
    let ind = 1
  else
    let ind = ind + 1
  endif

  let cl = a:firstline
  execute ":".cl
  " Insert commentString in each non-empty line, in column ind
  while (cl <= a:lastline)
    if strlen(getline(cl))
      execute "normal ".ind."|i".commentString
    endif
    execute "normal \<Down>"
    let cl = cl + 1
  endwhile
endfunction

" Uncomment selected lines
function! PythonUncommentSelection()  range
  " commentString could be different than the one from CommentSelection()
  " For example, this could be "# \\="
  let commentString = "#"
  let cl = a:firstline
  while (cl <= a:lastline)
    let ul = substitute(getline(cl),
             \"\\(\\s*\\)".commentString."\\(.*\\)$", "\\1\\2", "")
    call setline(cl, ul)
    let cl = cl + 1
  endwhile
endfunction

noremap <silent> <F8> :source ~/scripts/misc/ipy.vim<CR>

" add all python scripts to taglist
noremap <silent> <F10> :TlistAddFilesRecursive ~/scripts *.py<CR> 

" add tags of my python scripts
set tags+=~/scripts/pytags_scripts
set tags+=~/scripts/tags_numpy
set tags+=~/scripts/tags_scipy
set tags+=~/scripts/tags_sklearn

if exists('*<SID>Python_jump') | finish | endif

fun! <SID>Python_jump(motion) range
    let cnt = v:count1
    let save = @/    " save last search pattern
    mark '
    while cnt > 0
	silent! exe a:motion
	let cnt = cnt - 1
    endwhile
    call histdel('/', -1)
    let @/ = save    " restore last search pattern
endfun

if has("gui_win32") && !exists("b:browsefilter")
    let b:browsefilter = "Python Files (*.py)\t*.py\n" .
		       \ "All Files (*.*)\t*.*\n"
endif
