
# output "documentdb_endpoint" {
#   value = aws_docdb_cluster.example.endpoint
# }

# output "documentdb_snapshot_id" {
#   value = aws_docdb_cluster_snapshot.example_snapshot.id
# }

# output "cluster_name" {
#   value       = join("", aws_docdb_cluster.default[*].cluster_identifier)
#   description = "Cluster Identifier"
# }

# output "arn" {
#   value       = join("", aws_docdb_cluster.default[*].arn)
#   description = "Amazon Resource Name (ARN) of the cluster"
# }

# output "endpoint" {
#   value       = join("", aws_docdb_cluster.default[*].endpoint)
#   description = "Endpoint of the DocumentDB cluster"
# }

# output "reader_endpoint" {
#   value       = join("", aws_docdb_cluster.default[*].reader_endpoint)
#   description = "A read-only endpoint of the DocumentDB cluster, automatically load-balanced across replicas"
# }