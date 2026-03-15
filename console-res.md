```bash
❯ python3 train_and_push.py
2026/03/15 17:57:51 INFO mlflow.store.db.utils: Creating initial MLflow database tables...
2026/03/15 17:57:51 INFO mlflow.store.db.utils: Updating database tables
INFO  [alembic.runtime.migration] Context impl SQLiteImpl.
INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
INFO  [alembic.runtime.migration] Running upgrade  -> 451aebb31d03, add metric step
INFO  [alembic.runtime.migration] Running upgrade 451aebb31d03 -> 90e64c465722, migrate user column to tags
INFO  [alembic.runtime.migration] Running upgrade 90e64c465722 -> 181f10493468, allow nulls for metric values
INFO  [alembic.runtime.migration] Running upgrade 181f10493468 -> df50e92ffc5e, Add Experiment Tags Table
INFO  [alembic.runtime.migration] Running upgrade df50e92ffc5e -> 7ac759974ad8, Update run tags with larger limit
INFO  [alembic.runtime.migration] Running upgrade 7ac759974ad8 -> 89d4b8295536, create latest metrics table
INFO  [89d4b8295536_create_latest_metrics_table_py] Migration complete!
INFO  [alembic.runtime.migration] Running upgrade 89d4b8295536 -> 2b4d017a5e9b, add model registry tables to db
INFO  [2b4d017a5e9b_add_model_registry_tables_to_db_py] Adding registered_models and model_versions tables to database.
INFO  [2b4d017a5e9b_add_model_registry_tables_to_db_py] Migration complete!
INFO  [alembic.runtime.migration] Running upgrade 2b4d017a5e9b -> cfd24bdc0731, Update run status constraint with killed
INFO  [alembic.runtime.migration] Running upgrade cfd24bdc0731 -> 0a8213491aaa, drop_duplicate_killed_constraint
INFO  [alembic.runtime.migration] Running upgrade 0a8213491aaa -> 728d730b5ebd, add registered model tags table
INFO  [alembic.runtime.migration] Running upgrade 728d730b5ebd -> 27a6a02d2cf1, add model version tags table
INFO  [alembic.runtime.migration] Running upgrade 27a6a02d2cf1 -> 84291f40a231, add run_link to model_version
INFO  [alembic.runtime.migration] Running upgrade 84291f40a231 -> a8c4a736bde6, allow nulls for run_id
INFO  [alembic.runtime.migration] Running upgrade a8c4a736bde6 -> 39d1c3be5f05, add_is_nan_constraint_for_metrics_tables_if_necessary
INFO  [alembic.runtime.migration] Running upgrade 39d1c3be5f05 -> c48cb773bb87, reset_default_value_for_is_nan_in_metrics_table_for_mysql
INFO  [alembic.runtime.migration] Running upgrade c48cb773bb87 -> bd07f7e963c5, create index on run_uuid
INFO  [alembic.runtime.migration] Running upgrade bd07f7e963c5 -> 0c779009ac13, add deleted_time field to runs table
INFO  [alembic.runtime.migration] Running upgrade 0c779009ac13 -> cc1f77228345, change param value length to 500
INFO  [alembic.runtime.migration] Running upgrade cc1f77228345 -> 97727af70f4d, Add creation_time and last_update_time to experiments table
INFO  [alembic.runtime.migration] Running upgrade 97727af70f4d -> 3500859a5d39, Add Model Aliases table
INFO  [alembic.runtime.migration] Running upgrade 3500859a5d39 -> 7f2a7d5fae7d, add datasets inputs input_tags tables
INFO  [alembic.runtime.migration] Running upgrade 7f2a7d5fae7d -> 2d6e25af4d3e, increase max param val length from 500 to 8000
INFO  [alembic.runtime.migration] Running upgrade 2d6e25af4d3e -> acf3f17fdcc7, add storage location field to model versions
INFO  [alembic.runtime.migration] Running upgrade acf3f17fdcc7 -> 867495a8f9d4, add trace tables
INFO  [alembic.runtime.migration] Running upgrade 867495a8f9d4 -> 5b0e9adcef9c, add cascade deletion to trace tables foreign keys
INFO  [alembic.runtime.migration] Running upgrade 5b0e9adcef9c -> 4465047574b1, increase max dataset schema size
INFO  [alembic.runtime.migration] Running upgrade 4465047574b1 -> f5a4f2784254, increase run tag value limit to 8000
INFO  [alembic.runtime.migration] Running upgrade f5a4f2784254 -> 0584bdc529eb, add cascading deletion to datasets from experiments
INFO  [alembic.runtime.migration] Running upgrade 0584bdc529eb -> 400f98739977, add logged model tables
INFO  [alembic.runtime.migration] Running upgrade 400f98739977 -> 6953534de441, add step to inputs table
INFO  [alembic.runtime.migration] Running upgrade 6953534de441 -> bda7b8c39065, increase_model_version_tag_value_limit
INFO  [alembic.runtime.migration] Context impl SQLiteImpl.
INFO  [alembic.runtime.migration] Will assume non-transactional DDL.
2026/03/15 17:57:51 INFO mlflow.tracking.fluent: Experiment with name 'Iris_Model_Experiment' does not exist. Creating a new experiment.
Завантаження датасету Iris...

--- Запуск експерименту ID: 186b9adc4027412eba12d849aeaa4fd6 ---
Параметри: {'learning_rate': 0.01, 'epochs': 50}
/Users/mikk1max/Documents/GitHub/GoIT-edu/goit-ml-ops-cicd/mlops-experiments/experiments/venv/lib/python3.9/site-packages/sklearn/neural_network/_multilayer_perceptron.py:691: ConvergenceWarning: Stochastic Optimizer: Maximum iterations (50) reached and the optimization hasn't converged yet.
  warnings.warn(
Результат -> Accuracy: 1.0000, Loss: 0.0985
2026/03/15 17:57:51 WARNING mlflow.models.model: `artifact_path` is deprecated. Please use `name` instead.
2026/03/15 17:57:53 WARNING mlflow.models.model: Model logged without a signature and input example. Please set `input_example` parameter when logging the model to auto infer the model signature.

--- Запуск експерименту ID: 5bcb290525f9445cab8f6e55faa24a04 ---
Параметри: {'learning_rate': 0.05, 'epochs': 100}
Результат -> Accuracy: 1.0000, Loss: 0.0518
2026/03/15 17:57:53 WARNING mlflow.models.model: `artifact_path` is deprecated. Please use `name` instead.
2026/03/15 17:57:54 WARNING mlflow.models.model: Model logged without a signature and input example. Please set `input_example` parameter when logging the model to auto infer the model signature.

--- Запуск експерименту ID: 7fd7139a586547c1aadb821cccc19686 ---
Параметри: {'learning_rate': 0.001, 'epochs': 150}
/Users/mikk1max/Documents/GitHub/GoIT-edu/goit-ml-ops-cicd/mlops-experiments/experiments/venv/lib/python3.9/site-packages/sklearn/neural_network/_multilayer_perceptron.py:691: ConvergenceWarning: Stochastic Optimizer: Maximum iterations (150) reached and the optimization hasn't converged yet.
  warnings.warn(
Результат -> Accuracy: 1.0000, Loss: 0.3063
2026/03/15 17:57:54 WARNING mlflow.models.model: `artifact_path` is deprecated. Please use `name` instead.
2026/03/15 17:57:56 WARNING mlflow.models.model: Model logged without a signature and input example. Please set `input_example` parameter when logging the model to auto infer the model signature.

*** Експерименти завершено! Найкращий Run ID: 186b9adc4027412eba12d849aeaa4fd6 (Accuracy: 1.0000) ***
Завантаження найкращої моделі з MinIO в папку ../best_model...
Модель успішно збережена!
```
