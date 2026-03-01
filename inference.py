import torch
import sys
from PIL import Image
from torchvision import transforms


def predict(image_path):
    try:
        model = torch.jit.load("model.pt")
        model.eval()
    except Exception as e:
        print(f"Помилка завантаження моделі: {e}")
        sys.exit(1)

    # Стандартний препроцесинг для ImageNet моделей
    preprocess = transforms.Compose(
        [
            transforms.Resize(256),
            transforms.CenterCrop(224),
            transforms.ToTensor(),
            transforms.Normalize(mean=[0.485, 0.456, 0.406], std=[0.229, 0.224, 0.225]),
        ]
    )

    try:
        img = Image.open(image_path).convert("RGB")
        input_tensor = preprocess(img)
        input_batch = input_tensor.unsqueeze(0)
    except Exception as e:
        print(f"Помилка обробки зображення: {e}")
        sys.exit(1)

    with torch.no_grad():
        output = model(input_batch)

    # Отримуємо ймовірності та топ-3
    probabilities = torch.nn.functional.softmax(output[0], dim=0)
    top3_prob, top3_catid = torch.topk(probabilities, 3)

    print(f"--- Top 3 передбачення для {image_path} ---")
    for i in range(top3_prob.size(0)):
        print(
            f"Клас (ID): {top3_catid[i].item()}, Ймовірність: {top3_prob[i].item() * 100:.2f}%"
        )


if __name__ == "__main__":
    if len(sys.argv) < 2:
        print("Використання: python inference.py <шлях_до_зображення>")
        sys.exit(1)
    predict(sys.argv[1])
