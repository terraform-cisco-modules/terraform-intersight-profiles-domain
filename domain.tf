#____________________________________________________________
#
# Intersight UCS Domain Profile Resource
# GUI Location: Profiles > UCS Domain Profile > Create
#____________________________________________________________

data "intersight_network_element_summary" "fis" {
  for_each = { for s in local.domain_serial_numbers : s => s }
  serial   = each.value
}

resource "intersight_fabric_switch_cluster_profile" "map" {
  for_each    = { for k, v in local.domain : k => v }
  description = lookup(each.value, "description", "${each.value.name} Domain Profile.")
  name        = each.value.name
  type        = "instance"
  organization {
    moid        = var.orgs[each.value.organization]
    object_type = "organization.Organization"
  }
  dynamic "tags" {
    for_each = { for v in each.value.tags : v.key => v }
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}


resource "intersight_fabric_switch_profile" "map" {
  depends_on = [
    data.intersight_network_element_summary.fis,
    intersight_fabric_switch_cluster_profile.map
  ]
  for_each = local.switch_profiles
  dynamic "assigned_switch" {
    for_each = { for v in compact([each.value.serial_number]) : v => v if each.value.serial_number != "unknown" }
    content {
      moid = data.intersight_network_element_summary.fis[each.value.serial_number].results[0].moid
    }
  }
  description = lookup(each.value, "description", "${each.value.name} Switch Profile.")
  lifecycle {
    ignore_changes = [
      action,
      additional_properties,
      mod_time,
      wait_for_completion
    ]
  }
  name = each.value.name
  # the following policy_bucket statements map different policies to this
  # template -- the object_type shows the policy type
  dynamic "policy_bucket" {
    for_each = { for k, v in each.value.policy_bucket : v.object_type => v }
    content {
      moid = contains(keys(lookup(local.policies, policy_bucket.value.policy, {})), "${policy_bucket.value.org}/${policy_bucket.value.name}"
        ) == true ? local.policies[policy_bucket.value.policy]["${policy_bucket.value.org}/${policy_bucket.value.name}"
        ] : [for i in data.intersight_search_search_item.policies[policy_bucket.value.policy
          ].results : i.moid if jsondecode(i.additional_properties).Name == policy_bucket.value.name && jsondecode(i.additional_properties
      ).Organization.Moid == var.orgs[policy_bucket.value.org]][0]
      object_type = policy_bucket.value.object_type
    }
  }
  switch_cluster_profile {
    moid = intersight_fabric_switch_cluster_profile.map[each.value.domain_profile].moid
  }
  type = "instance"
  dynamic "tags" {
    for_each = each.value.tags
    content {
      key   = tags.value.key
      value = tags.value.value
    }
  }
}
