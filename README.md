# GitOps з ArgoCD та Terraform (GoIT MLOps Lesson 7)

Цей проєкт демонструє розгортання інфраструктури в AWS (VPC + EKS) за допомогою Terraform, автоматичне встановлення ArgoCD через Helm та налаштування GitOps-пайплайну для деплою застосунку (MLflow) з окремого Git-репозиторію.

## 📦 Структура проєкту

- **`terraform/`** — містить конфігурацію інфраструктури:
  - `vpc/` — мережева інфраструктура.
  - `eks/` — кластер Kubernetes (Node Group налаштовано на 4 `t3.micro` інстанси для обходу лімітів ENI).
  - `argocd/` — конфігурація Helm-релізу ArgoCD (`argocd-values.yaml`).
- **GitOps Репозиторій** — окремий репозиторій з маніфестом `application.yaml` для розгортання MLflow.
  - 🔗 **Посилання на GitOps репозиторій:** [https://github.com/mikk1max/goit-argo](https://github.com/mikk1max/goit-argo)

---

## 🚀 Інструкція із запуску

### 1. Розгортання інфраструктури (Terraform)

Переконайтеся, що ви авторизовані в AWS CLI (`aws configure`). Перейдіть у кореневу папку з Terraform та виконайте:

```bash
# Ініціалізація провайдерів
terraform init

# Перевірка плану виконання
terraform plan

# Створення VPC, EKS та встановлення ArgoCD
terraform apply
```

### 2. Налаштування доступу до кластера

Після успішного виконання `terraform apply`, оновіть конфігурацію `kubectl`:

```bash
aws eks --region eu-central-1 update-kubeconfig --name ml-production-cluster
```

Перевірте, що ArgoCD успішно встановився (всі поди мають бути у статусі Running):

```bash
kubectl get pods -n infra-tools
```

---

## 🔐 Доступ до ArgoCD UI

### 1. Отримайте пароль адміністратора:

```bash
kubectl -n infra-tools get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d
```

Збережіть отриманий пароль.

### 2. Відкрийте доступ до веб-інтерфейсу (Port-Forwarding):

```bash
kubectl port-forward svc/argocd-server -n infra-tools 8080:80
```

Залиште цей термінал відкритим.

### 3. Увійдіть в систему:

- Відкрийте браузер (бажано в режимі Інкогніто, щоб уникнути HSTS редиректів на https) і перейдіть за адресою: `http://127.0.0.1:8080`

- Логін: admin

- Пароль: той, що ви отримали на кроці 1.

---

## 🎯 Розгортання застосунку (GitOps)

Деплой MLflow відбувається автоматично через ArgoCD на основі маніфесту `application.yaml`, який зберігається в окремому репозиторії.

1. Перейдіть у директорію вашого GitOps репозиторію.

2. Застосуйте маніфест:

```bash
kubectl apply -f application.yaml
```

3. Перевірка:

- В UI ArgoCD з'явиться застосунок `mlflow-app` зі статусами `Healthy` та `Synced`.

- Перевірити створення подів через термінал:

```bash
kubectl get pods -n application
```

---

## 🧹 Видалення ресурсів

⚠️ Увага: Щоб уникнути зайвих витрат в AWS, після завершення перевірки обов'язково видаліть усі ресурси.

```bash
terraform destroy
```
