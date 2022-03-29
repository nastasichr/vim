syntax on
set number
set nocompatible
set hlsearch

" To get Vundle: git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim

filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'

" Add plugins here
Plugin 'inkarkat/vim-ingo-library.git'
Plugin 'inkarkat/vim-mark.git'
Plugin 'vim-airline/vim-airline'
Plugin 'junegunn/fzf'
Plugin 'junegunn/fzf.vim'
Plugin 'jremmen/vim-ripgrep'
Plugin 'tpope/vim-fugitive'

call vundle#end()
filetype plugin indent on

" Setting some decent VIM settings for programming
" This source file comes from git-for-windows build-extra repository (git-extra/vimrc)

ru! defaults.vim                " Use Enhanced Vim defaults
set mouse=                      " Reset the mouse setting from defaults
" aug vimStartup | au! | aug END  " Revert last positioned jump, as it is defined below
let g:skip_defaults_vim = 1     " Do not source defaults.vim again (after loading this system vimrc)

set ai                          " set auto-indenting on for programming
set showmatch                   " automatically show matching brackets. works like it does in bbedit.
set vb                          " turn on the "visual bell" - which is much quieter than the "audio blink"
set laststatus=2                " make the last line where the status is two lines deep so you can see status always
set showmode                    " show the current mode
set clipboard=unnamed           " set clipboard to unnamed to access the system clipboard under windows
set wildmode=list:longest,longest:full   " Better command line completion

