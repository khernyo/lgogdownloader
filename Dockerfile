FROM debian:buster-20200130-slim as builder

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils && \
    apt-get install -y \
    g++ cmake pkg-config help2man \
    libboost-dev libboost-system-dev libboost-filesystem-dev libboost-regex-dev libboost-program-options-dev \
    libboost-date-time-dev libboost-iostreams-dev \
    zlib1g-dev libcurl4-openssl-dev libssl-dev librhash-dev libjsoncpp-dev libhtmlcxx-dev libtinyxml2-dev \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/cache/apt/*

COPY . /build/
RUN mkdir -p /build/build
WORKDIR /build/build

RUN cmake ..
RUN make -j


FROM debian:buster-20200130-slim

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get update && apt-get install -y apt-utils && \
    apt-get install -y \
    libboost-system1.67.0 libboost-filesystem1.67.0 libboost-regex1.67.0 libboost-program-options1.67.0 \
    libboost-date-time1.67.0 libboost-iostreams1.67.0 libcurl4 libjsoncpp1 librhash0 libhtmlcxx3v5 libtinyxml2-6a \
    libcss-parser0 libcss-parser-pp0v5 \
    && apt-get autoremove --purge -y \
    && apt-get autoclean -y \
    && rm -rf /var/cache/apt/*

RUN mkdir -p /.config/lgogdownloader && chmod 777 /.config /.config/lgogdownloader

COPY --from=builder /build/build/lgogdownloader /lgogdownloader

CMD ["/lgogdownloader"]
