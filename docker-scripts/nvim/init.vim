source $HOME/.config/nvim/plugins.vim

if (has("termguicolors"))
 set termguicolors
endif
set background=dark
colorscheme gruvbox

"Enable Mouse Support
set mouse=a

" use alt+hjkl to move between split/vsplit panels
tnoremap <A-h> <C-\><C-n><C-w>h
tnoremap <A-j> <C-\><C-n><C-w>j
tnoremap <A-k> <C-\><C-n><C-w>k
tnoremap <A-l> <C-\><C-n><C-w>l
nnoremap <A-h> <C-w>h
nnoremap <A-j> <C-w>j
nnoremap <A-k> <C-w>k
nnoremap <A-l> <C-w>l
"Split panel
nnoremap <leader>v <C-w>v
nnoremap <leader>s <C-w>s
"Map yanked to clipboard
vnoremap <C-c> "*y


nmap <F8> :TagbarToggle<CR> 

"Editor Config
syntax enable
syntax on
set nowrap " set no soft wrap
set tabstop=2 softtabstop=2 " set tab size
set shiftwidth=2 " affect amount of indentation
set expandtab " set that tab will insert softabstop amount of space characters
set number " set line number
set breakindent                                      
set smartindent
set smartcase
set incsearch
set hidden

"Load up my various Plugin Configs:
source $HOME/.config/nvim/tree.vim
source $HOME/.config/nvim/lang.vim
source $HOME/.config/nvim/coc.vim
source $HOME/.config/nvim/commenter.vim
source $HOME/.config/nvim/status.vim
source $HOME/.config/nvim/search.vim
