#!/usr/bin/env bash
set -xe

NVIM_VERSION="0.9.5"
# NODE_VERSION="18.16.0" # NodeJS LTS
NODE_VERSION="20.11.0" # NodeJS LTS
# FZF_VERSION="0.35.0"
# LUA_LSP_VERSION="3.6.4"
# VSCODE_LLDB_VERSION="1.8.1"

NVIM_CONFIG_DIR=${HOME}/.config/nvim
NVIM_SHARE_DIR=${HOME}/.local/share/nvim
NVIM_STATE_DIR=${HOME}/.local/state/nvim
NVIM_CACHE_DIR=${HOME}/.cache/nvim
NVIM_LIB_DIR=${NVIM_SHARE_DIR}/lib

if ! type "sudo" >/dev/null; then
	echo "No sudo command found."
	SUDO=""
else
	echo "sudo command found."
	SUDO=sudo
fi

function reset_config_dir {
	echo "--- (Re)setting Neovim config folder."
	rm -rf ${NVIM_CONFIG_DIR}
	rm -rf ${NVIM_SHARE_DIR}
	rm -rf ${NVIM_STATE_DIR}
	rm -rf ${NVIM_CACHE_DIR}
}

function init_config_dir {
	mkdir -p ${HOME}/.config
	mkdir -p ${NVIM_SHARE_DIR}
	mkdir -p ${NVIM_LIB_DIR}
}

function install_deps {
	echo "--- Installing additional dependencies."
	# TODO: Install version for ARMv8
	if [[ $(uname -s) == "Linux" ]]; then
		${SUDO} apt update
		${SUDO} apt install -y libfuse2 kmod
	elif [[ $(uname -s) == "Darwin" ]]; then
		# brew reinstall curl ctags the_silver_searcher fd ripgrep wget pandoc pandoc-crossref rust ninja
		echo "No additional dependencies to install on macOS."
	fi
}

function install_neovim {
	echo "--- Installing Neovim."
	if [[ $(uname -s) == "Linux" ]]; then
		if [[ $(uname -m) == "x86_64" ]]; then
			sudo apt update
			sudo apt install make gcc ripgrep unzip git xclip curl
			# Now we install nvim
			curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux64.tar.gz
			sudo rm -rf /opt/nvim-linux64
			sudo mkdir -p /opt/nvim-linux64
			sudo chmod a+rX /opt/nvim-linux64
			sudo tar -C /opt -xzf nvim-linux64.tar.gz
			# make it available in /usr/local/bin, distro installs to /usr/bin
			sudo ln -sf /opt/nvim-linux64/bin/nvim /usr/local/bin/
		elif [[ $(uname -m) == "aarch64" ]]; then
			${SUDO} apt install -y libuv1 lua-luv-dev lua-lpeg-dev
			echo "Build Neovim from source."
		elif [[ $(uname -m) == "armv7l" ]]; then
			${SUDO} apt install -y libuv1 lua-luv-dev lua-lpeg-dev
			echo "Build Neovim from source."
		fi
	elif [[ $(uname -s) == "Darwin" ]]; then
		brew update
		brew reinstall neovim wget
	else
		echo "Unsupported OS."
	fi
}

function install_python {
	echo "--- Installing python environment for NeoVim."
	if [[ $(uname -s) == "Linux" ]]; then
		${SUDO} apt update
		${SUDO} apt install -y python3-venv
	elif [[ $(uname -s) == "Darwin" ]]; then
		brew update
		brew reinstall python
	else
		echo "Unsupported OS."
	fi
	VENV_PATH="${NVIM_LIB_DIR}/python"
	rm -rf ${VENV_PATH}
	cd ${NVIM_LIB_DIR}
	python3 -m venv ${VENV_PATH}
	source ${VENV_PATH}/bin/activate
	# Avoid problems due to outdated pip.
	pip install --upgrade pip
	pip install setuptools wheel
	# Install neovim extension
	pip install pynvim
}

function install_node {
	INSTALL_DIR=${NVIM_LIB_DIR}
	echo "--- Installing nodejs."
	if [[ $(uname -s) == "Linux" ]]; then
		NODE_OS="linux"
		NODE_EXTENSION="tar.gz"
		if [[ $(uname -m) == "x86_64" ]]; then
			NODE_ARCH="x64"
		elif [[ $(uname -m) == "aarch64" ]]; then
			if [[ $(getconf LONG_BIT) == "32" ]]; then
				NODE_ARCH="armv7l"
			else
				NODE_ARCH="arm64"
			fi
		elif [[ $(uname -m) == "armv7l" ]]; then
			FZF_ARCH="armv7l"
		fi
	elif [[ $(uname -s) == "Darwin" ]]; then
		NODE_OS="darwin"
		NODE_EXTENSION="tar.gz"
		if [[ $(uname -m) == "x86_64" ]]; then
			NODE_ARCH="x64"
		elif [[ $(uname -m) == "arm64" ]]; then
			NODE_ARCH="arm64"
		fi
	fi
	cd /tmp
	rm -rf node*
	rm -rf ${NVIM_LIB_DIR}/node*
	wget https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.${NODE_EXTENSION}
	echo "node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.${NODE_EXTENSION}"
	tar -xvf node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH}.${NODE_EXTENSION}
	mv node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH} ${NVIM_LIB_DIR}
	ln -s ${NVIM_LIB_DIR}/node-v${NODE_VERSION}-${NODE_OS}-${NODE_ARCH} ${NVIM_LIB_DIR}/node
	export PATH=${NVIM_LIB_DIR}/node/bin:$PATH

	${NVIM_LIB_DIR}/node/bin/npm install --location=global --prefix ${NVIM_LIB_DIR}/node neovim
}

