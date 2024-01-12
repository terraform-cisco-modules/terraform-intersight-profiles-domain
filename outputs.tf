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

output "z_moids_of_policies_that_were_referenced_in_the_domain_profile_but_not_already_created" {
  description = "moids of Pools that were referenced in server profiles but not defined"
  value = lookup(var.global_settings, "debugging", false) == true ? {
    network_connectivity = { for v in sort(keys(intersight_networkconfig_policy.data)) : v => intersight_networkconfig_policy.data[v].moid }
    ntp                  = { for v in sort(keys(intersight_ntp_policy.data)) : v => intersight_ntp_policy.data[v].moid }
    port                 = { for v in sort(keys(intersight_fabric_port_policy.data)) : v => intersight_fabric_port_policy.data[v].moid }
    snmp                 = { for v in sort(keys(intersight_snmp_policy.data)) : v => intersight_snmp_policy.data[v].moid }
    switch_control       = { for v in sort(keys(intersight_fabric_switch_control_policy.data)) : v => intersight_fabric_switch_control_policy.data[v].moid }
    syslog               = { for v in sort(keys(intersight_syslog_policy.data)) : v => intersight_syslog_policy.data[v].moid }
    system_qos           = { for v in sort(keys(intersight_fabric_system_qos_policy.data)) : v => intersight_fabric_system_qos_policy.data[v].moid }
    vlan                 = { for v in sort(keys(intersight_fabric_eth_network_policy.data)) : v => intersight_fabric_eth_network_policy.data[v].moid }
    vsan                 = { for v in sort(keys(intersight_fabric_fc_network_policy.data)) : v => intersight_fabric_fc_network_policy.data[v].moid }
  } : {}
}
