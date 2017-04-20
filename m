From: Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: kernel NULL pointer during reset_controller operation with IO on
 4.11.0-rc7
Date: Thu, 20 Apr 2017 02:03:39 -0400 (EDT)
Message-ID: <1413097100.14743757.1492668219336.JavaMail.zimbra@redhat.com>
References: <1575599772.13802712.1492592011810.JavaMail.zimbra@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1575599772.13802712.1492592011810.JavaMail.zimbra-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Hi

I reproduced two different kernel NULL pointer during reset_controller operation with IO on 4.11.0-rc7, here is the steps and kernel log, thanks

Reproduce steps:
1. Configure NVMe over RDMA on target
#nvmetcli restore rdma.json
2. connect to target on client
#nvme connect-all -t rdam -a $IP -s 4420
3. reset_controller during IO on client
#!/bin/bash
num=0
fio -filename=/dev/nvme0n1 -iodepth=1 -thread -rw=randwrite -ioengine=psync -bssplit=5k/10:9k/10:13k/10:17k/10:21k/10:25k/10:29k/10:33k/10:37k/10:41k/10 -bs_unaligned -runtime=300 -size=-group_reporting -name=mytest -numjobs=60 &
sleep 5
while [ $num -lt 50 ]
do
	echo 1 >/sys/block/nvme0n1/device/reset_controller
	[ $? -eq 1 ] && echo "reset_controller operation failed: $num" && exit 1
	((num++))
	sleep 0.5
done

RMDA device:
04:00.0 Infiniband controller: Mellanox Technologies MT27700 Family [ConnectX-4]
04:00.1 Infiniband controller: Mellanox Technologies MT27700 Family [ConnectX-4]
05:00.0 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]
05:00.1 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx]

