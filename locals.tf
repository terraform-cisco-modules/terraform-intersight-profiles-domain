locals {
  defaults    = var.defaults.domain
  name_prefix = var.defaults.name_prefix
  orgs        = var.orgs
  profiles    = var.profiles
  #policies       = var.policies
  #data_policies = var.moids == false ? {
  #  network_connectivity = distinct(compact(concat(
  #    [for i in lookup(local.profiles, "domain", []) : lookup(i, "network_connectivity_policy", "")]
  #  )))
  #  ntp = distinct(compact(concat(
  #    [for i in lookup(local.profiles, "domain", []) : lookup(i, "ntp_policy", "")]
  #  )))
  #  port = distinct(compact(concat(
  #    [for i in lookup(local.profiles, "domain", []) : lookup(i, "port_policies", [])]
  #  )))
  #  snmp = distinct(compact(concat(
  #    [for i in lookup(local.profiles, "domain", []) : lookup(i, "snmp_policy", "")]
  #  )))
  #  switch_control = distinct(compact(concat(
  #    [for i in lookup(local.profiles, "domain", []) : lookup(i, "switch_control_policy", "")]
  #  )))
  #  syslog = distinct(compact(concat(
  #    [for i in lookup(local.profiles, "domain", []) : lookup(i, "syslog_policy", "")]
  #  )))
  #  system_qos = distinct(compact(concat(
  #    [for i in lookup(local.profiles, "domain", []) : lookup(i, "system_qos_policy", "")]
  #  )))
  #  vlan = distinct(compact(concat(
  #    [for i in lookup(local.profiles, "domain", []) : lookup(i, "vlan_policies", [])]
  #  )))
  #  vsan = distinct(compact(concat(
  #    [for i in lookup(local.profiles, "domain", []) : lookup(i, "vsan_policies", [])]
  #  )))
  #} : {}

  domain = flatten([
    for v in lookup(local.profiles, "domain", []) : {
      action               = lookup(v, "action", local.defaults.action)
      description          = lookup(v, "description", "")
      name                 = "${local.name_prefix}${v.name}${local.defaults.name_suffix}"
      network_connectivity = lookup(v, "network_connectivity_policy", "")
      network_connectivity_policy = length(compact([lookup(v, "network_connectivity_policy", "")])) > 0 ? {
        name        = v.network_connectivity_policy
        object_type = "networkconfig.Policy"
        policy      = "network_connectivity"
      } : null
      ntp = lookup(v, "ntp_policy", "")
      ntp_policy = length(compact([v.ntp_policy])) > 0 ? {
        name        = v.ntp_policy
        object_type = "ntp.Policy"
        policy      = "ntp"
      } : null
      organization = lookup(v, "organization", var.organization)
      port         = lookup(v, "port_policies", [])
      port_policies = length(compact(lookup(v, "port_policies", []))) > 0 ? [
        for i in lookup(v, "port_policies", []) : {
          name        = i
          object_type = "fabric.PortPolicy"
          policy      = "port"
        }
      ] : null
      serial_numbers = v.serial_numbers
      snmp           = lookup(v, "snmp_policy", "")
      snmp_policy = length(compact([lookup(v, "snmp_policy", "")])) > 0 ? {
        name        = v.snmp_policy
        object_type = "snmp.Policy"
        policy      = "snmp"
      } : null
      switch_control = lookup(v, "switch_control_policy", "")
      switch_control_policy = length(compact([lookup(v, "switch_control_policy", "")])) > 0 ? {
        name        = v.switch_control_policy
        object_type = "fabric.SwitchControlPolicy"
        policy      = "switch_control"
      } : null
      syslog = lookup(v, "syslog_policy", "")
      syslog_policy = length(compact([v.syslog_policy])) > 0 ? {
        name        = v.syslog_policy
        object_type = "syslog.Policy"
        policy      = "syslog"
      } : null
      system_qos = lookup(v, "system_qos_policy", "")
      system_qos_policy = length(compact([v.system_qos_policy])) > 0 ? {
        name        = v.system_qos_policy
        object_type = "fabric.SystemQosPolicy"
        policy      = "system_qos"
      } : null
      vlan = lookup(v, "vlan_policies", [])
      vlan_policies = length(compact(lookup(v, "vlan_policies", []))) > 0 ? [
        for i in lookup(v, "vlan_policies", []) : {
          name        = i
          object_type = "fabric.EthNetworkPolicy"
          policy      = "vlan"
        }
      ] : null
      vsan = lookup(v, "vsan_policies", [])
      vsan_policies = length(compact(lookup(v, "vsan_policies", []))) > 0 ? [
        for i in lookup(v, "vsan_policies", []) : {
          name        = i
          object_type = "fabric.FcNetworkPolicy"
          policy      = "vsan"
        }
      ] : null
      tags = lookup(v, "tags", var.tags)
    }
  ])
  switch_profiles = { for i in flatten([
    for v in local.domain : [
      for s in [0, 1] : {
        action               = v.action
        description          = v.description
        domain_profile       = v.name
        name                 = s == 0 ? "${v.name}-A" : "${v.name}-B"
        network_connectivity = v.network_connectivity
        ntp                  = v.ntp
        organization         = v.organization
        policy_bucket = [
          for a in flatten(
            [
              v.network_connectivity_policy,
              v.ntp_policy,
              length(v.port) == 2 ? element(v.port_policies, s) : element(v.port_policies, 0),
              v.snmp_policy,
              v.switch_control_policy,
              v.syslog_policy,
              v.system_qos_policy,
              length(v.vlan) == 2 ? element(v.vlan_policies, s) : element(v.vlan_policies, 0),
              length(v.vsan) == 2 ? element(v.vsan_policies, s) : element(v.vsan_policies, 0)
            ]
          ) : a if a != null
        ]
        port           = length(v.port) == 2 ? element(v.port, s) : element(v.port, 0)
        serial_number  = element(v.serial_numbers, s)
        snmp           = v.snmp
        switch_control = v.switch_control
        syslog         = v.syslog
        system_qos     = v.system_qos
        tags           = v.tags
        vlan           = length(v.vlan) == 2 ? element(v.vlan, s) : element(v.vlan, 0)
        vsan           = length(v.vsan) == 2 ? element(v.vsan, s) : element(v.vsan, 0)
      }
    ]
  ]) : i.name => i }
  domain_serial_numbers = compact(
    [for v in local.switch_profiles : v.serial_number if length(regexall(
      "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][1-3])[\\dA-Z]{4}$", v.serial_number)
    ) > 0]
  )

}
