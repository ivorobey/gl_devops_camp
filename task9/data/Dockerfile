FROM jenkins/jenkins:lts-jdk11

# install jenkins plugins
COPY ./jenkins-plugins /usr/share/jenkins/plugins.txt
RUN jenkins-plugin-cli --plugin-file /usr/share/jenkins/plugins.txt

# Data for Jenkin's user
ENV JENKINS_USER admin
ENV JENKINS_PASS admin
ENV JENKINS_EMAIL mail@mail.com
ENV JENKINS_FULLNAME Admin Admin

# allows to skip Jenkins setup wizard
ENV JAVA_OPTS -Djenkins.install.runSetupWizard=false

# Jenkins runs all grovy files from init.groovy.d dir
# use this for creating default admin user
COPY default-user.groovy /usr/share/jenkins/ref/init.groovy.d/

# we will deploy index.html to Nginx on the same stage as Jenkins is running
RUN amazon-linux-extras install nginx1 -y
RUN service nginx start
RUN chown -R jenkins:root /usr/share/nginx/html


# volume for Jenkins settings
VOLUME /var/jenkins_home