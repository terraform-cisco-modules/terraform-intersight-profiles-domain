data "intersight_network_element_summary" "fis" {
  for_each = { for s in local.domain_serial_numbers : s => s }
  serial   = each.value
}


#____________________________________________________________
#
# Intersight UCS Domain Cluster Profile Resource
# GUI Location: Profiles > UCS Domain Profile > Create
#____________________________________________________________

resource "intersight_fabric_switch_cluster_profile" "domain_profile" {
  for_each    = { for v in local.domain : v.name => v }
  description = lookup(each.value, "description", "${each.value.name} Domain Profile.")
  name        = each.value.name
  type        = "instance"
  organization {
    moid = length(regexall(true, var.moids)
      ) > 0 ? local.orgs[each.value.organization
    ] : data.intersight_organization_organization.orgs[each.value.organization].results[0].moid
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


#____________________________________________________________
#
# Intersight UCS Domain Profile - Switch Resource
# GUI Location: Profiles > UCS Domain Profile > Create
#____________________________________________________________

resource "intersight_fabric_switch_profile" "switch_profiles" {
  depends_on = [
    data.intersight_network_element_summary.fis,
    intersight_fabric_switch_cluster_profile.domain_profile
  ]
  for_each    = local.switch_profiles
  description = lookup(each.value, "description", "${each.value.name} Switch Profile.")
  name        = each.value.name
  type        = "instance"
  lifecycle {
    ignore_changes = [
      action,
      additional_properties,
      mod_time,
      wait_for_completion
    ]
  }
  switch_cluster_profile {
    moid = intersight_fabric_switch_cluster_profile.domain_profile[each.value.domain_profile].moid
  }
  dynamic "assigned_switch" {
    for_each = { for v in compact([each.value.serial_number]) : v => v if each.value.serial_number != "unknown" }
    content {
      moid = data.intersight_network_element_summary.fis[each.value.serial_number].results[0].moid
    }
  }
  #dynamic "policy_bucket" {
  #  for_each = { for v in each.value.policy_bucket : v.object_type => v }
  #  content {
  #    moid = length(regexall(true, var.moids)
  #      ) > 0 ? var.policies[policy_bucket.value.policy][policy_bucket.value.name
  #      ] : length(regexall("networkconfig.Policy", policy_bucket.value.object_type)
  #      ) > 0 ? [for i in data.intersight_networkconfig_policy.network_connectivity[
  #        policy_bucket.value.name
  #      ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
  #      ][0] : length(regexall("ntp.Policy", policy_bucket.value.object_type)
  #      ) > 0 ? [for i in data.intersight_ntp_policy.ntp[policy_bucket.value.name
  #      ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
  #      ][0] : length(regexall("fabric.PortPolicy", policy_bucket.value.object_type)
  #      ) > 0 ? [for i in data.intersight_fabric_port_policy.port[policy_bucket.value.name
  #      ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
  #      ][0] : length(regexall("snmp.Policy", policy_bucket.value.object_type)
  #      ) > 0 ? [for i in data.intersight_snmp_policy.snmp[policy_bucket.value.name
  #      ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
  #      ][0] : length(regexall("fabric.SwitchControlPolicy", policy_bucket.value.object_type)
  #      ) > 0 ? [for i in data.intersight_fabric_switch_control_policy.switch_control[policy_bucket.value.name
  #      ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
  #      ][0] : length(regexall("syslog.Policy", policy_bucket.value.object_type)
  #      ) > 0 ? [for i in data.intersight_syslog_policy.syslog[policy_bucket.value.name
  #      ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
  #      ][0] : length(regexall("fabric.SystemQosPolicy", policy_bucket.value.object_type)
  #      ) > 0 ? [for i in data.intersight_fabric_system_qos_policy.system_qos[policy_bucket.value.name
  #      ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
  #      ][0] : length(regexall("fabric.EthNetworkPolicy", policy_bucket.value.object_type)
  #      ) > 0 ? [for i in data.intersight_fabric_eth_network_policy.vlan[policy_bucket.value.name
  #      ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
  #      ][0] : length(regexall("fabric.FcNetworkPolicy", policy_bucket.value.object_type)
  #      ) > 0 ? [for i in data.intersight_fabric_fc_network_policy.vsan[policy_bucket.value.name
  #      ].results : i.moid if i.organization[0].moid == local.orgs[each.value.organization]
  #    ][0] : ""
  #    object_type = policy_bucket.value.object_type
  #  }
  #}
  dynamic "tags" {
    for_each = var.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
