import os
import shutil
import mlflow
import mlflow.sklearn
from sklearn.datasets import load_iris
from sklearn.model_selection import train_test_split
from sklearn.neural_network import MLPClassifier
from sklearn.metrics import accuracy_score, log_loss
from prometheus_client import CollectorRegistry, Gauge, push_to_gateway

os.environ["MLFLOW_S3_ENDPOINT_URL"] = "http://localhost:9000"
os.environ["AWS_ACCESS_KEY_ID"] = "admin"
os.environ["AWS_SECRET_ACCESS_KEY"] = "password123"

# MLFLOW_URI = "http://localhost:5000"
PUSHGATEWAY_URI = "localhost:9091"

# mlflow.set_tracking_uri(MLFLOW_URI)
mlflow.set_tracking_uri("sqlite:///mlflow.db")
mlflow.set_experiment("Iris_Model_Experiment")

registry = CollectorRegistry()
g_accuracy = Gauge("mlflow_accuracy", "Model Accuracy", ["run_id"], registry=registry)
g_loss = Gauge("mlflow_loss", "Model Loss", ["run_id"], registry=registry)


def run_experiments():
    print("Завантаження датасету Iris...")
    data = load_iris()
    X_train, X_test, y_train, y_test = train_test_split(
        data.data, data.target, test_size=0.2, random_state=42
    )

    hyperparameters = [
        {"learning_rate": 0.01, "epochs": 50},
        {"learning_rate": 0.05, "epochs": 100},
        {"learning_rate": 0.001, "epochs": 150},
    ]

    best_accuracy = 0
    best_run_id = None

    for params in hyperparameters:
        with mlflow.start_run() as run:
            run_id = run.info.run_id
            print(f"\n--- Запуск експерименту ID: {run_id} ---")
            print(f"Параметри: {params}")

            model = MLPClassifier(
                learning_rate_init=params["learning_rate"],
                max_iter=params["epochs"],
                random_state=42,
            )
            model.fit(X_train, y_train)

            predictions = model.predict(X_test)
            proba = model.predict_proba(X_test)
            acc = accuracy_score(y_test, predictions)
            loss = log_loss(y_test, proba)
            print(f"Результат -> Accuracy: {acc:.4f}, Loss: {loss:.4f}")

            mlflow.log_params(params)
            mlflow.log_metrics({"accuracy": acc, "loss": loss})
            mlflow.sklearn.log_model(model, "model")

            g_accuracy.labels(run_id=run_id).set(acc)
            g_loss.labels(run_id=run_id).set(loss)
            try:
                push_to_gateway(
                    PUSHGATEWAY_URI, job="mlflow_metrics", registry=registry
                )
            except Exception as e:
                print(f"Помилка відправки в PushGateway: {e}")

            if acc > best_accuracy:
                best_accuracy = acc
                best_run_id = run_id

    print(
        f"\n*** Експерименти завершено! Найкращий Run ID: {best_run_id} (Accuracy: {best_accuracy:.4f}) ***"
    )
    return best_run_id


def save_best_model_locally(run_id):
    best_model_dir = "../best_model"
    if os.path.exists(best_model_dir):
        shutil.rmtree(best_model_dir)
    os.makedirs(best_model_dir, exist_ok=True)

    print(f"Завантаження найкращої моделі з MinIO в папку {best_model_dir}...")
    model_uri = f"runs:/{run_id}/model"
    best_model = mlflow.sklearn.load_model(model_uri)
    mlflow.sklearn.save_model(best_model, best_model_dir)
    print("Модель успішно збережена!")


if __name__ == "__main__":
    best_id = run_experiments()
    if best_id:
        save_best_model_locally(best_id)
