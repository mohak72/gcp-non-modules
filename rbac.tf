#provider "kubernetes" {
#  host                   = "https://${google_container_cluster.gke.endpoint}"
#  token                  = data.google_client_config.default.access_token
#  cluster_ca_certificate = base64decode(google_container_cluster.gke.master_auth[0].cluster_ca_certificate)
#}

#  Create a Kubernetes Namespace
resource "kubernetes_namespace" "rbac_namespace" {
  metadata {
    name = var.namespace
  }
}

# Define a Kubernetes Role (Namespace-Scoped)
resource "kubernetes_role" "developer_role" {
  metadata {
    name      = "developer-role"
    namespace = var.namespace
  }

  rule {
    api_groups = [""]
    resources  = ["pods", "services", "deployments", "configmaps"]
    verbs      = ["get", "list", "watch", "create", "update", "delete"]
  }
}

#  Bind Role to a GCP IAM User (Namespace-Scoped)
resource "kubernetes_role_binding" "developer_role_binding" {
  metadata {
    name      = "developer-role-binding"
    namespace = var.namespace
  }

  subject {
    kind      = "User"
    name      = var.gcp_user_email
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    kind      = "Role"
    name      = kubernetes_role.developer_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}

# Define a ClusterRole (Cluster-Wide Permissions)
resource "kubernetes_cluster_role" "admin_role" {
  metadata {
    name = "admin-cluster-role"
  }

  rule {
    api_groups = [""]
    resources  = ["*"]
    verbs      = ["*"]
  }
}

#  Bind ClusterRole to a GCP IAM Group (Cluster-Wide)
resource "kubernetes_cluster_role_binding" "admin_binding" {
  metadata {
    name = "admin-cluster-role-binding"
  }

  subject {
    kind      = "Group"
    name      = var.gcp_group_email
    api_group = "rbac.authorization.k8s.io"
  }

  role_ref {
    kind      = "ClusterRole"
    name      = kubernetes_cluster_role.admin_role.metadata[0].name
    api_group = "rbac.authorization.k8s.io"
  }
}
