call plug#begin("~/.vim/plugged")

"  Plug 'pluginOwner/pluginNames'
  Plug 'morhetz/gruvbox'
  Plug 'preservim/nerdtree'
  Plug 'tiagofumo/vim-nerdtree-syntax-highlight'
  Plug 'Xuyuanp/nerdtree-git-plugin' 
  Plug 'ryanoasis/vim-devicons'
  Plug 'autozimu/LanguageClient-neovim', {
    \ 'branch': 'next',
    \ 'do': 'bash install.sh',
    \ }
  Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
  Plug 'itchyny/lightline.vim'
  Plug 'tpope/vim-fugitive'
  Plug 'mbbill/undotree'
  Plug 'preservim/nerdcommenter'
  
  Plug 'tpope/vim-surround'
  Plug 'ap/vim-css-color'

  Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
  Plug 'mhinz/vim-startify'
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'majutsushi/tagbar'
call plug#end()


