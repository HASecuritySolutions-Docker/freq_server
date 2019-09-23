FROM alpine:latest

MAINTAINER Justin Henderson justin@hasecuritysolutions.com

RUN apk add --update --no-cache --virtual .build-deps \
    && apk add --no-cache --virtual .build-deps \
    && apk add --no-cache git py2-pip \
    && apk add --update --no-cache python2 \
    && pip install PySocks \
    && pip install six \
    && rm -rf /var/cache/apk/* \
    && cd /opt && git clone https://github.com/markbaggett/freq \
    && mv /opt/freq/freqtable2018.freq /opt/freq/freq_table.freq \
    && mkdir /var/log/freq \
    && ln -sf /dev/stderr /var/log/freq/freq.log \
    && adduser -Ds /bin/sh freq \
    && chown -R freq: /opt/freq
COPY *.freq /opt/freq

USER freq

EXPOSE 10004

STOPSIGNAL SIGTERM

CMD /usr/bin/python /opt/freq/freq_server.py -ip 0.0.0.0 10004 /opt/freq/alexa.freq
