output "jenkins_namespace" {
  value = var.namespace
}

output "jenkins_release_name" {
  value = helm_release.jenkins.name
}

