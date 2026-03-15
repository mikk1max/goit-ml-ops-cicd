import json


def lambda_handler(event, context):
    print("Validating data...")
    print(f"Input parameters: {json.dumps(event)}")

    # Симуляція перевірки
    result = {
        "status": "validation_passed",
        "original_source": event.get("source", "unknown"),
        "commit": event.get("commit", "unknown"),
    }

    return result
