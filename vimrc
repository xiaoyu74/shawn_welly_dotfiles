" ====================
" General Vim Settings
" ====================
set number                                  " Show line numbers
set cursorline                              " Highlight the current line
set cursorcolumn                            " Highlight the current column
set colorcolumn=100                         " Highlight the 100th column
set nocompatible                            " Disable Vi compatibility mode
set encoding=utf-8                          " Set file encoding to utf-8
set termguicolors                           " Enable true color support
set guifont=Fira\ Code\ Retina:h11          " Set GUI font
let mapleader = ","

" Remap keys for better usability
inoremap jj <ESC>                          " Map 'jj' to ESC in insert mode

" Custom commands for convenience
command! Blame Git blame

" =================
" Plugin Management
" =================
set rtp+=~/.vim/bundle/Vundle.vim           " Set runtime path to include Vundle
filetype off                                " Required by Vundle before initialization

call vundle#begin()                         " Begin Vundle plugin section

" List of plugins managed by Vundle
Plugin 'VundleVim/Vundle.vim'               " Let Vundle manage itself
Plugin 'vim-airline/vim-airline'            " Enhanced status/tabline
Plugin 'tpope/vim-fugitive'                 " Git integration
Plugin 'tpope/vim-commentary'               " Easy commenting
Plugin 'mhartington/oceanic-next'           " Color scheme
Plugin 'airblade/vim-gitgutter'             " Git changes in the gutter
Plugin 'fatih/vim-go'                       " Go development
Plugin 'Valloric/YouCompleteMe'             " Autocompletion
Plugin 'dense-analysis/ale'                 " Asynchronous linting (replaces syntastic)
Plugin 'junegunn/fzf'                       " Fuzzy file finder
Plugin 'junegunn/fzf.vim'                   " Fzf integration
Plugin 'ggreer/the_silver_searcher'         " Ag integration
Plugin 'preservim/nerdtree'                 " File explorer
Plugin 'plasticboy/vim-markdown'            " Markdown support
Plugin 'iamcco/markdown-preview.nvim', { 'do': 'cd app && yarn install' } " Markdown preview plugin with Mermaid support
Plugin 'vim-pandoc/vim-pandoc', {'for': 'markdown'}
Plugin 'vim-pandoc/vim-pandoc-syntax', {'for': 'markdown'}
Plugin 'suan/vim-instant-markdown'          " Markdown preview

call vundle#end()                           " End Vundle plugin section
filetype plugin indent on                   " Enable filetype plugins

" ======================
" Plugin Specific Config
" ======================
" Markdown settings for improved writing
autocmd FileType markdown setlocal spell spelllang=en_us

" Enable Mermaid support in markdown-preview.nvim
let g:mkdp_preview_options = {
      \ 'mkit': {},
      \ 'katex': {},
      \ 'uml': {},
      \ 'maid': {},
      \ 'disable_sync_scroll': 0,
      \ 'sync_scroll_type': 'middle',
      \ 'hide_yaml_meta': 1,
      \ 'sequence_diagrams': {},
      \ 'flowchart_diagrams': {},
      \ 'content_editable': v:false,
      \ 'disable_filename': 0,
      \ 'toc': {}
      \ }

" Automatically start Markdown preview when a Markdown file is opened
autocmd FileType markdown call mkdp#util#install()
autocmd FileType markdown call mkdp#util#open_preview_page()

" Map leader key for manual preview
nmap <leader>p :MarkdownPreview<CR>

" Airline configuration for a better visual experience
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#branch#enabled = 1
let g:airline#extensions#branch#displayed_head_limit = 10

" Go development settings with vim-go for enhanced productivity
let g:go_def_mode='gopls'
let g:go_info_mode='gopls'
let g:go_fmt_command = "goimports"
au FileType go nmap <Leader>i <Plug>(go-info)
au FileType go nmap <Leader>d <Plug>(go-def)

" YouCompleteMe configuration for smarter autocompletion
let g:ycm_language_server = [{'name': 'go', 'cmdline': ['gopls'], 'filetypes': ['go']}]

" ALE linting and fixing settings for cleaner code
let g:ale_linters_explicit = 1
let g:ale_linters = {'go': ['gopls', 'golint', 'govet']}
let g:ale_fixers = {'go': ['gofmt', 'goimports']}
let g:ale_fix_on_save = 1
set updatetime=300

" NERDTree for easy navigation and file management
nmap <C-n> :NERDTreeToggle<CR>

" Fzf and The Silver Searcher for efficient searching
set rtp+=~/.fzf

command! FzfFilesFromSpecificFolder cd ~/osd_functional_work | Files

" Function for searching and highlighting files in NERDTree
function! OpenFileAndFindInNerdTree()
  FzfFilesFromSpecificFolder
  autocmd BufReadPost * ++once NERDTreeFind
endfunction

" Map the function to a shortcut, for example <Leader>f
nnoremap <silent> <C-s> :call OpenFileAndFindInNerdTree()<CR>

" =======================
" Visuals and Color Theme
" =======================
colorscheme OceanicNext                      " Set the color scheme to OceanicNext

" Customize the appearance of the completion menu
highlight Pmenu guibg=#D3D3D3 guifg=#505050

" Customize Go syntax highlighting
highlight goDeclaration guifg=#ADD8E6
highlight goStatement guifg=#D291E4
highlight goVar guifg=#ADD8E6
highlight goPackage guifg=#ADD8E6
highlight goImport guifg=#ADD8E6

" Language-Specific Settings
" ==========================
" Go development enhancements
nnoremap <Leader>g :YcmCompleter GoTo<CR>
nnoremap <Leader>b <C-o>
