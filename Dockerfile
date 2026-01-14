FROM alpine AS build
COPY ./gcompat.diff /
ARG GCOMPAT_REF
ARG NODE_VERSION
RUN <<DONE
  set -eux
  apk add build-base curl git
  curl --silent https://nodejs.org/download/release/v$NODE_VERSION/node-v$NODE_VERSION-linux-arm64.tar.gz | tar xz
  git clone https://git.adelielinux.org/adelie/gcompat.git
  cd gcompat
  git checkout "$GCOMPAT_REF"
  cat ../gcompat.diff | git apply
  make LINKER_PATH=/lib/ld-musl-aarch64.so.1 LOADER_NAME=ld-linux-aarch64.so.1 all install
  /node-v$NODE_VERSION-linux-arm64/bin/node -e 'console.log("Hello world.")'
DONE

FROM scratch
COPY --from=build /lib/libgcompat.so.0 /lib/ld-linux-aarch64.so.1 /
