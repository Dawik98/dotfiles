
call plug#begin('~/.config/nvim/plugged')
" Add all plugins below

"Install NERDTree
Plug 'scrooloose/nerdtree'

"Line number
Plug 'jeffkreeftmeijer/vim-numbertoggle'

"Arduino syntax
Plug 'sudar/vim-arduino-syntax'

"Vim syntax
Plug 'potatoesmaster/i3-vim-syntax'

"Matlab syntax ++
Plug 'vim-scripts/MatlabFilesEdition'

"Auto brackets
Plug 'raimondi/delimitmate'

"Ranger plugin
Plug 'francoiscabrol/ranger.vim'

"COLORSCHEMES:
"Solarized
Plug 'lifepillar/vim-solarized8'

"Challenger deep
Plug 'challenger-deep-theme/vim'

call plug#end()



" OTHER CONFIG COMMANDS

"start NERDTree
"autocmd vimenter * NERDTree

"insert new line with enter
nmap <S-Enter> O<Esc>
nmap <Enter> o<Esc>

"use line number
:set number relativenumber

"indent setup
:set tabstop=8    
:set expandtab   
:set shiftwidth=4
:set autoindent 
:set smartindent 
:set cindent 

:syntax enable
:set termguicolors
:set t_Co=256
:set background=dark
:colorscheme rakr


