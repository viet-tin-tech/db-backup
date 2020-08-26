FROM bitnami/postgresql:12-debian-10

USER root
WORKDIR /backup 
COPY . .

ENV TZ=Asia/Ho_Chi_Minh

CMD  ["bash", "-c", "./entry-point.sh" ] 