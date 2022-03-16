locals {
  availability_zone_ids = [
    "apne1-az1",
    "apne1-az2",
    "apne1-az4",
  ]
}

provider "aws" {
  region = "ap-northeast-1"
}

# zone idからそのzoneの情報を取得する
# zone_id = apne1-az1はap-northeast-1aのこと
data "aws_availability_zone" "availables" {
  count   = length(local.availability_zone_ids)
  zone_id = local.availability_zone_ids[count.index]
}