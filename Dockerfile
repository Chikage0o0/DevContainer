FROM mcr.microsoft.com/devcontainers/base:debian-13

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/home/vscode/.cargo/bin:/home/vscode/.bun/bin:${PATH}"

SHELL ["/bin/bash", "-c"]

# 安装系统依赖、中文字体、Chromium 依赖、开发工具、Docker CLI 和 Compose 插件
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates curl gnupg git git-lfs python3 build-essential pre-commit clang mold pipx libprotobuf-dev \
        libasound2 libatk-bridge2.0-0 libatk1.0-0 libatspi2.0-0 libc6 libcairo2 libcups2 libdbus-1-3 libdrm2 \
        libexpat1 libgbm1 libglib2.0-0 libnspr4 libnss3 libpango-1.0-0 libpangocairo-1.0-0 libstdc++6 libudev1 \
        libuuid1 libx11-6 libx11-xcb1 libxcb-dri3-0 libxcb1 libxcomposite1 libxcursor1 libxdamage1 libxext6 \
        libxfixes3 libxi6 libxkbcommon0 libxrandr2 libxrender1 libxshmfence1 libxss1 libxtst6 \
        fonts-liberation xdg-utils lsb-release fonts-noto-cjk fonts-wqy-zenhei && \
    install -m 0755 -d /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/debian/gpg | gpg --dearmor -o /etc/apt/keyrings/docker.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/debian $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && \
    apt-get install -y --no-install-recommends docker-ce-cli docker-compose-plugin && \
    rm -rf /var/lib/apt/lists/* /etc/apt/keyrings/docker.gpg /etc/apt/sources.list.d/docker.list

USER vscode

# 安装 Rust、cargo 工具链及常用 cargo 扩展
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | bash -s -- -y && \
    . "$HOME/.cargo/env" && \
    curl -L https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash && \
    cargo binstall --no-confirm cargo-deny cargo-nextest cargo-watch tokei rust-script mdbook sqlx-cli sea-orm-cli just && \
    rm -rf "$HOME/.cargo/registry" "$HOME/.cargo/git"

# 安装 Bun
RUN curl -fsSL https://bun.sh/install | bash

# 安装 task
RUN bun install -g @go-task/cli

# 设置 node别名
RUN mkdir -p ~/.local/bin/ && \
    ln -sf "$(which bun)" ~/.local/bin/node && \
    ln -sf "$(which bun)" ~/.local/bin/npm && \
    ln -sf "$(which bunx)" ~/.local/bin/npx
