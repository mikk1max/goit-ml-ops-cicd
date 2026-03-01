import torch
import torchvision.models as models


def export_model():
    print("Завантаження попередньо натренованої моделі MobileNetV2...")
    model = models.mobilenet_v2(weights=models.MobileNet_V2_Weights.IMAGENET1K_V1)
    model.eval()

    # Створюємо dummy-тензор для трасування (tracing)
    example_input = torch.rand(1, 3, 224, 224)

    print("Конвертація у TorchScript...")
    traced_script_module = torch.jit.trace(model, example_input)

    save_path = "model.pt"
    traced_script_module.save(save_path)
    print(f"Модель успішно збережена як {save_path}")


if __name__ == "__main__":
    export_model()
