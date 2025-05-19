# author:slime3000fly
# TODO: ASIGN RESERVED PUBLIC IP

terraform {
  required_providers {
    oci = {
      source = "oracle/oci"
      version = ">= 6.37.0"
    }
  }
}

resource "oci_core_vcn" "internal" {
  dns_label      = "internal"
  cidr_block     = "172.16.0.0/20"
  compartment_id = "${var.compartment_id}"
  display_name   = "Puppet VCN"
}

resource "oci_core_subnet" "PuppetSubnet" {
  vcn_id              = oci_core_vcn.internal.id
  display_name        = "InternalSubnet"
  cidr_block          = "172.16.1.0/24"
  compartment_id      = "${var.compartment_id}"
  security_list_ids   = [oci_core_security_list.PuppetSecurityList.id]
}

# Firewall
resource "oci_core_security_list" "PuppetSecurityList" {
  compartment_id = "${var.compartment_id}"
  display_name   = "PuppetSecurityList"
  vcn_id         = "${oci_core_vcn.internal.id}"

  egress_security_rules {
    protocol    = "all"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      min = 22
      max = 22
    }
  }

  # Ingress – Puppet agent (TCP 8140)
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 8140
      max = 8140
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 8142
      max = 8142
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 8143
      max = 8143
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 8170
      max = 8170
    }
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 4433
      max = 4433
    }
  }

  # Ingress – HTTPS (TCP 443) 
  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"
    tcp_options {
      min = 443
      max = 443
    }
  }

  # Ingress – ICMP: Ping
  ingress_security_rules {
    protocol = "1"
    source   = "0.0.0.0/0"
    icmp_options {
      type = 8
      code = 0
    }
  }

  # Ingress – ICMP: Fragmentation Needed
  ingress_security_rules {
    protocol = "1"
    source   = "0.0.0.0/0"
    icmp_options {
      type = 3
      code = 4
    }
  }
}

resource "oci_core_internet_gateway" "igw" {
  compartment_id = var.compartment_id
  vcn_id         = oci_core_vcn.internal.id
  display_name   = "IGW"
}

resource "oci_core_default_route_table" "update_default" {
  manage_default_resource_id = oci_core_vcn.internal.default_route_table_id

  route_rules {
    network_entity_id = oci_core_internet_gateway.igw.id
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
  }
}

data "oci_identity_availability_domains" "ADs" {
    #Required
    compartment_id = "${var.compartment_id}"
}


# See https://docs.oracle.com/iaas/images/
data "oci_core_images" "test_images" {
  compartment_id           = var.compartment_id
  operating_system         = "Canonical Ubuntu"
  operating_system_version = "24.04"
  sort_by                  = "TIMECREATED"
  sort_order               = "DESC"
}

# output "debug_images" {
#   value = data.oci_core_images.test_images.images[*].display_name
# }

data "oci_identity_availability_domain" "ad" {
  compartment_id = var.tenancy_ocid
  ad_number      = 1
}

resource "oci_core_instance" "PuppetMaster" {
  availability_domain = "${lookup(data.oci_identity_availability_domains.ADs.availability_domains[var.AD - 1], "name")}"
  # availability_domain = data.oci_identity_availability_domain.ad.name
  compartment_id      = "${var.compartment_id}"
  display_name        = "PuppetMaster"
  shape               = "${var.InstanceShape}"

  shape_config {
    ocpus = var.instance_ocpus
    memory_in_gbs = var.instance_shape_config_memory_in_gbs
  }

  create_vnic_details {
    subnet_id        = "${oci_core_subnet.PuppetSubnet.id}"
    assign_public_ip = true
  }

  source_details {
    source_type = "image"
    source_id   = lookup(data.oci_core_images.test_images.images[0], "id")
  }

  metadata = {
    ssh_authorized_keys = "${file(var.ssh_public_key_path)}"
  }

  timeouts {
    create = "10m"
  }
}

output "public_ip" {
  value = oci_core_instance.PuppetMaster.public_ip
}