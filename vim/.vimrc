" Check existing set values with set <val>?
" Must have
set nocompatible

" Vim Plug
call plug#begin()
" One plugin encompassing linting and fmting
Plug 'dense-analysis/ale', { 'commit': '0b25d712b7978c3b6a3bd968645183377d9f1761' }
call plug#end()

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

" Force encoding to ensure it renders like it would on the terminal
" ~@~Y for apostrophe otherwise (unicode U+0027 vs U+2019)
set encoding=utf-8

" search for upper and lowercase
set ignorecase

" but if user types uppercase - search exactly
set smartcase

" keep the cursor at current column when jumping to other lines
set nostartofline

" use of the status line to show possible completions of : commands
set wildmenu

" set laststatus to show status line even when only one window is shown
" typically only set when on separate multiple windows via -o
set ls=2

" Syntax Toggle
syntax on

" Enable plugins
filetype plugin indent on

" Automatically create `~/.vim/.tmp directory, writable by the group
" Move swp and undo to anywhere but the cwd
" dont create backup
silent execute '!umask 002; mkdir -p ~/.vim/.tmp/'
set directory=~/.vim/.tmp//,/tmp//
set undodir=~/.vim/.tmp//,/tmp//
set nobackup

" Custom dictionary
set spellfile=~/.vim/spell/tech.utf-8.add

" Define a colorscheme
"colorscheme vividchalk
autocmd BufEnter * colorscheme vibrantink
autocmd BufEnter *.nix colorscheme vibrantink
autocmd BufEnter *.py colorscheme icansee
autocmd BufEnter *.rb colorscheme icansee
autocmd BufEnter *.tf* colorscheme icansee
autocmd BufEnter *.go colorscheme icansee
autocmd BufEnter *.rego colorscheme icansee
autocmd BufEnter *.yaml colorscheme vividchalk
autocmd BufEnter *.yml colorscheme vividchalk

autocmd BufRead,BufNewFile ~/.bashrc.d/* set syntax=sh

" Tab delimited files
autocmd BufNewFile,BufRead *.tsv set ft=tsv
autocmd FileType tsv setlocal softtabstop=8 tabstop=8 noexpandtab

" Fix makefile tabs
autocmd FileType make setlocal noexpandtab

" Enable spellcheck for commit messages
autocmd FileType gitcommit setlocal spell

" ALE preferences
" Check any settings of an open file: ALEInfo

" Only run linters named in ale_linters settings
" I dont want any random surprises
let g:ale_linters_explicit = 1
" Show available linters via :help ale-options
let g:ale_linters = {
\   'go': ['gofmt'],
\   'nix': ['nixpkgs-fmt'],
\   'python': ['black'],
\   'rego': ['opafmt'],
\   'sh': ['shellcheck'],
\   'terraform': ['terraform'],
\}


let g:ale_fixers = {
\   '*': ['remove_trailing_lines', 'trim_whitespace'],
\   'go': ['gofmt'],
\   'nix': ['nixpkgs-fmt'],
\   'terraform': ['terraform'],
\}

" Rubyisms
autocmd BufNewFile Gemfile 0r ~/.vim/templates/ruby/Gemfile

" go
autocmd BufRead,BufNewFile *.go set noet ts=4 sw=4

" goslide
autocmd BufRead,BufNewFile *.slide set filetype=slide

" Nix
autocmd BufRead,BufNewFile *.nix set filetype=nix
autocmd BufNewFile shell.nix 0r ~/.vim/templates/nix/shell.nix

" Terraform
" Make sure vim knows .tf* is correct syntax and not syntax=terraform
autocmd BufNewFile,BufRead *.tf* set syntax=tf

" Yaml
autocmd BufNewFile *.yaml,*.yml 0r ~/.vim/templates/skeleton.yaml

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


" Abbreviations
" inspired by: http://www.guckes.net/Setup/vimrc.mine
" emptysha when using nix drvs
iab emptysha      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";
iab dummysha      sha256 = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=";

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
    let w:checkline_enabled = matchadd('ColorColumn', '\%>121v.\+', 100)
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

" fmt so I dont have to think about it
function! <SID>fmt()
  " TODO: see if we can move this into ale fixer
  if &ft == "json"
    "python35+ doesnt sort keys alpha by default
    "https://hg.python.org/cpython/rev/58a871227e5b
    %!if [ $(command -v python3) ];then python3 -m json.tool;else python -m json.tool;fi
    echo "fmt json"
  " Check to see if global ale_fix var is already enabled
  elseif get(g:, 'ale_fix_on_save') == 1
    let g:ale_fix_on_save = 0
    echo "nofmt" &ft
  " Only fmt on save for whitelisted languages to avoid any crazy surprises
  elseif has_key(g:ale_fixers, &ft) >= 0
    let g:ale_fix_on_save = 1
    echo "fmt" &ft
  elseif &ft == "cert"
    "set textwidth=64
    "call :gq
    "execute "normal! gq"
    echo "fmt cert [not implemented]"
  else
    echo "no fmt filetype match for:" &ft
  endif
endfunction

" Rebuild spell only if .spl is missing
function! RebuildSpell()
  for d in glob('~/.vim/spell/*.add', 1, 1)
    if filereadable(d) && (!filereadable(d . '.spl') || getftime(d) > getftime(d . '.spl'))
      silent exec 'mkspell! ' . fnameescape(d)
    endif
  endfor
endfunction

" Key Bindings

" Disable F1 help since its too close to ESC
nmap <F1> :echo<CR>
imap <F1> <C-o>:echo<CR>

nnoremap <silent> <F5> :call <SID>StripTrailingWhitespaces()<CR>
nnoremap <silent> <F6> :call <SID>CheckLineWidth()<CR>
nnoremap <silent> <F7> :call <SID>CheckSpelling()<CR>
nnoremap <silent> <F8> :call <SID>fmt()<CR>

call RebuildSpell()
