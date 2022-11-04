" Must have
set nocompatible

" Vim Plug
call plug#begin()
Plug 'vim-syntastic/syntastic', { 'commit': 'd31e270cc8affc6338a9ed44e2efcaec0ca4cd34' }
Plug 'vim-autoformat/vim-autoformat', {'commit': 'd616fcf8a747f86bd3b26004b83ea5b7c7526df1' }
Plug 'fatih/vim-go', {'commit': 'f5d34f40d6757470f40600000c9c08de142d7ced' }
Plug 'LnL7/vim-nix', {'commit': 'a3eed01f4de995a51dfdd06287e44fcb231f6adf' }
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

" Autoformat plugin and whitelist
" NOTE: this plugin requires python be built into vim: vim --version
" https://github.com/vim-autoformat/vim-autoformat#requirement
let g:autoformat_autoindent = 0
let g:autoformat_retab = 0
let g:autoformat_verbosemode = 1

" Toggle autofmt whitelist for fmt func
let g:my_autofmt_whitelist = ['sh', 'python', 'nix', 'terraform']

" Pythonisms
let g:formatters_python = ['autopep8']
let g:formatdef_autopep8 = "'autopep8 - --max-line-length 120'"

" Rubyisms
autocmd BufNewFile Gemfile 0r ~/.vim/templates/ruby/Gemfile

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
let g:go_gopls_enabled = 0

" go-vim ignore warnings for vim < 7.4.1689
let g:go_version_warning = 0
autocmd BufRead,BufNewFile *.slide set filetype=slide

" Nix
autocmd BufRead,BufNewFile *.nix set filetype=nix
" Identifier just needs to be uniq since itll shell out
" based on the formatdef_*
"
" Cannot get hyphens in vars
let g:formatters_nix = ['nixpkgs_fmt']
let g:formatdef_nixpkgs_fmt = "'nixpkgs-fmt'"
autocmd BufNewFile shell.nix 0r ~/.vim/templates/nix/shell.nix

" Yaml
let g:syntastic_yaml_checkers = ['yamllint']
autocmd BufNewFile *.yaml,*.yml 0r ~/.vim/templates/skeleton.yaml

" Rego
let g:formatdef_rego = '"opa fmt"'
let g:formatters_rego = ['rego']
" Default to always autofmt rego
autocmd BufWritePre *.rego Autoformat

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
  " TODO: see if we can move this into autofmt
  if &ft == "json"
    "python35+ doesnt sort keys alpha by default
    "https://hg.python.org/cpython/rev/58a871227e5b
    %!if [ $(command -v python3) ];then python3 -m json.tool;else python -m json.tool;fi
    echo "fmt json"
  " Check to see if autofmt is already loaded
  elseif exists("g:autofmt_loaded")
    "only works since I dont have anything else manipulating BufWrite
    autocmd! BufWrite *
    echo "nofmt" &ft
    unlet g:autofmt_loaded
  " Only fmt on whitelisted languages that way I dont get any crazy surprises about formatting defaults on save
  "
  " Havent found a good way to detect calling Autoformat to be able to toggle it on and off. For now well let and unlet a
  " var to be the toggle
  elseif index(g:my_autofmt_whitelist, &ft) >= 0
    let g:autofmt_loaded = 1
    autocmd BufWrite * Autoformat
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
