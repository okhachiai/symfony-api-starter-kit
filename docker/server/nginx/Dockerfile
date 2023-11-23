FROM nginx:latest

LABEL maintainer="OUSSAMA KHACHIAI <oussama.khachiai@gmail.com>"

ARG UID

# Create user with same permissions as host and some useful stuff
RUN adduser -u ${UID} --disabled-password --gecos "" webapp
RUN mkdir /home/webapp/.ssh
RUN chown -R webapp:webapp /home/webapp/
RUN echo "StrictHostKeyChecking no" >> /home/webapp/.ssh/config
RUN echo "export COLUMNS=300" >> /home/webapp/.bashrc
RUN echo "alias sf=/var/app/current/bin/console" >> /home/webapp/.bashrc

COPY nginx.conf /etc/nginx/

COPY application.conf /etc/nginx/conf.d/default.conf

CMD ["nginx"]

EXPOSE 80

EXPOSE 443
