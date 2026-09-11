FROM jketterl/openwebrx:latest
COPY settings.json /var/lib/openwebrx/settings.json
RUN printf "tester1236\tester1236\n" | openwebrx-admin adduser admin
