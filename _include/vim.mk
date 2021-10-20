VIM_PLUG_VER ?= fc2813ef4484c7a5c080021ceaa6d1f70390d920

update-vim-plug:
	curl -fLo ./vim/.vim/autoload/plug.vim --create-dirs \
	  https://raw.githubusercontent.com/junegunn/vim-plug/$(VIM_PLUG_VER)/plug.vim

