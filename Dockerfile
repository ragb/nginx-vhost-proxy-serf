FROM ragb/supervisor-serf-nginx
WORKDIR /

RUN apt-get install -qy python-pip
RUN pip install jinja2

ADD start-serf.sh /start-serf.sh
ADD serf-join.sh /serf-join.sh
ADD generate-vhosts.py /generate-vhosts.py
ADD templates /opt/templates

ADD supervisord-serf.conf /etc/supervisor/conf.d/supervisord-serf.conf

RUN chmod 755 /*.sh
RUN chmod 755 /*.py

