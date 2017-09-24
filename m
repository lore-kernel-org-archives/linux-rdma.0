From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: Re: nvmeof rdma regression issue on 4.14.0-rc1 (or maybe mlx4?)
Date: Sun, 24 Sep 2017 10:38:39 +0300
Message-ID: <47493aa0-4cad-721b-4ea2-c3b2293340aa@grimberg.me>
References: <1735134433.8514119.1505997532669.JavaMail.zimbra@redhat.com>
 <1215229914.8516804.1505998051674.JavaMail.zimbra@redhat.com>
 <20170921144421.GA15285@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170921144421.GA15285-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Yi Zhang <yizhan-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

> Adding linux-rdma, the dma mappings happen in the mlx4 driver

...

>> [  293.209662] DMAR: ERROR: DMA PTE for vPFN 0xe0f59 already set (to 10369a9001 not 10115ed001)
>> [  293.219117] ------------[ cut here ]------------
>> [  293.224284] WARNING: CPU: 14 PID: 751 at drivers/iommu/intel-iommu.c:2305 __domain_mapping+0x367/0x380
>> [  293.234698] Modules linked in: nvme_rdma nvme_fabrics nvme_core sch_mqprio ebtable_filter ebtables ip6table_filter ip6_tables iptable_filter bridge 8021q garp mrp stp llc rpcrdma ib_isert iscsi_target_mod ib_iser libiscsi scsi_transport_iscsi ib_srpt target_core_mod ib_srp scsi_transport_srp ib_ipoib rdma_ucm ib_ucm ib_uverbs ib_umad rdma_cm ib_cm iw_cm mlx4_ib ib_core intel_rapl ipmi_ssif sb_edac x86_pkg_temp_thermal intel_powerclamp coretemp kvm_intel kvm irqbypass crct10dif_pclmul crc32_pclmul ghash_clmulni_intel intel_cstate intel_uncore iTCO_wdt ipmi_si intel_rapl_perf iTCO_vendor_support ipmi_devintf dcdbas sg pcspkr ipmi_msghandler ioatdma mei_me mei dca shpchp lpc_ich acpi_pad acpi_power_meter wmi nfsd auth_rpcgss nfs_acl lockd grace sunrpc binfmt_misc ip_tables xfs libcrc32c
  mlx4_en sd_mod
>> [  293.313884]  mgag200 i2c_algo_bit drm_kms_helper syscopyarea sysfillrect sysimgblt fb_sys_fops ttm drm mlx4_core tg3 ahci libahci ptp libata i2c_core crc32c_intel devlink pps_core dm_mirror dm_region_hash dm_log dm_mod
>> [  293.335583] CPU: 14 PID: 751 Comm: kworker/u369:7 Not tainted 4.14.0-rc1 #2
>> [  293.343374] Hardware name: Dell Inc. PowerEdge R430/03XKDV, BIOS 1.6.2 01/08/2016
>> [  293.351750] Workqueue: nvme-wq nvme_rdma_reconnect_ctrl_work [nvme_rdma]
>> [  293.359249] task: ffff881032ecdd00 task.stack: ffffc900084d8000
>> [  293.365873] RIP: 0010:__domain_mapping+0x367/0x380
>> [  293.371230] RSP: 0018:ffffc900084dbc60 EFLAGS: 00010202
>> [  293.377075] RAX: 0000000000000004 RBX: 00000010115ed001 RCX: 0000000000000000
>> [  293.385056] RDX: 0000000000000000 RSI: ffff88103e7ce038 RDI: ffff88103e7ce038
>> [  293.393040] RBP: ffffc900084dbcc0 R08: 0000000000000000 R09: 0000000000000000
>> [  293.401024] R10: 00000000000002f7 R11: 00000000010115ed R12: ffff88103b9e1ac8
>> [  293.409744] R13: 0000000000000001 R14: 0000000000000001 R15: 00000000000e0f59
>> [  293.418456] FS:  0000000000000000(0000) GS:ffff88103e7c0000(0000) knlGS:0000000000000000
>> [  293.428229] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
>> [  293.435391] CR2: 0000154ecabc9140 CR3: 0000001005709001 CR4: 00000000001606e0
>> [  293.444112] Call Trace:
>> [  293.447594]  __intel_map_single+0xeb/0x180
>> [  293.452918]  intel_map_page+0x39/0x40
>> [  293.457765]  mlx4_ib_alloc_mr+0x141/0x220 [mlx4_ib]
>> [  293.463965]  ib_alloc_mr+0x26/0x50 [ib_core]
>> [  293.469471]  nvme_rdma_reinit_request+0x3a/0x70 [nvme_rdma]
>> [  293.476433]  ? nvme_rdma_free_ctrl+0xb0/0xb0 [nvme_rdma]
>> [  293.483100]  blk_mq_reinit_tagset+0x5c/0x90
>> [  293.488508]  nvme_rdma_configure_io_queues+0x211/0x290 [nvme_rdma]
>> [  293.496152]  nvme_rdma_reconnect_ctrl_work+0x5b/0xd0 [nvme_rdma]
>> [  293.503598]  process_one_work+0x149/0x360
>> [  293.508815]  worker_thread+0x4d/0x3c0
>> [  293.513638]  kthread+0x109/0x140
>> [  293.517973]  ? rescuer_thread+0x380/0x380
>> [  293.523176]  ? kthread_park+0x60/0x60
>> [  293.527993]  ret_from_fork+0x25/0x30

Is it possible that ib_dereg_mr failed?

can you please apply the following patch and report if you see a warning?
--
diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 92a03ff5fb4d..ef50b58b0bb6 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -274,7 +274,7 @@ static int nvme_rdma_reinit_request(void *data, 
struct request *rq)
         struct nvme_rdma_request *req = blk_mq_rq_to_pdu(rq);
         int ret = 0;

-       ib_dereg_mr(req->mr);
+       WARN_ON_ONCE(ib_dereg_mr(req->mr));

         req->mr = ib_alloc_mr(dev->pd, IB_MR_TYPE_MEM_REG,
                         ctrl->max_fr_pages);
--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
