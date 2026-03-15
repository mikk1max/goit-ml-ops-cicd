# MLOps Experiments Tracking & Local Infrastructure

Цей проєкт демонструє повноцінний процес MLOps: декларативне розгортання інфраструктури, трекінг експериментів, логування моделей та моніторинг метрик. Проєкт було успішно адаптовано для роботи в локальному Kubernetes кластері (Docker Desktop) через обмеження ресурсів у хмарних безкоштовних тарифах[cite: 1, 2, 3].

## 🏗️ Архітектура проєкту

Проєкт базується на концепції GitOps та використовує наступний стек:

- **Infrastructure**: AWS EKS (через Terraform) або Docker Desktop (Kubernetes)[cite: 1, 2, 3, 4, 5, 6].
- **GitOps**: ArgoCD для автоматичного розгортання та синхронізації компонентів.
- **Storage**: MinIO (S3-сумісне сховище) для артефактів та PostgreSQL для метаданих.
- **Tracking**: MLflow для ведення логів експериментів та версіонування моделей.
- **Monitoring**: Prometheus Pushgateway для збору метрик навчання (accuracy, loss).

---

## 🚀 Як запустити проєкт (Local Dev Mode)

Для стабільної роботи на Docker Desktop було використано кастомні маніфести для обходу помилок завантаження образів Bitnami.

### 1. Підготовка Kubernetes

Переконайтеся, що Kubernetes увімкнено у налаштуваннях Docker Desktop. Застосуйте маніфести інфраструктури:

```bash
kubectl apply -f argocd/applications/
# Для виправлення помилок ErrImagePull застосовано патч:
kubectl apply -f fix-infra.yaml
```

### 2. Налаштування Port-Forward (Тунелі)

Щоб Python-скрипт міг спілкуватися з сервісами, відкрийте окремі термінали для кожного тунелю:

- MinIO: `kubectl port-forward svc/minio-new 9000:9000`
- Postgres: `kubectl port-forward svc/postgres-new 5432:5432`
- Pushgateway: `kubectl port-forward svc/pushgateway-prometheus-pushgateway 9091:9091 -n monitoring`

### 3. Запуск навчання моделей

Скрипт проведе 3 експерименти з різними гіперпараметрами для датасету Iris.Bashcd experiments

```bash
python3 -m venv venv
source venv/bin/activate
pip install -r requirements.txt
python train_and_push.py
```

### 📊 Результати виконання

1. Збереження моделі: Найкраща за точністю модель автоматично завантажується з MinIO та зберігається локально в папку `best_model/`.
2. Метрики у Pushgateway: Результати `mlflow_accuracy` та `mlflow_loss` доступні за адресою `http://localhost:9091`.
3. MLflow Tracking: Експерименти логуються у локальну базу` mlflow.db` та відображаються у логах скрипта.

### 📂 Структура репозиторію

`eks/` — Terraform конфігурації для розгортання AWS EKS.
`argocd/applications/` — Декларативні маніфести ArgoCD для MinIO, MLflow, Postgres та Pushgateway.
`experiments/` — Python код для навчання, логування та відправки метрик.
`best_model/` — Серіалізована найкраща модель (результат останнього запуску).
`fix-infra.yaml` — Кастомні маніфести для стабільної роботи в локальному Kubernetes.

### ⚠️ Очищення ресурсів

Якщо ви використовували AWS, не забудьте видалити ресурси, щоб уникнути зайвих витрат:
