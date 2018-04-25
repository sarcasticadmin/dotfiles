" Must have
set nocompatible

" Never fold
set nofoldenable

" Disable Bell (For my sanity)
set noeb vb t_vb=

" Move netrw to home dir
let g:netrw_home=$HOME

" Tab/Paste Preferences
set pastetoggle=<F2>
set backspace=2
set softtabstop=2 shiftwidth=2 expandtab

" search for upper and lowercase
set ignorecase

" but if user types uppercase - search exactly
set smartcase

" Use pathogen to manage vim plugins
call pathogen#infect()

" Syntax Toggle
syntax on

" Enable plugins
filetype plugin indent on

" Define a colorscheme
"colorscheme vividchalk
autocmd BufEnter * colorscheme vibrantink
autocmd BufEnter *.py colorscheme icansee
autocmd BufEnter *.rb colorscheme icansee
autocmd BufEnter *.tf* colorscheme icansee
autocmd BufEnter *.go colorscheme icansee

" Fix makefile tabs
autocmd FileType make setlocal noexpandtab

" Pythonisms
let g:autopep8_max_line_length=120
let g:autopep8_disable_show_diff=1

" Rubyisms
autocmd BufNewFile Gemfile 0r ~/.vim/templates/ruby/Gemfile

" Terraform specific configs
let g:terraform_fmt_on_save=1
let g:terraform_align=1

" goisms
let g:go_disable_autoinstall = 1
let g:go_fmt_autosave=1
let g:go_highlight_functions = 1
let g:go_highlight_methods = 1
let g:go_highlight_structs = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1
let g:go_highlight_fields=1
let g:go_highlight_types=1

" Fix Vim Colors for FreeBSD
if &term =~ "xterm" || &term =~ "screen"
  set t_Co=256
  if has("terminfo")
    let &t_Sf=nr2char(27).'[3%p1%dm'
    let &t_Sb=nr2char(27).'[4%p1%dm'
  else
    let &t_Sf=nr2char(27).'[3%dm'
    let &t_Sb=nr2char(27).'[4%dm'
  endif
endif

" Found at http://vimcasts.org/episodes/tidying-whitespace/
" Toggle Trailing Whitepsace
function! <SID>StripTrailingWhitespaces()
    " Preparation: save last search, and cursor position.
    let _s=@/
    let l = line(".")
    let c = col(".")
    " Do the business:
    %s/\s\+$//e
    " Clean up: restore previous search history, and cursor position
    let @/=_s
    call cursor(l, c)
    echo "Killed Trailing Whitespaces"
endfunction

" Toggle Column limit warning
highlight ColorColumn ctermbg=magenta
function! <SID>CheckLineWidth()
  if !exists('w:checkline_enabled')
    let w:checkline_enabled = matchadd('ColorColumn', '\%>80v.\+', 100)
    echo "Highlighting Long Lines"
  else
    call matchdelete(w:checkline_enabled)
    unlet w:checkline_enabled
    echo "Unhighlighting Long Lines"
  endif
endfunction

" Toggle Spell Checking
function! <SID>CheckSpelling()
  "If spell check is set then disable
  if &spell
    set nospell
    echo "Spell Checking Disabled"
  else
    set spell
    echo "Spell Checking Enabled"
  endif
endfunction

" fmt
function! <SID>fmt()
  if &ft == "json"
    %!python -m json.tool
    echo "fmt json"
  elseif &ft == "python"
    call Autopep8()
    echo "fmt python"
  else
    echo "no filetype match for fmt"
  endif
endfunction

" Key Bindings
nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>
nnoremap <silent> <F6> :call <SID>CheckLineWidth()<CR>
nnoremap <silent> <F7> :call <SID>CheckSpelling()<CR>
nnoremap <silent> <F8> :call <SID>fmt()<CR>
