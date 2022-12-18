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

output "depoy_switch_profiles" {
  value = {
    for v in sort(keys(intersight_fabric_switch_profile.switch_profiles)
      ) : v => intersight_fabric_switch_profile.switch_profiles[v].moid if length(regexall(
      "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][1-3])[\\dA-Z]{4}$", local.switch_profiles[v].serial_number)
    ) > 0 && local.switch_profiles[v].action == "Deploy"
  }
}
