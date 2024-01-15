<!-- BEGIN_TF_DOCS -->
[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](https://www.gnu.org/licenses/gpl-3.0)
[![Developed by: Cisco](https://img.shields.io/badge/Developed%20by-Cisco-blue)](https://developer.cisco.com)

# Terraform Intersight - Domain Profiles Module

A Terraform module to configure Intersight Infrastructure Domain Profiles.

### NOTE: THIS MODULE IS DESIGNED TO BE CONSUMED USING "EASY IMM"

### A comprehensive example using this module is available below:

## [Easy IMM](https://github.com/terraform-cisco-modules/easy-imm)

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >=1.3.0 |
| <a name="requirement_intersight"></a> [intersight](#requirement\_intersight) | >=1.0.44 |
## Providers

| Name | Version |
|------|---------|
| <a name="provider_intersight"></a> [intersight](#provider\_intersight) | 1.0.44 |
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_global_settings"></a> [global\_settings](#input\_global\_settings) | YAML to HCL Data - global\_settings. | `any` | n/a | yes |
| <a name="input_model"></a> [model](#input\_model) | YAML to HCL Data - model. | `any` | n/a | yes |
| <a name="input_orgs"></a> [orgs](#input\_orgs) | Intersight Organizations Moid Data. | `any` | n/a | yes |
| <a name="input_policies"></a> [policies](#input\_policies) | Policies - Module Output. | `any` | n/a | yes |
## Outputs

| Name | Description |
|------|-------------|
| <a name="output_domains"></a> [domains](#output\_domains) | Moid of the Domain Cluster Profiles |
| <a name="output_switch_profiles"></a> [switch\_profiles](#output\_switch\_profiles) | Moid and Policies of the Domain Switch Profiles |
| <a name="output_z_moids_of_policies_that_were_referenced_in_the_domain_profile_but_not_already_created"></a> [z\_moids\_of\_policies\_that\_were\_referenced\_in\_the\_domain\_profile\_but\_not\_already\_created](#output\_z\_moids\_of\_policies\_that\_were\_referenced\_in\_the\_domain\_profile\_but\_not\_already\_created) | moids of Pools that were referenced in server profiles but not defined |
## Resources

| Name | Type |
|------|------|
| [intersight_fabric_eth_network_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_eth_network_policy) | resource |
| [intersight_fabric_fc_network_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_fc_network_policy) | resource |
| [intersight_fabric_port_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_port_policy) | resource |
| [intersight_fabric_switch_cluster_profile.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_switch_cluster_profile) | resource |
| [intersight_fabric_switch_control_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_switch_control_policy) | resource |
| [intersight_fabric_switch_profile.map](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_switch_profile) | resource |
| [intersight_fabric_system_qos_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/fabric_system_qos_policy) | resource |
| [intersight_networkconfig_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/networkconfig_policy) | resource |
| [intersight_ntp_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/ntp_policy) | resource |
| [intersight_snmp_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/snmp_policy) | resource |
| [intersight_syslog_policy.data](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/resources/syslog_policy) | resource |
| [intersight_network_element_summary.fis](https://registry.terraform.io/providers/CiscoDevNet/intersight/latest/docs/data-sources/network_element_summary) | data source |
<!-- END_TF_DOCS -->