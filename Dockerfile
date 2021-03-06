FROM jpetazzo/dind

ENV GOCD_VERSION 16.11.0-4185
ENV GOCD_DISTR go-agent.deb

RUN apt-get update \
    && apt-get -y install -y openjdk-7-jre-headless unzip make supervisor \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

# Install go.cd agent
RUN curl -fSL "https://download.go.cd/binaries/${GOCD_VERSION}/deb/go-agent_${GOCD_VERSION}_all.deb" -o $GOCD_DISTR \
    && dpkg -i $GOCD_DISTR \
    && rm $GOCD_DISTR

RUN mkdir /home/go \
    && usermod -d /home/go go

VOLUME /var/lib/go-agent

ADD supervisord.conf /etc/supervisor/conf.d/supervisord.conf

CMD ["/usr/bin/supervisord"]
