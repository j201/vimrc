" vim set foldmarker={{{,}}}

set nocompatible
source $VIMRUNTIME/mswin.vim
behave mswin

" MyDiff function"{{{
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
"}}}

function! ConEmu() 
	" Should be more complex to find conemu - assumes ComEmu64 is in the PATH
	let cwd = getcwd()
	execute '!start ConEmu64.exe /cmd cmd "-new_console:d:' . escape(cwd, '\') . '"'
endfunction

function! LSN()
	ls
	let n = input('Buffer number: ')
	execute 'b ' . n
endfunction

" Commands"{{{
com! LS echo system('dir')
com! -nargs=1 MKD call system('mkdir <args>')
com! CSCrun !csc /out:"%:r.exe" "%" && "%:r.exe"
com! ConEmu call ConEmu()
com! -nargs=* E e <args> " Because I often press :E instead of :e
com! -nargs=1 New enew | setf <args>
"}}}

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

" `set` settings"{{{
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
set scrolloff=10		" Always show at least ten lines above/below cursor
set sidescrolloff=5		" Always show at least 5 columns beside cursor
set ff=unix
set ffs=unix,dos		" FFS, use unix line endings!
set ignorecase			" Ignore case by default in searches
set spelllang=en_ca		" Rocks and trees and trees and rocks...
set autoread			" Autoreload files changed externally
set formatoptions-=r	" Don't repeat comment leaders
set formatoptions-=c	" Don't repeat comment leaders
set formatoptions-=o	" Don't repeat comment leaders
set viewdir=~/.vim/view " Set view folder
set noerrorbells visualbell t_vb= " No error bells or flashing
autocmd GUIEnter * set visualbell t_vb=
"}}}

" Status line
set statusline=%.50F%m\ \ %y\ \ \ \ cwd:%{getcwd()}%=line:%l/%L\ \ col:%c\ 
set laststatus=2

" Key mappings "{{{
noremap <C-left>	<Esc>:bp<CR>
noremap <C-right>	<Esc>:bn<CR>
nnoremap <C-s>		:w!<CR>
inoremap <C-s>		<Esc>:w!<CR>
map <F3> :source ~/.vim/_session <cr>     " Restore previous session
nnoremap <esc> :noh<return><esc>

" CTRL-U in insert mode deletes a lot.  Use CTRL-G u to first break undo,
" so that you can undo CTRL-U after inserting a line break.
inoremap <C-U> <C-G>u<C-U>

nnoremap Q @q 

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
omap aa :normal Vaa<CR>

" Continuously indent in visual mode
vnoremap < <gv
vnoremap > >gv

" Leader commands - file management and temporary commands
nnoremap <Leader><Leader>	:confirm bd<CR>
nnoremap <Leader>v :e $MYVIMRC<CR>
nnoremap <Leader>cd :cd %:h<CR>

" FT commands
nnoremap <Leader>fjs	:setf javascript<CR>
nnoremap <Leader>fcs	:setf cs<CR>
nnoremap <Leader>fclj	:setf clojure<CR>
nnoremap <Leader>fhs	:setf haskell<CR>
nnoremap <Leader>fcpp	:setf cpp<CR>

" Comma commands - editing
" Replace word under cursor
nnoremap ,r :%s/\V\C\<<C-R><C-W>\>//g<Left><Left>
" Open gundo
nnoremap ,gu :GundoShow<CR>
" Close gundo
nnoremap ,gc :GundoHide<CR>

" Add j/k to jumplist
nnoremap <silent> k :<C-U>execute 'normal!' (v:count > 1 ? "m'" . v:count : 'g') . 'k'<CR>
nnoremap <silent> j :<C-U>execute 'normal!' (v:count > 1 ? "m'" . v:count : 'g') . 'j'<CR>

" Don't change registers on visual paste
vnoremap p "_dP
"}}}

" File local settings"{{{
set nocindent " No C indentation by default - it seems to break smartindent

au FileType txt,text,md,markdown setlocal formatoptions+=t		" autowrap
au FileType txt,text,md,markdown setlocal wrap			" Wrap text - NOT WORKING

au FileType html,xml imap <buffer> <// </<<C-X><C-O>

au GUIEnter * simalt ~x " Open maximized
au VimLeave * mksession! ~/.vim/_session"

au FileType * setlocal formatoptions-=c formatoptions-=o formatoptions-=r
"}}}

" Vundle stuff"{{{
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" My bundles
" Pretty status line and more importantly, buffer line
Plugin 'bling/vim-airline'
" Clojure quasi-repl
Plugin 'tpope/vim-fireplace'
" Clojure runtime files
Plugin 'guns/vim-clojure-static'
" Syntax checker
Plugin 'scrooloose/syntastic'
" Node repl interface
Plugin 'intuited/vim-noderepl'
" Bracket manipulation
Plugin 'tpope/vim-surround'
" Markdown syntax
Plugin 'hallison/vim-markdown'
" Trying this instead of JavaScript-Indent
Plugin 'pangloss/vim-javascript'
" Fuzzy file searching
Plugin 'kien/ctrlp.vim'
" gof and got to open file in explorer/terminal
Plugin 'justinmk/vim-gtfo'
" Smooth scrolling
Plugin 'terryma/vim-smooth-scroll'
" Automatically load autocomplete menu
Plugin 'neocomplcache'
" C# syntax/highlighting
" TODO: switch to OrangeT/vim-csharp if it ever get fixed up
Plugin 'j201/vim-csharp'
" Add :Rename command
Plugin 'Rename'
" Typescript syntax etc.
Plugin 'leafgarland/typescript-vim'
" Camel case motions and text objects
Plugin 'bkad/CamelCaseMotion'
" A better way to make
Plugin 'tpope/vim-dispatch'
" Auto-commenting with motions
Plugin 'tpope/vim-commentary'
" Highlight css colours
Plugin 'ap/vim-css-color'
" Faster HTML editing - see http://emmet.io/
Plugin 'mattn/emmet-vim'
" Less syntax
Plugin 'groenewege/vim-less'
" Indent guides (<Leader>ig)
Plugin 'nathanaelkane/vim-indent-guides'
" Abbreviations and substitutions that handle case and variants
Plugin 'abolish.vim'
" Lisp editing
Plugin 'paredit.vim'
" Fix colorschemes for the terminal
Plugin 'CSApprox'
" Visualize the undo tree
Plugin 'sjl/gundo.vim'
" Snippet runner
Plugin 'SirVer/ultisnips'
" Snippets
Plugin 'honza/vim-snippets'
" Ultisnips <-> Neocomplcache compat
Plugin 'JazzCore/neocomplcache-ultisnips'
" Git integration
Plugin 'tpope/vim-fugitive' 

call vundle#end()
filetype plugin indent on
syntax on
"}}}

" Plugin settings"{{{
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_section_b = '%y'
let g:airline_section_c = '%.50F%m'
let g:airline_section_x = 'cwd:%{getcwd()}'
let g:airline_section_z = '%=line:%l/%L col:%c'
let g:airline_section_warning = ''
let g:airline_theme = 'molokai'
let g:airline_left_sep = ''
let g:airline_right_sep = ''

let g:miniBufExplSortBy="number"

let g:syntastic_javascript_checkers=['jshint']
let g:syntastic_typescript_tsc_args='--target ES5 --module commonjs'

let g:ctrlp_open_new_file = 'r'
let g:ctrlp_extensions = ['buffertag']
" Open CtrlP for old files
nnoremap <Leader>o :CtrlPMRUFiles<Enter>
let g:ctrlp_custom_ignore='\v[\/](node_modules|target|out)$'

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

let g:UltiSnipsExpandTrigger="<c-l>"
let g:UltiSnipsJumpForwardTrigger="<c-b>"
let g:UltiSnipsJumpBackwardTrigger="<c-z>"

" vim-typescript: cindent seems to break the indentation
autocmd FileType typescript setlocal nocindent

autocmd FileType haskell setlocal expandtab

autocmd FileType json nnoremap ,f :%!python -m json.tool<CR>
autocmd FileType json set syntax=javascript

" paredit options
let g:paredit_leader = ','
let g:paredit_electric_return = 0
autocmd FileType clojure nmap ,i ,Wa
autocmd FileType clojure vmap ,i ,Wa

" add more indentation in html
let g:html_indent_inctags = "html,body,head,tbody,li"

let g:gundo_close_on_revert = 1
let g:gundo_right = 1

"}}}

autocmd FileType haskell setlocal expandtab

if (executable('ConEmu64.exe'))
	nmap got :ConEmu<CR>
endif

let g:colorizer_startup = 1

" abbreviations
au User AfterBundles Abolish hte the

" Save folds
au BufWinLeave ?* mkview
au BufWinEnter ?* silent loadview

" Auto reload vimrc
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC | AirlineRefresh
augroup END " }

" Load local settings if they exist
if filereadable($HOME . "/_vimrclocal")
	so $HOME/_vimrclocal
endif
