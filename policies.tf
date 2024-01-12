resource "intersight_fabric_eth_network_policy" "data" {
  for_each = { for v in local.pb.vlan : v => v if contains(lookup(lookup(local.policies, "locals", {}), "vlan", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_fabric_fc_network_policy" "data" {
  for_each = { for v in local.pb.vsan : v => v if contains(lookup(lookup(local.policies, "locals", {}), "vsan", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_fabric_port_policy" "data" {
  for_each = { for v in local.pb.port : v => v if contains(lookup(lookup(local.policies, "locals", {}), "port", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_fabric_switch_control_policy" "data" {
  for_each = { for v in local.pb.switch_control : v => v if contains(lookup(lookup(local.policies, "locals", {}), "switch_control", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_fabric_system_qos_policy" "data" {
  for_each = { for v in local.pb.system_qos : v => v if contains(lookup(lookup(local.policies, "locals", {}), "system_qos", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_networkconfig_policy" "data" {
  for_each = { for v in local.pb.network_connectivity : v => v if contains(lookup(lookup(local.policies, "locals", {}), "network_connectivity", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_ntp_policy" "data" {
  for_each = { for v in local.pb.ntp : v => v if contains(lookup(lookup(local.policies, "locals", {}), "ntp", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_snmp_policy" "data" {
  for_each = { for v in local.pb.snmp : v => v if contains(lookup(lookup(local.policies, "locals", {}), "snmp", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}

resource "intersight_syslog_policy" "data" {
  for_each = { for v in local.pb.syslog : v => v if contains(lookup(lookup(local.policies, "locals", {}), "syslog", []), v) == false }
  name     = element(split("/", each.value), 1)
  organization {
    moid = local.orgs[element(split("/", each.value), 0)]
  }
  lifecycle {
    ignore_changes  = all
    prevent_destroy = true
  }
}
