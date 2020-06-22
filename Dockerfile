FROM bitnami/postgresql:12-debian-10

USER root
WORKDIR /backup 
COPY . .

ENV TZ=Asia/Ho_Chi_Minh

ENTRYPOINT ["bash", "-c", "./entry-point.sh" ] 