#!/bin/bash

LOG_FILE="install.log"

# Функція для логування
log() {
    echo "$(date '+%Y-%m-%d %H:%M:%S') - $1" | tee -a "$LOG_FILE"
}

log "Початок перевірки та встановлення залежностей..."

# 1. Перевірка та встановлення Docker
if ! command -v docker &> /dev/null; then
    log "Docker не знайдено. Встановлюємо..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get update
        sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
        sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
        sudo apt-get update
        sudo apt-get install -y docker-ce docker-ce-cli containerd.io
        log "Docker успішно встановлено."
    else
        log "Увага: пакетний менеджер apt не знайдено. Якщо Docker не встановлено, використовуйте інструменти вашої ОС (наприклад, Homebrew для Mac)."
    fi
else
    log "Docker вже встановлено: $(docker --version)"
fi

# 2. Перевірка та встановлення Docker Compose
if ! command -v docker-compose &> /dev/null && ! docker compose version &> /dev/null; then
    log "Docker Compose не знайдено. Встановлюємо..."
    if command -v apt-get &> /dev/null; then
        sudo curl -L "https://github.com/docker/compose/releases/download/v2.20.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
        sudo chmod +x /usr/local/bin/docker-compose
        log "Docker Compose успішно встановлено."
    else
        log "Увага: пакетний менеджер apt не знайдено. Встановіть Docker Compose вручну."
    fi
else
    log "Docker Compose вже встановлено."
fi

# 3. Перевірка Python
if ! command -v python3 &> /dev/null; then
    log "Python3 не знайдено. Встановлюємо..."
    if command -v apt-get &> /dev/null; then
        sudo apt-get install -y python3 python3-pip python3-venv
    else
        log "Увага: встановіть Python3 вручну для вашої ОС (наприклад, через brew install python)."
    fi
else
    log "Python3 вже встановлено: $(python3 --version)"
fi

# 4. Створення віртуального середовища та встановлення залежностей
log "Створення віртуального середовища та встановлення Python-залежностей..."

VENV_DIR=".venv"

if [ ! -d "$VENV_DIR" ]; then
    python3 -m venv "$VENV_DIR"
    log "Віртуальне середовище створено у папці $VENV_DIR."
else
    log "Віртуальне середовище вже існує."
fi

# Використовуємо pip безпосередньо з віртуального середовища (уникаємо помилки PEP 668)
"$VENV_DIR/bin/pip" install --upgrade pip | tee -a "$LOG_FILE"
"$VENV_DIR/bin/pip" install torch torchvision pillow Django | tee -a "$LOG_FILE"

log "Python-залежності успішно встановлено у віртуальне середовище."
log "Налаштування завершено!"

echo "=========================================================="
echo "ВАЖЛИВО: Перед запуском Python-скриптів активуйте середовище:"
echo "source $VENV_DIR/bin/activate"
echo "=========================================================="