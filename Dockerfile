FROM alpine:3.4

ENV TF_VERSION "0.7.13"


RUN apk --update add \
      bash \
      curl \
    && curl -Ls https://releases.hashicorp.com/terraform/${TF_VERSION}/terraform_${TF_VERSION}_linux_amd64.zip > /tmp/tf.zip \
    && unzip /tmp/tf.zip -d /bin/ \
    && rm /tmp/* /var/cache/apk/*

ADD entrypoint.sh /bin/entrypoint.sh

VOLUME /app
WORKDIR /app

ENTRYPOINT ["entrypoint.sh"]