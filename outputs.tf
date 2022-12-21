#____________________________________________________________
#
# Collect the moid of the UCS Domain Cluster Profiles
#____________________________________________________________

output "domains" {
  description = "Moid of the Domain Cluster Profiles"
  value = {
    for v in sort(keys(intersight_fabric_switch_cluster_profile.domain_profile)
    ) : v => intersight_fabric_switch_cluster_profile.domain_profile[v].moid
  }
}

output "switch_profiles" {
  description = "Moid and Policies of the Domain Switch Profiles"
  value = {
    for v in sort(keys(intersight_fabric_switch_profile.switch_profiles)) : v => merge({
      moid = intersight_fabric_switch_profile.switch_profiles[v].moid
    }, local.switch_profiles[v])
  }
}
