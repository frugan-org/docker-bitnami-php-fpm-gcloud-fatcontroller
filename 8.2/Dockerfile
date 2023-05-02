#TODO - https://github.com/GoogleCloudPlatform/cloud-sdk-docker
#https://cloud.google.com/sdk/docs/downloads-docker
#https://earthly.dev/blog/docker-multistage/
#https://stackoverflow.com/a/49256835/3929620
#https://www.jhanley.com/google-cloud-understanding-gcloud-configurations/
#https://github.com/bitnami/bitnami-docker-google-cloud-sdk/issues/1
FROM bitnami/google-cloud-sdk:latest as build

#https://forums.docker.com/t/unable-to-find-user-root-no-matching-entries-in-passwd-file/26545/2
# Required to perform privileged actions
USER 0

#https://stackoverflow.com/a/64557582/3929620
#https://github.com/moby/moby/issues/34645
# This command slows down the building process.. but trust and wait!
RUN chown -Rf root:root \
    #/.config \
    /opt/bitnami/google-cloud-sdk \
    #/opt/bitnami/google-cloud-sdk/.buildcomplete \
    #/opt/bitnami/google-cloud-sdk/.install \
    #/opt/bitnami/google-cloud-sdk/LICENSE \
    #/opt/bitnami/google-cloud-sdk/README \
    #/opt/bitnami/google-cloud-sdk/RELEASE_NOTES \
    #/opt/bitnami/google-cloud-sdk/VERSION \
    #/opt/bitnami/google-cloud-sdk/bin \
    #/opt/bitnami/google-cloud-sdk/completion.bash.inc \
    #/opt/bitnami/google-cloud-sdk/completion.zsh.inc \
    #/opt/bitnami/google-cloud-sdk/data \
    #/opt/bitnami/google-cloud-sdk/deb \
    #/opt/bitnami/google-cloud-sdk/install.bat \
    #/opt/bitnami/google-cloud-sdk/install.sh \
    #/opt/bitnami/google-cloud-sdk/lib \
    #/opt/bitnami/google-cloud-sdk/licenses \
    #/opt/bitnami/google-cloud-sdk/path.bash.inc \
    #/opt/bitnami/google-cloud-sdk/path.fish.inc \
    #/opt/bitnami/google-cloud-sdk/path.zsh.inc \
    #/opt/bitnami/google-cloud-sdk/platform \
    #/opt/bitnami/google-cloud-sdk/properties \
    #/opt/bitnami/google-cloud-sdk/rpm \
    ;

# Revert to the original non-root user
USER 1001


### gcloud

FROM frugan/bitnami-php-fpm:8.2

ENV USER_ID=1000 \
    GROUP_ID=1000

#https://stackoverflow.com/a/51304870/3929620
# COPY <all> <the> <things> <last-arg-is-destination>
# When using COPY with more than one source file, the destination must be a directory and end with a /
COPY --from=build /.config /home/daemon/.config
COPY --from=build /opt/bitnami/google-cloud-sdk /opt/bitnami/google-cloud-sdk

RUN install_packages \
        #https://github.com/GoogleCloudPlatform/cloud-sdk-docker/pull/87
        openssh-client \
	    python3 \
    ; \
    # This command slows down the building process.. but trust and wait!
    chown -Rf ${USER_ID}:${GROUP_ID} \
        /home/daemon/.config \
        /opt/bitnami/google-cloud-sdk \
    ;

#https://stackoverflow.com/a/52842111/3929620
ENV PATH /opt/bitnami/google-cloud-sdk/bin:$PATH


### fatcontroller

#https://vsupalov.com/docker-arg-vs-env/
ARG FATCONTROLLER_VERSION=0.0.5

#https://askubuntu.com/a/871936/543855
ENV TERM xterm-256color

COPY patch /patch

RUN install_packages \
	    ca-certificates \
	    gcc \
	    libc-dev \
	    make \
	    patch \
	    tar \
	    wget \
	; \
    #https://www.includehelp.com/c-programming-questions/compiling-program-with-pthread-library-linux.aspx
    #https://stackoverflow.com/a/15252756/3929620
    wget --no-check-certificate -P /tmp https://downloads.sourceforge.net/project/fat-controller/fatcontroller-${FATCONTROLLER_VERSION}.tar.gz; \
	tar -zxvf /tmp/fatcontroller-${FATCONTROLLER_VERSION}.tar.gz -C /tmp; \
    \
    cd /tmp/fatcontroller-${FATCONTROLLER_VERSION}/; \
	make; \
	make install; \
	\
	patch -d /etc/init.d -p0 -N --dry-run --silent fatcontrollerd /patch/fatcontrollerd.patch 2>/dev/null; \
    \
    # If the patch has not been applied, then the $?, which is the exit status,
    # for last command would have a success status code = 0
    if [ $? -eq 0 ]; then \
    	# Apply the patch
    	patch -d /etc/init.d -p0 -N fatcontrollerd /patch/fatcontrollerd.patch; \
    fi; \
    \
    rm -Rf /tmp/fatcontroller-* \
    ;


####

COPY entrypoint-after.sh /

#https://github.com/docker-library/postgres/issues/296#issuecomment-308735942
RUN chmod +x /entrypoint-after.sh
