# Terraform RDS / Aurora Universal Module (lesson-db-module)

Цей проєкт містить універсальний Terraform-модуль `rds`, який може створювати або звичайну RDS instance (PostgreSQL/MySQL), або Aurora Cluster, залежно від значення змінної `use_aurora`.  
Модуль підходить для продакшн-середовищ і підтримує багаторазове використання.

---

## 📁 Структура проєкту

lesson-db-module/
│
├── main.tf
├── backend.tf
├── outputs.tf
│
└── modules/
└── rds/
├── shared.tf
├── rds.tf
├── aurora.tf
├── variables.tf
└── outputs.tf


## 📌 Приклад використання


module "rds" {
  source = "./modules/rds"

  use_aurora            = false

  engine                = "postgres"
  aurora_engine         = "aurora-postgresql"
  engine_version        = "15.3"

  instance_class        = "db.t3.small"
  allocated_storage     = 20
  multi_az              = false
  publicly_accessible   = false

  db_name               = "app_db"
  username              = "app_user"
  password              = "ChangeMe123!"

  vpc_id                = "vpc-xxxxxx"
  subnet_ids            = ["subnet-aaaaaa", "subnet-bbbbbb"]

  parameter_group_family = "postgres15"
  port                   = 5432
  identifier             = "lesson-db-module"
}
У цій демонстраційній версії vpc_id та subnet_ids використовуються як плейсхолдери для того, щоб модуль проходив terraform validate без реального AWS акаунта.

🔁 Перемикання між RDS та Aurora
✔ use_aurora = false → створюється звичайна RDS instance
aws_db_instance.this[0]

Aurora не створюється

✔ use_aurora = true → створюється Aurora Cluster
aws_rds_cluster.this[0]

aws_rds_cluster_instance.this[0]

звичайна RDS не створюється

У будь-якому режимі створюються:

DB Subnet Group

Security Group

Parameter Group

🔧 Змінні
Змінна	Тип	Дефолт	Опис
use_aurora	bool	false	Вибір між RDS/Aurora
engine	string	postgres	Двигун для RDS
aurora_engine	string	aurora-postgresql	Двигун Aurora
engine_version	string	15.3	Версія
instance_class	string	db.t3.small	Тип інстансу
allocated_storage	number	20	Обсяг диску (RDS only)
multi_az	bool	false	Multi-AZ режим
publicly_accessible	bool	false	Доступність з інтернету
db_name	string	app_db	Назва бази
username	string	app_user	Логін
password	string	ChangeMe123!	Пароль
vpc_id	string	vpc-xxxxxx	ID VPC
subnet_ids	list(string)	["subnet-1","subnet-2"]	Підмережі
parameter_group_family	string	postgres15	Тип параметр-групи
port	number	5432	Порт
identifier	string	lesson-db-module	Префікс ресурсів

📤 Outputs

output "db_endpoint" {}
output "db_port" {}
Для RDS:
db_endpoint = aws_db_instance.this[0].address

Для Aurora:
db_endpoint = aws_rds_cluster.this[0].endpoint

🛠 Команди Terraform
У директорії lesson-db-module:

terraform init
terraform validate
terraform plan
terraform destroy
✍ Автор
Nataliya Traxler
Гілка репозиторію: lesson-db-module