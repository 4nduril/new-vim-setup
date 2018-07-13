" Set runtime for pathogen as a submodule
runtime bundle/pathogen/autoload/pathogen.vim
execute pathogen#infect()

" make Vim use Vim defaults, not Vi.
set nocompatible

" We have 256 colors
set t_Co=256

" Copy indent from current line when starting a new line.
set autoindent

" Indent automatically after a line ending with '{', 'if' or the like.
set smartindent

" Number of columns a tab counts for while displaying.
set tabstop=4
" Number of columns a tab counts for while inserting.
set softtabstop=4
" Number of columns text is (auto)indented.
set shiftwidth=4
" Tabs are inserted, not spaces.
set noexpandtab
" For explanation read Vim help files or:
"	http://tedlogan.com/techblog3.html

" Minimal number of lines above and below the cursor.
set scrolloff=3
" Show if we are in Insert, Visual or Replace mode.
set showmode
" Hide buffers (open files) instead of unloading them. Makes it possible to
"	have several changed but unsaved files open at the same time.
set hidden

" Command completion in Vim. 'wildmenu' gives you a scrolling horizontal list
"	of the available options which are navigable by <left> and <right>.
"	'wildmode' displays a full list of all options and completes the command
"	line.
set wildmenu
set wildmode=list:longest

" Highlights the line on which the cursor is.
set cursorline
" Set symbols for tab and eol
set list lcs=tab:\·\ ,eol:¬
" We have a fast terminal connection.
set ttyfast
" Show current corsor position: line and column.
set ruler
" Allows <backspace> and others to cross indents, linebreaks and beginnings of
"	insertions.
set backspace=indent,eol,start
" Always show a status line.
set laststatus=2
" Show line numbers relative to the current line.
set relativenumber
" Save persistent undo history in a file.
set undofile
" Define global undo directory instead of cluttering the cwd
" Note the second slash at the end of the path. This way equally named files
" from different directories don't make problems
" if isdirectory($HOME . '/.vim/undo') == 0
" 	:silent !mkdir -p ~/.vim/undo > /dev/null 2>&1
" endif
set undodir=~/.vim_bkp-files/.undo//
set backupdir=~/.vim_bkp-files/.backup//
set directory=~/.vim_bkp-files/.swp//


" Define ',' for custom mappings.
let mapleader = ","

" Prepend all searches with the option \v which enables Perl regexps.
"nnoremap / /\v
"vnoremap / /\v
" Highlight search matches and find them while typing.
set hlsearch
set incsearch
" Comma-Space de-highlights search matches.
nnoremap <Leader><space> :noh<cr>
" Search case-agnostic.
set ignorecase
" Always apply substitutions globally on lines.
set gdefault
" When you insert a bracket, shortly show matching one.
set showmatch

" Display lines wrapped, when they are too long.
set wrap

" Enable spellchecking. Set spelllang according to your language.
"set spell 
set spelllang=de

" Enable mouse events
set mouse=a

" Enable syntax checking
syntax on

" Force using h,j,k,l for moving, not allowing arrow keys.
nnoremap <up> <nop>
nnoremap <down> <nop>
nnoremap <left> <nop>
nnoremap <right> <nop>
inoremap <up> <nop>
inoremap <down> <nop>
inoremap <left> <nop>
inoremap <right> <nop>
" Move by screen lines not by file lines.
" nnoremap j gj
" nnoremap k gk

" Define shortcuts for invoking external programs.
" Invoke uglifyjs on current file, mangle names on toplevel and save as
"	*.min.js.
" nnoremap <Leader>u :! uglifyjs % -m toplevel -o %:r.min.js<CR><Space>
" Save the current file and invoke lessc on it, all in one step.
" nnoremap <Leader>w :w <Bar> !lessc % > %:r.css<CR><Space>
" Open current file in Firefox or Chrome.
" nnoremap <Leader>ff :! firefox %<CR><Space>
" nnoremap <Leader>gc :! google-chrome %<CR><Space>
" Compile current LaTeX file in its own directory
nnoremap <Leader>p :! pdflatex -output-directory %:h %<CR><Space>

