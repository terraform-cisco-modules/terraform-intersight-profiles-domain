#____________________________________________________________
#
# Moid Data Source
#____________________________________________________________

data "intersight_search_search_item" "network_connectivity" {
  for_each              = { for v in [0] : v => v if length(local.network_connectivity) > 0 && var.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "networkconfig.Policy" })
}

data "intersight_search_search_item" "ntp" {
  for_each              = { for v in [0] : v => v if length(local.ntp) > 0 && var.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "ntp.Policy" })
}

data "intersight_search_search_item" "port" {
  for_each              = { for v in [0] : v => v if length(local.port) > 0 && var.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "fabric.PortPolicy" })
}

data "intersight_search_search_item" "snmp" {
  for_each              = { for v in [0] : v => v if length(local.snmp) > 0 && var.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "snmp.Policy" })
}

data "intersight_search_search_item" "switch" {
  for_each              = { for v in [0] : v => v if length(local.switch_control) > 0 && var.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "fabric.SwitchControlPolicy" })
}

data "intersight_search_search_item" "syslog" {
  for_each              = { for v in [0] : v => v if length(local.syslog) > 0 && var.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "syslog.Policy" })
}

data "intersight_search_search_item" "system" {
  for_each              = { for v in [0] : v => v if length(local.system_qos) > 0 && var.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "fabric.SystemQosPolicy" })
}

data "intersight_search_search_item" "vlan" {
  for_each              = { for v in [0] : v => v if length(local.vlan) > 0 && var.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "fabric.EthNetworkPolicy" })
}

data "intersight_search_search_item" "vsan" {
  for_each              = { for v in [0] : v => v if length(local.vsan) > 0 && var.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "fabric.FcNetworkPolicy" })
}
