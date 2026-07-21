filetype plugin indent on
syntax on
set title
set tabstop=8
set softtabstop=8
set shiftwidth=8
set noexpandtab
set autoindent
set smartindent
set number
set cursorline

let NERDTreeShowHidden=1
call plug#begin('~/.vim/plugged')

" --- Theme & UI ---
Plug 'sainnhe/sonokai'             " High-contrast, vibrant theme
Plug 'itchyny/lightline.vim'       " Clean statusline
Plug 'preservim/nerdtree'          " File tree sidebar (:NERDTree)
Plug 'ctrlpvim/ctrlp.vim'          " Fuzzy file finder (Ctrl+P)
Plug 'easymotion/vim-easymotion'   " Jump anywhere fast (<leader><leader>w)

call plug#end()

" --- Theme Configuration ---
if has('termguicolors')
  set termguicolors
endif

set background=dark
" 'atlantis' is very vibrant and high-contrast
let g:sonokai_style = 'atlantis'
let g:sonokai_better_performance = 1
let g:sonokai_enable_italic = 1
colorscheme sonokai

let g:lightline = {'colorscheme' : 'sonokai'}

" --- Transparency Fix ---
function! AdaptToTerminal()
    highlight Normal guibg=NONE ctermbg=NONE
    highlight NonText guibg=NONE ctermbg=NONE
    highlight EndOfBuffer guibg=NONE ctermbg=NONE
    highlight LineNr guibg=NONE ctermbg=NONE
    highlight SignColumn guibg=NONE ctermbg=NONE
    highlight MatchParen guifg=#FFFFFF guibg=#FF5F00 gui=bold
    highlight Terminal guibg=NONE ctermbg=NONE
    highlight StatusLine guibg=NONE ctermbg=NONE
    highlight StatusLineNC guibg=NONE ctermbg=NONE
endfunction

autocmd ColorScheme * call AdaptToTerminal()
call AdaptToTerminal()

" --- Keybindings ---
nnoremap <C-n> :NERDTreeToggle<CR>
autocmd StdinReadPre * let s:std_in=1
autocmd VimEnter * if argc() == 0 && !exists('s:std_in') | NERDTree | endif
autocmd BufEnter * if tabpagenr('$') == 1 && winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
nnoremap <C-f> :NERDTreeFind<CR>

" --- Linux Kernel C Style ---
autocmd FileType c,cpp setlocal cindent cinoptions=:0,l1,t0,g0,(0
