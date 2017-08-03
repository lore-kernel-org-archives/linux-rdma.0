From: "Steve Wise" <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: Flush warning
Date: Thu, 3 Aug 2017 13:32:46 -0500
Message-ID: <016301d30c86$e7034ae0$b509e0a0$@opengridcomputing.com>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagi grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hey guys,

We're seeing a WARNING happening when running an fio test on a single NVMF
attached ramdisk over iw_cxgb4.  While the fio test is running, the NVMF host is
also killing the controller via writing to
/sys/block/nvme*/device/reset_controller.  Here is the script:

----
[root@trinitycraft ~]# cat fio_issue.sh
num=0

fio --rw=randrw --name=random --norandommap --ioengine=libaio --size=400m
--group_reporting --exitall --fsync_on_close=1 --invalidate=1 --direct=1
--filename=/dev/nvme0n1 --time_based --runtime=30 --iodepth=32 --numjobs=8
--unit_base=1 --bs=4k --kb_base=1000 &

sleep 2
while [ $num -lt 30 ]
do
        echo 1 >/sys/block/nvme0n1/device/reset_controller
        [ $? -eq 1 ] && echo "reset_controller operation failed: $num" && exit 1
        ((num++))
        sleep 0.5
done
-----

The WARNING seems to be due to nvmet_rdma_queue_connect() calling
flush_scheduled_work() while in the upcall from the RDMA_CM.  It I running on
the iw_cm event workqueue, which is created with WQ_MEM_RECLAIM set.  I'm not
sure what this WARNING is telling me.  Does the iw_cm workqueue NOT need
WQ_MEM_RECLAIM set?  Or is there some other issue with the nvmet/rdma code doing
work flushing in the iw_cm workq context?

This is with 4.12.0.

Any thoughts?  Thanks!

Steve.

---

[ 1887.155804] workqueue: WQ_MEM_RECLAIM iw_cm_wq:cm_work_handler [iw_cm] is
flushing !WQ_MEM_RECLAIM events:          (null)
[ 1887.155811] ------------[ cut here ]------------
[ 1887.155816] WARNING: CPU: 6 PID: 3355 at kernel/workqueue.c:2423
check_flush_dependency+0xa9/0x100
[ 1887.155817] Modules linked in: nvmet_rdma nvmet rdma_ucm ib_uverbs iw_cxgb4
cxgb4 brd rdma_cm iw_cm ib_cm ib_core libcxgb xt_CHECKSUM iptable_mangle
ipt_MASQUERADE nf_nat_masquerade_ipv4 iptable_nat nf_nat_ipv4 nf_nat
nf_conntrack_ipv4 nf_defrag_ipv4 xt_conntrack nf_conntrack libcrc32c ipt_REJECT
nf_reject_ipv4 fuse tun bridge stp llc ebtable_filter ebtables ip6table_filter
ip6_tables iptable_filter intel_rapl sb_edac x86_pkg_temp_thermal
intel_powerclamp coretemp kvm_intel kvm iTCO_wdt iTCO_vendor_support mxm_wmi
irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel pcbc nvme nvme_core
aesni_intel mei_me crypto_simd ipmi_si glue_helper cryptd mei pcspkr sg ioatdma
lpc_ich ipmi_devintf shpchp i2c_i801 mfd_core ipmi_msghandler wmi acpi_pad
acpi_power_meter nfsd auth_rpcgss nfs_acl lockd grace
[ 1887.155849]  sunrpc ip_tables ext4 jbd2 mbcache sd_mod ast drm_kms_helper
syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm igb ahci libahci ptp
libata crc32c_intel pps_core dca i2c_algo_bit i2c_core dm_mirror dm_region_hash
dm_log dm_mod dax [last unloaded: nvmet]
[ 1887.155863] CPU: 6 PID: 3355 Comm: kworker/u32:1 Not tainted 4.12.0 #1
[ 1887.155864] Hardware name: Supermicro X10DRi/X10DRi, BIOS 2.1 09/13/2016
[ 1887.155866] Workqueue: iw_cm_wq cm_work_handler [iw_cm]
[ 1887.155867] task: ffff944585015700 task.stack: ffffb36b47604000
[ 1887.155869] RIP: 0010:check_flush_dependency+0xa9/0x100
[ 1887.155870] RSP: 0018:ffffb36b476079f8 EFLAGS: 00010246
[ 1887.155871] RAX: 000000000000006e RBX: ffff943d9f808e00 RCX: ffffffff8cc605a8
[ 1887.155872] RDX: 0000000000000000 RSI: 0000000000000082 RDI: 0000000000000202
[ 1887.155873] RBP: ffffb36b47607a10 R08: 000000000000006e R09: 00000000000005e9
[ 1887.155873] R10: 0000000000000000 R11: 000000000000006e R12: ffff943d92c72e40
[ 1887.155874] R13: 0000000000000000 R14: 0000000000000006 R15: ffffb36b47607a50
[ 1887.155875] FS:  0000000000000000(0000) GS:ffff9445bfc80000(0000)
knlGS:0000000000000000
[ 1887.155876] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 1887.155877] CR2: 00000000006e8430 CR3: 0000000160c09000 CR4: 00000000001406e0
[ 1887.155878] Call Trace:
[ 1887.155881]  flush_workqueue+0x15a/0x490
[ 1887.155885]  nvmet_rdma_queue_connect+0x7cf/0xc70 [nvmet_rdma]
[ 1887.155887]  ? nvmet_rdma_cm_reject+0xa0/0xa0 [nvmet_rdma]
[ 1887.155888]  nvmet_rdma_cm_handler+0x12f/0x2f0 [nvmet_rdma]
[ 1887.155893]  iw_conn_req_handler+0x186/0x230 [rdma_cm]
[ 1887.155894]  cm_work_handler+0xcef/0xd10 [iw_cm]
[ 1887.155897]  process_one_work+0x149/0x360
[ 1887.155898]  worker_thread+0x4d/0x3c0
[ 1887.155901]  kthread+0x109/0x140
[ 1887.155902]  ? rescuer_thread+0x380/0x380
[ 1887.155903]  ? kthread_park+0x60/0x60
[ 1887.155907]  ? do_syscall_64+0x67/0x150
[ 1887.155910]  ret_from_fork+0x25/0x30
[ 1887.155911] Code: 49 8b 54 24 18 48 8d 8b b0 00 00 00 48 81 c6 b0 00 00 00 4d
89 e8 48 c7 c7 c0 fc a2 8c 31 c0 c6 05 bd 62 c6 00 01 e8 31 82 10 00 <0f> ff e9
77 ff ff ff 45 31 ed e9 66 ff ff ff 80 3d a3 62 c6 00
[ 1887.155926] ---[ end trace c67d348e72eb38e9 ]---

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
