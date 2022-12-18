#____________________________________________________________
#
# Moid Data Source
#____________________________________________________________

data "intersight_organization_organization" "orgs" {
  for_each = {
    for v in local.organizations : v => v if var.moids == false
  }
  name = each.value
}

#data "intersight_networkconfig_policy" "network_connectivity" {
#  for_each = {
#    for v in local.data_policies : v.name => v if var.moids == false && v.object_type == "networkconfig.Policy"
#  }
#  name = each.value.name
#}
#
#data "intersight_ntp_policy" "ntp" {
#  for_each = {
#    for v in local.data_policies : v.name => v if var.moids == false && v.object_type == "ntp.Policy"
#  }
#  name = each.value.name
#}
#
#data "intersight_fabric_port_policy" "port" {
#  for_each = {
#    for v in local.data_policies : v.name => v if var.moids == false && v.object_type == "fabric.PortPolicy"
#  }
#  name = each.value.name
#}
#
#data "intersight_snmp_policy" "snmp" {
#  for_each = {
#    for v in local.data_policies : v.name => v if var.moids == false && v.object_type == "snmp.Policy"
#  }
#  name = each.value.name
#}
#
#data "intersight_fabric_switch_control_policy" "switch_control" {
#  for_each = {
#    for v in local.data_policies : v.name => v if var.moids == false && v.object_type == "fabric.SwitchControlPolicy"
#  }
#  name = each.value.name
#}
#
#data "intersight_syslog_policy" "syslog" {
#  for_each = {
#    for v in local.data_policies : v.name => v if var.moids == false && v.object_type == "syslog.Policy"
#  }
#  name = each.value.name
#}
#
#data "intersight_fabric_system_qos_policy" "system_qos" {
#  for_each = {
#    for v in local.data_policies : v.name => v if var.moids == false && v.object_type == "fabric.SystemQosPolicy"
#  }
#  name = each.value.name
#}
#
#data "intersight_fabric_eth_network_policy" "vlan" {
#  for_each = {
#    for v in local.data_policies : v.name => v if var.moids == false && v.object_type == "fabric.EthNetworkPolicy"
#  }
#  name = each.value.name
#}
#
#data "intersight_fabric_fc_network_policy" "vsan" {
#  for_each = {
#    for v in local.data_policies : v.name => v if var.moids == false && v.object_type == "fabric.FcNetworkPolicy"
#  }
#  name = each.value.name
#}
