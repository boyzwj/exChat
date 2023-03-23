FROM bitwalker/alpine-elixir:latest AS developer
ENV RUNNING_IN_DOCKER true

# Install build dependencies
RUN apk update && \
    apk --no-cache add \
    build-base \
    curl \
    git \
    gnome-keyring \
    libgcc \
    ca-certificates \
    gcc \
    g++ \
    rust \
    cargo \
    protoc \
    inotify-tools \
    vim \
    tzdata \
    openssh \
    npm \
    zsh zsh-autosuggestions zsh-syntax-highlighting bind-tools


ENV TZ=Asia/Shanghai


# RUN apk add --update npm


RUN sh -c "$(wget https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh -O -)"

RUN echo "ZSH_THEME=\"robbyrussell\""  >> ~/.zshrc && \
    echo "source /usr/share/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" >> ~/.zshrc && \
    echo "source /usr/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" >> ~/.zshrc && \
    echo "alias ll='ls -alF'" >>  ~/.zshrc

RUN /bin/zsh ~/.zshrc


RUN mix local.hex --force \
    && mix local.rebar --force \
    && mix archive.install --force hex phx_new 1.7.2


ARG GIT_USER_NAME
ARG SVN_USER_NAME
ARG SVN_PASSWORD
ENV GIT_USER_NAME=${GIT_USER_NAME}\
    ERL_AFLAGS="-kernel shell_history enabled"\
    SVN_USER_NAME=${SVN_USER_NAME}\
    SVN_PASSWORD=${SVN_PASSWORD}

RUN git config --global --add safe.directory /ws/exChat

RUN git config --global user.email "${GIT_USER_NAME}@illusioncolors.com" && \
    git config --global user.name "${GIT_USER_NAME}"

