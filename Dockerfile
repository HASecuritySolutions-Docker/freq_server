FROM centos:latest

MAINTAINER Justin Henderson justin@hasecuritysolutions.com

RUN yum install -y python git python-six && \
    cd /opt && git clone https://github.com/MarkBaggett/freq.git && \
    mv /opt/freq/freqtable2018.freq /opt/freq/freq_table.freq
    mkdir /var/log/freq && \
    ln -sf /dev/stderr /var/log/freq/freq.log && \
    useradd -ms /bin/bash freq && \
    chown -R freq: /opt/freq
USER freq

EXPOSE 10004

STOPSIGNAL SIGTERM

CMD /usr/bin/python /opt/freq/freq_server.py -ip 0.0.0.0 10004 /opt/freq/freq_table.freq
