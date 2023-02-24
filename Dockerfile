FROM python:3.11.2-slim

MAINTAINER Justin Henderson justin@hasecuritysolutions.com

RUN pip install PySocks \
    && pip install six \
    && apt update \
    && apt install -y git \
    && cd /opt && git clone https://github.com/markbaggett/freq \
    && mv /opt/freq/freqtable2018.freq /opt/freq/freq_table.freq \
    && mkdir /var/log/freq \
    && ln -sf /dev/stderr /var/log/freq/freq.log \
    && useradd freq
    
COPY *.freq /opt/freq

RUN chown freq:freq -R /opt/freq

USER freq

EXPOSE 10004

STOPSIGNAL SIGTERM

CMD /usr/local/bin/python /opt/freq/freq_server.py -ip 0.0.0.0 10004 /opt/freq/alexa.freq
