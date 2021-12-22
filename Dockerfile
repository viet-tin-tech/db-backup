FROM postgresql:13

WORKDIR /backup 
COPY . .

ENV TZ=Asia/Ho_Chi_Minh
RUN mkdir /data

USER root



CMD  ["/backup/entry-point.sh" ]