locals {
  defaults = yamldecode(file("${path.module}/defaults.yaml"))
  ldomain  = local.defaults.profiles.domain
  name_prefix = [for v in [merge(lookup(local.profiles, "name_prefix", {}), local.defaults.profiles.name_prefix)] : {
    domain = v.domain != "" ? v.domain : v.default
  }][0]
  name_suffix = [for v in [merge(lookup(local.profiles, "name_suffix", {}), local.defaults.profiles.name_suffix)] : {
    domain = v.domain != "" ? v.domain : v.default
  }][0]
  orgs     = var.orgs
  profiles = var.profiles
  #policies       = var.policies
  data_search = {
    network_connectivity = data.intersight_search_search_item.network_connectivity
    ntp                  = data.intersight_search_search_item.ntp
    port                 = data.intersight_search_search_item.port
    snmp                 = data.intersight_search_search_item.snmp
    switch_control       = data.intersight_search_search_item.switch_control
    syslog               = data.intersight_search_search_item.syslog
    system_qos           = data.intersight_search_search_item.system_qos
    vlan                 = data.intersight_search_search_item.vlan
    vsan                 = data.intersight_search_search_item.vsan
  }
  network_connectivity = distinct(compact(concat(
    [for i in local.switch_profiles : i.network_connectivity_policy]
  )))
  ntp = distinct(compact(concat(
    [for i in local.switch_profiles : i.ntp_policy]
  )))
  port = distinct(compact(concat(
    flatten([for i in local.switch_profiles : i.port_policies])
  )))
  snmp = distinct(compact(concat(
    [for i in local.switch_profiles : i.snmp_policy]
  )))
  switch_control = distinct(compact(concat(
    [for i in local.switch_profiles : i.switch_control_policy]
  )))
  syslog = distinct(compact(concat(
    [for i in local.switch_profiles : i.syslog_policy]
  )))
  system_qos = distinct(compact(concat(
    [for i in local.switch_profiles : i.system_qos_policy]
  )))
  vlan = distinct(compact(concat(
    flatten([for i in local.switch_profiles : i.vlan_policies])
  )))
  vsan = distinct(compact(concat(
    flatten([for i in local.switch_profiles : i.vsan_policies])
  )))

  #_________________________________________________________________________________________
  #
  # Domain Profile
  #_________________________________________________________________________________________
  domain = flatten([
    for v in lookup(local.profiles, "domain", []) : {
      action      = lookup(v, "action", local.ldomain.action)
      description = lookup(v, "description", "")
      key         = v.name
      name        = "${local.name_prefix.domain}${v.name}${local.name_suffix.domain}"
      network_connectivity_policy = lookup(v, "network_connectivity_policy", "") != "" ? try(
        {
          name        = tostring(v.network_connectivity_policy)
          object_type = "networkconfig.Policy"
          org         = var.organization
          policy      = "network_connectivity"
        },
        merge(v.network_connectivity_policy, {
          object_type = "networkconfig.Policy"
          policy      = "network_connectivity"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      ntp_policy = lookup(v, "ntp_policy", "") != "" ? try(
        {
          name        = tostring(v.ntp_policy)
          object_type = "ntp.Policy"
          org         = var.organization
          policy      = "ntp"
        },
        merge(v.ntp_policy, {
          object_type = "ntp.Policy"
          policy      = "ntp"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      organization = var.organization
      port_policies = length(compact(lookup(v, "port_policies", []))) > 0 ? [
        for e in v.port_policies : try(
          {
            name        = tostring(e)
            object_type = "fabric.PortPolicy"
            org         = var.organization
            policy      = "port"
          },
          merge(e, {
            object_type = "fabric.PortPolicy"
            policy      = "port"
          }))] : [{
          name = "UNUSED"
          org  = "UNUSED"
      }]
      serial_numbers = lookup(v, "serial_numbers", [])
      snmp_policy = lookup(v, "snmp_policy", "") != "" ? try(
        {
          name        = tostring(v.snmp_policy)
          object_type = "snmp.Policy"
          org         = var.organization
          policy      = "snmp"
        },
        merge(v.snmp_policy, {
          object_type = "snmp.Policy"
          policy      = "snmp"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      switch_control_policy = lookup(v, "switch_control_policy", "") != "" ? try(
        {
          name        = tostring(v.switch_control_policy)
          object_type = "fabric.SwitchControlPolicy"
          org         = var.organization
          policy      = "switch_control"
        },
        merge(v.switch_control_policy, {
          object_type = "fabric.SwitchControlPolicy"
          policy      = "switch_control"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      syslog_policy = lookup(v, "syslog_policy", "") != "" ? try(
        {
          name        = tostring(v.syslog_policy)
          object_type = "syslog.Policy"
          org         = var.organization
          policy      = "syslog"
        },
        merge(v.syslog_policy, {
          object_type = "syslog.Policy"
          policy      = "syslog"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      system_qos_policy = lookup(v, "system_qos_policy", "") != "" ? try(
        {
          name        = tostring(v.system_qos_policy)
          object_type = "fabric.SystemQosPolicy"
          org         = var.organization
          policy      = "system_qos"
        },
        merge(v.system_qos_policy, {
          object_type = "fabric.SystemQosPolicy"
          policy      = "system_qos"
        })) : {
        name = "UNUSED"
        org  = "UNUSED"
      }
      tags = lookup(v, "tags", var.tags)
      vlan_policies = length(compact(lookup(v, "vlan_policies", []))) > 0 ? [
        for e in v.vlan_policies : try(
          {
            name        = tostring(e)
            object_type = "fabric.EthNetworkPolicy"
            org         = var.organization
            policy      = "vlan"
          },
          merge(e, {
            object_type = "fabric.EthNetworkPolicy"
            policy      = "vlan"
          }))] : [{
          name = "UNUSED"
          org  = "UNUSED"
      }]
      vsan_policies = length(compact(lookup(v, "vsan_policies", []))) > 0 ? [
        for e in v.vsan_policies : try(
          {
            name        = tostring(e)
            object_type = "fabric.FcNetworkPolicy"
            org         = var.organization
            policy      = "vsan"
          },
          merge(e, {
            object_type = "fabric.FcNetworkPolicy"
            policy      = "vsan"
          }))] : [{
          name = "UNUSED"
          org  = "UNUSED"
      }]
    }
  ])
  switch_profiles = { for i in flatten([
    for v in local.domain : [
      for s in [0, 1] : {
        action         = v.action
        description    = v.description
        domain_profile = v.key
        name           = s == 0 ? "${v.name}-A" : "${v.name}-B"
        network_connectivity_policy = length(regexall("UNUSED", v.network_connectivity_policy.name)
        ) == 0 ? v.network_connectivity_policy.name : ""
        ntp_policy   = length(regexall("UNUSED", v.ntp_policy.name)) == 0 ? v.ntp_policy.name : ""
        organization = v.organization
        policy_bucket = [
          for a in flatten([
            v.network_connectivity_policy,
            v.ntp_policy,
            length(compact([for e in v.port_policies : e.name])) == 2 ? element(
              v.port_policies, s) : element(v.port_policies, 0
            ),
            v.snmp_policy,
            v.switch_control_policy,
            v.syslog_policy,
            v.system_qos_policy,
            length(compact([for e in v.vlan_policies : e.name])) == 2 ? element(
              v.vlan_policies, s) : element(v.vlan_policies, 0
            ),
            length(compact([for e in v.vsan_policies : e.name])) == 2 ? element(
              v.vsan_policies, s) : element(v.vsan_policies, 0
            )
          ]) : a if a.name != "UNUSED"
        ]
        port_policies = distinct(compact([for e in v.port_policies : length(regexall("UNUSED", e.name)) == 0 ? e.name : ""]))
        serial_number = length(v.serial_numbers) == 2 ? element(v.serial_numbers, s) : element(v.serial_numbers, 0)
        snmp_policy   = length(regexall("UNUSED", v.snmp_policy.name)) == 0 ? v.snmp_policy.name : ""
        switch_control_policy = length(regexall("UNUSED", v.switch_control_policy.name)
        ) == 0 ? v.switch_control_policy.name : ""
        syslog_policy = length(regexall("UNUSED", v.syslog_policy.name)) == 0 ? v.syslog_policy.name : ""
        system_qos_policy = length(regexall("UNUSED", v.system_qos_policy.name)
        ) == 0 ? v.system_qos_policy.name : ""
        tags          = v.tags
        vlan_policies = distinct(compact([for e in v.vlan_policies : length(regexall("UNUSED", e.name)) == 0 ? e.name : ""]))
        vsan_policies = distinct(compact([for e in v.vsan_policies : length(regexall("UNUSED", e.name)) == 0 ? e.name : ""]))
      }
    ]
  ]) : i.name => i }
  domain_serial_numbers = compact(flatten([for v in local.switch_profiles : v.serial_number if length(regexall(
  "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", v.serial_number)) > 0]))

}