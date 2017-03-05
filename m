From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: kernull NULL pointer observed on initiator side after 'nvmetcli
 clear' on target side
Date: Sun, 5 Mar 2017 08:39:44 -0500 (EST)
Message-ID: <1053522223.31446389.1488721184925.JavaMail.zimbra@redhat.com>
References: <1832491330.31443919.1488709276951.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1832491330.31443919.1488709276951.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: hch-jcswGhMUV9g@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi experts

If I offline one CPU on initiator side and nvmetcli clear on target side, it will cause kernel NULL pointer on initiator side, could you help check it, thanks

Steps to reproduce:
1. setup nvmet target with null-blk device:
#modprobe nvmet
#modprobe nvmet-rdma
#modprobe null_blk nr_devices=1
#nvmetcli restore rdma.json

2. connect the target on initiator side and offline one cpu:
#modprobe nvme-rdma
#nvme connect-all -t rdma -a 172.31.2.3 -s 1023
#echo 0 > /sys/devices/system/cpu/cpu1/online

3. nvmetcli clear on target side
#nvmetcli clear

Kernel log:

[  125.039340] nvme nvme0: new ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery", addr 172.31.2.3:1023
[  125.160587] nvme nvme0: creating 16 I/O queues.
[  125.602244] nvme nvme0: new ctrl: NQN "testnqn", addr 172.31.2.3:1023
[  140.930343] Broke affinity for irq 16
[  140.950295] Broke affinity for irq 28
[  140.969957] Broke affinity for irq 70
[  140.986584] Broke affinity for irq 90
[  141.003160] Broke affinity for irq 93
[  141.019779] Broke affinity for irq 97
[  141.036341] Broke affinity for irq 100
[  141.053782] Broke affinity for irq 104
[  141.072860] smpboot: CPU 1 is now offline
[  154.768104] nvme nvme0: reconnecting in 10 seconds
[  165.349689] BUG: unable to handle kernel NULL pointer dereference at           (null)
[  165.387783] IP: blk_mq_reinit_tagset+0x35/0x80
[  165.409550] PGD 0 
[  165.409550] 
[  165.427269] Oops: 0000 [#1] SMP
[  165.442876] Modules linked in: nvme_rdma nvme_fabrics nvme_core xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter bridge stp llc rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core intel_rapl ipmi_ssif sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate intel_uncore intel_rapl_perf iTCO_wdt ipmi_si iTCO_vendor_support wmi hpwdt pcspkr sg ipmi_de
 vintf hpilo
[  165.769732]  acpi_power_meter ipmi_msghandler ioatdma shpchp acpi_cpufreq lpc_ich dca nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs mlx4_en sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt ata_generic fb_sys_fops pata_acpi ttm bnx2x drm e1000e ata_piix mdio ptp mlx4_core i2c_core serio_raw libata pps_core hpsa libcrc32c devlink fjes scsi_transport_sas crc32c_intel dm_mirror dm_region_hash dm_log dm_mod
[  165.957288] CPU: 6 PID: 424 Comm: kworker/6:2 Not tainted 4.10.0+ #3
[  165.985856] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[  166.015576] Workqueue: nvme_rdma_wq nvme_rdma_reconnect_ctrl_work [nvme_rdma]
[  166.047813] task: ffff8804291f9680 task.stack: ffffc90004fa4000
[  166.074543] RIP: 0010:blk_mq_reinit_tagset+0x35/0x80
[  166.096784] RSP: 0018:ffffc90004fa7e00 EFLAGS: 00010246
[  166.120205] RAX: ffff88082a97f600 RBX: 0000000000000000 RCX: 000000018020001a
[  166.152099] RDX: 0000000000000001 RSI: ffff88042c1b5240 RDI: ffff88042c163680
[  166.183997] RBP: ffffc90004fa7e20 R08: ffff88042c388400 R09: 000000018020001a
[  166.216018] R10: 000000002c388801 R11: ffff88042c388400 R12: 0000000000000000
[  166.248248] R13: 0000000000000001 R14: ffff8804be65d018 R15: 0000000000000180
[  166.280594] FS:  0000000000000000(0000) GS:ffff88042f780000(0000) knlGS:0000000000000000
[  166.317022] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  166.342821] CR2: 0000000000000000 CR3: 0000000001c09000 CR4: 00000000000406e0
[  166.374899] Call Trace:
[  166.385854]  nvme_rdma_reconnect_ctrl_work+0x60/0x1f0 [nvme_rdma]
[  166.414954]  process_one_work+0x165/0x410
[  166.434888]  worker_thread+0x137/0x4c0
[  166.453275]  kthread+0x101/0x140
[  166.469530]  ? rescuer_thread+0x3b0/0x3b0
[  166.487549]  ? kthread_park+0x90/0x90
[  166.503966]  ret_from_fork+0x2c/0x40
[  166.520071] Code: 56 49 89 fe 41 55 41 54 53 48 8b 47 08 48 83 78 40 00 74 55 8b 57 10 85 d2 74 4e 45 31 ed 49 8b 46 38 49 63 d5 31 db 4c 8b 24 d0 <41> 8b 04 24 85 c0 74 2c 49 8b 84 24 80 00 00 00 48 63 d3 48 8b 
[  166.605127] RIP: blk_mq_reinit_tagset+0x35/0x80 RSP: ffffc90004fa7e00
[  166.634093] CR2: 0000000000000000
[  166.648963] ---[ end trace cabb6f7f7f9f7187 ]---
[  166.674180] Kernel panic - not syncing: Fatal exception
[  166.697717] Kernel Offset: disabled
[  166.717719] ---[ end Kernel panic - not syncing: Fatal exception
[  166.746440] ------------[ cut here ]------------
[  166.767150] WARNING: CPU: 6 PID: 424 at arch/x86/kernel/smp.c:127 native_smp_send_reschedule+0x3f/0x50
[  166.808742] Modules linked in: nvme_rdma nvme_fabrics nvme_core xt_CHECKSUM iptable_mangle ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack ipt_REJECT nf_reject_ipv4 tun ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter bridge stp llc rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core intel_rapl ipmi_ssif sb_edac edac_core x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate intel_uncore intel_rapl_perf iTCO_wdt ipmi_si iTCO_vendor_support wmi hpwdt pcspkr sg ipmi_de
 vintf hpilo
[  167.131981]  acpi_power_meter ipmi_msghandler ioatdma shpchp acpi_cpufreq lpc_ich dca nfsd auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs mlx4_en sr_mod sd_mod cdrom mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt ata_generic fb_sys_fops pata_acpi ttm bnx2x drm e1000e ata_piix mdio ptp mlx4_core i2c_core serio_raw libata pps_core hpsa libcrc32c devlink fjes scsi_transport_sas crc32c_intel dm_mirror dm_region_hash dm_log dm_mod
[  167.315426] CPU: 6 PID: 424 Comm: kworker/6:2 Tainted: G      D         4.10.0+ #3
[  167.349430] Hardware name: HP ProLiant DL388p Gen8, BIOS P70 12/20/2013
[  167.379147] Workqueue: nvme_rdma_wq nvme_rdma_reconnect_ctrl_work [nvme_rdma]
[  167.411437] Call Trace:
[  167.422486]  <IRQ>
[  167.432587]  dump_stack+0x63/0x87
[  167.449042]  __warn+0xd1/0xf0
[  167.463891]  warn_slowpath_null+0x1d/0x20
[  167.483697]  native_smp_send_reschedule+0x3f/0x50
[  167.506498]  resched_curr+0xa1/0xc0
[  167.522992]  check_preempt_curr+0x70/0x90
[  167.541625]  ttwu_do_wakeup+0x19/0xe0
[  167.559098]  ttwu_do_activate+0x6f/0x80
[  167.577357]  try_to_wake_up+0x1aa/0x3b0
[  167.594742]  ? select_idle_sibling+0x2c/0x3d0
[  167.614498]  default_wake_function+0x12/0x20
[  167.633655]  __wake_up_common+0x55/0x90
[  167.650534]  __wake_up_locked+0x13/0x20
[  167.667784]  ep_poll_callback+0xbb/0x240
[  167.685405]  __wake_up_common+0x55/0x90
[  167.702615]  __wake_up+0x39/0x50
[  167.717046]  wake_up_klogd_work_func+0x40/0x60
[  167.736993]  irq_work_run_list+0x4d/0x70
[  167.755647]  ? tick_sched_do_timer+0x70/0x70
[  167.776239]  irq_work_tick+0x40/0x50
[  167.792914]  update_process_times+0x42/0x60
[  167.812138]  tick_sched_handle.isra.18+0x25/0x60
[  167.833794]  tick_sched_timer+0x3d/0x70
[  167.851391]  __hrtimer_run_queues+0xf3/0x280
[  167.871180]  hrtimer_interrupt+0xa8/0x1a0
[  167.889854]  local_apic_timer_interrupt+0x35/0x60
[  167.912036]  smp_apic_timer_interrupt+0x38/0x50
[  167.933375]  apic_timer_interrupt+0x93/0xa0
[  167.954586] RIP: 0010:panic+0x1f5/0x239
[  167.974032] RSP: 0018:ffffc90004fa7b50 EFLAGS: 00000246 ORIG_RAX: ffffffffffffff10
[  168.009365] RAX: 0000000000000034 RBX: 0000000000000000 RCX: 0000000000000006
[  168.041566] RDX: 0000000000000000 RSI: 0000000000000046 RDI: ffff88042f78e000
[  168.073801] RBP: ffffc90004fa7bc0 R08: 00000000fffffffe R09: 00000000000004d9
[  168.105833] R10: 0000000000000005 R11: 00000000000004d8 R12: ffffffff81a0e2e1
[  168.137892] R13: 0000000000000000 R14: 0000000000000000 R15: 0000000000000046
[  168.170234]  </IRQ>
[  168.179603]  oops_end+0xb8/0xd0
[  168.193685]  no_context+0x19e/0x3f0
[  168.209369]  ? lock_timer_base+0xa0/0xa0
[  168.227067]  __bad_area_nosemaphore+0xee/0x1d0
[  168.246978]  bad_area_nosemaphore+0x14/0x20
[  168.266108]  __do_page_fault+0x89/0x4a0
[  168.283345]  ? __slab_free+0x9b/0x2c0
[  168.299742]  do_page_fault+0x30/0x80
[  168.315903]  page_fault+0x28/0x30
[  168.330741] RIP: 0010:blk_mq_reinit_tagset+0x35/0x80
[  168.353028] RSP: 0018:ffffc90004fa7e00 EFLAGS: 00010246
[  168.376493] RAX: ffff88082a97f600 RBX: 0000000000000000 RCX: 000000018020001a
[  168.408373] RDX: 0000000000000001 RSI: ffff88042c1b5240 RDI: ffff88042c163680
[  168.440447] RBP: ffffc90004fa7e20 R08: ffff88042c388400 R09: 000000018020001a
[  168.476491] R10: 000000002c388801 R11: ffff88042c388400 R12: 0000000000000000
[  168.510913] R13: 0000000000000001 R14: ffff8804be65d018 R15: 0000000000000180
[  168.543964]  nvme_rdma_reconnect_ctrl_work+0x60/0x1f0 [nvme_rdma]
[  168.571458]  process_one_work+0x165/0x410
[  168.589496]  worker_thread+0x137/0x4c0
[  168.606267]  kthread+0x101/0x140
[  168.620712]  ? rescuer_thread+0x3b0/0x3b0
[  168.638747]  ? kthread_park+0x90/0x90
[  168.655224]  ret_from_fork+0x2c/0x40
[  168.671278] ---[ end trace cabb6f7f7f9f7188 ]---

Best Regards,
  Yi Zhang
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
