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

" Fix makefile tabs
autocmd FileType make setlocal noexpandtab

" Rubyisms
autocmd BufNewFile Gemfile 0r ~/.vim/templates/ruby/Gemfile

" Terraform specific configs
let g:terraform_fmt_on_save=1
let g:terraform_align=1

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

" Make JSON sane
function! <SID>SanitizeJSON()
  %!python -m json.tool
  echo "Sanitizing JSON"
endfunction

" Key Bindings
nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>
nnoremap <silent> <F6> :call <SID>CheckLineWidth()<CR>
nnoremap <silent> <F7> :call <SID>CheckSpelling()<CR>
nnoremap <silent> <F8> :call <SID>SanitizeJSON()<CR>
