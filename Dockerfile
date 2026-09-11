FROM jketterl/openwebrx:latest
COPY settings.json /var/lib/openwebrx/settings.json
RUN printf "tester1236\ntester1236\n" | python3 /opt/openwebrx/openwebrx-admin.py adduser admin
