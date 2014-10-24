From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: ib_isert RDMA_CM_EVENT_DEVICE_REMOVAL events
Date: Thu, 23 Oct 2014 23:02:42 -0700
Message-ID: <1414130562.15076.27.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
Sender: target-devel-owner@vger.kernel.org
To: Or Gerlitz <ogerlitz@mellanox.com>, Sagi Grimberg <sagig@mellanox.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

Hey Or & Sagi,

Quick CMA related question for you..

I've been hitting the following NULL pointer dereference during reboot
using a v3.14.y based kernel with Sagi's latest ib_isert fixes in the
stable-queue from v3.17.

Note this system was not performing /etc/init.d/target stop during
reboot to take down the configfs layout, and no actual iser logins or
sessions had been previously established on iser enabled network portal
in question:

[info] Will now restart.
[  111.076328] kvm: exiting hardware virtualization
[  111.083670] sd 9:0:3:0: [sdi] Synchronizing SCSI cache
[  111.089825] sd 9:0:2:0: [sdh] Synchronizing SCSI cache
[  111.095924] sd 9:0:1:0: [sdg] Synchronizing SCSI cache
[  111.103375] sd 9:0:0:0: [sdf] Synchronizing SCSI cache
[  111.109707] sd 8:0:3:0: [sde] Synchronizing SCSI cache
[  111.116036] sd 8:0:2:0: [sdd] Synchronizing SCSI cache
[  111.122368] sd 8:0:1:0: [sdc] Synchronizing SCSI cache
[  111.128723] sd 8:0:0:0: [sdb] Synchronizing SCSI cache
[  111.134979] sd 0:0:0:0: [sda] Synchronizing SCSI cache
[  111.273440] isert_cma_handler: event 11 status 0 conn ffff880815896000 id ffff88101440d400
[  111.282871] isert_disconnect_work(): >>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>
[  111.290808] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  111.299886] IP: [<          (null)>]           (null)
[  111.305736] PGD 10186c6067 PUD 1016d84067 PMD 0 
[  111.311271] Oops: 0010 [#1] SMP 
[  111.315169] Modules linked in: ib_isert ib_ipoib mlx4_ib rpcsec_gss_krb5 nfsv4 ip_tables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 nf_nat nf_conntrack ip6table_filter ip6_tables ebtables x_tables iscsi_target_mod ib_srpt tcm_qla2xxx tcm_loop vhost_scsi vhost tcm_fc libfc target_core_file target_core_iblock target_core_pscsi target_core_mod 8021q garp stp mrp llc nfsd auth_rpcgss oid_registry nfs_acl nfs lockd sunrpc loop x86_pkg_temp_thermal intel_powerclamp crct10dif_pclmul sb_edac crc32_pclmul ioatdma ghash_clmulni_intel lpc_ich edac_core mfd_core i2c_i801 ipmi_si processor thermal_sys button md_mod sg hid_generic isci usbhid mpt3sas ixgbe mlx4_core libsas raid_class hid igb scsi_transport_sas qla2xxx mdio i2c_algo_bit i2c_core scsi_transport_fc dca
[  111.398587] CPU: 6 PID: 138 Comm: kworker/6:1 Not tainted 3.14.13+ #6
[  111.405902] Hardware name: Intel Corporation S2600GZ/S2600GZ, BIOS SE5C600.86B.02.01.0002.082220131453 08/22/2013
[  111.417530] Workqueue: events isert_disconnect_work [ib_isert]
[  111.424254] task: ffff88101a9bcb60 ti: ffff8810152bc000 task.ti: ffff8810152bc000
[  111.432762] RIP: 0010:[<0000000000000000>]  [<          (null)>]           (null)
[  111.441357] RSP: 0018:ffff8810152bddb0  EFLAGS: 00010087
[  111.447407] RAX: ffff8808158969e8 RBX: 0000000000000000 RCX: 0000000000000000
[  111.455499] RDX: 0000000000000000 RSI: 0000000000000003 RDI: ffff8808158969e8
[  111.463593] RBP: ffff880815896600 R08: 0000000000000000 R09: 000000000000074f
[  111.471685] R10: 0000000000000000 R11: 0000000000000000 R12: 0000000000000000
[  111.479779] R13: 0000000000000000 R14: 0000000000000003 R15: ffff880815896be8
[  111.487872] FS:  0000000000000000(0000) GS:ffff88101f200000(0000) knlGS:0000000000000000
[  111.497061] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  111.503598] CR2: 0000000000000000 CR3: 00000010040ce000 CR4: 00000000001407e0
[  111.511691] Stack:
[  111.514046]  ffffffff810f40ac ffff8810152bde08 00000001152bddc8 ffff88101f20f440
[  111.522812]  ffff8808158965f8 ffff8808158965f0 0000000000000292 ffff88101f216700
[  111.531578]  0000000000000000 0000000000000180 ffffffff810f49ca ffff8808158965a8
[  111.540344] Call Trace:
[  111.543195]  [<ffffffff810f40ac>] ? __wake_up_common+0x4c/0x80
[  111.549836]  [<ffffffff810f49ca>] ? complete+0x3a/0x60
[  111.555698]  [<ffffffff810ccecf>] ? process_one_work+0x16f/0x430
[  111.562528]  [<ffffffff810ce6d6>] ? worker_thread+0x116/0x3d0
[  111.569065]  [<ffffffff810ce5c0>] ? manage_workers.isra.21+0x2e0/0x2e0
[  111.576482]  [<ffffffff810d49bc>] ? kthread+0xbc/0xe0
[  111.582243]  [<ffffffff810d4900>] ? flush_kthread_worker+0x80/0x80
[  111.589273]  [<ffffffff8164d8cc>] ? ret_from_fork+0x7c/0xb0
[  111.595616]  [<ffffffff810d4900>] ? flush_kthread_worker+0x80/0x80
[  111.602639] Code:  Bad RIP value.
[  111.606631] RIP  [<          (null)>]           (null)
[  111.612576]  RSP <ffff8810152bddb0>
[  111.616583] CR2: 0000000000000000
[  111.620400] ---[ end trace 8e386ea065bef2ce ]---
[  111.634392] BUG: unable to handle kernel paging request at ffffffffffffffd8
[  111.642470] IP: [<ffffffff810d4d67>] kthread_data+0x7/0x10
[  111.648806] PGD 1c0d067 PUD 1c0f067 PMD 0 
[  111.653761] Oops: 0000 [#2] SMP 
[  111.657653] Modules linked in: ib_isert ib_ipoib mlx4_ib rpcsec_gss_krb5 nfsv4 ip_tables ip6table_nat nf_conntrack_ipv6 nf_defrag_ipv6 nf_nat_ipv6 nf_nat nf_conntrack ip6table_filter ip6_tables ebtables x_tables iscsi_target_mod ib_srpt tcm_qla2xxx tcm_loop vhost_scsi vhost tcm_fc libfc target_core_file target_core_iblock target_core_pscsi target_core_mod 8021q garp stp mrp llc nfsd auth_rpcgss oid_registry nfs_acl nfs lockd sunrpc loop x86_pkg_temp_thermal intel_powerclamp crct10dif_pclmul sb_edac crc32_pclmul ioatdma ghash_clmulni_intel lpc_ich edac_core mfd_core i2c_i801 ipmi_si processor thermal_sys button md_mod sg hid_generic isci usbhid mpt3sas ixgbe mlx4_core libsas raid_class hid igb scsi_transport_sas qla2xxx mdio i2c_algo_bit i2c_core scsi_transport_fc dca
[  111.740836] CPU: 6 PID: 138 Comm: kworker/6:1 Tainted: G      D      3.14.13+ #6
[  111.749239] Hardware name: Intel Corporation S2600GZ/S2600GZ, BIOS SE5C600.86B.02.01.0002.082220131453 08/22/2013
[  111.760875] task: ffff88101a9bcb60 ti: ffff8810152bc000 task.ti: ffff8810152bc000
[  111.769383] RIP: 0010:[<ffffffff810d4d67>]  [<ffffffff810d4d67>] kthread_data+0x7/0x10
[  111.778472] RSP: 0018:ffff8810152bda70  EFLAGS: 00010002
[  111.784522] RAX: 0000000000000000 RBX: 0000000000000006 RCX: 000000000000000f
[  111.792615] RDX: 0000000000000000 RSI: 0000000000000006 RDI: ffff88101a9bcb60
[  111.800708] RBP: ffff88101a9bcb60 R08: 0000000000000001 R09: 0000000000000001
[  111.808801] R10: 0000000000000001 R11: ffffea00404e9b80 R12: ffff88101f212dc0
[  111.816894] R13: 0000000000000006 R14: ffff88101a9bcb50 R15: ffff88101a9bcb60
[  111.824989] FS:  0000000000000000(0000) GS:ffff88101f200000(0000) knlGS:0000000000000000
[  111.834179] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  111.840716] CR2: 0000000000000028 CR3: 00000010040ce000 CR4: 00000000001407e0
[  111.848809] Stack:
[  111.851162]  ffffffff810ceb58 ffff88101a9bcf48 ffffffff81641ccd ffff881014f40190
[  111.859910]  0000000000000086 0000000000012dc0 ffff8810152bdfd8 0000000000012dc0
[  111.868675]  ffff88101a9bcb60 ffff88101a9bcb60 ffff88101a9bd168 ffff88101a9bce40
[  111.877433] Call Trace:
[  111.880277]  [<ffffffff810ceb58>] ? wq_worker_sleeping+0x8/0x80
[  111.887012]  [<ffffffff81641ccd>] ? __schedule+0x46d/0x760
[  111.893264]  [<ffffffff810b44d2>] ? do_exit+0x6c2/0xa30
[  111.899223]  [<ffffffff816466f2>] ? oops_end+0xa2/0x140
[  111.905184]  [<ffffffff8163a8d8>] ? no_context+0x264/0x28f
[  111.921058]  [<ffffffff81648d72>] ? __do_page_fault+0xd2/0x510
[  111.927696]  [<ffffffff8164932d>] ? __atomic_notifier_call_chain+0xd/0x20
[  111.935409]  [<ffffffff813e41a5>] ? notify_update+0x25/0x30
[  111.941753]  [<ffffffff813e4a60>] ? vt_console_print+0x230/0x3c0
[  111.948576]  [<ffffffff81645af8>] ? page_fault+0x28/0x30
[  111.954628]  [<ffffffff810f40ac>] ? __wake_up_common+0x4c/0x80
[  111.961265]  [<ffffffff810f49ca>] ? complete+0x3a/0x60
[  111.967124]  [<ffffffff810ccecf>] ? process_one_work+0x16f/0x430
[  111.973955]  [<ffffffff810ce6d6>] ? worker_thread+0x116/0x3d0
[  111.980495]  [<ffffffff810ce5c0>] ? manage_workers.isra.21+0x2e0/0x2e0
[  111.987909]  [<ffffffff810d49bc>] ? kthread+0xbc/0xe0
[  111.993671]  [<ffffffff810d4900>] ? flush_kthread_worker+0x80/0x80
[  112.000697]  [<ffffffff8164d8cc>] ? ret_from_fork+0x7c/0xb0
[  112.007043]  [<ffffffff810d4900>] ? flush_kthread_worker+0x80/0x80
[  112.014063] Code: 00 00 00 00 65 48 8b 04 25 c0 b8 00 00 48 8b 80 90 03 00 00 48 8b 40 c8 48 c1 e8 02 83 e0 01 c3 0f 1f 40 00 48 8b 87 90 03 00 00 <48> 8b 40 d8 c3 0f 1f 40 00 48 83 ec 18 ba 08 00 00 00 48 c7 44 
[  112.041059] RIP  [<ffffffff810d4d67>] kthread_data+0x7/0x10
[  112.047490]  RSP <ffff8810152bda70>
[  112.051487] CR2: ffffffffffffffd8
[  112.055301] ---[ end trace 8e386ea065bef2cf ]---
[  112.068495] Fixing recursive fault but reboot is needed!

AFAICT, it looks like the assumption in isert_disconnected_handler() to
dereference rdma_cm_id->context as isert_conn (in all cases) is wrong,
and the above RDMA_CM_EVENT_DEVICE_REMOVAL has iscsi_np stored in
->context from the original rdma_create_id() at isert_setup_np() time.

So, is there a way to tell the difference how rdma_cm_id->context should
be dereferenced when DEVICE_REMOVAL occurs..?  Does DEVICE_REMOVAL occur
on just the listener rdma_cm_id, or on all accepted children as well..?

Anything else to consider wrt to other CMA events being kicked off into
isert_disconnected_handler()..?

--nab
