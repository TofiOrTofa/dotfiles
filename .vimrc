syntax on
set number
set relativenumber
set expandtab
set tabstop=2
set shiftwidth=2
set softtabstop=2
set autoindent
set noswapfile
set noshowmode
set termguicolors
set scrolloff=12   
set nowrap

call plug#begin()
  Plug 'preservim/nerdtree', { 'on': 'NERDTreeToggle' }
  Plug 'arcticicestudio/nord-vim', { 'branch': 'develop' }
  Plug 'vim-airline/vim-airline' "красивая линия снизу
  "Plug 'mattn/emmet-vim'

  "HTML
  Plug 'alvan/vim-closetag'
  Plug 'cohama/lexima.vim'
call plug#end()


" Список расширений файлов, в которых плагин будет работать
let g:closetag_filenames = '*.html,*.xhtml,*.phtml,*.js,*.jsx,*.ts,*.tsx'

" Список типов файлов (filetypes), для которых включен плагин
let g:closetag_filetypes = 'html,xhtml,phtml,javascript,typescript,javascriptreact,typescriptreact'

" Для файлов расширений .xhtml и .jsx делать теги самозакрывающимися (напр. <br />)
let g:closetag_xhtml_filenames = '*.xhtml,*.jsx,*.tsx'

" Настройка сокращения: по умолчанию плагин срабатывает при вводе '>'
let g:closetag_shortcut = '>'

" Дополнительная настройка для React-фрагментов <></>
let g:closetag_enable_react_fragment = 1

let g:AutoPairsMapCR = 1


colorscheme nord
let g:airline_theme='nord'
set laststatus=2
let g:airline_powerline_fonts = 1


set clipboard^=unnamed,unnamedplus

"mappings

map <C-f> :NERDTreeToggle<CR>
