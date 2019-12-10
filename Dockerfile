FROM ruby:2.5.5
#RUN apk update && apk upgrade && apk add ruby ruby-json ruby-io-console ruby-bundler ruby-irb ruby-bigdecimal tzdata && apk add nodejs && apk add curl-dev ruby-dev build-base libffi-dev && apk add build-base libxslt-dev libxml2-dev ruby-rdoc mysql-dev
#RUN apt-get update -qq && apt-get install -y build-essential nodejs npm nodejs-legacy mysql-client vim

RUN apt-get update -qq && apt-get install -y nodejs mariadb-client vim


RUN mkdir /gamedooraAPI
WORKDIR /gamedooraAPI

RUN gem install bundler

COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

ENTRYPOINT ["sh", "./config/docker/startup.sh"]


