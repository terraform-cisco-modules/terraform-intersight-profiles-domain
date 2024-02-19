#__________________________________________________________________
#
# Data Objects - Pools and Policies
#__________________________________________________________________

data "intersight_search_search_item" "policies" {
  for_each = { for v in local.policy_types : v => v if length(local.data_policies[v]) > 0 }
  additional_properties = length(regexall("port|vlan|vsan", each.key)) > 0 ? jsonencode(
    { "ClassId" = "${local.bucket["${each.key}_policies"].object_type}' and Name in ('${trim(join("', '", local.data_policies[each.key]), ", '")
    }') and ObjectType eq '${local.bucket["${each.key}_policies"].object_type}" }) : jsonencode(
    { "ClassId" = "${local.bucket["${each.key}_policy"].object_type}' and Name in ('${trim(join("', '", local.data_policies[each.key]), ", '")
    }') and ObjectType eq '${local.bucket["${each.key}_policy"].object_type}" }
  )
}
