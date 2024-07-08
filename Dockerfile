FROM spurin/container-systemd-sshd-ttyd:centos_stream9

## The CentOS Stream image is lightweight, install Base
# RUN yum groupinstall -y Base \

# Also install editors and common utilities, openssl (needed for healthcheck script)
RUN yum install -y vim nano \
    openssl \
    diffutils iproute iputils git net-tools lsof unzip \
    python3 \
    dnf-plugins-core \
    && yum clean all

# Copy healthcheck script and service
COPY healthcheck.sh /utils/healthcheck.sh
COPY healthcheck.service /lib/systemd/system/healthcheck.service

# Enable healthcheck service
RUN ln -s /lib/systemd/system/healthcheck.service /etc/systemd/system/multi-user.target.wants/healthcheck.service

# https://forums.rockylinux.org/t/how-do-i-silence-annoying-connection-message/4152
RUN ln -sfn /dev/null /etc/motd.d/cockpit

# Copy update_sshd_ports.sh to /utils
COPY update_sshd_ports.sh /utils
