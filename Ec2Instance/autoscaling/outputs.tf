output "launch_template_id" {
  description = "The ID of the launch template"
  value       = module.example.launch_template_id
}

output "launch_template_arn" {
  description = "The ARN of the launch template"
  value       = module.example.launch_template_arn
}

output "autoscaling_group_id" {
  description = "The autoscaling group id"
  value       = module.example.autoscaling_group_id
}

output "autoscaling_group_availability_zones" {
  description = "The availability zones of the autoscale group"
  value       = module.example.autoscaling_group_availability_zones
}

output "autoscaling_group_vpc_zone_identifier" {
  description = "The VPC zone identifier"
  value       = module.example.autoscaling_group_vpc_zone_identifier
}

output "autoscaling_group_load_balancers" {
  description = "The load balancer names associated with the autoscaling group"
  value       = module.example.autoscaling_group_load_balancers
}

output "autoscaling_group_target_group_arns" {
  description = "List of Target Group ARNs that apply to this AutoScaling Group"
  value       = module.example.autoscaling_group_target_group_arns
}
