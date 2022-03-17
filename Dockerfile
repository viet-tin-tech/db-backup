FROM postgres:13

WORKDIR /backup 
COPY . .

ENV TZ=Asia/Ho_Chi_Minh
RUN mkdir /data

RUN apt-get update && \
    apt-get install -y ssh

USER root

ENV BACK_UP_LOCATION=/data


CMD  ["/backup/entry-point.sh" ]