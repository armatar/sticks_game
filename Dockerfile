FROM ubuntu:16.04

MAINTAINER Audra Matar <audramatar@gmail.com>

# updating apt-get
RUN apt-get update

# fixing the apt-utils issue with 16.04
RUN apt-get install -y --no-install-recommends apt-utils

# installing essentials
RUN apt-get install -y curl wget nano

# Copies the content of the folder ./test into a new folder test/ on the container
COPY /content content/

#installing rvm, ruby, and bundler
RUN gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
RUN \curl -L https://get.rvm.io | bash -s stable
RUN echo 'source /etc/profile.d/rvm.sh' >> ~/.bashrc
RUN /bin/bash -l -c "rvm install 2.4.0"
RUN /bin/bash -l -c "gem install bundler --no-ri --no-rdoc"
RUN /bin/bash -l -c "bundle install --gemfile=/content/Gemfile"
