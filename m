From: Shirley Ma <shirley.ma-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: rmmod mlx4_core panic 3.16-rc1
Date: Wed, 18 Jun 2014 20:33:07 -0700
Message-ID: <53A259F3.3040203@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hello Or,

Two questions here:
1. Whether IB VFs is supported in ConnectX-2 (mlx4 driver)?

I tried to num_vfs={port1,port2,port1+2} when loading mlx4_core module, it failed with
mlx4_core 0000:40:00.0: Invalid syntax of num_vfs/probe_vfs with IB port - single port VFs syntax is only supported when all ports are configured as ethernet

2. After mlx4_core module is being loaded with with num_vfs={} parameters, when removing mlx4_core, it consistently hits below panic. Whether this problem is being tracked?

Thanks
Shirley


<mlx4_ib> mlx4_ib_add: mlx4_ib: Mellanox ConnectX InfiniBand driver v2.2-1 (Feb 2014)
mlx4_core: Mellanox ConnectX core driver v2.2-1 (Feb, 2014)
mlx4_core: Initializing 0000:40:00.0
mlx4_core 0000:40:00.0: Enabling SR-IOV with 2 VFs
pci 0000:40:00.1: [15b3:1002] type 00 class 0x0c0600
mlx4_core: Initializing 0000:40:00.1
mlx4_core 0000:40:00.1: enabling device (0000 -> 0002)
mlx4_core 0000:40:00.1: Skipping virtual function:1
pci 0000:40:00.2: [15b3:1002] type 00 class 0x0c0600
mlx4_core: Initializing 0000:40:00.2
mlx4_core 0000:40:00.2: enabling device (0000 -> 0002)
mlx4_core 0000:40:00.2: Skipping virtual function:2
mlx4_core 0000:40:00.0: Running in master mode
mlx4_core 0000:40:00.0: PCIe BW is different than device's capability
mlx4_core 0000:40:00.0: PCIe link speed is 5.0GT/s, device supports 8.0GT/s
mlx4_core 0000:40:00.0: PCIe link width is x8, device supports x8
mlx4_core 0000:40:00.0: Invalid syntax of num_vfs/probe_vfs with IB port - single port VFs syntax is only supported when all ports are configured as ethernet
BUG: unable to handle kernel NULL pointer dereference at 000000000000038c
IP: [<ffffffffa0350450>] __mlx4_remove_one+0x20/0x380 [mlx4_core]
PGD 45d3ba067 PUD 45ace8067 PMD 0 
Oops: 0000 [#1] SMP DEBUG_PAGEALLOC
Modules linked in: mlx4_core(-) ebtable_nat ebtables ipt_MASQUERADE iptable_nat nf_nat_ipv4 nf_nat xt_CHECKSUM iptable_mangle bridge stp llc autofs4 cpufreq_ondemand ipt_REJECT nf_conntrack_ipv4 nf_defrag_ipv4 iptable_filter ip_tables ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 xt_state nf_conntrack ip6table_filter ip6_tables dm_mirror dm_region_hash dm_log dm_mod vhost_net macvtap macvlan vhost tun kvm_intel kvm iTCO_wdt iTCO_vendor_support microcode ipmi_si ipmi_msghandler acpi_cpufreq pcspkr i2c_i801 i2c_core lpc_ich mfd_core shpchp sg ioatdma ib_sa ib_mad ib_core ib_addr ipv6 vxlan ixgbe dca ptp pps_core hwmon mdio ext3 jbd mbcache sd_mod crc_t10dif crct10dif_common usb_storage ahci libahci mpt2sas scsi_transport_sas raid_class [last unloaded: mlx4_core]
CPU: 13 PID: 7212 Comm: rmmod Not tainted 3.16.0-rc1+ #1
Hardware name: Oracle Corporation SUN FIRE X4170 M3     /ASSY,MOTHERBOARD,1U   , BIOS 17050100 08/29/2013
task: ffff880461540110 ti: ffff880465000000 task.ti: ffff880465000000
RIP: 0010:[<ffffffffa0350450>]  [<ffffffffa0350450>] __mlx4_remove_one+0x20/0x380 [mlx4_core]
RSP: 0018:ffff880465003d88  EFLAGS: 00010296
RAX: 0000000000000001 RBX: 0000000000000000 RCX: 0000000000000000
RDX: 0000000000000026 RSI: 0000000000000292 RDI: ffff880468b8f000
RBP: ffff880465003db8 R08: 0000000000000000 R09: 0000000000000000
R10: 09f911029d74e35b R11: 09f911029d74e35b R12: 0000000000000000
R13: ffff880468b8f000 R14: ffffffffa036de40 R15: 0000000000000001
FS:  00007ff287fc2700(0000) GS:ffff88046fce0000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 000000000000038c CR3: 000000045cfae000 CR4: 00000000000407e0
Stack:
 ffff880465003da8 ffff880468b8f000 0000000000000000 ffff880468b8f000
 ffffffffa036de40 0000000000000001 ffff880465003dd8 ffffffffa0350805
 ffff880468b8f098 ffffffffa036dd60 ffff880465003e08 ffffffff812ebaa6
Call Trace:
 [<ffffffffa0350805>] mlx4_remove_one+0x25/0x50 [mlx4_core]
 [<ffffffff812ebaa6>] pci_device_remove+0x46/0xc0
 [<ffffffff813ce08f>] __device_release_driver+0x7f/0xf0
 [<ffffffff813ce1c8>] driver_detach+0xc8/0xd0
 [<ffffffff813cced9>] bus_remove_driver+0x59/0xd0
 [<ffffffff813cef80>] driver_unregister+0x30/0x70
 [<ffffffff812ebc13>] pci_unregister_driver+0x23/0x80
 [<ffffffffa03650e4>] mlx4_cleanup+0x10/0x1e [mlx4_core]
 [<ffffffff810ceff9>] SyS_delete_module+0x189/0x210
 [<ffffffff815d2f12>] system_call_fastpath+0x16/0x1b
Code: 66 66 2e 0f 1f 84 00 00 00 00 00 55 48 89 e5 41 57 41 56 41 55 41 54 53 48 83 ec 08 66 66 66 66 90 48 8b 9f 58 01 00 00 49 89 fd <44> 8b b3 8c 03 00 00 45 85 f6 0f 85 41 02 00 00 f6 43 08 04 44 
RIP  [<ffffffffa0350450>] __mlx4_remove_one+0x20/0x380 [mlx4_core]
 RSP <ffff880465003d88>
CR2: 000000000000038c
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
