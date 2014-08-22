FROM ubuntu:14.04

RUN apt-get update
RUN apt-get install libtool make automake supervisor curl python3-pip -qy
RUN apt-get install libyaml-0-2 -yq
RUN apt-get install -y memcached

# Install twemproxy
RUN curl -qL https://twemproxy.googlecode.com/files/nutcracker-0.3.0.tar.gz | tar xzf -
RUN cd nutcracker-0.3.0 && ./configure --enable-debug=log && make && mv src/nutcracker /usr/local/bin/nutcracker
RUN cd / && rm -rf nutcracker-0.3.0

# install pip deps
RUN pip3 install pyaml
RUN pip3 install boto

# Configuration
RUN mkdir -p /etc/nutcracker
RUN mkdir -p /var/log/nutcracker
ADD generate_configs.py /generate_configs.py
ADD run.sh /run.sh
RUN chmod a+x run.sh

EXPOSE 3000 22222 22123
CMD ["/run.sh"]

RUN apt-get remove libtool make automake curl -yq
