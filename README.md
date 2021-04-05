# terraform-ecs-on-ec2-sample

TerraformでAmazon ECS環境（on ec2）を作成するためのコード。

## セットアップ

全体的な流れとしては、ECR → RDS → その他リソースといった順番で作成していくとスムーズ。

### 環境変数をセット

```
$ cp terraform.tfvars.sample terraform.tfvars
```

terraform.tfvars内にAWSアクセスキーやデータベースの情報などを記述する。

```
aws_access_key    = "AWSアクセスキー"
aws_secret_key    = "AWSシークレットキー"
aws_account_id    = "AWSアカウントID"
database_host     = "RDSのエンドポイント（後ほど作成）"
database_name     = "sample_app_production"
database_username = "root"
database_password = "password"
app_image_uri     = "ECRリポジトリ(app)のURI（後ほど作成）"
nginx_image_uri   = "ECRリポジトリ(nginx)のURI（後ほど作成）"
rails_master_key  = "Railsアプリのmaster.key"
```

### 初期化

```
$ terraform init
```

### ECRリポジトリを作成

```
$ terraform apply -target={aws_ecr_repository.sample_app,aws_ecr_lifecycle_policy.sample_app_lifecycle_policy,aws_ecr_repository.sample_nginx}
```
リポジトリが作成できたらその中にDockerイメージをプッシュしておく。

### RDSを作成

```
$ terraform apply -target={aws_db_subnet_group.sample_db_subnet_group,aws_db_instance.sample_db}
```

### その他リソースを一括で作成

```
$ terraform apply
```

作成されたロードバランサーのDNS名にアクセスするとアプリがデプロイできているはず。
