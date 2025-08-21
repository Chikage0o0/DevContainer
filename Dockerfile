FROM mcr.microsoft.com/devcontainers/base:debian

# Install required packages
RUN apt-get update && apt-get install -y \
    libprotobuf-dev \
    pipx \
    build-essential \
    git \
    ca-certificates \
    python3 \
    git-lfs \
    pre-commit \
    clang \
    mold \
    && rm -rf /var/lib/apt/lists/*

# Switch to user vscode
USER vscode

# Install Rust
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y

# Install cargo-binstall and cargo tools
RUN . $HOME/.cargo/env && \
    curl -L https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash && \
    cargo binstall cargo-deny cargo-nextest cargo-watch tokei rust-script mdbook just --no-confirm && \
    cargo install sea-orm-cli --no-default-features --features cli,codegen,runtime-async-std-rustls,async-std,sqlx-postgres && \
    rm -rf $HOME/.cargo/registry $HOME/.cargo/git