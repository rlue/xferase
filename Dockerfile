# syntax = docker/dockerfile:1.1-experimental
FROM ruby:3.0.1-alpine
MAINTAINER Ryan Lue <hello@ryanlue.com>

RUN apk add --no-cache --update \
    build-base \
    exiftool \
    imagemagick \
    ffmpeg \
    mediainfo \
    optipng \
    tzdata

RUN gem install xferase

ENTRYPOINT xferase --inbox "$INBOX" --staging "$STAGING" --library "$LIBRARY" --library-web "$LIBRARY_WEB" --grace-period "$GRACE_PERIOD"
