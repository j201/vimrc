set nocompatible
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

function! ConEmu() 
	" Should be more complex to find conemu - assumes ComEmu64 is in the PATH
	let cwd = getcwd()
	execute '!start ConEmu64.exe /dir ' . escape(cwd, '\')
endfunction

com! LS echo system('dir')
com! -nargs=1 MKD call system('mkdir <args>')
com! CSCrun !csc /out:"%:r.exe" "%" && "%:r.exe"
com! ConEmu call ConEmu()
com! -nargs=* E e <args> " Because I often press :E instead of :e
com! -nargs=1 New enew | setf <args>

if has("gui_running")
	set guifont=Consolas:h10
endif

if !has("gui_running") && !empty($CONEMUBUILD)
  set term=xterm
  set t_Co=256
  let &t_AB="\e[48;5;%dm"
  let &t_AF="\e[38;5;%dm"
endif 

colorscheme custom_vivify
let $COLORSCHEME=$VIM . '\vimfiles\colors\' . g:colors_name . '.vim'

set directory=$TEMP		" Temp dir

set ruler				" Show cursor position at bottom
set history=30			" Number of remembered commands
set incsearch			" Incremental searching
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
set number				" Have absolute numbering at the cursor
set relativenumber		" Number relative to the cursor
set linebreak			" If wrapping is on, wrap at words
set cryptmethod=blowfish	" Use strong encryption
set incsearch			" Start searching before pressing enter
set scrolloff=1			" Always show at least one line above/below cursor
set sidescrolloff=5		" Always show at least 5 columns beside cursor
set ffs=unix,dos		" FFS, use unix line endings!
set ignorecase			" Ignore case by default in searches
set spelllang=en_ca		" Rocks and trees and trees and rocks...
set autoread			" Autoreload files changed externally
set formatoptions-=ro	" Don't repeat comment leaders

" Status line
set statusline=%.50F%m\ \ %y\ \ \ \ cwd:%{getcwd()}%=line:%l/%L\ \ col:%c\ 
set laststatus=2

" Key mappings
" nnoremap <C-left>	<Esc>:MBEbp<CR>
" nnoremap <C-right>	<Esc>:MBEbn<CR>
" inoremap <C-left>	<Esc>:MBEbp<CR>i
" inoremap <C-right>	<Esc>:MBEbn<CR>i
nnoremap <C-left>	<Esc>:bp<CR>
nnoremap <C-right>	<Esc>:bn<CR>
inoremap <C-left>	<Esc>:bp<CR>i
inoremap <C-right>	<Esc>:bn<CR>i
nnoremap <C-s>		:w!<CR>
inoremap <C-s>		<Esc>:w!<CR>
map <F3> :source ~/.vim/_session <cr>     " Restore previous session
nnoremap <esc> :noh<return><esc>
" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>
nmap <F3> :TlistToggle<CR>
imap <F3> <Esc>:TlistToggle<CR>
nmap Q <nop> 
" I should find a use for Q
" Use <C-G><char> for greek character
inoremap <C-G> <C-K>*
" Reset the behaviour of <C-Y>
noremap <C-Y> <C-Y>
" Reset the behaviour of <C-A>
noremap <C-A> <C-A>

" Use very nomagic by default - kinda hackish and a bit annoying
nnoremap / /\V
nnoremap :s/ :s/\V
nnoremap :%s/ :%s/\V
vnoremap :s/ :s/\V

" Make Y yank to the end of the line
nnoremap Y y$

" Custom text objects (http://vim.wikia.com/wiki/Creating_new_text_objects)
vnoremap aa :<C-U>silent! normal! ggVG<CR>
vnoremap ia :<C-U>silent! normal! ggVG<CR>
omap aa :normal Vaa<CR>
omap ia :normal Via<CR>

" Continuously indent in visual mode
vnoremap < <gv
vnoremap > >gv

" Leader commands - file management and temporary commands
nnoremap <Leader><Leader>	:confirm bd<CR>
nnoremap <Leader>v :e $MYVIMRC<CR>

" Comma commands - editing
nnoremap ,c :Crunch 
" Replace word under cursor
nnoremap ,r :%s/\V\C\<<C-R><C-W>\>//g<Left><Left>

" Custom digraphs
:digr E# 8707 A# 8704 d# 8705 s# 8747

" File local settings
set nocindent " No C indentation by default - it seems to break smartindent

au FileType txt,text,md,markdown setlocal formatoptions+=t		" autowrap
au FileType txt,text,md,markdown setlocal wrap			" Wrap text - NOT WORKING

au GUIEnter * simalt ~x " Open maximized
au VimLeave * mksession! ~/.vim/_session

" Vundle stuff
set rtp+=~/.vim/bundle/vundle
call vundle#rc()
Bundle 'gmarik/vundle'

" My bundles
" Buffers as tabs, forked from fholgado
Bundle 'j201/minibufexpl.vim'
" Clojure quasi-repl
Bundle 'tpope/vim-fireplace' 
" Clojure runtime files
Bundle 'guns/vim-clojure-static' 
" Syntax checker
Bundle 'scrooloose/syntastic' 
" JS syntax files
" Bundle 'jelera/vim-javascript-syntax' 
" Node repl interface
Bundle 'intuited/vim-noderepl' 
" Bracket manipulation
Bundle 'tpope/vim-surround' 
" Markdown syntax
Bundle 'hallison/vim-markdown' 
" JS Indent
" Bundle 'JavaScript-Indent'
" Trying this instead of JavaScript-Indent
Bundle 'pangloss/vim-javascript'
" Fuzzy file searching
Bundle 'kien/ctrlp.vim'
" gof and got to open file in explorer/terminal
Bundle  'justinmk/vim-gtfo'
" Smooth scrolling
Bundle 'terryma/vim-smooth-scroll'
" Automatically load autocomplete menu
Bundle 'neocomplcache'
" C# syntax/highlighting
Bundle 'OrangeT/vim-csharp'
" Add :Rename command
Bundle 'Rename'
" Taglist sidebar
Bundle 'taglist.vim'
" Typescript syntax etc.
Bundle 'leafgarland/typescript-vim'
" Camel case motions and text objects
Bundle 'bkad/CamelCaseMotion'
" A better calculator
Bundle 'arecarn/crunch'
" A better way to make
Bundle 'tpope/vim-dispatch'
" Auto-commenting with motions
Bundle 'tpope/vim-commentary'
" Highlight css colours
Bundle 'ap/vim-css-color'
" Faster HTML editing - see http://emmet.io/
Bundle 'mattn/emmet-vim'
" Less syntax
Bundle 'groenewege/vim-less'
" Indent guides (<Leader>ig)
Bundle 'nathanaelkane/vim-indent-guides'
" Abbreviations and substitutions that handle case and variants
Bundle 'abolish.vim'
" Lisp editing
Bundle 'paredit.vim'
" Fix colorschemes for the terminal
Bundle 'CSApprox'

filetype plugin indent on
syntax on

" Plugin settings
let g:miniBufExplSortBy="number"

let g:syntastic_javascript_checkers=['jshint']

let g:ctrlp_open_new_file = 'r'
let g:ctrlp_extensions = ['buffertag']
" Open CtrlP for old files
nnoremap <Leader>o :CtrlPMRUFiles<Enter>
let g:ctrlp_custom_ignore='\v[\/](node_modules|target)$'

let g:neocomplcache_enable_at_startup = 1
let g:neocomplcache_min_syntax_length = 2
inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
inoremap <expr><CR> neocomplcache#close_popup()."\<CR>"

noremap <silent> <c-u> :call smooth_scroll#up(&scroll, 25, 2)<CR>
noremap <silent> <c-d> :call smooth_scroll#down(&scroll, 25, 2)<CR>
noremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 25, 4)<CR>
noremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 25, 4)<CR>

let Tlist_Auto_Open=0
let Tlist_Show_One_File = 1
let Tlist_Use_SingleClick = 1

let g:user_emmet_install_global = 0
autocmd FileType html,css EmmetInstall
autocmd FileType html,css imap <C-E> <C-Y>,

let g:indent_guides_color_change_percent = 5
let g:indent_guides_guide_size = 1

" vim-typescript: cindent seems to break the indentation
autocmd FileType typescript setlocal nocindent

" paredit options
let g:paredit_leader = ','
let g:paredit_electric_return = 0
autocmd FileType clojure nmap ,i ,Wa
" run call PareditInitBuffer() to start it

" add more indentation in html
:let g:html_indent_inctags = "html,body,head,tbody,li"

if (executable('ConEmu64.exe'))
	nmap got :ConEmu<CR>
endif

let g:colorizer_startup = 1

" abbreviations
au User AfterBundles Abolish hte the

" Auto reload vimrc
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC
augroup END " }

" Load local settings if they exist
if filereadable($HOME . "/_vimrclocal")
	so $HOME/_vimrclocal
endif
