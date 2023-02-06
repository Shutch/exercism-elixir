FROM ubuntu:22.04

# install prerequisites
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
    build-essential \
    git \
    erlang-dev \
    erlang-xmerl \
    elixir

RUN mix local.hex --force
RUN mix local.rebar --force

# RUN curl -L --output /exercism-linux-64bit.tar.gz https://github.com/exercism/cli/releases/download/v3.1.0/exercism-3.1.0-linux-x86_64.tar.gz 
# RUN tar -xf /exercism-linux-64bit.tgz
COPY exercism /bin

CMD ["tail", "-f", "/dev/null"]