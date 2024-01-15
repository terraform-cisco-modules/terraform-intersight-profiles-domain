locals {
  #_________________________________________________________________________________________
  #
  # Local Functions
  #_________________________________________________________________________________________

  defaults = yamldecode(file("${path.module}/defaults.yaml"))
  global_settings = merge(var.global_settings, {
    ignore_domain_serials = lookup(var.global_settings, "ignore_domain_serials", false)
  })
  ldomain = local.defaults.profiles.domain
  name_prefix = { for org in sort(keys(var.model)) : org => merge(
    { for e in local.profile_names : e => lookup(lookup(var.model[org], "name_prefix", local.npfx), e, local.npfx[e]) },
    { organization = org })
  }
  name_suffix = { for org in sort(keys(var.model)) : org => merge(
    { for e in local.profile_names : e => lookup(lookup(var.model[org], "name_suffix", local.nsfx), e, local.nsfx[e]) },
    { organization = org })
  }
  npfx          = local.defaults.profiles.name_prefix
  nsfx          = local.defaults.profiles.name_suffix
  orgs          = var.orgs
  policies      = lookup(var.policies, "map", {})
  profile_names = ["domain"]

  data_sources = {
    network_connectivity = { for v in sort(keys(intersight_networkconfig_policy.data)) : v => intersight_networkconfig_policy.data[v].moid }
    ntp                  = { for v in sort(keys(intersight_ntp_policy.data)) : v => intersight_ntp_policy.data[v].moid }
    port                 = { for v in sort(keys(intersight_fabric_port_policy.data)) : v => intersight_fabric_port_policy.data[v].moid }
    snmp                 = { for v in sort(keys(intersight_snmp_policy.data)) : v => intersight_snmp_policy.data[v].moid }
    switch_control       = { for v in sort(keys(intersight_fabric_switch_control_policy.data)) : v => intersight_fabric_switch_control_policy.data[v].moid }
    syslog               = { for v in sort(keys(intersight_syslog_policy.data)) : v => intersight_syslog_policy.data[v].moid }
    system_qos           = { for v in sort(keys(intersight_fabric_system_qos_policy.data)) : v => intersight_fabric_system_qos_policy.data[v].moid }
    vlan                 = { for v in sort(keys(intersight_fabric_eth_network_policy.data)) : v => intersight_fabric_eth_network_policy.data[v].moid }
    vsan                 = { for v in sort(keys(intersight_fabric_fc_network_policy.data)) : v => intersight_fabric_fc_network_policy.data[v].moid }
  }
  pb = merge(
    { for i in local.bucket.policies : trimsuffix(i, "_policy") => setsubtract(distinct(compact(
      [for e in local.switch_profiles : [lookup(e, i, "UNUSED") != "UNUSED" ? length(regexall("/", e[i])) > 0 ? e[i] : "${e.organization}/${e[i]}" : "UNUSED"][0]]
    )), ["UNUSED"]) },
    { for i in local.bucket.dual_policies : trimsuffix(i, "_policies") => setsubtract(distinct(compact(
      flatten([for e in local.switch_profiles : [
        for d in range(length(lookup(e, i, []))) : [d != "UNUSED" ? length(regexall("/", e[i][d])) > 0 ? e[i][d] : "${e.organization}/${e[i][d]}" : "UNUSED"][0]
      ]])
  )), ["UNUSED"]) })

  #_________________________________________________________________________________________
  #
  # Policy Bucket Settings
  #_________________________________________________________________________________________

  bucket = {
    network_connectivity_policy = { object_type = "networkconfig.Policy", policy = "network_connectivity", }
    ntp_policy                  = { object_type = "ntp.Policy", policy = "ntp", }
    port_policies               = { object_type = "fabric.PortPolicy", policy = "port", }
    dual_policies = [
      "port_policies",
      "vlan_policies",
      "vsan_policies",
    ]
    policies = [
      "network_connectivity_policy",
      "ntp_policy",
      "snmp_policy",
      "switch_control_policy",
      "syslog_policy",
      "system_qos_policy",
    ]
    snmp_policy           = { object_type = "snmp.Policy", policy = "snmp", }
    switch_control_policy = { object_type = "fabric.SwitchControlPolicy", policy = "switch_control", }
    syslog_policy         = { object_type = "syslog.Policy", policy = "syslog", }
    system_qos_policy     = { object_type = "fabric.SystemQosPolicy", policy = "system_qos", }
    uuid_pool             = { object_type = "uuidpool.Pool", policy = "uuid", }
    vlan_policies         = { object_type = "fabric.EthNetworkPolicy", policy = "vlan", }
    vsan_policies         = { object_type = "fabric.FcNetworkPolicy", policy = "vsan", }
  }

  #_________________________________________________________________________________________
  #
  # Domain Profiles
  #_________________________________________________________________________________________
  domain = { for d in flatten([for org in sort(keys(var.model)) : [
    for v in lookup(lookup(var.model[org], "profiles", {}), "domain", []) : merge(local.ldomain, v, {
      key          = v.name
      name         = "${local.name_prefix[org].domain}${v.name}${local.name_suffix[org].domain}"
      organization = org
      tags         = lookup(v, "tags", local.global_settings.tags)
    })
  ] if length(lookup(lookup(var.model[org], "profiles", {}), "domain", [])) > 0]) : "${d.organization}/${d.key}" => d }
  switch_profiles = { for i in flatten([
    for k, v in local.domain : [
      for s in [0, 1] : merge(v, {
        domain_profile = k
        name           = s == 0 ? "${v.name}-A" : "${v.name}-B"
        organization   = v.organization
        policy_bucket = merge({
          for e in local.bucket.policies : replace(local.bucket[e].object_type, ".", "") => {
            name        = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 1) : lookup(v, e, "UNUSED")
            object_type = local.bucket[e].object_type
            org         = length(regexall("/", lookup(v, e, "UNUSED"))) > 0 ? element(split("/", v[e]), 0) : v.organization
            policy      = local.bucket[e].policy
          } if lookup(v, e, "UNUSED") != "UNUSED"
          }, {
          for e in local.bucket.dual_policies : local.bucket[e].policy => {
            name = length(
              lookup(v, e, [])) > 1 ? [length(regexall("/", v[e][s])) > 0 ? element(split("/", v[e][s]), 1) : v[e][s]][0] : length(
              lookup(v, e, [])) > 0 ? [length(regexall("/", v[e][0])) > 0 ? element(split("/", v[e][0]), 1) : v[e][0]][0
            ] : "UNUSED"
            object_type = local.bucket[e].object_type
            org = length(
              lookup(v, e, [])) > 1 ? [length(regexall("/", v[e][s])) > 0 ? element(split("/", v[e][s]), 0) : v.organization][0] : length(
              lookup(v, e, [])) > 0 ? [length(regexall("/", v[e][0])) > 0 ? element(split("/", v[e][0]), 0) : v.organization][0
            ] : v.organization
            policy = local.bucket[e].policy
          }
        })
        serial_number = length(lookup(v, "serial_numbers", [])) == 2 ? element(v.serial_numbers, s) : length(lookup(v, "serial_numbers", [])
        ) == 1 ? element(v.serial_numbers, 0) : "unknown"
      })
    ]
  ]) : "${i.organization}/${i.key}" => i }
  domain_serial_numbers = compact(flatten([for v in local.switch_profiles : v.serial_number if length(regexall(
  "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", v.serial_number)) > 0]))
}