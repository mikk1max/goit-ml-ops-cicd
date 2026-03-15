# MLOps Train Automation

Цей проєкт демонструє автоматизацію процесу тренування ML-моделей за допомогою AWS Step Functions, AWS Lambda та GitLab CI. Інфраструктура керується через Terraform.

## 1. Як зібрати Lambda-архіви

Перед розгортанням інфраструктури потрібно створити `.zip` архіви з кодом Lambda-функцій:

```bash
cd terraform/lambda
zip validate.zip validate.py
zip log_metrics.zip log_metrics.py
cd ../../
```

## 2. Як розгорнути інфраструктуру через Terraform

Переконайтеся, що у вас налаштовані AWS credentials (`aws configure`). Потім виконайте:

```bash
cd terraform
terraform init
terraform plan
terraform apply -auto-approve
```

Після успішного виконання ви побачите вивід `step_function_arn`. Скопіюйте це значення — воно знадобиться для GitLab CI.

### 3. Як вручну запустити Step Function

1. Перейдіть до AWS Console -> Step Functions.

2. Знайдіть State Machine з назвою MLOps-Training-Pipeline.

3. Натисніть Start execution.

4. Вставте наступний JSON як вхідні параметри:

```json
{
  "source": "manual-trigger",
  "commit": "N/A"
}
```

5. Натисніть Start execution та спостерігайте за візуальним графом проходження кроків `ValidateData` -> `LogMetrics`.

### 4. Як працює GitLab CI

При кожному `push` у репозиторій запускається job `train-model`. Він використовує офіційний Docker-образ `amazon/aws-cli` і через команду `aws stepfunctions start-execution` запускає наш пайплайн.

#### Необхідні CI/CD змінні в GitLab

Перейдіть у Settings -> CI/CD -> Variables вашого репозиторію і додайте:

- AWS_ACCESS_KEY_ID: Ваш AWS ключ доступу.

- AWS_SECRET_ACCESS_KEY: Ваш секретний ключ.

- AWS_DEFAULT_REGION: Ваш регіон (наприклад, eu-central-1).

- STEP_FUNCTION_ARN: ARN вашої Step Function, який видав Terraform.
