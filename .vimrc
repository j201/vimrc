set nocompatible

" MyDiff function"{{{
if has("win32") || has("win64")
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
endif
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

function! BufNumReset()
    mksession! ~/.vim/_bnrsession
    %bd
    so ~/.vim/_bnrsession
endfunction

" Commands"{{{
com! LS echo system('dir')
com! -nargs=1 MKD call system('mkdir <args>')
com! CSCrun !csc /out:"%:r.exe" "%" && "%:r.exe"
com! ConEmu call ConEmu()
com! -nargs=* -complete=file E e <args> " Because I often press :E instead of :e
com! -nargs=* -complete=file W w <args>
com! -nargs=* Q q <args>
com! -nargs=* -complete=dir Cd cd <args>
com! -nargs=1 -complete=filetype New enew | setf <args>
com! BufNumReset call BufNumReset()
"}}}

" OS-specific settings{{{
if has("gui_running")
    if has("unix")
        "For some reason, Consolas doesn't look nice on linux mint at least
        set guifont=Ubuntu\ Mono\ 11
    elseif has("win32") || has("win64")
        set guifont=Consolas:h10
        au GUIEnter * simalt ~x " Open maximized
        set directory=$TEMP        " Temp dir
    endif
endif
"}}}

" `set` settings"{{{
set ruler                 " Show cursor position at bottom
set history=30            " Number of remembered commands
set incsearch             " Incremental searching
set tabstop=4             " Set tab width
set shiftwidth=4          " Set autoindent tab width
set noexpandtab           " No spaces, only tabs
"set smarttab             " Tab to the correct location when pressed at the start of a line
set autoindent            " Indents match the last line
set fileformats="unix"    " Use unix newlines by default in new buffers
set guioptions-=t         " Remove tearoff menu options
set guioptions-=T         " Hide toolbar
set guioptions+=b         " Show bottom scrollbar
set history=100           " Remember 100 commands
set nowrap                " No line wrapping
set sidescroll=5          " Set horizontal scroll when moving off screen
set encoding=utf-8        " Unicode
set fileencodings=ucs-bom,utf-8,ucs-2le,latin1 " Default encodings to try when opening a file
set backspace=indent,eol,start " Allow backspacing over everything
set shortmess+=I          " No intro message
set nobackup              " No persistent backup...
set writebackup           " But a temporary one
set hidden                " Don't abandon hidden buffers
set selectmode=""         " Always use visual mode, not select mode
set number                " Have absolute numbering at the cursor
set relativenumber        " Number relative to the cursor
set linebreak             " If wrapping is on, wrap at words
set cryptmethod=blowfish  " Use strong encryption
set incsearch             " Start searching before pressing enter
set scrolloff=10          " Always show at least ten lines above/below cursor
set sidescrolloff=5       " Always show at least 5 columns beside cursor
set ff=unix
set ffs=unix,dos          " FFS, use unix line endings!
set ignorecase            " Ignore case by default in searches
set spelllang=en_ca       " Rocks and trees and trees and rocks...
set autoread              " Autoreload files changed externally
set textwidth=100   	  " Set width for gq to 100 - removing c and t from formatoptions should prevent auto-wrapping
set formatoptions-=r      " Don't repeat comment leaders
set formatoptions-=o      " Don't repeat comment leaders
set formatoptions-=c      " Don't auto-wrap text
set formatoptions-=t      " Don't auto-wrap text
set viewdir=~/.vim/view   " Set view folder
set noerrorbells visualbell t_vb= " No error bells or flashing
autocmd GUIEnter * set visualbell t_vb=
set exrc                  " enable per-directory .vimrc files
set secure                " disable unsafe commands in local .vimrc files
set showcmd               " Show pending command
set breakindent           " Preserve indent level when wrapping text
set report=2              " Report the number of lines yanked or deleted
set diffopt+=vertical     " Open diffs as vertical by default
set wildmenu              " Magic super ex completion
set wildmode=longest,list,full " Subsequent wildmenu tabs complete, then list, then cycle
set completeopt-=preview  " Never open preview window on autocomplete
set hlsearch              " Highlight by default
set mouse=a               " Enable mouse scrolling for all modes in terminals
set tags=./tags;/,tags  " Search recursively for tags file to / (TODO: check windows)
set display=lastline      " Display lines even when incomplete
set cm=blowfish2 		" Use strong encryption
set splitbelow			" When opening a vsplit or preview window, put the new one on the bottom
set maxfuncdepth=500	" Trying to increase maxfuncdepth for LSP
set previewheight=5		" Preview window height, e.g. for :LspHover

" Status line
set statusline=%.50F%m\ \ %y\ \ \ \ cwd:%{getcwd()}%=line:%l/%L\ \ col:%c\
set laststatus=2
"}}}

" Key mappings "{{{
" This hackery allows the use of a number before the key
" noremap <Left>    :<C-U>exe v:count."bp"<CR>
" noremap <Up>   :<C-U>exe v:count."bp"<CR>
" noremap <Right>    :<C-U>exe v:count."bn"<CR>
" noremap <Down>    :<C-U>exe v:count."bn"<CR>
nnoremap <C-K>   :<C-U>exe v:count."bp"<CR>
nnoremap <C-J>    :<C-U>exe v:count."bn"<CR>
nnoremap <C-s>        :w!<CR>
inoremap <C-s>        <Esc>:w!<CR>
map <F3> :source ~/.vim/_session <cr>     " Restore previous session
nnoremap / :set hls<CR>/
nnoremap ? :set hls<CR>?
" see :help {
nnoremap [[ ?{<CR>w99[{
nnoremap ][ /}<CR>b99]}
nnoremap ]] j0[[%/{<CR>
nnoremap [] k$][%?}<CR>

if has('gui_running')
  nnoremap <silent> <Esc> :noh<CR><Esc>
else
  nnoremap <silent> <Esc> :noh<CR><Esc>
  "http://stackoverflow.com/questions/657447/vim-clear-last-search-highlighting/1037182#1037182
  nnoremap <Esc>^[ <Esc>^[
  " don't know where I got this, but it doesn't seem to do the job
  " augroup no_highlight
  "   autocmd TermResponse * nnoremap <esc> :noh<return><esc>
  " augroup END
end

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
vnoremap ac :<C-U>silent! normal! `[v`]$<CR>
omap ac :normal Vac<CR>
" Relies on CamelCaseMotion mappings (which should probably be changed)
" the vmap doesn't work
vmap i,w :<C-U>silent! normal! ,bv,e<CR>
omap i,w :normal ,bv,e<CR>

" Continuously indent in visual mode
vnoremap < <gv
vnoremap > >gv

" Leader commands - file management and temporary commands
nnoremap <Leader><Leader>    :b#<bar>confirm bd#<CR>
nnoremap <Leader><Leader>    :BD<CR>
nnoremap <Leader>v :e $MYVIMRC<CR>
nnoremap <Leader>cd :cd %:h<CR>
nnoremap <Leader>yp :let @+=expand("%:p")<CR>
nnoremap <Leader>b :ls<CR>:b<Space>
nnoremap <Leader>gg viw"gy:Ggrep <C-R>g<CR>
vnoremap <Leader>gg "gy:Ggrep <C-R>g<CR>
nnoremap <Leader>n :enew<CR>
nnoremap <Leader>eh :e %:h/

" FT commands
nnoremap <Leader>fjs    :setf javascript<CR>
nnoremap <Leader>fjson  :setf json<CR>
nnoremap <Leader>fcs    :setf cs<CR>
nnoremap <Leader>fclj   :setf clojure<CR>
nnoremap <Leader>fc     :setf c<CR>
nnoremap <Leader>fhs    :setf haskell<CR>
nnoremap <Leader>fcpp   :setf cpp<CR>
nnoremap <Leader>fhtml  :setf html<CR>
nnoremap <Leader>fxml   :setf xml<CR>
nnoremap <Leader>fmd    :setf markdown<CR>
nnoremap <Leader>ftxt   :setf txt<CR>
nnoremap <Leader>fpy    :setf python<CR>
nnoremap <Leader>f        :setf<Space>

" Space commands - editing
" Replace word under cursor
nnoremap <Space>r :%s/\V\C\<<C-R><C-W>\>//g<Left><Left>
" Same, but populated
nnoremap <Space>pr :%s/\V\C\<<C-R><C-W>\>/<C-R><C-W>/g<Left><Left>
nnoremap <Space>gu :GundoShow<CR>
nnoremap <Space>gc :GundoHide<CR>
" Make copy of line/selection and comment it
nmap <Space>cc yypkgccj
vmap <Space>cc yPgcacvac<Esc>j^
" Print the highlight group applied under the cursor
nnoremap <Space>hi :echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
\ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
\ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"<CR>
" Delete trailing whitespace
nnoremap <Space>dt :%s/\V\s\+\$//<CR><C-O>
vnoremap <Space>dt :s/\V\s\+\$//<CR><C-O>
" Copy and paste from /tmp/alex-vim-clip
vnoremap <Space>y <Esc>:keepalt '<,'>w! /tmp/alex-vim-clip<CR>
nnoremap <Space>yy V<Esc>:keepalt '<,'>w! /tmp/alex-vim-clip<CR>
nnoremap <Space>p :keepalt r /tmp/alex-vim-clip<CR>
vnoremap <Space>p <Esc>:keepalt r /tmp/alex-vim-clip<CR>gvd

" Add j/k to jumplist
nnoremap <silent> k :<C-U>execute 'normal!' (v:count > 1 ? "m'" . v:count : 'g') . 'k'<CR>
nnoremap <silent> j :<C-U>execute 'normal!' (v:count > 1 ? "m'" . v:count : 'g') . 'j'<CR>

" Don't change registers on visual paste
vnoremap p "_dP

" Don't paste on middle mouse click (was hitting it accidentally)
map <MiddleMouse> <Nop>
imap <MiddleMouse> <Nop>

" Make ZZ/ZQ quit all windows
nnoremap ZZ :xa<CR>
nnoremap ZQ :qa!<CR>

" Swap 0 and ^
nnoremap 0 ^
nnoremap ^ 0
"}}}

" File local settings"{{{
set nocindent " No C indentation by default - it seems to break smartindent

" au FileType txt,text,md,markdown setlocal formatoptions+=t        " autowrap
au FileType txt,text,md,markdown setlocal wrap            " Wrap text - NOT WORKING

au FileType md setf markdown
au BufNewFile,BufRead *.md setf markdown

au FileType html,xml imap <buffer> <// </<<C-X><C-O>

au FileType vim set foldmethod=marker

au VimLeave * mksession! ~/.vim/_session"

" Show trailing whitespace, but I want to explicitly whitelist the file types
au FileType c,h,javascript,python,clojure,haskell,cpp,css,java match SpellBad '\s\+$'

au FileType tex setlocal wrap

"}}}

" Plugins"{{{
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'gmarik/Vundle.vim'

" My bundles
" Enhanced . support for plugins
Plugin 'tpope/vim-repeat'
" Pretty status line - not too useful anymore (not using tabline)
Plugin 'bling/vim-airline'
" Themes to make it prettier
Plugin 'vim-airline/vim-airline-themes'
" Clojure quasi-repl
Plugin 'tpope/vim-fireplace'
" Clojure runtime files
Plugin 'guns/vim-clojure-static'
" Syntax checker
Plugin 'scrooloose/syntastic'
" Bracket manipulation
Plugin 'tpope/vim-surround'
" Markdown syntax
Plugin 'hallison/vim-markdown'
" Trying this instead of JavaScript-Indent
" Plugin 'pangloss/vim-javascript'
Plugin 'JavaScript-Indent'
" " Here goes...
" Plugin 'Shougo/unite.vim'
" " MRU sources for unite
" Plugin 'Shougo/neomru.vim'
" " tags source for unite
" Plugin 'tsukkee/unite-tag'
" gof and got to open file in explorer/terminal
Plugin 'justinmk/vim-gtfo'
" Smooth scrolling
Plugin 'terryma/vim-smooth-scroll'
" " Automatically load autocomplete menu
" Plugin 'neocomplcache'
" Alternative autocomplete
Plugin 'prabirshrestha/asyncomplete.vim'
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
" Plugin 'paredit.vim'
" Fix colorschemes for the terminal
" Plugin 'CSApprox'
" Visualize the undo tree
Plugin 'sjl/gundo.vim'
" Snippet runner
" Plugin 'SirVer/ultisnips'
" Snippets
Plugin 'honza/vim-snippets'
" " Ultisnips <-> Neocomplcache compat
" Plugin 'JazzCore/neocomplcache-ultisnips'
" Elm support
Plugin 'lambdatoast/elm.vim'
" Git integration
Plugin 'tpope/vim-fugitive'
" My colour scheme
Plugin 'j201/stainless'
" junegunn's nutso plugin for aligning around particular characters
Plugin 'junegunn/vim-easy-align'
" Persistent buffer list
" Plugin 'jeetsukumaran/vim-buffergator'
Plugin 'j201/vim-buffergator'
" Close a buffer without closing its window
Plugin 'qpkorr/vim-bufkill'
" Show git diff info beside the buffer
Plugin 'airblade/vim-gitgutter'
" " Alternative
" Plugin 'mhinz/vim-signify'
" Rust support
Plugin 'rust-lang/rust.vim'
" TOML support
Plugin 'cespare/vim-toml'
" Ack interop
Plugin 'mileszs/ack.vim'
" " Required for EnhancedJumps
" Plugin 'ingo-library'
" " Jumps to MRU buffers, among other things TODO: configure controls
" Plugin 'EnhancedJumps' " Suuuper buggy
" Julia support
Plugin 'JuliaEditorSupport/julia-vim'
" Markdown folding
Plugin 'nelstrom/vim-markdown-folding'
" Dependency for SQLUtilities
Plugin 'Align'
" SQL formatting and utils
Plugin 'SQLUtilities'
" LaTeX support
Plugin 'lervag/vimtex'
" Basic tmux integration
Plugin 'tpope/vim-tbone'
" LSP support
Plugin 'prabirshrestha/vim-lsp'
" Auto-install LSP
Plugin 'mattn/vim-lsp-settings'
" LSP <-> asynccomplete
Plugin 'prabirshrestha/asyncomplete-lsp.vim'
" Use buffer as asyncomplete source
Plugin 'prabirshrestha/asyncomplete-buffer.vim'
" Use files/directories as ac source
Plugin 'prabirshrestha/asyncomplete-file.vim'
" yaml folds
Plugin 'pedrohdz/vim-yaml-folds'
" FZF - unite replacement
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'

call vundle#end()
filetype plugin indent on
syntax on
"}}}

" if has("gui_running")
  colorscheme stainless
" else
"   colorscheme stainless
"   colorscheme morning " TODO
" endif
set background=light

au FileType * setlocal formatoptions-=c formatoptions-=o formatoptions-=r

" Plugin settings"{{{
" let g:airline#extensions#tabline#enabled = 1
" let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_section_b = '%y'
let g:airline_section_c = '%.50F%m'
let g:airline_section_x = 'cwd:%{getcwd()}'
let g:airline_section_z = '%=line:%l/%L col:%c'
let g:airline_section_warning = ''
let g:airline_theme = 'molokai'
let g:airline_left_sep = ''
let g:airline_right_sep = ''

let g:miniBufExplSortBy="number"

let g:buffergator_autodismiss_on_select = 0
let g:buffergator_display_regime = "basename"
let g:buffergator_autoupdate = 1
let g:buffergator_split_size = 26
let g:buffergator_suppress_keymaps = 1
let g:buffergator_relative_numbering = 1
nmap <F5> :BuffergatorOpen<CR><C-W>l
nmap <C-N> :BuffergatorMruCyclePrev<CR>
" au VimEnter * exe 'BuffergatorOpen' | setf buffergator | exe "normal \<c-w>l"

let g:syntastic_javascript_checkers=['jshint']
let g:syntastic_typescript_tsc_args='--target ES5 --module commonjs'
let g:syntastic_python_checkers=['python']

let g:ctrlp_open_new_file = 'r'
let g:ctrlp_working_path_mode = ''
let g:ctrlp_extensions = ['buffertag']
" Open CtrlP for old files
" nnoremap <Leader>o :CtrlPMRUFiles<Enter>
let g:ctrlp_custom_ignore='\v[\/](node_modules|target|build)$'

" Neocomplcache settings
" let g:neocomplcache_enable_at_startup = 1
" let g:neocomplcache_min_syntax_length = 2
" inoremap <expr><TAB>  pumvisible() ? "\<C-n>" : "\<TAB>"
" inoremap <expr><CR> neocomplcache#close_popup()."\<CR>"

" asyncomplete settings
inoremap <expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr><CR> asyncomplete#close_popup()."\<CR>"

call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'allowlist': ['*'],
    \ 'blocklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ 'config': {
    \    'max_buffer_size': 5000000,
    \  },
    \ }))

nnoremap <silent> <c-u> :call smooth_scroll#up(&scroll, 15, 2)<CR>
nnoremap <silent> <c-d> :call smooth_scroll#down(&scroll, 15, 2)<CR>
nnoremap <silent> <c-b> :call smooth_scroll#up(&scroll*2, 15, 4)<CR>
nnoremap <silent> <c-f> :call smooth_scroll#down(&scroll*2, 15, 4)<CR>

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

autocmd FileType json nnoremap <buffer> <Space>f :%!python -m json.tool<CR>
autocmd FileType javascript nnoremap <buffer> <Space>f :%!python -m json.tool<CR>
" autocmd FileType json set syntax=javascript

" " paredit options
" let g:paredit_leader = ','
" let g:paredit_electric_return = 0
" autocmd FileType clojure nmap ,i ,Wa
" autocmd FileType clojure vmap ,i ,Wa

" add more indentation in html
let g:html_indent_inctags = "html,body,head,tbody,li"

let g:gundo_close_on_revert = 1
let g:gundo_right = 1
if !has('python')
    let g:gundo_prefer_python3 = 1
endif

" Unite settings
" nnoremap    [unite]   <Nop>
" nmap - [unite]
" " call unite#filters#matcher_default#use(['matcher_fuzzy'])
" " call unite#custom#source('file_rec', 'ignore_globs', ['*.ll', '*.s', '*.bc', '*.o', '*.dsy', '*.class', '*.swp', 'target/', '__pycache__/'])
" call unite#custom#source('file_rec', 'ignore_pattern', '__pycache__\|\.venv')
" nnoremap [unite]p :<C-u>Unite -start-insert file_rec<CR>
" nnoremap [unite]h :<C-u>Unite -start-insert file_rec:<C-R>=expand('%:h')<CR><CR>
" nnoremap [unite]o :<C-u>Unite -start-insert file_mru<CR>
" nnoremap [unite]b :<C-u>Unite -start-insert buffer<CR>
" nnoremap [unite]r :<C-u>Unite -start-insert register<CR>
" nnoremap [unite]j :<C-u>Unite -start-insert jump<CR>
" nnoremap [unite]c :<C-u>Unite -start-insert change<CR>
" nnoremap [unite]t :<C-u>Unite -start-insert tag<CR>
" function! s:unite_settings()
" 	nmap <buffer> <esc> <Plug>(unite_exit)
" 	" nmap <buffer> <Esc><Esc> <Plug>(unite_exit)
" 	" inoremap <buffer> <Esc><Esc> <plug>(unite_exit)
" 	let b:asyncomplete_enable = 0
" endfunction
" autocmd FileType unite call s:unite_settings()

" FZF options
let $FZF_DEFAULT_COMMAND="find \\( -name \".venv*\" -o -name .git -o -name *.sw* -o -name *.pyc \\) -prune -o -type f -print"
nnoremap -p :Files<CR>
nnoremap -g :GFiles<CR>
nnoremap -o :History<CR>
nnoremap -c :Commands<CR>
nnoremap -b :Buffers<CR>
nnoremap -l :BLines<CR>
nnoremap -g :RG<CR>
let g:fzf_layout = { 'down': '50%' }

" Start interactive EasyAlign in visual mode (e.g. vip<Enter>)
vmap <Enter> <Plug>(EasyAlign)
" Start interactive EasyAlign for a motion/text object (e.g. gaip)
nmap ga <Plug>(EasyAlign)

hi GitGutterChange ctermfg=60 ctermbg=252 guifg=#0000ff guibg=#cccccc guisp=#cccccc

let g:signify_vcs_list = [ 'git' ]

" rust.vim overwrites indent settings. This makes me very angry. I don't want style pedantry from a highlighting plugin.
let g:rust_recommended_style = 0
" Similarly...
au FileType vim setlocal textwidth=0
" Aaaand...
" What the hell is the point of having my own options if the plugin writers think they know better than me?
let g:python_recommended_style = 0

if !exists('g:python_indent')
	let g:python_indent = {}
endif
let g:python_indent.disable_parentheses_indenting = 1

if !exists('g:neocomplete#sources#omni#input_patterns')
	let g:neocomplete#sources#omni#input_patterns = {}
endif
" let g:neocomplete#sources#omni#input_patterns.tex =
" 	\ g:vimtex#re#neocomplete
let g:matchup_matchparen_deferred = 1

" EnhancedJumps
" unmap <C-O>
" unmap <C-I>

let g:tex_flavor = 'latex'

" LSP settings

function! s:on_lsp_buffer_enabled() abort
    " setlocal omnifunc=lsp#complete
    " setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> <C-]> <plug>(lsp-definition)
    nmap <buffer> gr <plug>(lsp-references)
    nmap <buffer> gi <plug>(lsp-implementation)
    nmap <buffer> gt <plug>(lsp-type-definition)
    nmap <buffer> <Space>sr <plug>(lsp-rename)
    nmap <buffer> <Space>f <plug>(lsp-code-action)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)
    nmap <buffer> <Space>d :LspDocumentDiagnostics<CR><C-W>p
    
    " refer to doc to add more commands
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END

" Uncomment to debug LSP
let g:lsp_log_verbose=1
let g:lsp_log_file='/tmp/lsp.log'

" Disable pycodestyle in pylsp
let g:lsp_settings = {
			\   'pyls-all': {
			\     'workspace_config': {
			\       'pyls': {
			\         'configurationSources': ['pycodestyle'],
			\         'plugins': {
			\           'pycodestyle': {
			\             'enabled': v:false,
			\             'ignore': ['E501']
			\           },
			\         }
			\       }
			\     }
			\   },
			\}
let g:lsp_diagnostics_echo_cursor =11
let g:lsp_diagnostics_virtual_text_enabled=0

"}}}

autocmd FileType haskell,elm setlocal expandtab
" The elm tab handling is sucky
autocmd FileType elm setf haskell

au BufNewFile,BufRead package.json setlocal expandtab tabstop=2 shiftwidth=2

autocmd BufRead,BufNewFile *.jl set filetype=julia
au FileType julia let g:paredit_mode=0

au FileType matlab set commentstring=%%s

let g:Haskell_no_mapping=1

if (executable('ConEmu64.exe'))
    nmap got :ConEmu<CR>
endif

let g:colorizer_startup = 1

" abbreviations
au User AfterBundles Abolish hte the

" turn off syntax when entering a big file
autocmd BufWinEnter * if line2byte(line("$") + 1) > 300000 | syntax clear | endif

" Save folds
au BufWinLeave ?* mkview
" au BufWinEnter ?* silent loadview

" Set default filetype to txt
autocmd BufEnter * if &filetype == "" | setlocal ft=txt | endif
autocmd BufWritePost * if &filetype == "txt" | filetype detect | endif

" Auto reload vimrc
augroup reload_vimrc " {
    autocmd!
    autocmd BufWritePost $MYVIMRC source $MYVIMRC | AirlineRefresh
augroup END " }

" Load local settings if they exist
if filereadable($HOME . "/_vimrclocal")
    so $HOME/_vimrclocal
elseif filereadable($HOME . "/.vimrclocal")
    so $HOME/.vimrclocal
endif

if &term =~ '^xterm'
	" normal mode
	let &t_EI .= "\<Esc>[0 q"
	" insert mode
	let &t_SI .= "\<Esc>[6 q"
endi
