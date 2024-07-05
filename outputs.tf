# Output the backend key for verification
output "backend_key" {
  description = "The backend key as read from the state file"
  value       = local.backend_key
}
