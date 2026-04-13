FROM ruby:4.0
LABEL maintainer="alex.kochurov@gmail.com"

RUN apt-get update -yqq && apt-get install -yqq --no-install-recommends \
  curl \
  nano \
  git \
  && rm -rf /var/lib/apt/lists/*

# Install JavaScript dependencies
ARG NODE_VERSION=22.22.2
ARG YARN_VERSION=1.22.22
RUN ARCH=$(dpkg --print-architecture) && \
    if [ "$ARCH" = "amd64" ]; then ARCH="x64"; fi && \
    curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/SHASUMS256.txt" -o /tmp/SHASUMS256.txt && \
    curl -fsSL "https://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-${ARCH}.tar.xz" -o /tmp/node.tar.xz && \
    EXPECTED=$(grep "node-v${NODE_VERSION}-linux-${ARCH}.tar.xz" /tmp/SHASUMS256.txt | awk '{print $1}') && \
    echo "${EXPECTED}  /tmp/node.tar.xz" | sha256sum -c - && \
    tar -xJ --strip-components=1 -C /usr/local/ -f /tmp/node.tar.xz && \
    rm /tmp/node.tar.xz /tmp/SHASUMS256.txt && \
    npm install -g yarn@$YARN_VERSION

WORKDIR /usr/src/app

ARG UID=1000
ARG GID=1000

RUN groupadd -g $GID app && \
    useradd -m -s /bin/bash -u $UID -g $GID app && \
    chown -R app:app /usr/src/app

USER app

CMD ["bin/rails", "s", "-b", "0.0.0.0"]
