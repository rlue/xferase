# syntax = docker/dockerfile:1.1-experimental
FROM ruby:3.4-alpine
MAINTAINER Ryan Lue <hello@ryanlue.com>

RUN apk add --no-cache --update \
    build-base \
    exiftool \
    imagemagick \
    ffmpeg \
    mediainfo \
    optipng \
    tzdata

RUN gem install xferase --version 0.1.9

ENTRYPOINT xferase --inbox "$INBOX" --library "$LIBRARY" --library-web "$LIBRARY_WEB"
