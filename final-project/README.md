Final DevOps Project – AWS Terraform Infrastructure

Цей проєкт є фінальним завданням курсу і демонструє зібрану інфраструктуру DevOps на базі AWS з використанням Terraform.
Структура проєкту будується на основі попередніх домашніх завдань (VPC, EKS, ECR, RDS, Jenkins, Argo CD, Helm).

Структура проєкту

final-project/

backend.tf – конфігурація Terraform backend (local)

main.tf – підключення всіх модулів інфраструктури

outputs.tf – вихідні значення (ECR URL, VPC ID, RDS endpoint)

README.md – опис проєкту

modules/

s3-backend/ – модуль S3 + DynamoDB для Terraform backend

vpc/ – модуль VPC (CIDR, підмережі, маршрути)

ecr/ – модуль для створення репозиторію ECR

eks/ – модуль для Kubernetes кластера EKS

rds/ – універсальний модуль RDS/Aurora

jenkins/ – модуль для встановлення Jenkins через Helm

argo_cd/ – модуль для встановлення Argo CD через Helm

charts/

django-app/ – Helm-чарт для Django-застосунку

django/

app/ – директорія для коду застосунку (заготовка)

Dockerfile

Jenkinsfile

docker-compose.yaml

Опис компонентів інфраструктури

VPC (modules/vpc)

Створюється окрема VPC з CIDR 10.0.0.0/16

Публічні та приватні підмережі

Налаштування маршрутизації та Internet Gateway

ECR (modules/ecr)

Репозиторій Amazon ECR для зберігання Docker-образів Django-застосунку

Підтримка scan_on_push для перевірки вразливостей

EKS (modules/eks)

Kubernetes-кластер на базі AWS EKS

Прив’язка до VPC

(У поточній конфігурації використані технічні значення-заглушки, щоб Terraform міг пройти validate без реального AWS акаунта)

RDS / Aurora (modules/rds)

Універсальний модуль для бази даних

use_aurora = false → створюється звичайна RDS instance (PostgreSQL)

use_aurora = true → Aurora cluster + writer instance

Автоматично створюються:

DB Subnet Group

Security Group

Parameter Group

Jenkins (modules/jenkins)

Розгортання Jenkins через Helm у namespace jenkins

Використовується для CI/CD-пайплайну:

збірка Docker-образу Django

пуш до ECR

оновлення Helm-чарта / Git-репозиторію

Argo CD (modules/argo_cd)

Розгортання Argo CD через Helm у namespace argocd

Використовується для GitOps-доставки:

відслідковує зміни у Helm-чарті

синхронізує застосунок у кластері

Helm-чарт django-app

deployment.yaml – розгортання Django-подів з образом із ECR

service.yaml – сервіс типу LoadBalancer або ClusterIP

configmap.yaml – змінні середовища (налаштування Django)

hpa.yaml – Horizontal Pod Autoscaler (масштабування за CPU)

values.yaml – параметри образу, сервісу, autoscaling, ConfigMap

Terraform конфігурація (main.tf)

У файлі main.tf підключені всі модулі:

s3-backend – логічний backend для збереження стейту (в даному проєкті використовується backend "local")

vpc – створення мережевої інфраструктури

ecr – реєстр контейнерів

eks – кластер Kubernetes

rds – база даних для додатку

jenkins – CI-система

argo_cd – GitOps-орієнтований CD

У провайдерах kubernetes та helm використані заглушки (фейкові endpoint/token), щоб Terraform міг коректно пройти terraform validate без реального EKS-кластера.

Як запускати (логічний сценарій)

У реальному AWS-середовищі порядок дій був би таким:

Ініціалізація Terraform:
terraform init

Перевірка конфігурації:
terraform validate

План розгортання:
terraform plan

Розгортання інфраструктури:
terraform apply

Налаштування доступу до кластера EKS:
aws eks update-kubeconfig --name final-eks --region <your-region>

Перевірка просторів і сервісів:
kubectl get all -n jenkins
kubectl get all -n argocd
kubectl get all -n monitoring

Port-forward до основних сервісів:
Jenkins:
kubectl port-forward svc/jenkins 8080:8080 -n jenkins

Argo CD:
kubectl port-forward svc/argocd-server 8081:443 -n argocd

Grafana:
kubectl port-forward svc/grafana 3000:80 -n monitoring

Безпека та зауваження

У поточній версії інфраструктура налаштована таким чином, щоб не вимагати реального AWS акаунта для перевірки коду (terraform validate).

Паролі та критичні секрети в демо-конфігурації захардкожені для спрощення перевірки коду – у реальному середовищі їх потрібно виносити в AWS Secrets Manager, SSM Parameter Store або Kubernetes Secrets.

Стан Terraform може зберігатися в локальному backend (backend.tf), однак для реального продакшн-оточення рекомендовано використовувати S3 + DynamoDB для блокувань.

Висновок

Цей проєкт демонструє повну збірку DevOps-інфраструктури на AWS із використанням Terraform, включно з VPC, EKS, RDS/Aurora, ECR, Jenkins, Argo CD та Helm.
Структура коду та модулів дозволяє легко адаптувати розв’язання для реального хмарного середовища, додати моніторинг (Prometheus + Grafana) та повноцінний CI/CD-процес.

Автор: Nataliya Traxler
Гілка репозиторію: final-project
