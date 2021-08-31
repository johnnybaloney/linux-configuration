" VIM minimal setup: http://www.guckes.net/vim/setup.html


"==[ Plugin List ]============================================================

" Vim Addon Manager (VAM)
" https://github.com/MarcWeber/vim-addon-manager

" Bash Support
" https://github.com/WolfgangMehner/vim-plugins

" ctrlp - buffer explorer
" fuzzy buffer, mru, tag, ... finder with regexp support
" https://github.com/kien/ctrlp.vim

" LargeFile
" Edit large files quickly
" http://vim.sourceforge.net/scripts/script.php?script_id=1506

" The NERD Tree - directory tree
" https://github.com/scrooloose/nerdtree

" Bbye (Buffer Bye) for Vim
" Bbye allows you to do delete buffers (close files) without closing your
" windows or messing up your layout.
" https://github.com/moll/vim-bbye

" vim-fugitive
" git wrapper
" https://github.com/tpope/vim-fugitive

" vim-airline
" status/tabline for vim
" https://github.com/bling/vim-airline

" vim-gitgutter
" added/removed/modified git gutter for vim
" https://github.com/airblade/vim-gitgutter

" vim-markdown-toc
" generate markdown TOC
" https://github.com/mzlogin/vim-markdown-toc

"==[ END ]====================================================================

"==[ Manual Plugin Removal ]==================================================

" I you want to uninstall a plugin which was installed into ~/.vim manually,
" you should redownload its archive, list its content and manually remove
" everything, then run :helptags again (this will remove missing tags).

" If plugin was installed from a vimball, see documentation for :RmVimball.
" Vimball archives normally have .vba or .vba.gz extensions. In case you don't
" remember vimball file name, it is contained into ~/.vim/.VimballRecord file.

"==[ END ]====================================================================

"==[ Plugin: Vim Addon Manager (VAM) ]========================================

" put this line first in ~/.vimrc
set nocompatible | filetype indent plugin on | syn on

fun! SetupVAM()
  let c = get(g:, 'vim_addon_manager', {})
  let g:vim_addon_manager = c
  let c.plugin_root_dir = expand('$HOME', 1) . '/.vim/vim-addons'

  " Force your ~/.vim/after directory to be last in &rtp always:
  " let g:vim_addon_manager.rtp_list_hook = 'vam#ForceUsersAfterDirectoriesToBeLast'

  " most used options you may want to use:
  " let c.log_to_buf = 1
  " let c.auto_install = 0
  let &rtp.=(empty(&rtp)?'':',').c.plugin_root_dir.'/vim-addon-manager'
  if !isdirectory(c.plugin_root_dir.'/vim-addon-manager/autoload')
    execute '!git clone --depth=1 git://github.com/MarcWeber/vim-addon-manager '
        \       shellescape(c.plugin_root_dir.'/vim-addon-manager', 1)
  endif

  " This provides the VAMActivate command, you could be passing plugin names, too
  call vam#ActivateAddons([], {})
endfun
call SetupVAM()

" ACTIVATING PLUGINS

" OPTION 1, use VAMActivate
"VAMActivate PLUGIN_NAME PLUGIN_NAME ..

" OPTION 2: use call vam#ActivateAddons
" use <c-x><c-p> to complete plugin names
"call vam#ActivateAddons(["bash-support"], {})
call vam#ActivateAddons(["ctrlp"], {})
call vam#ActivateAddons(["LargeFile"], {})
"call vam#ActivateAddons(["HiCursorWords"], {})
call vam#ActivateAddons(["The_NERD_tree"], {})
call vam#ActivateAddons(["bbye"], {})
call vam#ActivateAddons(["fugitive"], {})
call vam#ActivateAddons(["vim-airline"], {})
call vam#ActivateAddons(["vim-gitgutter"], {})

" MANUAL INSTALLATION: the plugins below have to be cloned manually.
" Clone the repository to ~/.vim/vim-addons by hand.

" https://github.com/vim-airline/vim-airline-themes.git
call vam#ActivateAddons([ 'vim-airline-themes' ])
" https://github.com/mzlogin/vim-markdown-toc
call vam#ActivateAddons(["vim-markdown-toc"])

" OPTION 3: Create a file ~/.vim-srcipts putting a PLUGIN_NAME into each line
" See lazy loading plugins section in README.md for details
"call vam#Scripts('~/.vim-scripts', {'tag_regex': '.*'})

"==[ END ]====================================================================

"--------------------[ PLUGIN CONFIGURATION AND TIPS ]------------------------

"==[ Plugin: The NERD Tree ]==================================================

