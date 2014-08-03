FROM dockerfile/nginx
WORKDIR /

RUN apt-get install -qy supervisor
ADD supervisord-nginx.conf /etc/supervisor/conf.d/supervisord-nginx.conf

# Get serf
ADD https://dl.bintray.com/mitchellh/serf/0.6.3_linux_amd64.zip /serf.zip
RUN unzip /serf.zip
RUN mv serf /usr/bin/serf
RUN rm /serf.zip

RUN apt-get install -qy python-pip
RUN pip install jinja2

ADD start-serf.sh /start-serf.sh
ADD serf-join.sh /serf-join.sh
ADD generate-vhosts.py /generate-vhosts.py
ADD templates /opt/templates

ADD supervisord-serf.conf /etc/supervisor/conf.d/supervisord-serf.conf

ADD run.sh /run.sh

RUN chmod 755 /*.sh
RUN chmod 755 /*.py

EXPOSE 80

CMD ["/run.sh"]