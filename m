From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Crash in mlx4 shutdown with 4.9-rc3
Date: Fri, 4 Nov 2016 09:29:47 -0500
Message-ID: <01e001d236a7$e4c24160$ae46c420$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey Yishai,  Is this by chance a known bug having a pending fix somewhere?  I'm
seeing it frequently when shutting down.  I'm using 4.9-rc3 with memory
debugging enabled...

[59984.502834] mlx4_core 0000:81:00.0: mlx4_shutdown was called
[59984.603599] mlx4_en 0000:81:00.0: removed PHC
[59985.145590] general protection fault: 0000 [#1] SMP DEBUG_PAGEALLOC
[59985.151990] Modules linked in: uio_pci_generic uio iw_cxgb4 cxgb4 nvmet_rdma
nvmet null_blk brd rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi
scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib
rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm dm_mirror dm_region_hash
dm_log dm_mod intel_rapl iosf_mbi sb_edac edac_core x86_pkg_temp_thermal
coretemp ext4 kvm jbd2 irqbypass crct10dif_pclmul crc32_pclmul
ghash_clmulni_intel mbcache aesni_intel lrw gf128mul iTCO_wdt glue_helper mei_me
iTCO_vendor_support ablk_helper cryptd mxm_wmi ipmi_si i2c_i801 lpc_ich mei sg
nfsd mfd_core i2c_smbus ipmi_msghandler pcspkr shpchp auth_rpcgss wmi nfs_acl
lockd grace sunrpc ip_tables xfs libcrc32c libcxgb mlx4_ib ib_core mlx4_en
sd_mod drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm
mlx4_core igb drm ahci libahci ptp libata crc32c_intel pps_core dca nvme
i2c_algo_bit nvme_core i2c_core [last unloaded: cxgb4]
[59985.239258] CPU: 30 PID: 10937 Comm: kworker/30:1 Not tainted
4.9.0-rc3-debug+ #2
[59985.246992] Hardware name: Supermicro X9DR3-F/X9DR3-F, BIOS 3.2a 07/09/2015
[59985.254098] Workqueue: events linkwatch_event
[59985.258600] task: ffff88105312c6c0 task.stack: ffffc90020204000
[59985.264657] RIP: 0010:[<ffffffffa05ae1ba>]  [<ffffffffa05ae1ba>]
mlx4_en_get_phys_port_id+0x1a/0x50 [mlx4_en]
[59985.274874] RSP: 0018:ffffc90020207c30  EFLAGS: 00010286
[59985.280312] RAX: 6b6b6b6b6b6b6b6b RBX: ffff881048c220c0 RCX: 0000000000000000
[59985.287582] RDX: 0000000000000001 RSI: ffffc90020207cb0 RDI: ffff881037020000
[59985.294844] RBP: ffffc90020207c30 R08: 00000000000005f0 R09: ffff88102017e752
[59985.302100] R10: ffff88085f4090c0 R11: ffff88102017e678 R12: ffff881037020000
[59985.309356] R13: ffff88102017e678 R14: 0000000000000000 R15: 0000000000000000
[59985.316608] FS:  0000000000000000(0000) GS:ffff881057580000(0000)
knlGS:0000000000000000
[59985.324936] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[59985.330805] CR2: 00007fff8fd82ff8 CR3: 0000000001c07000 CR4: 00000000000406e0
[59985.338072] Stack:
[59985.340219]  ffffc90020207c40 ffffffff81587a6e ffffc90020207d00
ffffffff815a36ce
[59985.347950]  ffff881048c220c0 ffffc90020207cd7 0000000000000000
0000000000000010
[59985.355684]  02000000ffffffff 000003e820000000 00000000000005dc
0000010000000000
[59985.363408] Call Trace:
[59985.365994]  [<ffffffff81587a6e>] dev_get_phys_port_id+0x1e/0x30
[59985.372123]  [<ffffffff815a36ce>] rtnl_fill_ifinfo+0x4be/0xff0
[59985.378076]  [<ffffffff815a53f3>] rtmsg_ifinfo_build_skb+0x73/0xe0
[59985.384377]  [<ffffffff815a5476>] rtmsg_ifinfo.part.27+0x16/0x50
[59985.390505]  [<ffffffff815a54c8>] rtmsg_ifinfo+0x18/0x20
[59985.395940]  [<ffffffff8158a6c6>] netdev_state_change+0x46/0x50
[59985.401983]  [<ffffffff815a5e78>] linkwatch_do_dev+0x38/0x50
[59985.407764]  [<ffffffff815a6165>] __linkwatch_run_queue+0xf5/0x170
[59985.414067]  [<ffffffff815a6205>] linkwatch_event+0x25/0x30
[59985.419764]  [<ffffffff81099a82>] process_one_work+0x152/0x400
[59985.425716]  [<ffffffff8109a325>] worker_thread+0x125/0x4b0
[59985.431409]  [<ffffffff8109a200>] ? rescuer_thread+0x350/0x350
[59985.437366]  [<ffffffff8109fc6a>] kthread+0xca/0xe0
[59985.442367]  [<ffffffff8109fba0>] ? kthread_park+0x60/0x60
[59985.447978]  [<ffffffff816a1285>] ret_from_fork+0x25/0x30
[59985.453497] Code: f0 5d c3 66 66 66 66 66 2e 0f 1f 84 00 00 00 00 00 66 66 66
66 90 55 48 8b 87 c0 08 00 00 48 63 97 9c d5 00 00 48 89 e5 48 8b 00 <48> 8b 94
d0 58 02 00 00 48 85 d2 74 1c c6 46 20 08 31 c0 88 54
[59985.474081] RIP  [<ffffffffa05ae1ba>] mlx4_en_get_phys_port_id+0x1a/0x50
[mlx4_en]
[59985.481915]  RSP <ffffc90020207c30>
[59985.485910] ---[ end trace 317937c8890959b8 ]---
[59990.228721] Kernel panic - not syncing: Fatal exception
[59990.234181] Kernel Offset: disabled
[59990.239944] ---[ end Kernel panic - not syncing: Fatal exception

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
