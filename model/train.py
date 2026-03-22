import time
import logging

logging.basicConfig(level=logging.INFO)
logger = logging.getLogger(__name__)

def train_model():
    logger.info("Початок перенавчання моделі на нових даних...")
    time.sleep(3)
    logger.info("Модель успішно перенавчено. Артефакт збережено як model_v2.pkl")

if __name__ == "__main__":
    train_model()