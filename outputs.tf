#__________________________________________________________
#
# Data Object Outputs
#__________________________________________________________

output "data_policies" {
  value = { for e in keys(data.intersight_search_search_item.policies) : e => {
    for i in data.intersight_search_search_item.policies[e
    ].results : "${local.org_moids[jsondecode(i.additional_properties).Organization.Moid]}/${jsondecode(i.additional_properties).Name}" => i.moid }
  }
}

#____________________________________________________________
#
# Collect the moid of the UCS Domain Cluster Profiles
#____________________________________________________________

output "domains" {
  description = "Moid of the Domain Cluster Profiles"
  value       = { for v in sort(keys(intersight_fabric_switch_cluster_profile.map)) : v => intersight_fabric_switch_cluster_profile.map[v].moid }
}

output "switch_profiles" {
  description = "Moid and Policies of the Domain Switch Profiles"
  value       = { for v in sort(keys(intersight_fabric_switch_profile.map)) : v => intersight_fabric_switch_profile.map[v].moid }
}
