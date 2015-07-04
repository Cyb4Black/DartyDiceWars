# Install a dart container for demonstration purposes.
# Your dart server app will be accessible via HTTP on container port 8080. The port can be changed.
# You should adapt this Dockerfile to your needs.
# If you are new to Dockerfiles please read 
# http://docs.docker.io/en/latest/reference/builder/
# to learn more about Dockerfiles.
#
# This file is hosted on github. Therefore you can start it in docker like this:
# > docker build -t containerdart github.com/nkratzke/containerdart
# > docker run -p 8888:8080 -d containerdart

FROM google/dart
MAINTAINER Hex-3-En <pwillnow@gmail.com>

WORKDIR /container

ADD pubspec.yaml  /container/pubspec.yaml
ADD lib /container/lib
RUN chmod +x /container/lib/DartyDiceWars.dart
RUN chmod +x /container/lib/src/model.dart
RUN chmod +x /container/lib/src/view.dart
RUN chmod +x /container/lib/src/control.dart
ADD bin /conatiner/bin
RUN chmod +x /container/bin/server.dart
ADD web /container/web
RUN chmod +x /container/web/DartyDiceClient.dart
RUN pub get
ADD . /container/
RUN pub get --offline

#EXPOSE 8080

#WORKDIR /container/bin
ENTRYPOINT ["/container/bin", "server.dart"]

#CMD["server.dart"]