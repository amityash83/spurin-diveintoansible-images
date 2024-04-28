FROM spurin/diveintoansible-rc:ansible

# Install docker
RUN apt-get update \
    && apt-get install -y docker docker.io \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Set Docker Env for Docker Tests to run as expected
ENV DOCKER_HOST=tcp://docker:2375

# Copy healthcheck script and service
COPY tests/* /tests/

# Install pip requirements
RUN pip3 install nose2 pytest docker parameterized gitpython

# Use a modified display.py (specific to Ansible 9.5.1) - removed set to True to allow tests to run
#    @proxy_display
#    def deprecated(
#        self,
#        msg: str,
#        version: str | None = None,
#        removed: bool = True,
#        date: str | None = None,
#        collection_name: str | None = None,
#    ) -> None:
#        if not removed and not C.DEPRECATION_WARNINGS:
#            return
COPY display.py /usr/local/lib/python3.10/dist-packages/ansible/utils/display.py

# Override CMD
CMD /bin/startup.sh; nose2 -vs /tests
