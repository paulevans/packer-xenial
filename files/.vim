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
" VAMActivate PLUGIN_NAME PLUGIN_NAME ..

" OPTION 2: use call vam#ActivateAddons
" call vam#ActivateAddons([PLUGIN_NAME], {})
" use <c-x><c-p> to complete plugin names

" OPTION 3: Create a file ~/.vim-scripts putting a PLUGIN_NAME into each line
" See lazy loading plugins section in README.md for details
" call vam#Scripts('~/.vim-scripts', {'tag_regex': '.*'})

set expandtab
set tabstop=4
set shiftwidth=4
set smarttab
set autoindent
set ruler
syntax on

autocmd BufNewFile,BufRead Gemfile,*.pp set filetype=ruby
autocmd BufNewFile,BufRead *.erb set filetype=eruby.html
autocmd BufNewFile,BufRead *.sls set filetype=yaml
autocmd BufNewFile,BufRead *.json set filetype=javascript
autocmd BufNewFile,BufRead *.jinja set filetype=jinja

" special rules by file type
autocmd Filetype yaml call SetYAMLOptions()
function SetYAMLOptions()
    set tabstop=2
    set shiftwidth=2
endfunction
autocmd Filetype html call SetHTMLOptions()
function SetHTMLOptions()
    set tabstop=2
    set shiftwidth=2
endfunction
autocmd Filetype sh call SetBASHOptions()
function SetBASHOptions()
    set tabstop=2
    set shiftwidth=2
endfunction
autocmd Filetype php call SetPHPOptions()
function SetPHPOptions()
    set tabstop=4
    set shiftwidth=4
    set noexpandtab
endfunction

" nice formatting for text files
autocmd BufNewFile,BufRead *.txt set filetype=txt
autocmd FileType txt set wrap
autocmd FileType txt set linebreak
autocmd FileType txt set nolist

if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif
