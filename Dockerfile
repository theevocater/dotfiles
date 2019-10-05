FROM ubuntu:disco

COPY bootstrap/ /root/bootstrap
RUN /root/bootstrap/00-packages.sh
COPY ansible/hosts /root/ansible/
COPY ansible/playbook.yaml /root/ansible/
RUN ansible-playbook -i /root/ansible/hosts /root/ansible/base.yml
COPY ansible/ /root/ansible
