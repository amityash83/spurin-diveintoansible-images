FROM spurin/container-systemd-sshd-ttyd:centos_stream9

# The CentOS Stream image is lightweight, install Base
#
# Also install editors and common utilities, openssl (needed for healthcheck script)
RUN yum groupinstall -y Base \
    && yum install -y vim nano \
    openssl \
    diffutils iproute iputils git net-tools lsof unzip \
    python3 \
    && yum clean all

# Copy healthcheck script and service
COPY healthcheck.sh /utils/healthcheck.sh
COPY healthcheck.service /lib/systemd/system/healthcheck.service

# Enable healthcheck service
RUN ln -s /lib/systemd/system/healthcheck.service /etc/systemd/system/multi-user.target.wants/healthcheck.service

# Setup login banner for guidance
COPY login_banner /etc
RUN sed -i '1i auth optional pam_echo.so file=/etc/login_banner' /etc/pam.d/login

# Configure sshd to run on both Port 22 and Port 2222 on the CentOS hosts
RUN echo -e "Port 22\nPort 2222" >> /etc/ssh/sshd_config
