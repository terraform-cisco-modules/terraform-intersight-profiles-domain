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
    moid        = local.orgs[each.value.organization]
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
    for_each = { for v in compact([each.value.serial_number]) : v => v if length(
        regexall("^[A-Z]{3}[2-3][\\d]([0][1-9]|[1-4][0-9]|[5][0-3])[\\dA-Z]{4}$", each.value.serial_number)
      ) > 0}
    content {
      moid = data.intersight_network_element_summary.fis[each.value.serial_number].results[0].moid
    }
  }
  # the following policy_bucket statements map different policies to this
  # template -- the object_type shows the policy type
  #dynamic "policy_bucket" {
  #  for_each = { for v in each.value.policy_bucket : v.object_type => v }
  #  content {
  #    moid = length(regexall(false, var.moids_policies)) > 0 && length(regexall(
  #      policy_bucket.value.org, each.value.organization)) > 0 ? var.policies[policy_bucket.value.org][
  #      policy_bucket.value.policy][policy_bucket.value.name] : [for i in local.data_search[
  #        policy_bucket.value.policy][0].results : i.moid if jsondecode(i.additional_properties
  #        ).Organization.Moid == local.orgs[policy_bucket.value.org] && jsondecode(i.additional_properties
  #    ).Name == policy_bucket.value.name][0]
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
