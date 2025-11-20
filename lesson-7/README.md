# Lesson 7 — Kubernetes, Terraform, Helm

У цьому завданні реалізовано повний цикл підготовки інфраструктури для деплою Django-застосунку за допомогою Terraform, Kubernetes (EKS) та Helm.

---

## 1. AWS інфраструктура (Terraform)

У проєкті створено такі модулі:

### • VPC
Використано модуль VPC, створений у попередньому домашньому завданні:
- CIDR блок 10.0.0.0/16
- Public та Private підмережі
- Internet Gateway, маршрутизація  
Модуль імпортований у `main.tf`.

### • ECR
Створено репозиторій Amazon Elastic Container Registry для зберігання Docker-образу Django:
- репозиторій створюється через модуль `ecr`
- увімкнено підтримку image scanning on push

### • EKS
Створений модуль `eks`, що описує:
- IAM-ролі для кластера та node group
- створення EKS Cluster
- створення Node Group
- привʼязку до VPC  

У зв'язку з відсутністю реального AWS-акаунта sabnet-ідентифікатори спрощені, але конфігурація успішно проходить `terraform validate`.

### Стан Terraform

Стан інфраструктури зберігається локально (backend "local").

Команди перевірки:

```bash
terraform init
terraform validate
