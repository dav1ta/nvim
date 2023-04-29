FROM alpine:3.17

# Install necessary packages
RUN apk add --no-cache neovim nodejs npm git gcc ripgrep g++ python3 py3-pip
RUN npm install -g tree-sitter-cli

# Set default editor to Neovim
ENV EDITOR=nvim


RUN git clone https://github.com/dav1ta/nvim ~/.config/nvim && cd ~/.config/nvim && git checkout v8.3
# Set the default working directory

# Launch Neovim by default
CMD ["sleep", "infinity"]

