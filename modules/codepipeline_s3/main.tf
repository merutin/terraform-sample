module "codedepipeline_s3" {
  source = "../modules/"

  name = "test-pipeline-s3"
  # source codeをuploadするbucket名
  bucket_name = "delta-test-s3-bucket"
  # GitHubのaccount/repository
  repository_id = "merutin/react-sample"
  # deploy対象のブランチ
  branch_name        = "main"
  deploy_bucket_name = "delta-deploy-bucket"
  object_key         = "root"
  build_environment = [
    {
      "name" : "ENV",
      "value" : "production",
    },
  ]
}
