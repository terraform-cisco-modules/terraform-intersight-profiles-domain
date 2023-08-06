#____________________________________________________________
#
# Collect the moid of the UCS Domain Cluster Profiles
#____________________________________________________________

output "domains" {
  description = "Moid of the Domain Cluster Profiles"
  value = {
    for v in sort(keys(intersight_fabric_switch_cluster_profile.map)) : v => intersight_fabric_switch_cluster_profile.map[v].moid
  }
}

output "switch_profiles" {
  description = "Moid and Policies of the Domain Switch Profiles"
  value = {
    for v in sort(keys(intersight_fabric_switch_profile.map)) : v => merge({ moid = intersight_fabric_switch_profile.map[v].moid
    }, local.switch_profiles[v])
  }
}
