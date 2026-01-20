import torch
from torch import nn
from torch.utils.data import DataLoader
from torchvision import datasets, transforms
from transformers import AutoImageProcessor, SwinForImageClassification
from sklearn.metrics import classification_report
import os
from sklearn.metrics import confusion_matrix
import matplotlib.pyplot as plt
import seaborn as sns


DATA_DIR = "archive"
BATCH_SIZE = 16
EPOCHS = 5
NUM_CLASSES = 4
DEVICE = "mps" if torch.backends.mps.is_available() else "cpu"

RESULTS_DIR = "results"
os.makedirs(RESULTS_DIR, exist_ok=True)

train_losses = []
train_accuracies = []


processor = AutoImageProcessor.from_pretrained(
    "microsoft/swin-tiny-patch4-window7-224"
)

transform = transforms.Compose([
    transforms.Resize((224, 224)),
    transforms.ToTensor(),
    transforms.Normalize(
        mean=processor.image_mean,
        std=processor.image_std
    )
])

train_dataset = datasets.ImageFolder(
    os.path.join(DATA_DIR, "Training"),
    transform=transform
)

test_dataset = datasets.ImageFolder(
    os.path.join(DATA_DIR, "Testing"),
    transform=transform
)

train_loader = DataLoader(train_dataset, batch_size=BATCH_SIZE, shuffle=True)
test_loader = DataLoader(test_dataset, batch_size=BATCH_SIZE, shuffle=False)

model = SwinForImageClassification.from_pretrained(
    "microsoft/swin-tiny-patch4-window7-224",
    num_labels=NUM_CLASSES,
    ignore_mismatched_sizes=True
)

model.to(DEVICE)

optimizer = torch.optim.AdamW(model.parameters(), lr=1e-4)
criterion = nn.CrossEntropyLoss()

model.train()
for epoch in range(EPOCHS):
    total_loss = 0
    correct = 0
    total = 0

    for x, y in train_loader:
        x, y = x.to(DEVICE), y.to(DEVICE)

        optimizer.zero_grad()
        outputs = model(pixel_values=x).logits
        loss = criterion(outputs, y)
        loss.backward()
        optimizer.step()

        total_loss += loss.item()

        preds = torch.argmax(outputs, dim=1)
        correct += (preds == y).sum().item()
        total += y.size(0)

    avg_loss = total_loss / len(train_loader)
    accuracy = correct / total

    train_losses.append(avg_loss)
    train_accuracies.append(accuracy)

    print(
        f"Epoch {epoch+1}/{EPOCHS} | "
        f"loss={avg_loss:.4f} | acc={accuracy:.4f}"
    )


plt.figure(figsize=(12, 4))

# Loss
plt.subplot(1, 2, 1)
plt.plot(train_losses, marker="o")
plt.title("Swin Transformer – Training Loss")
plt.xlabel("Epoch")
plt.ylabel("Loss")

# Accuracy
plt.subplot(1, 2, 2)
plt.plot(train_accuracies, marker="o")
plt.title("Swin Transformer – Training Accuracy")
plt.xlabel("Epoch")
plt.ylabel("Accuracy")

plt.tight_layout()
plt.savefig(os.path.join(RESULTS_DIR, "swin_training_curves.png"))
plt.close()


model.eval()
y_true, y_pred = [], []

with torch.no_grad():
    for x, y in test_loader:
        x = x.to(DEVICE)
        outputs = model(pixel_values=x).logits
        preds = torch.argmax(outputs, dim=1).cpu().numpy()

        y_pred.extend(preds)
        y_true.extend(y.numpy())

class_names = train_dataset.classes

cm = confusion_matrix(y_true, y_pred)

plt.figure(figsize=(6, 5))
sns.heatmap(
    cm,
    annot=True,
    fmt="d",
    cmap="Blues",
    xticklabels=class_names,
    yticklabels=class_names
)

plt.xlabel("Predicted label")
plt.ylabel("True label")
plt.title("Confusion Matrix – Swin Transformer")

plt.tight_layout()
plt.savefig(os.path.join(RESULTS_DIR, "swin_confusion_matrix.png"))
plt.close()
report = classification_report(
    y_true, y_pred, target_names=class_names
)

print(report)

with open(os.path.join(RESULTS_DIR, "swin_hf_classification_report.txt"), "w") as f:
    f.write(report)
