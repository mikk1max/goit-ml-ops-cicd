import json


def lambda_handler(event, context):
    print("Logging metrics...")
    print(f"Input from previous step: {json.dumps(event)}")

    # Симуляція логування
    result = {"status": "metrics_logged", "accuracy": 0.95, "loss": 0.05}

    return result
