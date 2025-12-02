FROM mcr.microsoft.com/devcontainers/base:debian-13

ENV DEBIAN_FRONTEND=noninteractive \
    PATH="/home/vscode/.cargo/bin:/home/vscode/.bun/bin:${PATH}"

SHELL ["/bin/bash", "-c"]

# 安装系统依赖、中文字体、Chromium 依赖、开发工具、Docker CLI 和 Compose 插件
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
        ca-certificates curl gnupg git git-lfs python3 build-essential pre-commit clang mold pipx libprotobuf-dev protobuf-compiler \
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
    rustup component add rust-analyzer && \
    curl -L https://raw.githubusercontent.com/cargo-bins/cargo-binstall/main/install-from-binstall-release.sh | bash && \
    cargo binstall --no-confirm cargo-deny cargo-nextest cargo-watch tokei rust-script mdbook sqlx-cli sea-orm-cli just && \
    rm -rf "$HOME/.cargo/registry" "$HOME/.cargo/git"
    
# 安装 uv (Python 包管理器)
RUN curl -LsSf https://astral.sh/uv/install.sh | sh

# 安装 Node.js
RUN curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash && \
    /bin/bash -c "source $HOME/.nvm/nvm.sh && nvm install --lts && npm install -g @go-task/cli && npm install -g pnpm" 

# 安装 Go 语言环境到用户目录
RUN GO_VERSION=$(curl -s "https://go.dev/VERSION?m=text" | head -n 1) && \
    ARCH=$(dpkg --print-architecture) && \
    TEMP_GO_TAR="${GO_VERSION}.linux-${ARCH}.tar.gz" && \
    curl -L "https://go.dev/dl/${TEMP_GO_TAR}" -o "/tmp/${TEMP_GO_TAR}" && \
    tar -C "$HOME" -xzf "/tmp/${TEMP_GO_TAR}" && \
    rm "/tmp/${TEMP_GO_TAR}"

# 设置 Go 环境变量
ENV GOROOT="/home/vscode/go"
ENV GOPATH="/home/vscode/go_workspace"
ENV PATH="${GOROOT}/bin:${GOPATH}/bin:${PATH}"