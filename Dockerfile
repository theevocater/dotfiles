FROM ubuntu:eoan-20191127

COPY bootstrap/ /root/bootstrap
RUN /root/bootstrap/00-packages.sh
RUN /root/bootstrap/01-venv.sh
COPY ansible/hosts ansible/root /root/ansible/
WORKDIR /root/ansible/
RUN ansible-playbook -v -i hosts base.yml
RUN ansible-playbook -v -i hosts docker.yml
USER jkaufman
COPY --chown=jkaufman:jkaufman . /home/jkaufman/.dotfiles/
WORKDIR /home/jkaufman/.dotfiles
#RUN ansible-playbook -v -i ansible/hosts ansible/jkaufman/fonts.yml