Kernel log
[1]
[ 5968.515237] DMAR: DRHD: handling fault status reg 2
[ 5968.519449] mlx5_2:dump_cqe:262:(pid 0): dump error cqe
[ 5968.519450] 00000000 00000000 00000000 00000000
[ 5968.519451] 00000000 00000000 00000000 00000000
[ 5968.519451] 00000000 00000000 00000000 00000000
[ 5968.519452] 00000000 02005104 00000316 a71710e3
[ 5968.546797] DMAR: [DMA Read] Request device [05:00.0] fault addr ab978000 [fault reason 06] PTE Read access is not set
[ 5999.693035] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
[ 5999.701799] IP: 0x1
[ 5999.704142] PGD 0 
[ 5999.704143] 
[ 5999.708052] Oops: 0010 [#1] SMP
[ 5999.711562] Modules linked in: sch_mqprio bridge 8021q garp mrp stp llc nvme_rdma nvme_fabrics nvme_core rpcrdma ib_isert iscsi_target_mod ib_isee
[ 5999.791200]  drm tg3 devlink ahci libahci ptp libata crc32c_intel i2c_core pps_core dm_mirror dm_region_hash dm_log dm_mod
[ 5999.803558] CPU: 16 PID: 3839 Comm: kworker/16:1H Not tainted 4.11.0-rc7+ #1
[ 5999.811440] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.6.2 01/08/2016
[ 5999.819812] Workqueue: kblockd blk_mq_timeout_work
[ 5999.825848] task: ffff93c9258f8000 task.stack: ffffbc26a13f8000
[ 5999.833113] RIP: 0010:0x1
[ 5999.836684] RSP: 0018:ffffbc26a13fbca8 EFLAGS: 00010202
[ 5999.843170] RAX: ffff93c91a776000 RBX: ffff93c917a33600 RCX: ffff93ca3fa00000
[ 5999.851789] RDX: ffffbc26a13fbcb0 RSI: ffffbc26a13fbcb8 RDI: ffff93c91a777c00
[ 5999.860395] RBP: ffffbc26a13fbd08 R08: 000000000000ffff R09: 0000000000000000
[ 5999.869001] R10: 00000574e9925428 R11: 0000000000000020 R12: ffff93c92e22cbd0
[ 5999.877616] R13: ffff93da3e3fc000 R14: ffff93c9facd5000 R15: ffff93c9179efc00
[ 5999.886235] FS:  0000000000000000(0000) GS:ffff93ca3fa00000(0000) knlGS:0000000000000000
[ 5999.895934] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[ 5999.903021] CR2: 0000000000000001 CR3: 0000000fd5e72000 CR4: 00000000001406e0
[ 5999.911676] Call Trace:
[ 5999.915091]  ? nvme_rdma_unmap_data+0x126/0x1b0 [nvme_rdma]
[ 5999.922014]  nvme_rdma_complete_rq+0x1c/0xa0 [nvme_rdma]
[ 5999.928654]  __blk_mq_complete_request+0xb9/0x130
[ 5999.934615]  blk_mq_rq_timed_out+0x66/0x70
[ 5999.939900]  blk_mq_check_expired+0x37/0x60
[ 5999.945277]  bt_iter+0x48/0x50
[ 5999.949387]  blk_mq_queue_tag_busy_iter+0xdd/0x1f0
[ 5999.955440]  ? blk_mq_rq_timed_out+0x70/0x70
[ 5999.960912]  ? blk_mq_rq_timed_out+0x70/0x70
[ 5999.966378]  blk_mq_timeout_work+0x88/0x170
[ 5999.971734]  process_one_work+0x165/0x410
[ 5999.976884]  worker_thread+0x137/0x4c0
[ 5999.981740]  kthread+0x109/0x140
[ 5999.986002]  ? rescuer_thread+0x3b0/0x3b0
[ 5999.991293]  ? kthread_park+0x90/0x90
[ 5999.996202]  ret_from_fork+0x2c/0x40
[ 6000.001023] Code:  Bad RIP value.
[ 6000.005395] RIP: 0x1 RSP: ffffbc26a13fbca8
[ 6000.010641] CR2: 0000000000000001
[ 6000.017674] ---[ end trace aefe12bb2d39bb6c ]---
[ 6000.025847] Kernel panic - not syncing: Fatal exception
[ 6000.032339] Kernel Offset: 0x7800000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[ 6000.047129] ---[ end Kernel panic - not syncing: Fatal exception

[2]
[  181.885449] nvme nvme0: new ctrl: NQN "nqn.2014-08.org.nvmexpress.discovery", addr 172.31.45.92:4420
[  182.051854] nvme nvme0: creating 40 I/O queues.
[  183.196669] nvme nvme0: new ctrl: NQN "testnqn", addr 172.31.45.92:4420
[  335.152533] DMAR: DRHD: handling fault status reg 2
[  335.155522] mlx5_2:dump_cqe:262:(pid 0): dump error cqe
[  335.155523] 00000000 00000000 00000000 00000000
[  335.155523] 00000000 00000000 00000000 00000000
[  335.155524] 00000000 00000000 00000000 00000000
[  335.155524] 00000000 02005104 00000313 2d56a1e3
[  335.184087] DMAR: [DMA Read] Request device [05:00.0] fault addr afe64000 [fault reason 06] PTE Read access is not set
[  335.565825] nvme nvme0: creating 40 I/O queues.
[  335.946585] DMAR: DRHD: handling fault status reg 102
[  335.948848] mlx5_2:dump_cqe:262:(pid 0): dump error cqe
[  335.948849] 00000000 00000000 00000000 00000000
[  335.948849] 00000000 00000000 00000000 00000000
[  335.948849] 00000000 00000000 00000000 00000000
[  335.948850] 00000000 02005104 0000033e 123982e2
[  335.978349] DMAR: [DMA Read] Request device [05:00.0] fault addr af0c6000 [fault reason 06] PTE Read access is not set
[  336.286112] nvme nvme0: creating 40 I/O queues.
[  336.976392] nvme nvme0: creating 40 I/O queues.
[  337.329610] mlx5_2:dump_cqe:262:(pid 0): dump error cqe
[  337.335456] 00000000 00000000 00000000 00000000
[  337.340521] 00000000 00000000 00000000 00000000
[  337.345586] 00000000 00000000 00000000 00000000
[  337.350651] 00000000 93005204 0000038c 052a29e3
[  337.623917] nvme nvme0: creating 40 I/O queues.
[  338.286747] nvme nvme0: creating 40 I/O queues.
[  338.647457] DMAR: DRHD: handling fault status reg 202
[  338.649077] mlx5_2:dump_cqe:262:(pid 0): dump error cqe
[  338.649078] 00000000 00000000 00000000 00000000
[  338.649079] 00000000 00000000 00000000 00000000
[  338.649079] 00000000 00000000 00000000 00000000
[  338.649080] 00000000 02005104 000003dc 096258e2
[  338.681899] DMAR: [DMA Read] Request device [05:00.0] fault addr adaf8000 [fault reason 06] PTE Read access is not set
[  339.003086] nvme nvme0: creating 40 I/O queues.
[  341.419403] BUG: unable to handle kernel NULL pointer dereference at 0000000000000001
[  341.428698] IP: 0x1
[  341.431518] PGD 0 
[  341.431519] 
[  341.436353] Oops: 0010 [#1] SMP
[  341.440319] Modules linked in: sch_mqprio bridge 8021q garp mrp stp llc nvme_rdma nvme_fabrics nvme_core rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srpe
[  341.523752]  drm tg3 ahci devlink libahci ptp libata crc32c_intel i2c_core pps_core dm_mirror dm_region_hash dm_log dm_mod
[  341.536724] CPU: 29 PID: 859 Comm: kworker/u82:2 Not tainted 4.11.0-rc7+ #1
[  341.545128] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.6.2 01/08/2016
[  341.554122] Workqueue: writeback wb_workfn (flush-259:0)
[  341.560683] task: ffff94c637484380 task.stack: ffffb6d08ed1c000
[  341.567928] RIP: 0010:0x1
[  341.571481] RSP: 0018:ffffb6d08ed1f670 EFLAGS: 00010282
[  341.577959] RAX: ffff94c63e6cb800 RBX: ffff94b53080cd20 RCX: 0000000000000001
[  341.586589] RDX: ffffb6d08ed1f678 RSI: ffff94c62c3413a8 RDI: ffff94c63e6ce400
[  341.595227] RBP: ffffb6d08ed1f6c0 R08: ffff94c62c3413a8 R09: 0000000000000000
[  341.603848] R10: 0000000000000000 R11: 0000000000000000 R12: ffff94b4e5620fc0
[  341.612459] R13: ffff94c63a39c000 R14: 0000000000000002 R15: ffff94c62c341200
[  341.621069] FS:  0000000000000000(0000) GS:ffff94c63f380000(0000) knlGS:0000000000000000
[  341.630754] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
[  341.637822] CR2: 0000000000000001 CR3: 00000008d5c09000 CR4: 00000000001406e0
[  341.646457] Call Trace:
[  341.649862]  ? nvme_rdma_post_send+0x9b/0x100 [nvme_rdma]
[  341.656577]  nvme_rdma_queue_rq+0x2fb/0x680 [nvme_rdma]
[  341.663085]  blk_mq_try_issue_directly+0xbb/0x110
[  341.668995]  blk_mq_make_request+0x354/0x620
[  341.674424]  generic_make_request+0x110/0x2c0
[  341.679947]  submit_bio+0x75/0x150
[  341.684400]  submit_bh_wbc+0x141/0x180
[  341.689244]  __block_write_full_page+0x13d/0x3b0
[  341.695068]  ? I_BDEV+0x20/0x20
[  341.699244]  ? I_BDEV+0x20/0x20
[  341.703411]  block_write_full_page+0xdc/0x100
[  341.708946]  blkdev_writepage+0x18/0x20
[  341.713898]  __writepage+0x13/0x40
[  341.718357]  write_cache_pages+0x26f/0x510
[  341.723593]  ? compound_head+0x20/0x20
[  341.728447]  generic_writepages+0x51/0x80
[  341.733600]  ? __wake_up_common+0x55/0x90
[  341.738753]  blkdev_writepages+0x2f/0x40
[  341.743795]  do_writepages+0x1e/0x30
[  341.748429]  __writeback_single_inode+0x45/0x330
[  341.754221]  writeback_sb_inodes+0x280/0x570
[  341.759616]  __writeback_inodes_wb+0x8c/0xc0
[  341.765015]  wb_writeback+0x276/0x310
[  341.769742]  wb_workfn+0x19c/0x3b0
[  341.774178]  process_one_work+0x165/0x410
[  341.779274]  worker_thread+0x137/0x4c0
[  341.784061]  kthread+0x109/0x140
[  341.788243]  ? rescuer_thread+0x3b0/0x3b0
[  341.793279]  ? kthread_park+0x90/0x90
[  341.797905]  ret_from_fork+0x2c/0x40
[  341.802414] Code:  Bad RIP value.
[  341.806612] RIP: 0x1 RSP: ffffb6d08ed1f670
[  341.811663] CR2: 0000000000000001
[  341.815833] ---[ end trace 9a64941b3df0eb88 ]---
[  341.878226] Kernel panic - not syncing: Fatal exception
[  341.884533] Kernel Offset: 0x12800000 from 0xffffffff81000000 (relocation range: 0xffffffff80000000-0xffffffffbfffffff)
[  341.917376] ---[ end Kernel panic - not syncing: Fatal exception


Best Regards,
  Yi Zhang


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