" Quick tips:
" * CTRL+n - open/close
" * CTRL+w w - (switch window) to move focus to NERD Tree
" * ? - access help
" * r - refresh
" * Enter - opens file a new window
" * t - opens file in new tab and jumps straight to there 
" * T - opens file in new tab but focus remains in the tree
" ** 'gt' (next) or 'gT' (previous) to move between tabs, this is vim feature
" ** also the tabs don't seem to play well with ctrlp

" map NERD Tree toggle to CTRL+n 
map <C-n> :NERDTreeToggle<CR>

" close vim when the only *window* left is NERD Tree (will close even when
" there are other files in the buffer
"autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

" open NERD Tree at start up when no file was specified
"autocmd StdinReadPre * let s:std_in=1
"autocmd VimEnter * if argc() == 0 && !exists("s:std_in") | NERDTree | endif

"==[ END ]====================================================================

"==[ Plugin: ctrlp ]==========================================================

" Quick tips:
" * CTRL+p - select files
" * CTRL+b - select buffers (+ cycle)

" http://kien.github.io/ctrlp.vim/

" manual:
" https://github.com/kien/ctrlp.vim/blob/master/doc/ctrlp.txt

" change the default mapping and the default command to invoke CtrlP: 
let g:ctrlp_map = '<c-p>'
let g:ctrlp_cmd = 'CtrlP'

" open new file in the current window
let g:ctrlp_open_new_file = 'r'
" open files as hidden buffers
let g:ctrlp_open_multiple_files = 'i'

" fix to creating a new split when opening a buffer
" https://github.com/kien/ctrlp.vim/issues/344
let g:ctrlp_reuse_window = 'netrw\|help\|quickfix'

" add a custom mapping for CtrlPBuffer
map <C-B> :CtrlPBuffer<CR>

" when invoked, unless a starting directory is specified, CtrlP will set its 
" local working directory according to this variable: 
" http://kien.github.io/ctrlp.vim/
let g:ctrlp_working_path_mode = 'ra'

