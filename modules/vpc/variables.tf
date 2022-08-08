# 指定したsystem-envでVPCを作成する
# public subnetにはインターネットゲートウェイをつける
# private subnetはlocalのみとする
# ref: https://dev.classmethod.jp/articles/terraform-deploy-module/
variable "system" {
	description = "system name"
	type = string
}
variable "env" {
	description = "environment name"
	type = string
}
variable "cidr_vpc" {
	description = "VPCのCIDR ex:x.x.x.x/xx"
	type = string
}
variable "cidr_public" {
	description = "public subnetのCIDR(利用するAZの分だけ定義する)"
	type = list(string)
}
variable "cidr_private" {
	description = "private subnetのCIDR(利用しない予定)"
	type = list(string)
	default = []
}