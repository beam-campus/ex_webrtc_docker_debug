################# Variables ################
ARG ELIXIR_VERSION=1.17.3
ARG OTP_VERSION=27.1.2
ARG OS_VERSION=bullseye-20241111-slim
ARG OS_TYPE=debian
ARG RUST_VERSION=1.82.0

ARG BUILDER_IMAGE="hexpm/elixir:${ELIXIR_VERSION}-erlang-${OTP_VERSION}-${OS_TYPE}-${OS_VERSION}"
ARG RUNNER_IMAGE="${OS_TYPE}:${OS_VERSION}"

##########################################
################# BUILDER ################
##########################################
# FROM ${BUILDER_IMAGE} AS builder
FROM elixir:latest

ARG APP=minimal_web_rtc

RUN apt-get update -y && \
    apt-get install -y pkg-config openssl curl build-essential git npm esbuild libc6 libsrtp2-dev && \
    apt-get upgrade -y --autoremove && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_*

RUN echo "Install rustup and Rust v${RUST_VERSION}"
RUN curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y \
    && ~/.cargo/bin/rustup install 1.82.0 \
    && ~/.cargo/bin/rustup default 1.82.0

# Add Cargo to PATH
ENV PATH="/root/.cargo/bin:${PATH}"

# Verify installation
RUN rustc --version && cargo --version

# prepare build dir
WORKDIR /build_space

# install hex + rebar
RUN mix local.hex --force && \
    mix local.rebar --force

# set build ENV
ARG MIX_ENV=prod
ENV MIX_ENV=prod

ENV OTPROOT=/usr/lib/erlang
ENV ERL_LIBS=/usr/lib/erlang/lib

COPY ${APP} .


# install mix dependencies
RUN MIX_ENV="dev" mix do deps.get, deps.update --all, deps.compile

VOLUME /build_space

EXPOSE 5000-5010/udp

ENV HOME=/build_space
ENV MIX_ENV="dev"

RUN ls -la /usr/local/bin/
RUN ls -la /usr/bin/

COPY dbg-entrypoint.sh .
RUN chmod +x dbg-entrypoint.sh

#CMD ["iex", "-S", "mix"]
CMD ["./dbg-entrypoint.sh"]
