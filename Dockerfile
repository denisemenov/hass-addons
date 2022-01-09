ARG BUILD_FROM
FROM $BUILD_FROM

RUN apk add --no-cache openssh

RUN ssh-keygen -q -C "[Home Assistant SSH Tunnel]" -N "" -f ~/.ssh/id_ed25519 -t ed25519

COPY run.sh /
RUN chmod a+x /run.sh

CMD [ "/run.sh" ]
