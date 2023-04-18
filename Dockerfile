FROM ubuntu:22.10 as builder

ENV TZ=Asia/Dubai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

WORKDIR /root
RUN apt-get -y update && apt-get install -y git cmake pkg-config libpcap-dev autoconf libtool libglib2.0 librdkafka-dev tzdata

RUN git clone https://github.com/nocsysmars/nDPId.git
#for dev, uncomment below
#RUN mkdir /root/nDPId
#COPY . /root/nDPId/

RUN cd nDPId && mkdir build && cd build && cmake .. -DBUILD_NDPI=ON && make


FROM ubuntu:22.10
WORKDIR /root
RUN apt-get -y update && apt-get -y install libpcap-dev

COPY --from=builder /root/nDPId/libnDPI/ /root/
COPY --from=builder /root/nDPId/build/nDPIsrvd /root/nDPId/build/nDPId /root/

#RUN echo "#!/bin/bash\n" \
#         "/root/nDPIsrvd -d\n"\
#         "/root/nDPId \n" > run.sh && cat run.sh && chmod +x run.sh

#ENTRYPOINT ["/root/run.sh"]
