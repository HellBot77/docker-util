FROM alpine/git AS base

ARG TAG=latest
RUN git clone https://github.com/mat-sz/util.git && \
    cd util && \
    ([[ "$TAG" = "latest" ]] || git checkout ${TAG}) && \
    rm -rf .git

FROM node as build

WORKDIR /util
COPY --from=base /git/util .
RUN yarn && \
    export NODE_ENV=production && \
    yarn build

FROM lipanski/docker-static-website

COPY --from=build /util/dist .
