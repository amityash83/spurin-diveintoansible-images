FROM spurin/diveintoansible:centos_stream

# Configure sshd to run on port 2222
RUN sed -ri 's/^#Port 22/Port 2222/' /etc/ssh/sshd_config

# Open Ports
EXPOSE 2222
