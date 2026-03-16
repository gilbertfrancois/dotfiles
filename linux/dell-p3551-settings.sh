sudo grubby --update-kernel=ALL --remove-args="acpi_backlight=vendor"
sudo grubby --update-kernel=ALL --args="i915.enable_lspcon=0"
