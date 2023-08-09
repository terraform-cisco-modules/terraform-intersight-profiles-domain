locals {
  #_________________________________________________________________________________________
  #
  # Local Functions
  #_________________________________________________________________________________________

  defaults       = yamldecode(file("${path.module}/defaults.yaml"))
  ldomain        = local.defaults.profiles.domain
  moids_policies = var.profiles.global_settings.moids_policies
  name_prefix = [for v in [merge(lookup(local.profiles, "name_prefix", {}), local.defaults.profiles.name_prefix)] : {
    domain = v.domain != "" ? v.domain : v.default
  }][0]
  name_suffix = [for v in [merge(lookup(local.profiles, "name_suffix", {}), local.defaults.profiles.name_suffix)] : {
    domain = v.domain != "" ? v.domain : v.default
  }][0]
  orgs     = var.profiles.orgs
  policies = var.profiles.policies
  profiles = var.profiles

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
  pb = merge(
    { for i in local.bucket.policies : trimsuffix(i, "_policy") => distinct(compact(
      [for e in local.switch_profiles : lookup(e, i, "UNUSED") if lookup(e, i, "UNUSED") != "UNUSED"]
    )) },
    { for i in local.bucket.dual_policies : trimsuffix(i, "_policies") => distinct(compact(
      flatten([for e in local.switch_profiles : lookup(e, i, "UNUSED") if lookup(e, i, "UNUSED") != "UNUSED"])
  )) })

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
  domain = {
    for v in lookup(local.profiles, "domain", []) : v.name => merge(local.ldomain, v, {
      name         = "${local.name_prefix.domain}${v.name}${local.name_suffix.domain}"
      organization = var.profiles.organization
      tags         = lookup(v, "tags", var.profiles.global_settings.tags)
    })
  }
  switch_profiles = { for i in flatten([
    for k, v in local.domain : [
      for s in [0, 1] : merge(v, {
        domain_profile = k
        name           = s == 0 ? "${v.name}-A" : "${v.name}-B"
        organization   = v.organization
        policy_bucket = merge({
          for e in local.bucket.policies : replace(local.bucket[e].object_type, ".", "") => {
            name        = lookup(v, e, "UNUSED")
            object_type = local.bucket[e].object_type
            org         = var.profiles.organization
            policy      = local.bucket[e].policy
          } if lookup(v, e, "UNUSED") != "UNUSED"
          },
          {
            for e in local.bucket.dual_policies : local.bucket[e].policy => {
              name = length(lookup(v, e, [])) == 2 ? element(lookup(v, e, []), s
              ) : length(lookup(v, e, [])) == 1 ? element(lookup(v, e, []), 0) : "UNUSED"
              object_type = local.bucket[e].object_type
              org         = var.profiles.organization
              policy      = local.bucket[e].policy
            }
        })
        serial_number = length(v.serial_numbers) == 2 ? element(v.serial_numbers, s) : element(v.serial_numbers, 0)
      })
    ]
  ]) : i.name => i }
  domain_serial_numbers = compact(flatten([for v in local.switch_profiles : v.serial_number if length(regexall(
  "^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", v.serial_number)) > 0]))
}