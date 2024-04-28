FROM spurin/container-systemd-sshd-ttyd:centos_8

# Install editors and common utilities, openssl (needed for healthcheck script)
## python3 added to satisfy python dependency for remote module execution
RUN yum install -y vim nano \
    openssl \
    diffutils iputils git net-tools lsof unzip \
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
