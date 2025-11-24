# CI/CD Pipeline: Terraform + Jenkins + ECR + Helm + Argo CD

Цей проєкт реалізує повний CI/CD-процес для Django-застосунку з використанням:

- **Terraform** (інфраструктура як код)
- **Amazon ECR** (контейнерний реєстр)
- **Jenkins** (CI-пайплайн)
- **Helm** (пакування Kubernetes-застосунків)
- **Argo CD** (GitOps CD-підхід)
- **EKS (Kubernetes)** — описаний у модулі, але без фактичного AWS-акаунта

Проєкт виконаний у форматі домашнього завдання **Lesson 8–9**.

---

## 📌 Структура проєкту
lesson-8-9/
│
├── main.tf
├── backend.tf
├── outputs.tf
│
├── modules/
│ ├── s3-backend/ # модуль для S3 + DynamoDB (бекенд)
│ ├── vpc/ # модуль VPC
│ ├── ecr/ # репозиторій ECR
│ ├── eks/ # кластер EKS (спрощений)
│ ├── jenkins/ # встановлення Jenkins через Helm
│ └── argo_cd/ # встановлення Argo CD + Helm-чарт apps
│
└── charts/
└── django-app/ # Helm-чарт застосунку


---

# 🧩 Інфраструктура Terraform

### 1️⃣ Backend
Стейт Terraform зберігається локально (`backend "local"`), щоб уникнути помилок без AWS-акаунта.

### 2️⃣ VPC
Описана мережа з підмережами, IGW і маршрутизацією.

### 3️⃣ ECR
Terraform створює ECR-репозиторій, куди мав би пушитись Docker-образ.

### 4️⃣ EKS
Кластер Kubernetes описаний модулем `eks`.
Але через відсутність AWS-підписки сабнети замінено на порожній список, що дозволяє пройти `terraform validate`.

### 5️⃣ Jenkins
Встановлюється через Helm:

- створюється namespace
- встановлюється Helm-чарт
- підключено providers helm/kubernetes

### 6️⃣ Argo CD
Встановлюється через Helm:

- Argo CD сервер
- окремий Helm-чарт для Argo CD Applications (`modules/argo_cd/charts`)
- створюється Application для Django-застосунку

---

# 🚀 CI/CD Pipeline (Jenkins)

Jenkinsfile знаходиться в корені репозиторію.

### Пайплайн складається з етапів:

1. **Checkout**
   - клонування репозиторію `my-microservice-project`

2. **Build Docker Image (simulated)**
   - імітація збірки Docker-образу Django

3. **Push to ECR (simulated)**
   - замінено echo-командами (оскільки ECR недоступний)

4. **Update Helm values.yaml**
   - пайплайн оновлює:
     ```
     lesson-8-9/charts/django-app/values.yaml
     ```
   - змінює поле:
     ```
     tag: "latest" → tag: "build-{BUILD_NUMBER}"
     ```

5. **Commit & Push**
   - Jenkins робить git commit і пушить у `main`

### 🔄 Argo CD (GitOps)

Після пушу в main:

- Argo CD виявляє зміну Helm-чарту
- автоматично застосовує її в кластері (у реальному середовищі)
- оновлює версію образу в Kubernetes

---

# 🛠 Команди Terraform

### Ініціалізація:

```bash
terraform init

