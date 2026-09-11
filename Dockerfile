FROM jketterl/openwebrx:latest
COPY settings.json /var/lib/openwebrx/settings.json
RUN ADMIN_BIN=$(find / -name "openwebrx-admin*" 2>/dev/null | head -n 1) && \
    printf "tester1236\ntester1236\n" | $ADMIN_BIN adduser admin
