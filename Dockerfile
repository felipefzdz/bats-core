ARG bashver=latest

FROM bash:${bashver}
ARG TINI_VERSION=v0.19.0

RUN wget https://github.com/krallin/tini/releases/download/${TINI_VERSION}/tini-static-amd64 -O /tini && \
    chmod +x /tini

# Install parallel and accept the citation notice (we aren't using this in a
# context where it make sense to cite GNU Parallel).
RUN apk add --no-cache parallel ncurses && \
    mkdir -p ~/.parallel && touch ~/.parallel/will-cite

RUN apk add --no-cache git

RUN ln -s /opt/bats/bin/bats /usr/local/bin/bats
COPY . /opt/bats/

WORKDIR /code/

RUN git init /code
RUN git submodule add https://github.com/ztombol/bats-support /code/test_helper/bats-support
RUN git submodule add https://github.com/ztombol/bats-assert /code/test_helper/bats-assert
RUN git submodule add https://github.com/ztombol/bats-file /code/test_helper/bats-file
RUN git submodule add https://github.com/jasonkarns/bats-mock /code/test_helper/bats-mock

ENTRYPOINT ["/tini", "--", "bash", "bats"]
