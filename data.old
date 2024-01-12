#____________________________________________________________
#
# Moid Data Source
#____________________________________________________________

data "intersight_search_search_item" "network_connectivity" {
  for_each              = { for v in [0] : v => v if length(local.pb.network_connectivity) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "networkconfig.Policy" })
}

data "intersight_search_search_item" "ntp" {
  for_each              = { for v in [0] : v => v if length(local.pb.ntp) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "ntp.Policy" })
}

data "intersight_search_search_item" "port" {
  for_each              = { for v in [0] : v => v if length(local.pb.port) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "fabric.PortPolicy" })
}

data "intersight_search_search_item" "snmp" {
  for_each              = { for v in [0] : v => v if length(local.pb.snmp) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "snmp.Policy" })
}

data "intersight_search_search_item" "switch_control" {
  for_each              = { for v in [0] : v => v if length(local.pb.switch_control) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "fabric.SwitchControlPolicy" })
}

data "intersight_search_search_item" "syslog" {
  for_each              = { for v in [0] : v => v if length(local.pb.syslog) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "syslog.Policy" })
}

data "intersight_search_search_item" "system_qos" {
  for_each              = { for v in [0] : v => v if length(local.pb.system_qos) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "fabric.SystemQosPolicy" })
}

data "intersight_search_search_item" "vlan" {
  for_each              = { for v in [0] : v => v if length(local.pb.vlan) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "fabric.EthNetworkPolicy" })
}

data "intersight_search_search_item" "vsan" {
  for_each              = { for v in [0] : v => v if length(local.pb.vsan) > 0 && local.moids_policies == true }
  additional_properties = jsonencode({ "ObjectType" = "fabric.FcNetworkPolicy" })
}
