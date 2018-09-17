module "serverless" {
  source = "./tf_serverless_resources"
  
  environment = "${var.environment}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}

module "webserver" {
  source = "./tf_webserver_resources"
  
  environment = "${var.environment}"
  access_key = "${var.access_key}"
  secret_key = "${var.secret_key}"
}