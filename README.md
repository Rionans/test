## Описание работы скрипта
### monitoring.sh
- скрипт `monitoring.sh` проверяет запуск процесса `test`

- eсли процесс запущен, то стучится на `https://test.com/monitoring/test/api`

- если процесс был перезапущен или сервер мониторинга не доступен пишет в лог `/var/log/monitoring.log`

### monitoring.service

- это описание службы, которая должна быть запущена и управляема systemd

### monitoring.timer

- `monitoring.timer` нужен для запуска `monitoring.service`, ожидания выполнения и завершения, а потом повторного вызыва через минуту

- для запуска необходимо обновить демона `sudo systemctl daemon-reload` и добавления в автозагрузку таймер `sudo systemctl enable --now monitoring.timer`
