module "dashboard_repo_uri" {
  source     = "../modules/ssm_repo_uri"
  image_name = "archivematica_dashboard"
}

module "dashboard_nginx_repo_uri" {
  source     = "../modules/ssm_repo_uri"
  image_name = "archivematica_dashboard_nginx"
}

module "mcp_client_repo_uri" {
  source     = "../modules/ssm_repo_uri"
  image_name = "archivematica_mcp_client"
}

module "mcp_server_repo_uri" {
  source     = "../modules/ssm_repo_uri"
  image_name = "archivematica_mcp_server"
}

module "storage_service_repo_uri" {
  source     = "../modules/ssm_repo_uri"
  image_name = "archivematica_storage_service"
}

module "storage_service_nginx_repo_uri" {
  source     = "../modules/ssm_repo_uri"
  image_name = "archivematica_storage_service_nginx"
}
