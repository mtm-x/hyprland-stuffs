filetype plugin indent on
syntax on
set title
set tabstop=8
set softtabstop=8
set shiftwidth=8
set noexpandtab
set number


let NERDTreeShowHidden=1
call plug#begin('~/.vim/plugged')

" --- your plugins go here ---
Plug 'preservim/nerdtree'          " File tree sidebar (:NERDTree)
Plug 'ctrlpvim/ctrlp.vim'          " Fuzzy file finder (Ctrl+P)
Plug 'easymotion/vim-easymotion'   " Jump anywhere fast (<leader><leader>w)

call plug#end()


" Toggle with Ctrl+n
nnoremap <C-n> :NERDTreeToggle<CR>

" Open NERDTree automatically when vim starts with no file
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif

" Close vim if NERDTree is the only window left
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 &&
  \ exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif

" Keep NERDTree in sync with current file
nnoremap <C-f> :NERDTreeFind<CR>
