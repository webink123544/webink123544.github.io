FROM jketterl/openwebrx:latest

COPY settings.json /var/lib/openwebrx/settings.json

# Создаем папку инициализации и скрипт добавления админа
RUN mkdir -p /etc/cont-init.d && \
    echo '#!/bin/sh' > /etc/cont-init.d/99-admin.sh && \
    echo 'printf "tester1236\ntester1236\n" | openwebrx-admin adduser admin || true' >> /etc/cont-init.d/99-admin.sh && \
    chmod +x /etc/cont-init.d/99-admin.sh