" Show EOL type and last modified timestamp, right after the filename
" Set the statusline
set statusline=%f               " filename relative to current $PWD
set statusline+=%h              " help file flag
set statusline+=%m              " modified flag
set statusline+=%r              " readonly flag
set statusline+=\ [%{&ff}]      " Fileformat [unix]/[dos] etc...
set statusline+=\ (%{strftime(\"%H:%M\ %d/%m/%Y\",getftime(expand(\"%:p\")))})  " last modified timestamp
set statusline+=%=              " Rest: right align
set statusline+=%l,%c%V         " Position in buffer: linenumber, column, virtual column
set statusline+=\ %P            " Position in buffer: Percentage

if &term =~ 'xterm-256color'    " mintty identifies itself as xterm-compatible
  if &t_Co == 8
    set t_Co = 256              " Use at least 256 colors
  endif
  " set termguicolors           " Uncomment to allow truecolors on mintty
endif
"------------------------------------------------------------------------------
" Only do this part when compiled with support for autocommands.
if has("autocmd")
    " Set UTF-8 as the default encoding for commit messages
    autocmd BufReadPre COMMIT_EDITMSG,MERGE_MSG,git-rebase-todo setlocal fileencodings=utf-8

    " Remember the positions in files with some git-specific exceptions"
    autocmd BufReadPost *
      \ if line("'\"") > 0 && line("'\"") <= line("$")
      \           && &filetype !~# 'commit\|gitrebase'
      \           && expand("%") !~ "ADD_EDIT.patch"
      \           && expand("%") !~ "addp-hunk-edit.diff" |
      \   exe "normal g`\"" |
      \ endif

      autocmd BufNewFile,BufRead *.patch set filetype=diff

      autocmd Filetype diff
      \ highlight WhiteSpaceEOL ctermbg=red |
      \ match WhiteSpaceEOL /\(^+.*\)\@<=\s\+$/
endif " has("autocmd")



" Required for RXWT on Win32 (msys)
map  <Esc>[7~ <Home>
map  <Esc>[8~ <End>
imap <Esc>[7~ <Home>
imap <Esc>[8~ <End>


" Map ctrl-movement keys to window switching
map <C-Up> <C-w><Up>
map <C-Down> <C-w><Down>
map <C-Right> <C-w><Right>
map <C-Left> <C-w><Left>

" Switch to alternate file
map <C-n> :bnext<cr>
map <C-p> :bprevious<cr>
map <C-b><C-d> :bdelete<cr>

""" Function for Error-like highlighting chars beyond 80th column
"command ChrisColumn80CheckerOn let s:Chris_Column80Checker_Active=1 | let w:m1=matchadd('Search', '\%<81v.\%>77v', -1) | let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
"command ChrisColumn80CheckerOff let s:Chris_Column80Checker_Active=0 | if exists("w:m1") | call matchdelete(w:m1) | endif | if exists("w:m2") | call matchdelete(w:m2) | endif
" command ChrisColumn80ChEckerOn let s:Chris_Column80Checker_Active=1 | windo match ErrorMsg '\%>80v.\+'
" command ChrisColumn80CheckerOff let s:Chris_Column80Checker_Active=0 | windo match
" function! Chris_Column80Checker_Toggle()
"     if s:Chris_Column80Checker_Active == 0
"         ChrisColumn80CheckerOn
"         echo "80 columns check ON"
"     else
"         ChrisColumn80CheckerOff
"         echo "80 columns check OFF"
"     endif
" endfunction

" ChrisColumn80CheckerOn
" """ Toggle 80th column checker
" map <silent> <F2> :call Chris_Column80Checker_Toggle()<CR>

""" Set tab 4 spaces
command ChrisTab2spacesOn set tabstop=2  | set shiftwidth=2 | set shiftwidth=2 | set expandtab | echo "TAB = 2 spaces" 
command ChrisTab4spacesOn set tabstop=4  | set shiftwidth=4 | set shiftwidth=4 | set expandtab | echo "TAB = 4 spaces" 
command ChrisTabSpacesOff set tabstop=8  | set shiftwidth=8 | set shiftwidth=8  | set noexpandtab | echo "TAB = TAB (8 wide)" 
map <silent> <F2> :ChrisTab2spacesOn<CR>
map <silent> <F3> :ChrisTab4spacesOn<CR>
map <silent> <F4> :ChrisTabSpacesOff<CR>

""" RipGrep plugin

""" Commands for the taglist plugin
"let Tlist_Ctags_Cmd = "/usr/bin/ctags"
let Tlist_WinWidth = 50
map <F7> :TlistToggle<CR>
map <F8> :!/usr/bin/ctags -R --c++-kinds=+p --fields=+iaS --extra=+q .<CR>

if has("cscope")
        set cscopetag
        set cscopeprg=/usr/bin/cscope
        set csto=0
        set cst
        set nocsverb
        " add any database in current directory
        if filereadable("cscope.out")
            cs add cscope.out
        " else add database pointed to by environment
        elseif $CSCOPE_DB != ""
            cs add $CSCOPE_DB
        endif
        set csverb
        nmap <C-@>s :cs find s <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>g :cs find g <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>c :cs find c <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>t :cs find t <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>e :cs find e <C-R>=expand("<cword>")<CR><CR>
        nmap <C-@>f :cs find f <C-R>=expand("<cfile>")<CR><CR>
        nmap <C-@>i :cs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
        nmap <C-@>d :cs find d <C-R>=expand("<cword>")<CR><CR>
        
        " Using 'CTRL-spacebar' then a search type makes the vim window
        " split horizontally, with search result displayed in
        " the new window.
        
"        nmap <C-space>s :scs find s <C-R>=expand("<cword>")<CR><CR>
"        nmap <C-space>g :scs find g <C-R>=expand("<cword>")<CR><CR>
"        nmap <C-space>c :scs find c <C-R>=expand("<cword>")<CR><CR>
"        nmap <C-space>t :scs find t <C-R>=expand("<cword>")<CR><CR>
"        nmap <C-space>e :scs find e <C-R>=expand("<cword>")<CR><CR>
"        nmap <C-space>f :scs find f <C-R>=expand("<cfile>")<CR><CR>
"        nmap <C-space>i :scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"        nmap <C-space>d :scs find d <C-R>=expand("<cword>")<CR><CR>
"        
"        " Hitting CTRL-space *twice* before the search type does a vertical
"        " split instead of a horizontal one
"        
"        nmap <C-space><C-space>s
"                \:vert scs find s <C-R>=expand("<cword>")<CR><CR>
"        nmap <C-space><C-space>g
"                \:vert scs find g <C-R>=expand("<cword>")<CR><CR>
"        nmap <C-space><C-space>c
"                \:vert scs find c <C-R>=expand("<cword>")<CR><CR>
"        nmap <C-space><C-space>t
"                \:vert scs find t <C-R>=expand("<cword>")<CR><CR>
"        nmap <C-space><C-space>e
"                \:vert scs find e <C-R>=expand("<cword>")<CR><CR>
"        nmap <C-space><C-space>i
"                \:vert scs find i ^<C-R>=expand("<cfile>")<CR>$<CR>
"        nmap <C-space><C-space>d
"                \:vert scs find d <C-R>=expand("<cword>")<CR><CR>
"
        command UpdateCscopeDB exec "!/usr/bin/cscope -ubR" | cs reset
        map <F9> :UpdateCscopeDB<CR><CR>
endif


" if exists('+colorcolumn')
"   set colorcolumn=80
" else
"   au BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>80v.\+', -1)
" endif
"
set colorcolumn=80

:nnoremap <Leader>s :%s/\<<C-r><C-w>\>/


" This is only availale in the quickfix window, owing to the filetype
" restriction on the autocmd (see below).
function! <SID>OpenQuickfix(new_split_cmd)
  " 1. the current line is the result idx as we are in the quickfix
  let l:qf_idx = line('.')
  " 2. jump to the previous window
  wincmd p
  " 3. switch to a new split (the new_split_cmd will be 'vnew' or 'split')
  execute a:new_split_cmd
  " 4. open the 'current' item of the quickfix list in the newly created buffer
  "    (the current means, the one focused before switching to the new buffer)
  execute l:qf_idx . 'cc'
endfunction

autocmd FileType qf nnoremap <buffer> <C-v> :call <SID>OpenQuickfix("vnew")<CR>
autocmd FileType qf nnoremap <buffer> <C-x> :call <SID>OpenQuickfix("split")<CR>


":highlight ExtraWhitespace ctermbg=red guibg=red
" The following alternative may be less obtrusive.
:highlight ExtraWhitespace ctermbg=darkgreen guibg=lightgreen
" Try the following if your GUI uses a dark background.
":highlight ExtraWhitespace ctermbg=darkgreen guibg=darkgreen

" Show trailing whitespace:
:match ExtraWhitespace /\s\+$/
" Show trailing whitespace and spaces before a tab:
:match ExtraWhitespace /\s\+$\| \+\ze\t/
" Show tabs that are not at the start of a line:
":match ExtraWhitespace /[^\t]\zs\t\+/
" Show spaces used for indenting (so you use only tabs for indenting).
":match ExtraWhitespace /^\t*\zs \+/
