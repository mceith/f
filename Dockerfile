FROM ubuntu:14.04

ENV DOMAIN example.com

RUN apt-get update
RUN apt-get install software-properties-common -y
RUN add-apt-repository ppa:ondrej/php5-5.6 -y
RUN sed -i 's/restricted//'g /etc/apt/sources.list
RUN apt-get update -y
RUN apt-get install -y php5-redis nginx php5-mysql php5-fpm git curl --force-yes
RUN git clone https://github.com/frc/bedrock-on-heroku /tmp/bedrock-on-heroku
RUN curl -sS https://getcomposer.org/installer | sudo php -- --install-dir=/usr/local/bin --filename=composer
RUN composer install -d /tmp/bedrock-on-heroku

ADD run.sh /run.sh

VOLUME ["/tmp/bedrock-on-heroku", "/var/wwwlogs", "/var/log/nginx"]
EXPOSE 80
ENTRYPOINT /run.sh
