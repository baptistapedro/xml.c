FROM fuzzers/libfuzzer:12.0

RUN apt-get update
RUN apt install -y build-essential wget git clang cmake  automake autotools-dev  libtool zlib1g zlib1g-dev libexif-dev \
    libjpeg-dev 
RUN git clone https://github.com/ooxi/xml.c.git
WORKDIR /xml.c
RUN cmake -DCMAKE_C_COMPILER=clang -DCMAKE_CXX_COMPILER=clang++ .
RUN make
COPY fuzzers/f1.c .
RUN clang -I./src/ -fsanitize=fuzzer,address f1.c -o /x libxml.a
RUN mkdir /xmlCorpus
RUN cp ./test/*.xml /xmlCorpus
ENV LD_LIBRARY_PATH=/usr/local/lib/

ENTRYPOINT []
CMD ["/x", "/xmlCorpus"]
