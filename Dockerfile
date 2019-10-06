FROM ubuntu:disco

COPY bootstrap/ /root/bootstrap
RUN /root/bootstrap/00-packages.sh
COPY ansible/hosts ansible/root /root/ansible/
WORKDIR /root/ansible/
RUN ansible-playbook -v -i hosts *.yml
USER jkaufman
COPY --chown=jkaufman:jkaufman . /home/jkaufman/.dotfiles/
WORKDIR /home/jkaufman/.dotfiles
RUN ansible-playbook -v -i ansible/hosts ansible/jkaufman/*.yml