" Define shortcuts for window splitting.
nnoremap <Leader>v :vsplit<Space>
nnoremap <Leader>h :split<Space>
" Better split opening
set splitbelow
set splitright
" Define shortcuts for switchng between open split windows. <C- stands for 
"	Ctrl-
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Set HTML FileType for EJS and Dust templates.
autocmd BufRead,BufNewFile *.ejs setfiletype html
autocmd BufRead,BufNewFile *.dust setfiletype html

" Set JSON FileType
autocmd BufRead,BufNewFile *.json setfiletype json

" Set Vue FileType
" autocmd BufRead,BufNewFile *.vue setlocal filetype=vue.html.javascript.css

" Set Typescript / JSX Filetype
autocmd BufRead,BufNewFile *.jsx,*.tsx set filetype=typescript.jsx

" Enable auto completion features for specific languages on file type base.
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
"Done by Tern
"autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
"autocmd FileType javascript setlocal omnifunc=tern#complete
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType less set omnifunc=csscomplete#CompleteCSS

" Auto closing of braces
inoremap {      {}<Left>
inoremap {<CR>  {<CR>}<Esc>O
inoremap {{     {
inoremap {}     {}

" Auto closing of parens
inoremap (      ()<Left>
inoremap (<CR>  (<CR>)<Esc>O
inoremap ((     (
inoremap ()     ()

" Wrapping one word in parentheses
nnoremap <Leader>( bi(<Esc>ea)<Esc>

" Setting for Latex-Suite
filetype plugin on
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

" Define Ctrl-Space (<Nul>) as shortcut for auto complete.
inoremap <Nul> <C-x><C-o>

" Integrate plugin bundles.

" Remap command from latex-suite so <C-j> will work again
nnoremap <SID>Anything_maybe_change_it <Plug>IMAP_JumpForward

" ALE options
let g:ale_list_window_size=4
let g:ale_open_list=1
" let g:ale_lint_on_text_changed=0
" let g:ale_lint_on_insert_leave=1
let g:ale_linters = {
\	'typescript': ['tslint'],
\}
let g:ale_fixers = {
\	'typescript': ['prettier'],
\}
let g:ale_fix_on_save = 1

" Abbreviations for Handlebars
let g:mustache_abbreviations=1

" YCM options
let g:ycm_path_to_python_interpreter='/usr/bin/python3'
let g:ycm_semantic_triggers = {
	\ 'elm' : ['.'],
	\}
set completeopt-=preview

" set colors
"colorscheme robokai
if has("termguicolors")
	let &t_8f = "[38;2;%lu;%lu;%lum"
	let &t_8b = "[48;2;%lu;%lu;%lum"
	set termguicolors
endif
colorscheme gruvbox
set background=dark
" Style the highlighting for the cursorline more nicely.
"hi CursorLine cterm=NONE ctermbg=DarkGray


" Use jsx highlighting in *.js files
let g:jsx_ext_required = 0

" Indent Guide
let g:indent_guides_enable_on_vim_startup = 0
let g:indent_guides_guide_size = 1

" NERDtree
nnoremap <Leader>n :NERDTreeToggle<CR>
nnoremap <Leader>nf :NERDTreeFind<CR>

" NERDCommenter
let g:NERDSpaceDelims = 1

" CtrlP
let g:ctrlp_root_markers = ['package.json']
let g:ctrlp_user_command = 'ag %s -i --nocolor --nogroup --hidden
    \ --ignore .git
    \ -g ""'

" Ag – The silver searcher
nnoremap <Leader>a :Ag 
"let g:ag_working_path_mode="r"

" Jump to errors
nnoremap <Leader>e :lnext<cr>
nnoremap <Leader>E :lprevious<cr>

" airline options
let g:airline_powerline_fonts = 1
