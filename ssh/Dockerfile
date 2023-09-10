FROM ubuntu:latest

RUN apt-get update && apt-get install -y openssh-server unzip
COPY vault-config.hcl /etc/vault-ssh-helper.d/vault-config.hcl
COPY vault-setup.sh /root/vault-setup.sh
COPY .bash_profile /root/.bash_profile

RUN mkdir /var/run/sshd && \
  echo root:123 | chpasswd && \
  sed -i "s/#PermitRootLogin prohibit-password/PermitRootLogin yes/g" /etc/ssh/sshd_config && service ssh restart
RUN apt-get install -y mysql-server-8.0
RUN wget https://releases.hashicorp.com/vault/1.14.2/vault_1.14.2_linux_amd64.zip && \
  unzip vault_1.14.2_linux_amd64.zip && \
  mv vault /bin && rm vault_1.14.2_linux_amd64.zip

RUN sed "s@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g" -i /etc/pam.d/sshd

ENV NOTVISIBLE "in users profile"
RUN echo "export VISIBLE=now" >> /etc/profile

EXPOSE 22
CMD [ "/usr/sbin/sshd", "-D" ]