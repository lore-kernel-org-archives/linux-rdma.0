From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: list corruption in IPOIB
Date: Fri, 17 May 2013 21:36:20 +0200
Message-ID: <519686B4.7010300@profitbricks.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Shlomo & Or,

We've seen below neigh->list list corruption warning during testing,
 From Dongsu's and my opinion, several place also need
netif_tx_lock(_bh)/netif_tx_unlock(_bh) pairs around neigh->list , I
tried to add netif_tx_lock/netif_tx_unlock into ipoib_cm_destroy_tx, it
improved the situation, there're some other places in ipoib_main.c and
ipoib_mcast.c, but I don't know which lock should be added, if you can
take some time to look into it, that will be great.



May 17 15:17:57 ib2 kernel: [  274.910792] ib0: failed to send RTU: -22
May 17 15:17:59 ib2 kernel: [  276.118006] ib0: enabling connected mode
will cause multicast packet drops
May 17 15:18:01 ib2 kernel: [  278.557566] ib0: enabling connected mode
will cause multicast packet drops
May 17 15:18:02 ib2 kernel: [  279.793565] ib0: failed to send cm req: -22
May 17 15:18:02 ib2 kernel: [  279.793713] ------------[ cut here
]------------
May 17 15:18:02 ib2 kernel: [  279.793779] WARNING: at
lib/list_debug.c:49 __list_del_entry+0x63/0xd0()
May 17 15:18:02 ib2 kernel: [  279.793840] Hardware name: System Product
Name
May 17 15:18:02 ib2 kernel: [  279.793898] list_del corruption,
ffff8801f9708740->next is LIST_POISON1 (dead000000100100)
May 17 15:18:02 ib2 kernel: [  279.794013] Modules linked in: rdma_ucm
rdma_cm iw_cm ib_addr ib_ipoib ib_cm ib_sa ib_uverbs ib_umad mlx4_ib
ib_mad ib_core ip6table_filter ip6_tables iptable_filter ip_tables
ebtable_nat ebtables x_tables cpufreq_powersave cpufreq_conservative
cpufreq_stats cpufreq_userspace binfmt_misc fuse loop kvm_amd kvm
psmouse powernow_k8 tpm_tis tpm tpm_bios serio_raw edac_core mperf evdev
shpchp processor edac_mce_amd microcode pci_hotplug i2c_piix4
asus_atk0110 thermal_sys button dm_multipath scsi_dh mlx4_en sg sd_mod
crc_t10dif mlx4_core ahci libahci r8169 libata scsi_mod [last unloaded:
scsi_wait_scan]
May 17 15:18:02 ib2 kernel: [  279.796082] Pid: 220, comm: kworker/u:5
Not tainted 3.4.23-pserver+ #98
May 17 15:18:02 ib2 kernel: [  279.796142] Call Trace:
May 17 15:18:02 ib2 kernel: [  279.796202]  [<ffffffff8103c21f>]
warn_slowpath_common+0x7f/0xc0
May 17 15:18:02 ib2 kernel: [  279.796266]  [<ffffffff8103c316>]
warn_slowpath_fmt+0x46/0x50
May 17 15:18:02 ib2 kernel: [  279.796328]  [<ffffffff81428ff3>]
__list_del_entry+0x63/0xd0
May 17 15:18:02 ib2 kernel: [  279.796828]  [<ffffffff81429071>]
list_del+0x11/0x40
May 17 15:18:02 ib2 kernel: [  279.796897]  [<ffffffffa02b7978>]
ipoib_cm_tx_start+0x2e8/0x3b0 [ib_ipoib]
May 17 15:18:02 ib2 kernel: [  279.796964]  [<ffffffff8105da3a>]
process_one_work+0x19a/0x5c0
May 17 15:18:02 ib2 kernel: [  279.797026]  [<ffffffff8105d9cd>] ?
process_one_work+0x12d/0x5c0
May 17 15:18:02 ib2 kernel: [  279.797096]  [<ffffffffa02b7690>] ?
ipoib_cm_destroy_tx+0xc0/0xc0 [ib_ipoib]
May 17 15:18:02 ib2 kernel: [  279.797162]  [<ffffffff8105f7b5>]
worker_thread+0x175/0x380
May 17 15:18:02 ib2 kernel: [  279.797224]  [<ffffffff8105f640>] ?
manage_workers+0x210/0x210
May 17 15:18:02 ib2 kernel: [  279.797285]  [<ffffffff81064d5e>]
kthread+0xbe/0xd0
May 17 15:18:02 ib2 kernel: [  279.797346]  [<ffffffff8109f1d0>] ?
trace_hardirqs_on_caller+0x20/0x1b0
May 17 15:18:02 ib2 kernel: [  279.797412]  [<ffffffff81746b74>]
kernel_thread_helper+0x4/0x10
May 17 15:18:02 ib2 kernel: [  279.797475]  [<ffffffff8173ce70>] ?
retint_restore_args+0x13/0x13
May 17 15:18:02 ib2 kernel: [  279.797539]  [<ffffffff81064ca0>] ?
__init_kthread_worker+0x70/0x70
May 17 15:18:02 ib2 kernel: [  279.797602]  [<ffffffff81746b70>] ?
gs_change+0x13/0x13
May 17 15:18:02 ib2 kernel: [  279.797660] ---[ end trace
a513a4365628073c ]---
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