function install_fzf {
	echo "--- Installing FZF."
	if [[ $(uname -s) == "Linux" ]]; then
		FZF_OS="linux"
		FZF_EXTENSION="tar.gz"
		if [[ $(uname -m) == "x86_64" ]]; then
			FZF_ARCH="amd64"
		elif [[ $(uname -m) == "aarch64" ]]; then
			FZF_ARCH="arm64"
		elif [[ $(uname -m) == "armv7l" ]]; then
			FZF_ARCH="armv7"
		fi
		cd /tmp
		wget https://github.com/junegunn/fzf/releases/download/${FZF_VERSION}/fzf-${FZF_VERSION}-${FZF_OS}_${FZF_ARCH}.${FZF_EXTENSION}
		tar zxvf fzf-${FZF_VERSION}-${FZF_OS}_${FZF_ARCH}.tar.gz
		${SUDO} cp fzf /usr/local/bin
	elif [[ $(uname -s) == "Darwin" ]]; then
		brew reinstall fzf
	fi
}

function lsp_extensions {
	# Python
	${HOME}/.local/share/nvim/lib/python/bin/python -m pip install pynvim pyright black isort

	# LaTeX
	cargo install --force texlab

	# # GLSL
	pushd /tmp
	rm -rf glsl-language-server
	git clone https://github.com/svenstaro/glsl-language-server.git
	cd glsl-language-server
	pwd
	git submodule update --init
	cmake -Bbuild -GNinja
	ninja -Cbuild
	${SUDO} ninja -Cbuild install
	popd

	# Lua
	pushd /tmp
	if [[ $(uname -s) == "Linux" ]]; then
		OS="linux"
	elif [[ $(uname -s) == "Darwin" ]]; then
		OS="darwin"
	else
		OS=""
		echo "Unsupported OS."
	fi
	if [[ $(uname -m) == "x86_64" ]]; then
		ARCH="x64"
	elif [[ $(uname -m) == "arm64" ]]; then
		ARCH="arm64"
	elif [[ $(uname -m) == "aarch64" ]]; then
		ARCH="aarch64"
	elif [[ $(uname -m) == "armv7l" ]]; then
		ARCH="armv71"
	else
		ARCH=""
		echo "Unsupported architecture"
	fi

	wget https://github.com/sumneko/lua-language-server/releases/download/${LUA_LSP_VERSION}/lua-language-server-${LUA_LSP_VERSION}-${OS}-${ARCH}.tar.gz
	rm -rf lua-language-server
	mkdir lua-language-server
	cd lua-language-server
	tar zxvf ../lua-language-server-${LUA_LSP_VERSION}-${OS}-${ARCH}.tar.gz
	cd ..
	rm -rf ${NVIM_LIB_DIR}/lua-language-server
	cp -r lua-language-server ${NVIM_LIB_DIR}/
	popd
}

function install_dap_extensions {
	if [[ $(uname -s) == "Linux" ]]; then
		OS="linux"
	elif [[ $(uname -s) == "Darwin" ]]; then
		OS="darwin"
	else
		OS=""
		echo "Unsupported OS."
	fi
	if [[ $(uname -m) == "x86_64" ]]; then
		ARCH="x86_64"
	elif [[ $(uname -m) == "aarch64" ]]; then
		ARCH="aarch64"
	elif [[ $(uname -m) == "arm64" ]]; then
		ARCH="aarch64"
	elif [[ $(uname -m) == "armv7l" ]]; then
		ARCH="arm"
	else
		ARCH=""
		echo "Unsupported architecture"
	fi

	pushd /tmp
	rm -rf /tmp/vscode_lldb
	mkdir /tmp/vscode_lldb
	cd /tmp/vscode_lldb
	wget https://github.com/vadimcn/vscode-lldb/releases/download/v${VSCODE_LLDB_VERSION}/codelldb-${ARCH}-${OS}.vsix
	unzip codelldb-${ARCH}-${OS}.vsix
	rm -f codelldb-${ARCH}-${OS}.vsix
	cd ..
	mv vscode_lldb ${NVIM_LIB_DIR}
	popd
}

function __os_template {
	if [[ $(uname -s) == "Linux" ]]; then
		OS="linux"
	elif [[ $(uname -s) == "Darwin" ]]; then
		OS="darwin"
	else
		OS=""
		echo "Unsupported OS."
	fi
	if [[ $(uname -m) == "x86_64" ]]; then
		ARCH="x86_64"
	elif [[ $(uname -m) == "aarch64" ]]; then
		ARCH="aarch64"
	elif [[ $(uname -m) == "armv7l" ]]; then
		ARCH="armv71"
	else
		ARCH=""
		echo "Unsupported architecture"
	fi
}

function install_alias {
	ALIAS="alias nvim='PATH=${HOME}/.local/share/nvim/lib/python/bin:${HOME}/.local/share/nvim/lib/node/bin:\${PATH} nvim'"
	PROFILE_PATH=${HOME}/.profile
	if grep "alias nvim" ${PROFILE_PATH}; then
		echo "  - Alias already installed in ${PROFILE_PATH}."
	else
		echo ${ALIAS} >>${PROFILE_PATH}
		echo "  - Alias added to ${PROFILE_PATH}."
	fi
}

reset_config_dir
init_config_dir
ln -s ${HOME}/.dotfiles/nvim/config/nvim ${HOME}/.config/nvim
install_neovim
install_deps
install_python
install_node
install_alias
source ${HOME}/.profile
if [[ $(uname -s) == "Linux" ]]; then
	${SUDO} /usr/sbin/modprobe fuse
fi
nvim --headless "+Lazy! sync" +qa
