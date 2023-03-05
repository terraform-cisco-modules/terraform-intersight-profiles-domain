#____________________________________________________________
#
# Moid Data Source
#____________________________________________________________

#data "intersight_search_search_item" "network_connectivity" {
#  for_each = { for v in [0] : v => v if length(local.network_connectivity) > 0 }
#  additional_properties = jsonencode({ "ClassId" = "networkconfig.Policy' and Name in ('${
#    trim(join("', '", local.network_connectivity), ", '")}') and ObjectType eq 'networkconfig.Policy"
#  })
#}
#
#data "intersight_search_search_item" "ntp" {
#  for_each = { for v in [0] : v => v if length(local.ntp) > 0 }
#  additional_properties = jsonencode({ "ClassId" = "ntp.Policy' and Name in ('${
#    trim(join("', '", local.ntp), ", '")}') and ObjectType eq 'ntp.Policy"
#  })
#}
#
#data "intersight_search_search_item" "port" {
#  for_each = { for v in [0] : v => v if length(local.port) > 0 }
#  additional_properties = jsonencode({ "ClassId" = "fabric.PortPolicy' and Name in ('${
#    trim(join("', '", local.port), ", '")}') and ObjectType eq 'fabric.PortPolicy"
#  })
#}
#
#data "intersight_search_search_item" "snmp" {
#  for_each = { for v in [0] : v => v if length(local.snmp) > 0 }
#  additional_properties = jsonencode({ "ClassId" = "snmp.Policy' and Name in ('${
#    trim(join("', '", local.snmp), ", '")}') and ObjectType eq 'snmp.Policy"
#  })
#}
#
#data "intersight_search_search_item" "switch_control" {
#  for_each = { for v in [0] : v => v if length(local.switch_control) > 0 }
#  additional_properties = jsonencode({ "ClassId" = "fabric.SwitchControlPolicy' and Name in ('${
#    trim(join("', '", local.switch_control), ", '")}') and ObjectType eq 'fabric.SwitchControlPolicy"
#  })
#}
#
#data "intersight_search_search_item" "syslog" {
#  for_each = { for v in [0] : v => v if length(local.syslog) > 0 }
#  additional_properties = jsonencode({ "ClassId" = "syslog.Policy' and Name in ('${
#    trim(join("', '", local.syslog), ", '")}') and ObjectType eq 'syslog.Policy"
#  })
#}
#
#data "intersight_search_search_item" "system_qos" {
#  for_each = { for v in [0] : v => v if length(local.system_qos) > 0 }
#  additional_properties = jsonencode({ "ClassId" = "fabric.SystemQosPolicy' and Name in ('${
#    trim(join("', '", local.system_qos), ", '")}') and ObjectType eq 'fabric.SystemQosPolicy"
#  })
#}
#
#data "intersight_search_search_item" "vlan" {
#  for_each = { for v in [0] : v => v if length(local.vlan) > 0 }
#  additional_properties = jsonencode({ "ClassId" = "fabric.EthNetworkPolicy' and Name in ('${
#    trim(join("', '", local.vlan), ", '")}') and ObjectType eq 'fabric.EthNetworkPolicy"
#  })
#}
#
#data "intersight_search_search_item" "vsan" {
#  for_each = { for v in [0] : v => v if length(local.vsan) > 0 }
#  additional_properties = jsonencode({ "ClassId" = "fabric.FcNetworkPolicy' and Name in ('${
#    trim(join("', '", local.vsan), ", '")}') and ObjectType eq 'fabric.FcNetworkPolicy"
#  })
#}
#