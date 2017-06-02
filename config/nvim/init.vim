syntax on
scriptencoding utf-8

" Basic {{{
set cmdheight=3
set cursorline
set hidden
set history=1000
set showcmd
set showmatch
set showtabline=2
set termguicolors

" folding
set foldmethod=marker

" line number
set number
set relativenumber

" tab character
set expandtab
set shiftwidth=2
set softtabstop=2
set tabstop=2

" encoding
set fileencodings=utf-8,euc-jp

" search
set hlsearch
set ignorecase
set incsearch
set smartcase
set wrapscan

" undofile
set undofile
set undodir=~/.undo

" auto cd
au BufEnter * execute ":lcd " . expand("%:p:h")

" }}}

" stataus line {{{
set statusline=%F%m%r%h%w\ [%{&ff}]\ [%Y]\ (%04l,%04v)[%p%%]
set laststatus=2
au InsertEnter * hi StatusLine guifg=DarkBlue guibg=DarkYellow gui=none ctermfg=Black ctermbg=Yellow cterm=none
au InsertLeave * hi StatusLine guifg=DarkBlue guibg=DarkGray gui=none ctermfg=Black ctermbg=White cterm=none

if has('unix') && !has('gui_running')
  inoremap <silent> <ESC> <ESC>
  inoremap <silent> <C-[> <ESC>
  inoremap <silent> <C-c> <ESC>
endif

" }}}

" abbrev {{{
ia esd /* eslint-disable */
ia fsl # frozen_string_literal: true
" }}}

" invisible character {{{
" special character
set list
set lcs=tab:.\ ,trail:_

let &showbreak = "\u21b3 "

set display=uhex

" Strip trailing space before file write
autocmd BufWritePre * call StripTrailingWhite()
function! StripTrailingWhite()
  let l:winview = winsaveview()
  silent! %s/\s\+$//
  call winrestview(l:winview)
endfunction

" }}}

" key bindings {{{
let g:no_ocaml_maps = 1
let maplocalleader = "\\"
" }}}

" Plugin Manager {{{
let s:dein_dir = expand('~/.cache/dein')
let s:dein_repo_dir = s:dein_dir . '/repos/github.com/Shougo/dein.vim'

if !isdirectory(s:dein_repo_dir)
  execute '!git clone https://github.com/Shougo/dein.vim' s:dein_repo_dir
endif

execute 'set runtimepath^=' . s:dein_repo_dir

if dein#load_state(s:dein_dir)
  call dein#begin(s:dein_dir)
  call dein#add(s:dein_dir)
  call dein#add('vim-scripts/desert256.vim')
  call dein#add('vim-scripts/buftabs')
  call dein#add('vim-utils/vim-ruby-fold')
  call dein#add('Shougo/denite.nvim')
  call dein#add('Shougo/neomru.vim')
  call dein#add('Shougo/neoyank.vim')
  call dein#add('vim-airline/vim-airline')
  call dein#add('vim-airline/vim-airline-themes')
  call dein#add('nathanaelkane/vim-indent-guides')
  call dein#add('let-def/ocp-indent-vim')
  call dein#add('rust-lang/rust.vim')
  call dein#add('ocaml/merlin', { 'rtp': 'vim/merlin', 'rev': 'v2.5.3' })
  call dein#add('reasonml/vim-reason')
  call dein#end()
  call dein#save_state()
endif

if dein#check_install()
  call dein#install()
endif

filetype plugin indent on
syntax enable

" }}}

" Other Plugin settings {{{
colorscheme desert256
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#buffer_idx_mode = 1
let g:airline_powerline_fonts = 1

let g:indent_guides_enable_on_vim_startup = 1
let g:indent_guides_guide_size = 2
let g:indent_guides_auto_colors = 0
autocmd VimEnter,Colorscheme * hi IndentGuidesOdd  guibg=#303030
" }}}

" Denite {{{
nnoremap <silent> ,ub :<C-u>Denite buffer<CR>
nnoremap <silent> ,ur :<C-u>Denite buffer file_mru<CR>
nnoremap <silent> ,uy :<C-u>Denite neoyank regiser<CR>
nnoremap <silent> ,uf :<C-u>DeniteProjectDir file_rec<CR>
nnoremap <silent> ,ug :<C-u>DeniteProjectDir grep<CR>
nnoremap <silent> ,uu :<C-u>Denite menu<CR>

call denite#custom#map('insert', '<C-n>',
      \ '<denite:move_to_next_line>', 'noremap')
call denite#custom#map('insert', '<C-p>',
      \ '<denite:move_to_previous_line>', 'noremap')
call denite#custom#map('insert', '<C-a>',
      \ '<denite:move_caret_to_head>', 'noremap')
call denite#custom#map('insert', '<C-e>',
      \ '<denite:move_caret_to_tail>', 'noremap')
call denite#custom#map('insert', '<C-k>',
      \ '<denite:delete_text_after_caret>', 'noremap')

call denite#custom#var('file_rec', 'command', ['ag', '--follow', '--nocolor', '--nogroup', '-g', ''])
call denite#custom#var('grep', 'command', ['ag'])
call denite#custom#var('grep', 'recursive_opts', [])
call denite#custom#var('grep', 'pattern_opt', [])
call denite#custom#var('grep', 'final_opts', [])
call denite#custom#var('grep', 'separator', [])
call denite#custom#var('grep', 'default_opts',
      \ ['--nocolor', '--nogroup'])

let s:menus = {}
let s:menus.denite = { 'description': 'show denite other sources' }
let s:menus.denite.command_candidates = [
\ ['register', 'Denite register'],
\ ['outline', 'Denite outline']
\]

let s:menus.vim = { 'description': 'use vim configures' }
let s:menus.vim.command_candidates = [
\ ['filetype', 'Denite filetype'],
\ ['reload', 'source ~/.config/nvim/init.vim']
\]

call denite#custom#var('menu', 'menus', s:menus)
" }}}
