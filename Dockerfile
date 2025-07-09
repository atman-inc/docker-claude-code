FROM node:22-bullseye

ARG TZ=Asia/Tokyo
ENV TZ=$TZ

RUN apt update && apt install -y \
    git \
    openssh-client \
    openssh-server \
    && rm -rf /var/lib/apt/lists/*

RUN npm install -g @anthropic-ai/claude-code

RUN useradd -m -s /bin/bash claude
USER claude
WORKDIR /workspace
