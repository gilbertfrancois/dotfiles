lua << EOF
require'lspconfig'.pyright.setup{
	on_attach = function()
		print("Attached pyright to the LSP server.")
	end,
}
EOF
