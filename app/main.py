import time
import random
import logging
from fastapi import FastAPI, Request
from pydantic import BaseModel
from prometheus_client import make_asgi_app, Counter, Histogram

# Налаштування логування (Loki/Promtail збиратиме stdout)
logging.basicConfig(level=logging.INFO, format="%(asctime)s - %(levelname)s - %(message)s")
logger = logging.getLogger(__name__)

app = FastAPI(title="AIOps Inference Service")

REQUEST_COUNT = Counter("inference_requests_total", "Total inference requests")
DRIFT_COUNT = Counter("drift_detected_total", "Total number of drift detections")
REQUEST_LATENCY = Histogram("inference_request_latency_seconds", "Inference request latency")

metrics_app = make_asgi_app()
app.mount("/metrics", metrics_app)

class InferenceData(BaseModel):
    feature_1: float
    feature_2: float

class MockModel:
    def __init__(self):
        logger.info("Модель завантажено при старті сервісу.")
    
    def predict(self, data: InferenceData) -> float:
        # Симуляція роботи моделі
        return data.feature_1 * 0.5 + data.feature_2 * 1.2

model = MockModel()

def drift_detector(data: InferenceData):
    """
    Симуляція Alibi Detect / Great Expectations.
    У реальному проєкті тут буде виклик cd.predict(data).
    """
    # Для тестування: якщо feature_1 > 100, симулюємо дрейф
    if data.feature_1 > 100.0:
        logger.warning("Drift detected! Feature values are out of expected distribution.")
        print("Drift detected")
        DRIFT_COUNT.inc()

@app.post("/predict")
async def predict_endpoint(data: InferenceData):
    REQUEST_COUNT.inc()
    start_time = time.time()
    
    logger.info(f"Отримано вхідні дані: {data.dict()}")
    
    drift_detector(data)
    
    prediction = model.predict(data)
    
    logger.info(f"Результат прогнозу: {prediction}")
    
    REQUEST_LATENCY.observe(time.time() - start_time)
    
    return {"prediction": prediction, "is_prediction": True}

@app.get("/health")
def health_check():
    return {"status": "ok"}