FROM mcr.microsoft.com/devcontainers/ruby:0-3-bullseye

ARG USERNAME=${USERNAME}
ARG USER_UID=${USER_UID}
ARG USER_GID=${USER_GID}
ARG TIME_ZONE=${TIME_ZONE}
ARG LOCALE=${LOCALE}

ENV LANG=${LOCALE}
ENV LANGUAGE=${LANGUAGE}
ENV TZ=${TIME_ZONE}

RUN apt-get update \
  && apt-get install -y locales \
  && locale-gen ja_JP.UTF-8 \
  && localedef -f UTF-8 -i ja_JP ja_JP.UTF-8 \
  && update-locale LANG=ja_JP.UTF-8

RUN ln -snf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime \
  && echo ${TIME_ZONE} > /etc/timezone 

USER ${USER_UID}

RUN curl https://get.volta.sh | bash

RUN echo -n "\n\
LANG="${LANG}"\n\
LANGUAGE="${LANGUAGE}"\n\
LC_ALL="${LOCALE}"\n\
" >> ~/.bashrc
