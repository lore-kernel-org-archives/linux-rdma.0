From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: 'nvmetcli clear' operation caused kernel BUG after offline CPUS on
 initiator side during IO
Date: Wed, 19 Apr 2017 12:28:18 -0400 (EDT)
Message-ID: <58365994.14333214.1492619298269.JavaMail.zimbra@redhat.com>
References: <1938774873.14330831.1492618572765.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1938774873.14330831.1492618572765.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi 
I reproduced this kernel BUG with below steps on 4.11.0-rc7, could you help check it, thanks.

Steps:
1. Configure NVMe over iWARP RDMA on target
nvmetcli rdma.json
2. Client side:
nvme connect-all -t rdma -a 172.31.52.12 -s 4420
fio -filename=/dev/nvme0n1 -iodepth=1 -thread -rw=randwrite -ioengine=psync -bssplit=5k/10:9k/10:13k/10:17k/10:21k/10:25k/10:29k/10:33k/10:37k/10:41k/10 -bs_unaligned -runtime=300 -size=-group_reporting -name=mytest -numjobs=60  &
echo 0 > /sys/devices/system/cpu/cpu1/online
echo 0 > /sys/devices/system/cpu/cpu2/online
echo 0 > /sys/devices/system/cpu/cpu3/online
3. Target side
nvmetcli clear

$ lspci | grep -i chelsio
05:00.0 Ethernet controller: Chelsio Communications Inc T520-CR Unified Wire Ethernet Controller
05:00.1 Ethernet controller: Chelsio Communications Inc T520-CR Unified Wire Ethernet Controller
05:00.2 Ethernet controller: Chelsio Communications Inc T520-CR Unified Wire Ethernet Controller
05:00.3 Ethernet controller: Chelsio Communications Inc T520-CR Unified Wire Ethernet Controller
05:00.4 Ethernet controller: Chelsio Communications Inc T520-CR Unified Wire Ethernet Controller
05:00.5 SCSI storage controller: Chelsio Communications Inc T520-CR Unified Wire Storage Controller
05:00.6 Fibre Channel: Chelsio Communications Inc T520-CR Unified Wire Storage Controller

