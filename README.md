# 🖥 Linux Process Monitoring Script

## 📌 Описание

Bash-скрипт для мониторинга процесса `test` в Linux-среде.  
Скрипт:

- Запускается автоматически при старте системы через `systemd timer`
- Проверяет каждую минуту, запущен ли процесс `test`
- Если процесс найден — отправляет запрос на `https://test.com/monitoring/test/api`
- Если процесс был перезапущен — записывает информацию в лог `/var/log/monitoring.log`
- Если мониторинг-сервер недоступен — также пишет в лог

---

## 📂 Состав проекта

```
.
├── monitor_test.sh             # Bash-скрипт для мониторинга
├── monitor-test.service        # systemd unit-файл
└── monitor-test.timer          # systemd таймер (ежеминутный запуск)
```

---

## ⚙️ Установка

### 1. Скопируйте файлы в соответствующие директории:

```bash
# Bash-скрипт
sudo cp monitor_test.sh /usr/local/bin/
sudo chmod +x /usr/local/bin/monitor_test.sh

# systemd unit и таймер
sudo cp monitor-test.service /etc/systemd/system/
sudo cp monitor-test.timer /etc/systemd/system/
```

### 2. Перезагрузите systemd

```bash
sudo systemctl daemon-reload
```

### 3. Активируйте и запустите таймер

```bash
sudo systemctl enable --now monitor-test.timer
```

---

## 🧪 Проверка работы

- Убедитесь, что процесс `test` запущен:
  ```bash
  pgrep test
  ```

- Остановите и перезапустите процесс:
  ```bash
  sudo pkill test
  ./test &  # или любой способ запуска процесса
  ```

- Проверьте лог:
  ```bash
  cat /var/log/monitoring.log
  ```

---

## 📄 Логирование

- PID предыдущего процесса хранится в:  
  `/var/run/test_pid`

- Все сообщения логируются в файл:  
  `/var/log/monitoring.log`

---

## 🛠 Зависимости

- `curl` (для HTTPS-запроса)

---

## 🧑‍💻 Автор

> Реализация тестового задания для позиции DevOps-инженера.  
> Разработчик: Бектрумов Тамерлан

---

## ✅ Пример лога

```text
2025-05-19 14:22:01 Process 'test' restarted (old PID: 1234, new PID: 5678)
2025-05-19 14:22:01 Monitoring server unreachable at https://test.com/monitoring/test/api
```

---
