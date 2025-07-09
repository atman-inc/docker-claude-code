FROM node:22-bullseye

ARG TZ=America/Los_Angeles
ENV TZ=$TZ

RUN apt update && apt install -y \
    git \
    openssh-client \
    openssh-server \
    procps \
    fzf \
    man-db \
    unzip \
    gnupg2 \
    iptables \
    ipset \
    jq \
    aggregate \
    dnsutils \
    sudo \
    tzdata \
    && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /usr/local/share/npm-global && \
    chown -R node:node /usr/local/share/npm-global && \
    echo 'export PATH="/usr/local/share/npm-global/bin:$PATH"' >> /home/node/.bashrc

RUN echo "node ALL=(ALL) NOPASSWD: /usr/local/bin/init-firewall.sh" >> /etc/sudoers

COPY init-firewall.sh /usr/local/bin/init-firewall.sh
RUN chmod +x /usr/local/bin/init-firewall.sh

RUN mkdir -p /commandhistory && \
    touch /commandhistory/.bash_history && \
    chown -R node:node /commandhistory/.bash_history

ARG USERNAME=node

RUN mkdir -p /usr/local/share/npm-global && \
    chown -R node:node /usr/local/share/npm-global

USER node
WORKDIR /usr/local/share/npm-global

RUN npm config set prefix /usr/local/share/npm-global

RUN npm install -g @anthropic-ai/claude-code

ENV PATH="/usr/local/share/npm-global/bin:$PATH"

WORKDIR /workspace

ENV HISTFILE=/commandhistory/.bash_history
