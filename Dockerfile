FROM alpine:3.10.0

RUN sed -i 's/dl-cdn.alpinelinux.org/mirrors.aliyun.com/g' /etc/apk/repositories;

RUN apk update && apk upgrade
RUN apk add stunnel \
            bash;

WORKDIR /root

COPY stunnel.pem /etc/stunnel/stunnel.pem

RUN sed -i 's/\/run\/stunnel\/stunnel.pid/\/var\/run\/stunnel\/stunnel.pid/g' /etc/stunnel/stunnel.conf; \
    sed -i 's/#verify = 2/verify = 3/g' /etc/stunnel/stunnel.conf; \
    sed -i 's/#CAfile = \/etc\/stunnel\/certs.pem/CAfile = \/etc\/stunnel\/stunnel.pem/g' /etc/stunnel/stunnel.conf;

RUN echo "" >> /etc/stunnel/stunnel.conf; \
    echo "foreground = yes" >> /etc/stunnel/stunnel.conf; \
    echo "delay = no" >> /etc/stunnel/stunnel.conf; \
    echo "output = /var/log/stunnel/stunnel.log" >> /etc/stunnel/stunnel.conf; \
    echo "" >> /etc/stunnel/stunnel.conf; \
    echo "[sproxy]" >> /etc/stunnel/stunnel.conf; \
    echo "accept = 8000" >> /etc/stunnel/stunnel.conf; \
    echo "connect = 192.168.0.1:8000" >> /etc/stunnel/stunnel.conf; \
    echo "cert = /etc/stunnel/stunnel.pem" >> /etc/stunnel/stunnel.conf;

RUN mkdir -p /var/log/stunnel; \
    chown -R stunnel:stunnel /var/log/stunnel; \
    mkdir -p /var/run/stunnel; \
    chown -R stunnel:stunnel /var/run/stunnel;

EXPOSE 8000
CMD ["stunnel"]
