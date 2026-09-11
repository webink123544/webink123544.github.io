FROM jketterl/openwebrx:latest

COPY settings.json /var/lib/openwebrx/settings.json

# Добавляем скрипт инициализации, создающий админа ПРИ СТАРТЕ контейнера
RUN echo '#!/bin/sh' > /etc/cont-init.d/99-admin.sh && \
    echo 'ADMIN_BIN=$(which openwebrx-admin 2>/dev/null || find / -name "openwebrx-admin*" 2>/dev/null | head -n 1)' >> /etc/cont-init.d/99-admin.sh && \
    echo 'printf "tester1236\ntester1236\n" | $ADMIN_BIN adduser admin || true' >> /etc/cont-init.d/99-admin.sh && \
    chmod +x /etc/cont-init.d/99-admin.sh