"exclude files or directories using Vim's wildignore: 
set wildignore+=*/tmp/*,*.so,*.swp,*.zip
"...and/Or CtrlP's own g:ctrlp_custom_ignore: 
let g:ctrlp_custom_ignore = {
    \ 'dir':  '\v[\/]\.(git|hg|svn)$',
    \ 'file': '\v\.(exe|so|dll)$',
    \ }
"    \ 'link': 'SOME_BAD_SYMBOLIC_LINKS',

" Basic Usage
" 
"     Run :CtrlP or :CtrlP [starting-directory] to invoke CtrlP in find file mode.
"     Run :CtrlPBuffer or :CtrlPMRU to invoke CtrlP in find buffer or find MRU file mode.
"     Run :CtrlPMixed to search in Files, Buffers and MRU files at the same time.
" 
" Check :help ctrlp-commands and :help ctrlp-extensions for other commands.
" Once CtrlP is open:
" 
"     Press <F5> to purge the cache for the current directory to get new files, 
"         remove deleted files and apply new ignore options.
"     Press <c-f> and <c-b> to cycle between modes.
"     Press <c-d> to switch to filename only search instead of full path.
"     Press <c-r> to switch to regexp mode.
"     Use <c-j>, <c-k> or the arrow keys to navigate the result list.
"     Use <c-t> or <c-v>, <c-x> to open the selected entry in a new tab or in a new split.
"     Use <c-n>, <c-p> to select the next/previous string in the prompt's history.
"     Use <c-y> to create a new file and its parent directories.
"     Use <c-z> to mark/unmark multiple files and <c-o> to open them.
" 
" Run :help ctrlp-mappings or submit ? in CtrlP for more mapping help.
" 
"     Submit two or more dots .. to go up the directory tree by one or multiple levels.
"     End the input string with a colon : followed by a command to execute it on the opening file(s):
"     Use :25 to jump to line 25.
"     Use :diffthis when opening multiple files to run :diffthis on the first 4 files.

"==[ END ]====================================================================

"==[ Plugin: LargeFile ]======================================================

" activate plugin when file larger than given value
let g:LargeFile=100

"==[ END ]====================================================================

"==[ Plugin: bbye ]===========================================================

" Instead of using :bdelete, use :Bdelete. Fortunately autocomplete helps by
" sorting :Bdelete before its lowercase brother.

" As it's likely you'll be using :Bdelete often, make a shortcut to \q, for 
" example, to save time:

" Leader -> '\'
:nnoremap <Leader>x :Bdelete<CR>

"==[ END ]====================================================================

"==[ Plugin: vim-airline ]====================================================

" skins: https://github.com/bling/vim-airline/wiki/Screenshots
" skin config: https://github.com/bling/vim-airline/wiki/FAQ#where-should-i-store-my-own-custom-theme
" can try from vim command: AirlineTheme <theme>

" enable 256 colors in vim
" http://vim.wikia.com/wiki/256_colors_in_vim
set t_Co=256
let g:airline_theme='powerlineish'
" disable warnings on the status bar
" see airline-customization in https://github.com/bling/vim-airline/blob/master/doc/airline.txt
let g:airline_section_warning=''
let g:airline_section_x=''

" delay when switching insert mode to normal mode using esc key
set ttimeoutlen=50

"-----------------------------------------------------------------------------
" to display the status line always
" http://vimdoc.sourceforge.net/htmldoc/options.html#%27laststatus%27
set laststatus=2

" status line settings below disabled when used with vim-airline plugin

" http://vimdoc.sourceforge.net/htmldoc/options.html#%27statusline%27 
" set statusline+=%F
" set modeline
"-----------------------------------------------------------------------------

"==[ END ]====================================================================

"==[ Plugin: vim-gitgutter ]==================================================

" You can jump between hunks:
"- jump to next hunk (change): ]c
"- jump to previous hunk (change): [c

"==[ END ]====================================================================

"==[ Plugin: vim-markdown-toc ]===============================================

" Generate table of contents

" Move the cursor to the line you want to append table of contents, then type
" the command below to generate table of contents headings in Github Flavoured
" Markdown style:

" :GenTocGFM

" Update existing table of contents. Generally you don't need to do this manually,
"existing table of contents will auto update on save by default.

" The :UpdateToc command, which is designed to update toc manually, can only work 
" when g:vmt_auto_update_on_save turned off, and keep insert fence.

"==[ END ]====================================================================

"----------------------[ VIM CONFIGURATION AND TIPS ]-------------------------

"==[ Configuration ]==========================================================

set nohls
set nu
" https://vi.stackexchange.com/questions/12505
set hidden

set textwidth=0 
set wrapmargin=0

" case insensitive search (required by set smartcase)
" Note: it also affects case-sensitive substitutions, you need to override:
" :%s/lowercasesearch\C/replaceString/g
set ignorecase
" If you search for something containing uppercase characters, it will do
" a case sensitive search; if you search for something purely lowercase, it will
" do a case insensitive search. 
set smartcase
" You can use <code>\c</code> and <code>\C</code> to override:
" /copyright      " Case insensitive
" /Copyright      " Case sensitive
" /copyright\C    " Case sensitive
" /Copyright\c    " Case insensitive

" moving around wrapped long lines
noremap j gj
noremap k gk

syntax on

noremap <F7> :tabp<CR>
noremap <F8> :tabn<CR>

" autohighlight identical words (the 'visual' style) 
" use if HiCursorWords plugin is unavailable
autocmd CursorMoved * exe printf('match IncSearch /\V\<%s\>/', escape(expand('<cword>'), '/\'))

" diable autocomments
autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

"--[ Tabulation ]-------------------------------------------------------------

" The width of a TAB is set to 4. Still it is a \t. It is just that Vim will
" interpret it to be having a width of 4.
set tabstop=2

" Indents will have a width of 4
set shiftwidth=2

" Sets the number of columns for a TAB
set softtabstop=2

" Expand TABs to spaces
set expandtab

" make 'tab' insert indents instead of tabs at the beginning of a line
set smarttab

" Configure tab's for Python
autocmd Filetype python setlocal ts=2 sw=2 expandtab

"--[ END ]--------------------------------------------------------------------

"--[ Swapping Lines ]---------------------------------------------------------

function! s:swap_lines(n1, n2)
    let line1 = getline(a:n1)
    let line2 = getline(a:n2)
    call setline(a:n1, line2)
    call setline(a:n2, line1)
endfunction

function! s:swap_up()
    let n = line('.')
    if n == 1
        return
    endif

    call s:swap_lines(n, n - 1)
    exec n - 1
endfunction

function! s:swap_down()
    let n = line('.')
    if n == line('$')
        return
    endif

    call s:swap_lines(n, n + 1)
    exec n + 1
endfunction

nnoremap <c-u> :call <SID>swap_up()<CR>
nnoremap <c-o> :call <SID>swap_down()<CR>

"--[ END ]--------------------------------------------------------------------

"--[ Colours ]----------------------------------------------------------------

" http://vimcolorschemetest.googlecode.com/ VIM color scheme test

" Vim color file
" Maintainer:   David Schweikert <dws@ee.ethz.ch>
" Last Change:  2001 Mai 14
"
" First remove all existing highlighting.
hi clear
"
let colors_name = "delek"
"
hi Normal guifg=Black guibg=white
"
" Groups used in the 'highlight' and 'guicursor' options default value.
hi ErrorMsg term=standout ctermbg=DarkRed ctermfg=White guibg=Red guifg=White
hi IncSearch term=reverse cterm=reverse gui=reverse
hi ModeMsg term=bold cterm=bold gui=bold
hi VertSplit term=reverse cterm=reverse gui=reverse
hi Visual term=reverse cterm=reverse gui=reverse guifg=Grey guibg=fg
hi VisualNOS term=underline,bold cterm=underline,bold gui=underline,bold
hi DiffText term=reverse cterm=bold ctermbg=Red gui=bold guibg=Red
hi Cursor guibg=Green guifg=NONE
hi lCursor guibg=Cyan guifg=NONE
hi Directory term=bold ctermfg=DarkBlue guifg=Blue
hi LineNr term=underline ctermfg=Brown guifg=Brown
hi MoreMsg term=bold ctermfg=DarkGreen gui=bold guifg=SeaGreen
hi Question term=standout ctermfg=DarkGreen gui=bold guifg=SeaGreen
hi Search term=reverse ctermbg=Yellow ctermfg=NONE guibg=Yellow guifg=NONE
hi SpecialKey term=bold ctermfg=DarkBlue guifg=Blue
hi Title term=bold ctermfg=DarkMagenta gui=bold guifg=Magenta
hi WarningMsg term=standout ctermfg=DarkRed guifg=Red
hi WildMenu term=standout ctermbg=Yellow ctermfg=Black guibg=Yellow guifg=Black
hi Folded term=standout ctermbg=Grey ctermfg=DarkBlue guibg=LightGrey guifg=DarkBlue
hi FoldColumn term=standout ctermbg=Grey ctermfg=DarkBlue guibg=Grey guifg=DarkBlue
hi DiffAdd term=bold ctermbg=LightBlue guibg=LightBlue
hi DiffChange term=bold ctermbg=LightMagenta guibg=LightMagenta
hi DiffDelete term=bold ctermfg=Blue ctermbg=LightCyan gui=bold guifg=Blue guibg=LightCyan

hi StatusLine   cterm=bold ctermbg=blue ctermfg=yellow guibg=gold guifg=blue
hi StatusLineNC cterm=bold ctermbg=blue ctermfg=black  guibg=gold guifg=blue
hi NonText term=bold ctermfg=Blue gui=bold guifg=gray guibg=white
hi Cursor guibg=fg guifg=bg

" syntax highlighting
hi PreProc    term=underline cterm=NONE ctermfg=darkmagenta  gui=NONE guifg=magenta3
hi Identifier term=underline cterm=NONE ctermfg=darkcyan     gui=NONE guifg=cyan4
hi Comment    term=NONE      cterm=NONE ctermfg=darkred      gui=NONE guifg=red2
hi Constant   term=underline cterm=NONE ctermfg=darkgreen    gui=NONE guifg=green3
hi Special    term=bold      cterm=NONE ctermfg=lightred     gui=NONE guifg=deeppink
hi Statement  term=bold      cterm=bold ctermfg=blue         gui=bold guifg=blue
hi Type       term=underline cterm=NONE ctermfg=blue         gui=bold guifg=blue 

if exists("syntax_on")
  let syntax_cmd = "enable"
  runtime syntax/syncolor.vim
  unlet syntax_cmd
endif

" vim: sw=2

"--[ END ]--------------------------------------------------------------------

"--[ File Types ]-------------------------------------------------------------

" Recognise md files as markdown
au BufRead,BufNewFile *.md set filetype=markdown

" Recognise gradle files as Groovy
au BufNewFile,BufRead *.gradle setf groovy

"-----------------------------------------------------------------------------

"==[ END ]====================================================================

"---------------------------------[ VIM HELP ]--------------------------------

" Cheat sheet: http://www.viemu.com/a_vi_vim_graphical_cheat_sheet_tutorial.html

" A buffer is an in-memory representation of the document you are editing, 
" which may or may not be associated with a file on disk. Therefore, tabs do
" not represent an alternative to buffers.

" A window is a view into a buffer.

" A tab (page) is a set of windows (or you can think of it as a layout).

" :map - show key mappings made by plugins (n - normal, v - visual, i - insert)
" :help index - show all key mappings

" Spliting and moving between windows:

" Ctrl+w, s for horizontal splitting
" Ctrl+w, v for vertical splitting
" Ctrl+w, q to close one
" Ctrl+w, Ctrl+w to switch between windows
" Ctrl+w, j (xor k, h, l) to switch to adjacent window

" Ctrl+w, _ minimise other windows
" Ctrl+w, = resize windows to equal size
" :resize [-+]<x>, resize window by/to the given value
