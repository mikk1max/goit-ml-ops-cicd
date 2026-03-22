# AIOps Quality Project

## Опис інфраструктури

Цей проєкт реалізує автоматизований MLOps/AIOps пайплайн. FastAPI-сервіс служить для інференсу моделі та містить інтегрований Drift Detector. Сервіс задеплоєно у Kubernetes за допомогою Helm-чарту. ArgoCD реалізує GitOps-підхід, автоматично синхронізуючи стан кластера з репозиторієм (auto-sync, self-heal). Prometheus збирає бізнес-метрики (latencies, кількість запитів, дрейф), а Promtail+Loki забезпечують збір логів. При виявленні дрейфу може тригеритися GitLab CI для перенавчання (retrain).

## Як запустити проєкт

1. Запустіть Kubernetes кластер (наприклад, Minikube або Kind).
2. Застосуйте ArgoCD маніфест: `kubectl apply -f argocd/application.yaml`.
3. ArgoCD автоматично розгорне Helm-чарт з директорії `helm/`.
4. Переконайтеся, що поди працюють: `kubectl get pods`.
5. Зробіть port-forward: `kubectl port-forward svc/aiops-inference-service 8000:8000`.

## Як протестувати запит

Виконайте POST-запит до локального API:

```bash
curl -X POST "http://localhost:8000/predict" \
     -H "Content-Type: application/json" \
     -d '{"feature_1": 10.5, "feature_2": 20.0}'
```

## Як перевірити логування та спрацювання детектора

Для звичайного запиту в логах буде інформація про вхідні дані та прогноз.
Щоб симулювати дрейф даних, відправте аномальне значення (`feature_1 > 100`):

```bash
curl -X POST "http://localhost:8000/predict" \
     -H "Content-Type: application/json" \
     -d '{"feature_1": 150.0, "feature_2": 20.0}'
```

Перевірте логи поду:

```bash
kubectl logs -l app=aiops-inference
```

Ви побачите повідомлення `Drift detected! Feature values are out of expected distribution`.

## Як перевірити, що retrain-пайплайн працює

У GitLab перейдіть у CI/CD -> Pipelines і запустіть пайплайн вручну (Run Pipeline) або надішліть webhook. Job `retrain-model` запустить скрипт `model/train.py`, згенерує новий образ і оновить Helm-чарт.

## Як оновити модель

Процес повністю автоматизований завдяки CI/CD. Після завершення job `update-helm-redeploy`, пайплайн оновлює тег образу в `helm/values.yaml` у Git-репозиторії. ArgoCD фіксує цю зміну і робить auto-sync, перезапускаючи поди з новою версією моделі без ручного втручання.
