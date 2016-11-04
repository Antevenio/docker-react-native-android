FROM java:latest
RUN apt-get update && \
    apt-get install -y lib32z1 lib32ncurses5 lib32stdc++6 openssh-server vim
RUN mkdir /var/run/sshd
RUN echo "root:root" | chpasswd
RUN echo "export ANDROID_SDK_HOME=\"/opt/android-sdk-linux/\"" >> /etc/bash.bashrc && \
    echo "export ANDROID_HOME=\"/opt/android-sdk-linux/\"" >> /etc/bash.bashrc && \
    echo "PATH=\"\$PATH:\$ANDROID_SDK_HOME/tools\"" >> /etc/bash.bashrc
RUN sed -i '/^PermitRootLogin.*$/c\PermitRootLogin yes' /etc/ssh/sshd_config
RUN cd /tmp && \
    curl -O https://dl.google.com/android/android-sdk_r24.4.1-linux.tgz && \
    cd /opt && tar xzf /tmp/*.tgz && rm /tmp/*.tgz
RUN echo "y" | /opt/android-sdk-linux/tools/android update sdk --no-ui --force -a --filter platform-tools,android-23,build-tools-23,sys-img-x86-android-23
ENV ANDROID_SDK_HOME=/opt/android-sdk-linux/
ENV ANDROID_HOME=/opt/android-sdk-linux/
#RUN echo "n" | /opt/android-sdk-linux/tools/android create avd --force -n test -t android-23 -b default/x86
ENTRYPOINT /usr/sbin/sshd -D
