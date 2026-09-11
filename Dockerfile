FROM jketterl/openwebrx:latest

COPY settings.json /var/lib/openwebrx/settings.json

# Запускаем добавление админа в фоновом режиме через 5 секунд после старта /init
RUN echo '#!/bin/sh' > /start.sh && \
    echo '(sleep 5 && (printf "tester1236\ntester1236\n" | openwebrx-admin adduser admin 2>/dev/null || printf "tester1236\ntester1236\n" | openwebrx-admin password admin)) &' >> /start.sh && \
    echo 'exec /init' >> /start.sh && \
    chmod +x /start.sh

ENTRYPOINT ["/start.sh"]
