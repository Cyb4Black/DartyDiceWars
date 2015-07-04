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

FROM google/dart-runtime
MAINTAINER Hex-3-En <pwillnow@gmail.com>

WORKDIR /container
ADD pubspec.yaml  /container/

RUN pub get    

# comment in if you need lib to run pub build
ADD lib         /container/lib

ADD bin          /container/bin       

# comment out if you do not need web for working app
ADD web          /container/web

RUN pub get --offline
# Expose port 8080. You should change it to the port(s) your app is serving on.
EXPOSE 8080

# Entrypoint. Whenever the container is started the following command is executed in your container.
# In most cases it simply starts your app.
WORKDIR /container/bin
ENTRYPOINT ["/container/bin", "server.dart"]

# Change this to your starting dart.
#CMD ["server.dart"]