# 💤 LazyVim

A starter template for [LazyVim](https://github.com/LazyVim/LazyVim).
Refer to the [documentation](https://lazyvim.github.io/installation) to get started.

## Installation

### Common

```bash
git clone git@github.com/ysl2/starter.git ~/.config/nvim

sudo apt install -y xsel  # For clipboard support
brew install rustup; rustup toolchain install nightly  # For blink.cmp
brew install pngpaste  # For img-clip.nvim

# For zathura in vimtex
# Ref: https://github.com/zegervdv/homebrew-zathura?tab=readme-ov-file#osx_native_integration
brew install girara --HEAD
brew install zathura --HEAD
mkdir -p $(brew --prefix zathura)/lib/zathura
ln -s $(brew --prefix zathura-pdf-poppler)/libpdf-poppler.dylib $(brew --prefix zathura)/lib/zathura/libpdf-poppler.dylib

# https://ghproxy.link

`custom = true`: This means that the plugin is added by myself.
```

### For windows specific

```bash
git clone git@github.com:ysl2/starter.git 'C:\Users\Songli Yu\AppData\Local\nvim'
```
