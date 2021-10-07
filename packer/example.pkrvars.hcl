# Copyright 2021 SchedMD LLC
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

###########
# GENERAL #
###########

project = "<PROJECT_ID>"
zone    = "us-central1-a"

#########
# IMAGE #
#########

source_image_project_id = [
  "cloud-hpc-image-public",
]

# *NOT* intended for production use
# skip_create_image = true

###########
# NETWORK #
###########

# network_project_id = "<NETWORK_PROJECT_ID>"

# subnetwork = "<SUBNETWORK_ID>"

tags = [
  # "tag0",
  # "tag1",
]

#############
# PROVISION #
#############

slurm_version = "slurm-20.11"

##########
# BUILDS #
##########

### Service Account ###

service_account_email = "default"

service_account_scopes = [
  "https://www.googleapis.com/auth/userinfo.email",
  "https://www.googleapis.com/auth/compute",
  "https://www.googleapis.com/auth/devstorage.full_control",
]

### Builds ###

builds = [
  {
    ### image ###
    source_image        = null
    source_image_family = "centos-7"
    image_licenses      = null
    labels              = null

    ### ssh ###
    ssh_username = "packer"
    ssh_password = null

    ### instance ###
    machine_type = "n2d-standard-4"
    preemptible  = false

    ### root of trust ###
    enable_secure_boot          = null
    enable_vtpm                 = null
    enable_integrity_monitoring = null

    ### storage ###
    disk_size = null
    disk_type = null
  },
  {
    ### image ###
    source_image        = null
    source_image_family = "hpc-centos-7"
    image_licenses      = null
    labels              = null

    ### ssh ###
    ssh_username = "packer"
    ssh_password = null

    ### instance ###
    machine_type = "n2d-standard-4"
    preemptible  = false

    ### root of trust ###
    enable_secure_boot          = true
    enable_vtpm                 = true
    enable_integrity_monitoring = true

    ### storage ###
    disk_size = null
    disk_type = null
  },
  {
    ### image ###
    source_image        = null
    source_image_family = "centos-8"
    image_licenses      = null
    labels              = null

    ### ssh ###
    ssh_username = "packer"
    ssh_password = null

    ### instance ###
    machine_type = "n2d-standard-4"
    preemptible  = false

    ### root of trust ###
    enable_secure_boot          = null
    enable_vtpm                 = null
    enable_integrity_monitoring = null

    ### storage ###
    disk_size = null
    disk_type = null
  },
  {
    ### image ###
    source_image        = null
    source_image_family = "debian-10"
    image_licenses      = null
    labels              = null

    ### ssh ###
    ssh_username = "packer"
    ssh_password = null

    ### instance ###
    machine_type = "n2d-standard-4"
    preemptible  = false

    ### root of trust ###
    enable_secure_boot          = null
    enable_vtpm                 = null
    enable_integrity_monitoring = null

    ### storage ###
    disk_size = null
    disk_type = null
  },
]
