FROM fedora:30
LABEL maintainer="kdevensen@gmail.com"
ENV JAVA_HOME=/usr/lib/jvm/java-1.8.0-openjdk \
    HOME=/home/default \
    GOPATH=/homde/default/go
RUN dnf install -y --setopt=tsflags=nodocs \
        emacs \
    	gcc-c++ \
	git \
        golang \
	java-1.8.0-openjdk-devel \
	make \
	maven \
        nano \
    	nmap-ncat \
    	npm \
        openssh-server \
	openssl \
        origin-clients \
	docker \
	screen \
	vim \
        tree \
        glide \
	unzip && \
    dnf clean all && \
    rm -rf /var/cache/yum/*

RUN mkdir /home/default && \
    useradd -u 2000 default && \
    echo "default:${WETTY_PASSWORD:-wetty}" | chpasswd && \
    chown default:default /home/default
    
RUN usermod -a -G docker default
RUN chmod 666 /var/run/docker.sock
RUN chmod 666 /run/docker.sock

RUN /usr/bin/ssh-keygen -A -N '' && \
    chmod -R a+r /etc/ssh/* && \
    /usr/sbin/setcap 'cap_net_bind_service=+ep' /usr/sbin/sshd

COPY fedora-profile.sh /etc/profile.d/
RUN chmod a+r /etc/profile.d/fedora-profile.sh
RUN exec bash

EXPOSE 22
WORKDIR /home/default
USER default

CMD ["/usr/sbin/sshd", "-D", "-p", "22", "-E", "/home/default/ssh.log"]
