FROM jketterl/openwebrx:latest

COPY settings.json /var/lib/openwebrx/settings.json

# Создаем гарантированный скрипт старта
RUN echo '#!/bin/sh' > /start.sh && \
    echo 'printf "tester1236\ntester1236\n" | openwebrx-admin adduser admin 2>/dev/null || printf "tester1236\ntester1236\n" | openwebrx-admin password admin' >> /start.sh && \
    echo 'exec /init' >> /start.sh && \
    chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