kernel log:
[  262.536831] iwpm_register_pid: Unable to send a nlmsg (client = 2)
[  262.646112] nvme nvme0: new ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery", addr 172.31.52.12:4420
[  262.687561] NOHZ: local_softirq_pending 20
[  262.706037] NOHZ: local_softirq_pending 20
[  262.788802] nvme nvme0: creating 8 I/O queues.
[  262.976568] nvme nvme0: new ctrl: NQN "testnqn", addr 172.31.52.12:4420
[  297.255173] Broke affinity for irq 32
[  297.273414] Broke affinity for irq 44
[  297.291639] Broke affinity for irq 56
[  297.309285] Broke affinity for irq 57
[  297.326361] Broke affinity for irq 87
[  297.343787] Broke affinity for irq 93
[  297.362580] smpboot: CPU 1 is now offline
[  297.411077] Broke affinity for irq 27
[  297.428935] Broke affinity for irq 32
[  297.446820] Broke affinity for irq 33
[  297.464341] Broke affinity for irq 44
[  297.481796] Broke affinity for irq 45
[  297.498207] Broke affinity for irq 48
[  297.514653] Broke affinity for irq 49
[  297.531085] Broke affinity for irq 56
[  297.547493] Broke affinity for irq 57
[  297.564717] Broke affinity for irq 87
[  297.581963] Broke affinity for irq 93
[  297.600602] smpboot: CPU 2 is now offline
[  297.645066] Broke affinity for irq 27
[  297.661542] Broke affinity for irq 28
[  297.678246] Broke affinity for irq 29
[  297.695672] Broke affinity for irq 31
[  297.712112] Broke affinity for irq 32
[  297.728532] Broke affinity for irq 33
[  297.745086] Broke affinity for irq 44
[  297.761607] Broke affinity for irq 45
[  297.778118] Broke affinity for irq 48
[  297.796281] Broke affinity for irq 49
[  297.814911] Broke affinity for irq 53
[  297.832768] Broke affinity for irq 56
[  297.851111] Broke affinity for irq 57
[  297.867968] Broke affinity for irq 59
[  297.884419] Broke affinity for irq 87
[  297.900936] Broke affinity for irq 89
[  297.917462] Broke affinity for irq 93
[  297.933903] Broke affinity for irq 95
[  297.952237] smpboot: CPU 3 is now offline
[  308.694162] blk_update_request: I/O error, dev nvme0n1, sector 127606888
[  308.694198] blk_update_request: I/O error, dev nvme0n1, sector 54248896
[  308.694200] Buffer I/O error on dev nvme0n1, logical block 6781112, lost async page write
[  308.694201] Buffer I/O error on dev nvme0n1, logical block 6781113, lost async page write
[  308.694202] Buffer I/O error on dev nvme0n1, logical block 6781114, lost async page write
[  308.694202] Buffer I/O error on dev nvme0n1, logical block 6781115, lost async page write
[  308.694203] Buffer I/O error on dev nvme0n1, logical block 6781116, lost async page write
[  308.694250] blk_update_request: I/O error, dev nvme0n1, sector 53778448
[  308.694251] Buffer I/O error on dev nvme0n1, logical block 6722306, lost async page write
[  308.694252] Buffer I/O error on dev nvme0n1, logical block 6722307, lost async page write
[  308.694253] Buffer I/O error on dev nvme0n1, logical block 6722308, lost async page write
[  308.694253] Buffer I/O error on dev nvme0n1, logical block 6722309, lost async page write
[  308.694254] Buffer I/O error on dev nvme0n1, logical block 6722310, lost async page write
[  308.694283] blk_update_request: I/O error, dev nvme0n1, sector 53779456
[  308.694314] blk_update_request: I/O error, dev nvme0n1, sector 53952928
[  308.694357] blk_update_request: I/O error, dev nvme0n1, sector 53953576
[  308.694377] blk_update_request: I/O error, dev nvme0n1, sector 54249336
[  308.694459] blk_update_request: I/O error, dev nvme0n1, sector 53783656
[  308.694463] blk_update_request: I/O error, dev nvme0n1, sector 53784200
[  308.694467] blk_update_request: I/O error, dev nvme0n1, sector 505367392
[  308.713493] nvme nvme0: RECV for CQE 0xffff960decb919f8 failed with status WR flushed (5)
[  308.713538] BUG: unable to handle kernel paging request at 00000026e802b800
[  308.713540] IP: 0x26e802b800
[  308.713540] PGD 3a7b81067 
[  308.713541] PUD 0 
[  308.713541] 
[  308.713542] Oops: 0010 [#1] SMP
[  308.713543] Modules linked in: 8021q garp mrp stp llc nvme_rdma nvme_fabrics nvme_core rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm iw_cxgb4 ib_core libcxgb intel_rapl x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ipmi_ssif ghash_clmulni_intel pcbc iTCO_wdt aesni_intel hpilo hpwdt iTCO_vendor_support crypto_simd ipmi_si glue_helper cryptd sg gpio_ich pcc_cpufreq nfsd ipmi_devintf ie31200_edac ipmi_msghandler acpi_cpufreq pcspkr shpchp lpc_ich edac_core acpi_power_meter auth_rpcgss nfs_acl lockd grace sunrpc ip_tables xfs libcrc32c sd_mod mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrec
 t sysimgblt
[  308.713565]  fb_sys_fops ttm drm ahci tg3 libahci ptp libata cxgb4 crc32c_intel i2c_core serio_raw pps_core dm_mirror dm_region_hash dm_log dm_mod
[  308.713571] CPU: 5 PID: 422 Comm: kworker/u128:4 Not tainted 4.11.0-rc7+ #1
[  308.713572] Hardware name: HP ProLiant DL320e Gen8, BIOS J05 11/09/2013
[  308.713576] Workqueue: iw_cxgb4 process_work [iw_cxgb4]
[  308.713577] task: ffff960dec53da00 task.stack: ffffadce433ec000
[  308.713577] RIP: 0010:0x26e802b800
[  308.713578] RSP: 0000:ffff960df6743ee8 EFLAGS: 00010286
[  308.713578] RAX: ffff960d64490160 RBX: 0000000000000000 RCX: 0000000000000000
[  308.713579] RDX: 0000000000000001 RSI: ffff960dce59a400 RDI: ffff960deb801400
[  308.713579] RBP: ffff960df6743f20 R08: 0000000000000000 R09: 000000000000000c
[  308.713580] R10: ffff960dce59e560 R11: 0000000000000000 R12: 0000000000000040
[  308.713580] R13: 0000000000000001 R14: 0000000000000080 R15: ffff960deb801400
[  308.713581] FS:  0000000000000000(0000) GS:ffff960df6740000(0000) knlGS:0000000000000000
[  308.713581] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  308.713582] CR2: 00000026e802b800 CR3: 000000040e427000 CR4: 00000000001406e0
[  308.713582] Call Trace:
[  308.713583]  <IRQ>
[  308.713589]  ? __ib_process_cq+0x5c/0xd0 [ib_core]
[  308.713592]  ib_poll_handler+0x22/0x70 [ib_core]
[  308.713596]  irq_poll_softirq+0xaf/0x110
[  308.713599]  __do_softirq+0xc9/0x28c
[  308.713600]  do_softirq_own_stack+0x1c/0x30
[  308.713600]  </IRQ>
[  308.713602]  do_softirq+0x50/0x60
[  308.713603]  __local_bh_enable_ip+0x85/0x90
[  308.713607]  t4_ofld_send+0x114/0x180 [cxgb4]
[  308.713610]  cxgb4_remove_tid+0x93/0x130 [cxgb4]
[  308.713613]  _c4iw_free_ep+0x59/0x110 [iw_cxgb4]
[  308.713615]  close_con_rpl+0xb3/0x1b0 [iw_cxgb4]
[  308.713617]  ? kfree+0x133/0x180
[  308.713620]  ? process_work+0x4f/0x60 [iw_cxgb4]
[  308.713621]  ? kmem_cache_free+0x1db/0x1f0
[  308.713623]  ? process_work+0x4f/0x60 [iw_cxgb4]
[  308.713625]  ? skb_dequeue+0x59/0x70
[  308.713627]  process_work+0x43/0x60 [iw_cxgb4]
[  308.713628]  process_one_work+0x165/0x410
[  308.713629]  worker_thread+0x137/0x4c0
[  308.713630]  kthread+0x109/0x140
[  308.713631]  ? rescuer_thread+0x3b0/0x3b0
[  308.713632]  ? kthread_park+0x90/0x90
[  308.713633]  ret_from_fork+0x2c/0x40
[  308.713634] Code:  Bad RIP value.
[  308.713635] RIP: 0x26e802b800 RSP: ffff960df6743ee8
[  308.713635] CR2: 00000026e802b800
[  308.713651] ---[ end trace 8c635389637eeb24 ]---
[  308.717566] ERST: [Firmware Warn]: Firmware does not respond in time.
[  308.720272] Kernel panic - not syncing: Fatal exception in interrupt
[  308.727476] Kernel Offset: 0x16400000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  310.993421] ---[ end Kernel panic - not syncing: Fatal exception in interrupt


Best Regards,
  Yi Zhang


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
