# MLOps Lesson 3: Контейнеризація ML

Цей проєкт демонструє завантаження моделі TorchScript та її запуск у контейнерах різного розміру.

## Кроки для запуску

1. **Підготовка середовища:**

   ```bash
   chmod +x install_dev_tools.sh
   ./install_dev_tools.sh
   ```

2. **Експорт моделі:**

   ```bash
   python export_model.py
   ```

   (Згенерується файл model.pt)

3. **Збірка образів:**

   ```bash
   docker build -t ml-fat -f Dockerfile.fat .
   docker build -t ml-slim -f Dockerfile.slim .
   ```

4. **Запуск (передайте будь-яке тестове зображення test.jpg):**

   ```bash
   docker run --rm -v $(pwd)/test.jpg:/app/test.jpg ml-fat /app/test.jpg
   docker run --rm -v $(pwd)/test.jpg:/app/test.jpg ml-slim /app/test.jpg
   ```
