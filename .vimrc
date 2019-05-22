"-----------"
" INTERNALS "
"-----------"

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
nnoremap / /\v
vnoremap / /\v
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

" Better split opening
set splitbelow
set splitright
" Define shortcuts for switchng between open split windows. <C- stands for 
"	Ctrl-
nnoremap <C-j> <C-w>j
nnoremap <C-k> <C-w>k
nnoremap <C-h> <C-w>h
nnoremap <C-l> <C-w>l

" Define shortcuts for window splitting.
nnoremap <Leader>v :vsplit<Space>
nnoremap <Leader>h :split<Space>

" Define shortcuts for invoking external programs.
" Compile current LaTeX file in its own directory
nnoremap <Leader>p :! pdflatex -output-directory %:h %<CR><Space>

" FileType stuff
filetype plugin on
filetype indent on

" Set HTML FileType for EJS and Dust templates.
autocmd BufRead,BufNewFile *.ejs setfiletype html
autocmd BufRead,BufNewFile *.dust setfiletype html

" set colors
if has("termguicolors")
	let &t_8f = "[38;2;%lu;%lu;%lum"
	let &t_8b = "[48;2;%lu;%lu;%lum"
	set termguicolors
endif
colorscheme gruvbox
set background=dark

" Jump to errors
nnoremap <Leader>e :lnext<cr>
nnoremap <Leader>E :lprevious<cr>

"-----------"
" EXTERNALS "
"-----------"

" Setting for Latex-Suite
set grepprg=grep\ -nH\ $*
let g:tex_flavor='latex'

" Remap command from latex-suite so <C-j> will work again
nnoremap <SID>Anything_maybe_change_it <Plug>IMAP_JumpForward

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

" FZF
nnoremap <C-p> :Files<CR>

" Ag – The silver searcher
" :Ag is actually part of FZF.vim
let g:ackprg = 'ag --vimgrep --smart-case'
nnoremap <Leader>a :Ack!<Space>

" airline options
let g:airline_powerline_fonts = 1

" COMPLETION

" Enable auto completion features for specific languages on file type base.
" autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
" autocmd FileType php set omnifunc=phpcomplete#CompletePHP
" autocmd FileType css set omnifunc=csscomplete#CompleteCSS
" autocmd FileType less set omnifunc=csscomplete#CompleteCSS

" Define Ctrl-Space (<Nul>) as shortcut for auto complete.
" inoremap <Nul> <C-x><C-o>

" ALE options
let g:ale_list_window_size=4
let g:ale_open_list=1
let g:ale_sign_error = '✘'
let g:ale_sign_warning = '⚠'
" let g:ale_lint_on_text_changed=0
" let g:ale_lint_on_insert_leave=1
" let g:ale_linters = {
" \	'typescript': ['tslint', 'tsserver'],
" \}
" let g:ale_linters = {
" \	'typescript': ['tslint'],
" \}
" let g:ale_fixers = {
" \	'javascript': ['eslint'],
" \	'typescript': ['prettier'],
" \}
let g:ale_fix_on_save = 1
" let g:ale_elm_ls_use_global = 1

" Use Tab for completion menu
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"

" Tsuquyomi
" let g:tsuquyomi_disable_default_mappings = 1
" let g:tsuquyomi_disable_quickfix = 1
" autocmd FileType typescript nnoremap <buffer> <C-]> :TsuDefinition<cr>
" autocmd FileType typescript nnoremap <buffer> <leader>t : <C-u>echo tsuquyomi#hint()<cr>

" Tern
" autocmd FileType javascript nnoremap <buffer> <C-]> :TernDef<cr>
" autocmd FileType javascript nnoremap <buffer> <leader>t :TernType<cr>

" Language settings
" let g:LanguageClient_settingsPath = 

" Language Servers
" let g:LanguageClient_serverCommands = {
    " \ 'javascript': ['/usr/bin/javascript-typescript-stdio'],
    " \ 'javascript.jsx': ['/usr/bin/javascript-typescript-stdio'],
    " \ 'typescript': ['/usr/bin/javascript-typescript-stdio'],
    " \ 'typescript.tsx': ['/usr/bin/javascript-typescript-stdio'],
	" \ 'reason': ['/home/tobi/Code/reason-language-server/reason-language-server.exe'],
	" \ 'elm': ['elm-ls', '--stdio']
    " \ }

" function LC_maps()
  " if has_key(g:LanguageClient_serverCommands, &filetype)
	" nnoremap <F5> :call LanguageClient_contextMenu()<CR>
	" nnoremap <silent> <leader>t :call LanguageClient#textDocument_hover()<CR>
	" nnoremap <buffer> <C-]> :call LanguageClient#textDocument_definition()<CR>
	" nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
  " endif
" endfunction

" autocmd FileType * call LC_maps()

" Welcome
" :echo ">^.^<"
