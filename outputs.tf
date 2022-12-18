#____________________________________________________________
#
# Collect the moid of the UCS Domain Cluster Profiles
#____________________________________________________________

output "domains" {
  value = {
    for v in sort(keys(intersight_fabric_switch_profile.switch_profiles)) : v => merge({
      moid = intersight_fabric_switch_profile.switch_profiles[v].moid
    }, local.switch_profiles[v])

  }
}

#output "domains" {
#  description = "UCS Domain Cluster Profile Managed Object ID (moid)."
#  value = {
#    for v in sort(keys(intersight_fabric_switch_cluster_profile.domain_profile)) : v => {
#      name = intersight_fabric_switch_cluster_profile.domain_profile[v].name
#      moid = intersight_fabric_switch_cluster_profile.domain_profile[v].moid
#      A = intersight_fabric_switch_profile.switch_profiles["${v}-A"].moid
#      B = intersight_fabric_switch_profile.switch_profiles["${v}-B"].moid
#    }
#  }
#}

output "switch_profiles" {
  value = {
    for v in sort(keys(intersight_fabric_switch_profile.switch_profiles)
      ) : v => intersight_fabric_switch_profile.switch_profiles[v
    ].moid if local.switch_profiles[v].serial_number != "unknown"
  }
}
