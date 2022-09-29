module "codedepipeline" {
  source = "../modules"

  name = "test-pipeline2"
  # source codeをuploadするbucket名
  bucket_name = "delta-test-bucket"
  # GitHubのaccount/repository
  repository_id = "merutin/react-sample"
  # deploy対象のブランチ
  branch_name           = "main"
  # albのtarget groupが必要
  target_group_name = "asg-test"
  # 先にasgの設定が必要
  autoscaling_group_name = "CodeDeploy_test3"
}
