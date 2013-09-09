set nocompatible
source $VIMRUNTIME/vimrc_example.vim
source $VIMRUNTIME/mswin.vim
behave mswin

set diffexpr=MyDiff()
function! MyDiff()
  let opt = '-a --binary '
  if &diffopt =~ 'icase' | let opt = opt . '-i ' | endif
  if &diffopt =~ 'iwhite' | let opt = opt . '-b ' | endif
  let arg1 = v:fname_in
  if arg1 =~ ' ' | let arg1 = '"' . arg1 . '"' | endif
  let arg2 = v:fname_new
  if arg2 =~ ' ' | let arg2 = '"' . arg2 . '"' | endif
  let arg3 = v:fname_out
  if arg3 =~ ' ' | let arg3 = '"' . arg3 . '"' | endif
  let eq = ''
  if $VIMRUNTIME =~ ' '
    if &sh =~ '\<cmd'
      let cmd = '""' . $VIMRUNTIME . '\diff"'
      let eq = '"'
    else
      let cmd = substitute($VIMRUNTIME, ' ', '" ', '') . '\diff"'
    endif
  else
    let cmd = $VIMRUNTIME . '\diff'
  endif
  silent execute '!' . cmd . ' ' . opt . arg1 . ' ' . arg2 . ' > ' . arg3 . eq
endfunction

if has("gui_running")
	set guifont=Consolas:h10
	colorscheme custom_vivify
endif

set tabstop=4			" Set tab width
set shiftwidth=4		" Set autoindent tab width
set noexpandtab			" No spaces, only tabs
"set smarttab			" Tab to the correct location when pressed at the start of a line
set autoindent			" Indents match the last line
set fileformats="unix" " Use unix newlines by default in new buffers
set guioptions-=t		" Remove tearoff menu options
set guioptions-=T		" Hide toolbar
set guioptions+=b		" Show bottom scrollbar
set history=100			" Remember 100 commands
set nowrap				" No line wrapping
set sidescroll=5		" Set horizontal scroll when moving off screen
set encoding=utf-8		" Unicode
set fileencodings=ucs-bom,utf-8,ucs-2le,latin1 " Default encodings to try when opening a file
set backspace=indent,eol,start " Allow backspacing over everything
set shortmess+=I		" No intro message
set nobackup			" No persistent backup...
set writebackup			" But a temporary one
set hidden				" Don't abandon hidden buffers
set selectmode=""		" Always use visual mode, not select mode
set nonumber			" Disable normal numbering
set relativenumber		" Number relative to the cursor
set linebreak			" If wrapping is on, wrap at words
set cryptmethod=blowfish	" Use strong encryption
set incsearch			" Start searching before pressing enter
set scrolloff=1			" Always show at least one line above/below cursor
set sidescrolloff=5		" Always show at least 5 columns beside cursor
set ffs=unix,dos		" FFS, use unix line endings!

" Key mappings
nnoremap <C-left> 	:tabprevious<CR>
nnoremap <C-right>	:tabnext<CR>
nnoremap <C-w><C-t>	:tabnew<CR>
nnoremap <C-w><C-w>	:confirm bd<CR>
inoremap <C-left>	<Esc>:tabprevious<CR>i
inoremap <C-right>	<Esc>:tabnext<CR>i inoremap <C-w><C-t>	<Esc>:tabnew<CR>i
inoremap <C-w><C-w>	<Esc>:confirm bd<CR>i
nnoremap <C-s>		:w!<CR>
inoremap <C-s>		<Esc>:w!<CR>
nnoremap gb			^d0i<Backspace> <Esc>l	
map <F3> :source ~/.vim/_session <cr>     " Restore previous session

" File local settings
set nocindent " No C indentation by default - it seems to break smartindent
au FileType c,h setlocal cindent                            " enable the intelligent cindent (cin) feature for the following files
au FileType java,js,javascript setlocal smartindent                    " enable the smartindenting (si) feature for the following files
au FileType rkt,racket setlocal lisp		" lisp indentation NOTE: OVERRIDES = BEHAVIOUR

au FileType txt,text,md,markdown setlocal formatoptions+=t		" autowrap
au FileType txt,text,md,markdown setlocal wrap			" Wrap text - NOT WORKING

au GUIEnter * simalt ~x " Open maximized
au VimLeave * mksession! ~/.vim/_session

" Vundle stuff
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Bundle 'gmarik/vundle'

" My bundles
" Clojure quasi-repl
Bundle 'tpope/vim-fireplace' 
" Clojure runtime files
Bundle 'guns/vim-clojure-static' 
" Syntax checker
Bundle 'scrooloose/syntastic' 
" Tree file viewer
Bundle 'scrooloose/nerdtree' 
" JS syntax files
Bundle 'jelera/vim-javascript-syntax' 
" Node repl interface
Bundle 'intuited/vim-noderepl' 
" Bracket manipulation
Bundle 'tpope/vim-surround' 
" Markdown syntax
Bundle 'hallison/vim-markdown' 
" JS Indent
Bundle 'JavaScript-Indent'
" Fuzzy file searching
Bundle 'kien/ctrlp.vim'
" Easier motions
Bundle 'Lokaltog/vim-easymotion'
" gof and got to open file in explorer/terminal
Bundle  'justinmk/vim-gtfo'
" Smooth scrolling
Bundle 'terryma/vim-smooth-scroll'
" Automatically load autocomplete menu
Bundle 'neocomplcache'

filetype plugin indent on

" Plugin settings
let g:syntastic_javascript_checkers=['jshint']

let g:neocomplcache_enable_at_startup = 1
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 25, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 25, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 25, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 25, 4)<CR>

" Auto reload vimrc
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }
