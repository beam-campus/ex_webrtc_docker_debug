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
FROM ${BUILDER_IMAGE} AS builder

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
RUN MIX_ENV="prod" mix do deps.get --only "prod", deps.update --all, deps.compile

RUN MIX_ENV="prod" mix compile && \
    MIX_ENV="prod" mix release minimal_web_rtc

###################################
########### RUNTIME ###############
###################################
FROM ${RUNNER_IMAGE} AS for_edge

ARG APP=minimsl_web_rtc

RUN apt-get update -y && \
    apt-get install -y libstdc++6 pkg-config openssl libncurses5 locales ca-certificates curl systemd libc6 libnspr4 libnss3 libsrtp2-dev && \
    apt-get upgrade -y --autoremove && \
    apt-get clean && \
    rm -f /var/lib/apt/lists/*_* 

# Set the locale
RUN sed -i '/en_US.UTF-8/s/^# //g' /etc/locale.gen && locale-gen

ENV LANG=en_US.UTF-8
ENV LANGUAGE=en_US:en
ENV LC_ALL=en_US.UTF-8

WORKDIR /system

RUN chown nobody /system

COPY --from=builder --chown=nobody /build_space/_build/prod/rel/minimal_web_rtc .

COPY entrypoint.sh .

RUN chmod +x entrypoint.sh

USER nobody

VOLUME /system

EXPOSE 5000-5010/udp

ENV HOME=/system
ENV MIX_ENV="prod"

CMD ["./entrypoint.sh"]
