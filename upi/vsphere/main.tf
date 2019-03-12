provider "vsphere" {
  user                 = "${var.vsphere_user}"
  password             = "${var.vsphere_password}"
  vsphere_server       = "${var.vsphere_server}"
  allow_unverified_ssl = true
}

module "resource_pool" {
  source = "./resource_pool"

  vsphere_cluster       = "${var.vsphere_cluster}"
  vsphere_datacenter    = "${var.vsphere_datacenter}"
  vsphere_resource_pool = "${var.vsphere_resource_pool}"
}

module "bootstrap" {
  source = "./bootstrap"

  bootstrap_ip       = "${var.bootstrap_ip}"
  cluster_id         = "${var.cluster_id}"
  machine_cidr       = "${var.machine_cidr}"
  vsphere_cluster    = "${var.vsphere_cluster}"
  vsphere_datacenter = "${var.vsphere_datacenter}"
  vsphere_datastore  = "${var.vsphere_datastore}"
  resource_pool_id   = "${module.resource_pool.pool_id}"
  vm_base_domain     = "${var.vm_base_domain}"
  vm_network         = "${var.vm_network}"
  vm_template        = "${var.vm_template}"
}

module "masters" {
  source = "./masters"

  master_count       = "${var.master_count}"
  master_ips         = "${var.master_ips}"
  cluster_id         = "${var.cluster_id}"
  machine_cidr       = "${var.machine_cidr}"
  vsphere_cluster    = "${var.vsphere_cluster}"
  vsphere_datacenter = "${var.vsphere_datacenter}"
  vsphere_datastore  = "${var.vsphere_datastore}"
  resource_pool_id   = "${module.resource_pool.pool_id}"
  vm_base_domain     = "${var.vm_base_domain}"
  vm_network         = "${var.vm_network}"
  vm_template        = "${var.vm_template}"
}

module "workers" {
  source = "./workers"

  worker_count       = "${var.master_count}"
  worker_ips         = "${var.worker_ips}"
  cluster_id         = "${var.cluster_id}"
  machine_cidr       = "${var.machine_cidr}"
  vsphere_cluster    = "${var.vsphere_cluster}"
  vsphere_datacenter = "${var.vsphere_datacenter}"
  vsphere_datastore  = "${var.vsphere_datastore}"
  resource_pool_id   = "${module.resource_pool.pool_id}"
  vm_base_domain     = "${var.vm_base_domain}"
  vm_network         = "${var.vm_network}"
  vm_template        = "${var.vm_template}"
}

module "dns" {
  source = "./route53"

  base_domain       = "${var.base_domain}"
  cluster_domain    = "${var.vm_base_domain}"
  cluster_id        = "${var.cluster_id}"
  etcd_count        = "${var.master_count}"
  etcd_ip_addresses = "${var.master_ips}"
}
