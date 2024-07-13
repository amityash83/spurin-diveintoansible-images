FROM docker:dind

ENV DOCKER_TLS_CERTDIR=

# Add world writeable /shared area
RUN mkdir /shared && chmod 777 /shared

# Redirect logs to a file
RUN sed -ri 's/exec "\$@\"/exec "\$@\" > \/var\/log\/docker.log 2>\&1/g' /usr/local/bin/dockerd-entrypoint.sh
RUN sed -ri 's/exec "\$@\"/exec "\$@\" > \/var\/log\/docker.log 2>\&1/g' /usr/local/bin/docker-entrypoint.sh

# Override the default entrypoint to quieten dind
ENTRYPOINT ["/bin/sh", "-c", "exec dockerd-entrypoint.sh > /dev/null 2>&1"]
