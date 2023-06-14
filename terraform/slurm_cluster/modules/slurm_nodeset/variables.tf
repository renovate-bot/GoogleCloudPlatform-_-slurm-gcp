/**
 * Copyright (C) SchedMD LLC.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *     https://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

variable "nodeset_name" {
  description = "Name of Slurm nodeset."
  type        = string

  validation {
    condition     = can(regex("^[a-z](?:[a-z0-9]{0,6})$", var.nodeset_name))
    error_message = "Variable 'nodeset_name' must be a match of regex '^[a-z](?:[a-z0-9]{0,6})$'."
  }
}

variable "node_conf" {
  description = <<EOD
Slurm node configuration, as a map.
See https://slurm.schedmd.com/slurm.conf.html#SECTION_NODE-CONFIGURATION for details.
EOD
  type        = map(string)
  default     = {}
}

variable "instance_template_self_link" {
  description = "Instance template self_link used to create compute instances."
  type        = string

  validation {
    condition     = length(regexall("projects/([^/]*)", var.instance_template_self_link)) > 0
    error_message = "Must be a self link."
  }
}

variable "subnetwork_self_link" {
  description = "The subnetwork self_link to attach instances to."
  type        = string

  validation {
    condition     = length(regexall("projects/([^/]*)", var.subnetwork_self_link)) > 0 && length(regexall("/regions/([^/]*)", var.subnetwork_self_link)) > 0
    error_message = "Must be a self link."
  }
}

variable "zones" {
  description = <<-EOD
    Nodes will only be created in the listed zones.
    If none are given, all available zones for the region will be allowed.
    NOTE: Machine Type and GPU availability may vary with zone.
  EOD
  type        = set(string)
  default     = []
}

variable "zone_target_shape" {
  description = <<EOD
Strategy for distributing VMs across zones in a region.
ANY
  GCE picks zones for creating VM instances to fulfill the requested number of VMs
  within present resource constraints and to maximize utilization of unused zonal
  reservations.
ANY_SINGLE_ZONE (default)
  GCE always selects a single zone for all the VMs, optimizing for resource quotas,
  available reservations and general capacity.
BALANCED
  GCE prioritizes acquisition of resources, scheduling VMs in zones where resources
  are available while distributing VMs as evenly as possible across allowed zones
  to minimize the impact of zonal failure.
EOD
  type        = string
  default     = "ANY_SINGLE_ZONE"
  validation {
    condition     = contains(["ANY", "ANY_SINGLE_ZONE", "BALANCED"], var.zone_target_shape)
    error_message = "Allowed values for zone_target_shape are \"ANY\", \"ANY_SINGLE_ZONE\", or \"BALANCED\"."
  }
}

variable "node_count_static" {
  description = "Number of nodes to be statically created."
  type        = number
  default     = 0

  validation {
    condition     = var.node_count_static >= 0
    error_message = "Value must be >= 0."
  }
}

variable "node_count_dynamic_max" {
  description = "Maximum number of nodes allowed in this partition to be created dynamically."
  type        = number
  default     = 0

  validation {
    condition     = var.node_count_dynamic_max >= 0
    error_message = "Value must be >= 0."
  }
}

variable "access_config" {
  description = "Access configurations, i.e. IPs via which the VM instance can be accessed via the Internet."
  type = list(object({
    nat_ip       = string
    network_tier = string
  }))
  default = []
}

variable "bandwidth_tier" {
  description = <<-EOD
    Tier 1 bandwidth increases the maximum egress bandwidth for VMs.
    Using the `virtio_enabled` setting will only enable VirtioNet and will not enable TIER_1.
    Using the `tier_1_enabled` setting will enable both gVNIC and TIER_1 higher bandwidth networking.
    Using the `gvnic_enabled` setting will only enable gVNIC and will not enable TIER_1.
    Note that TIER_1 only works with specific machine families & shapes and must be using an image that supports gVNIC. See [official docs](https://cloud.google.com/compute/docs/networking/configure-vm-with-high-bandwidth-configuration) for more details.
  EOD
  type        = string
  default     = "platform_default"

  validation {
    condition     = contains(["platform_default", "virtio_enabled", "gvnic_enabled", "tier_1_enabled"], var.bandwidth_tier)
    error_message = "Allowed values for bandwidth_tier are 'platform_default', 'virtio_enabled', 'gvnic_enabled', or 'tier_1_enabled'."
  }
}

variable "enable_spot_vm" {
  description = "Enable SPOT type preemptible VM."
  type        = bool
  default     = false
}

variable "spot_instance_config" {
  description = "Configure spot VM."
  type = object({
    termination_action = string
  })
  default = null

  validation {
    condition     = var.spot_instance_config == null ? true : contains(["STOP", "DELETE"], lookup(var.spot_instance_config, "termination_action", null))
    error_message = "Key 'termination_action' allowed values: \"STOP\", \"DELETE\"."
  }
}
