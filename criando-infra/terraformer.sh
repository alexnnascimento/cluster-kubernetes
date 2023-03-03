#!/bin/bash

# Para execução deste script é necessário ter o terraformer instalado
# Caso não tenha segue abaixo link para instalação
###################################
###################################
###### INSTALAÇÃO NO LINUX ########
#  export PROVIDER=aws 
#  curl -LO https://github.com/GoogleCloudPlatform/terraformer/releases/download/$(curl -s https://api.github.com/repos/GoogleCloudPlatform/terraformer/releases/latest | grep tag_name | cut -d '"' -f 4)/terraformer-${PROVIDER}-linux-amd64
#  chmod +x terraformer-${PROVIDER}-linux-amd64
#  sudo mv terraformer-${PROVIDER}-linux-amd64 /usr/local/bin/terraformer
###################################
###################################
###################################
# Abaixo link com mais informações e caso ocorra erro na instalação:
# https://github.com/GoogleCloudPlatform/terraformer
# Em breve será adicionado a instalação automatica por esse script

#Criando arquivo provider
cat << EOF > provider.tf
terraform {
  required_providers {
     aws = {
      source = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
}
EOF

#Iniciando terraform
terraform init

#Verificando se o diretório .terraform foi criado
while [ ! -d ".terraform" ]; do
    echo "Aguardando inicialização do Terraform..."
    sleep 5
done

echo "Terraform inicializado com sucesso!"

# Define uma lista de regiões da AWS
regions=("us-east-1" "sa-east-1")

# Abaixo informe o nome da conta
account=("nomeDaConta")

# Abaixo informar o nome dos serviços que deseja importar
services=("accessanalyzer" "alb" "api_gateway" "appsync" "auto_scaling" "batch" "cloudformation" "cloudfront" "cloudhsm" "codebuild" "codecommit" "codedeploy" "codepipeline" "cognito" "customer_gateway" "datapipeline" "docdb" "dynamodb" "ebs" "ec2_instance" "ecr" "ecrpublic" "ecs" "efs" "eip" "eks" "elasticache" "elastic_beanstalk" "elb" "emr" "eni" "es" "glue" "igw" "kinesis" "kms" "lambda" "media_store" "msk" "nacl" "nat" "qldb" "rds" "route_table" "s3" "ses" "sfn" "sg" "sqs" "ssm" "subnet" "transit_gateway" "vpc" "vpc_peering" "vpn_connection" "vpn_gateway" "xray" "cloudfront" "ecrpublic" "route53")

# Loop pelas contas
for acc in "${account[@]}"; do

    # Verifica se a pasta existe
    if [[ -d "$acc" ]]; then
        echo "A pasta $acc já existe, ignorando..."
    else
        echo "A pasta $acc não existe, criando..."
        mkdir "$acc"
    fi

    # Loop pelas regiões e execute o comando em cada uma delas
    for reg in "${regions[@]}"; do
        echo "Criando pastas referente a região $reg"
        mkdir -p "$PWD/$acc/$reg"
        echo "Listando regiões $reg"

        # Loop pelos serviços e executa o comando em cada um deles
        for serv in "${services[@]}"; do
            echo "Executando import na região $reg"
            terraformer import aws --resources="$serv" --regions="$reg" --profile="$acc"
            sleep 1
            echo "Realizando cópia do conteúdo"
            rsync -avzu "$PWD/generated/aws/" "$PWD/$acc/$reg/"
        done

        # Remove as pastas já copiadas
        echo "Removendo pastas já copiadas"
        rm -r -f "$PWD/$acc/$reg/aws" "$PWD/generated"
    done
done
