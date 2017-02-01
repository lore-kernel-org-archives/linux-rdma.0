From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: Re: iSER fails to release rdma resources (WRs) if iw_cxgb4 is
 unloaded while IO is in progress
Date: Wed, 1 Feb 2017 17:17:39 +0200
Message-ID: <49223bb6-e2a1-eee7-cf4e-701957e6727f@mellanox.com>
References: <CY1PR12MB077405C1FA5279D200AD3089BC4D0@CY1PR12MB0774.namprd12.prod.outlook.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
        boundary="------------837C7D55C691C7053700761A"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CY1PR12MB077405C1FA5279D200AD3089BC4D0-1s8aH8ViOEdztePUUsNjzQdYzm3356FpvxpqHgZTriW3zl9H0oFU5g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Raju Rangoju <rajur-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: SWise OGC <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Potnuri Bharat Teja <bharat-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

--------------837C7D55C691C7053700761A
Content-Type: text/plain; charset="windows-1252"; format=flowed
Content-Transfer-Encoding: 7bit

hi Raju,
please apply the attached patch I want to push soon (still haven't find 
the chance to test it).
I'm not sure it will solve your problem but let's try it.

thanks,
Max.

On 2/1/2017 11:08 AM, Raju  Rangoju wrote:
>
> Hello Sagi,
>
> I intermittently see an issue with iser when unloading the iw_cxgb4 module while traffic is running. Apparently the rdma resources are not getting released when the iser receives RDMA_CM_EVENT_DEVICE_REMOVAL event while the IO in progress. iser_cma_handler() upon receiving the DEVICE_REMOVAL event, destroys the device by calling iser_cleanup_handler(). iser_free_ib_conn_res() destroys the qp and calls iser_free_fastreg_pool() to free the Memory Regions in the fastreg_pool list, and then it calls ib_dealloc_pd.
>
> Issue:
>
> iSCSI uses its .xmit_task and .cleanup_task callbacks to get/put MRs from iser fr_pool(fastreg_pool) during the normal IO, at this point if the DEVICE_REMOVAL event is received, iser_cma_handler()->iser_cleanup_handler() it simply releases the available MRs in the fr_pool list (some MRs may have been moved to running task list) and eventually calls ib_dealloc_pd, which ends up hitting kernel panic as some registered MRs are not freed up.
>
> iser_free_fastreg_pool() complains about the registered regions; "pool still has %d regions registered"
>
> Trace:
>
> iser: iser_free_fastreg_pool: pool still has 1 regions registered
> iser: iser_device_try_release: device ffff880508660080 refcount 0
> iw_cxgb4:c4iw_destroy_cq ib_cq ffff8803f3addc00
> iw_cxgb4:c4iw_wait_for_reply add wr_waitp ffffc9000dd83a28
> ------------[ cut here ]------------
> WARNING: CPU: 7 PID: 14790 at drivers/infiniband/core/verbs.c:305 ib_dealloc_pd+0x87/0xd0 [ib_core]
> Modules linked in: rdma_ucm ib_uverbs iw_cxgb4(OE-) autofs4 target_core_iblock target_core_file target_core_pscsi target_core_mod bnx2fc fcoe libfcoe 8021q libfc garp stp llc scsi_transport_fc cpufreq_ondemand be2iscsi iscsi_boot_sysfs bnx2i cnic uio cxgb3i libcxgbi iw_cxgb3 cxgb3 mdio libcxgb ib_iser rdma_cm ib_cm iw_cm ib_core configfs ipv6 crc_ccitt iscsi_tcp libiscsi_tcp libiscsi scsi_transport_iscsi uinput ppdev iTCO_wdt iTCO_vendor_support serio_raw pcspkr parport_pc parport tpm_infineon sg i2c_i801 i2c_core lpc_ich mfd_core e1000e acpi_cpufreq i7core_edac edac_core ioatdma dca ext4(E) mbcache(E) jbd2(E) sd_mod(E) pata_acpi(E) ata_generic(E) ata_piix(E) floppy(E) cxgb4(OE) ptp(E) pps_core(E) dm_mirror(E) dm_region_hash(E) dm_log(E) dm_mod(E)
> CPU: 7 PID: 14790 Comm: rmmod Tainted: G           OE   4.10.0-rc4+ #22
> Hardware name: Supermicro X8ST3/X8ST3, BIOS 2.0        07/29/10
> Call Trace:
> dump_stack+0x51/0x78
> __warn+0xfd/0x120
> warn_slowpath_null+0x1d/0x20
> ib_dealloc_pd+0x87/0xd0 [ib_core]
> ? ib_unregister_event_handler+0x6d/0x80 [ib_core]
> ? mutex_lock+0x16/0x40
> iser_device_try_release+0x81/0x120 [ib_iser]
> ? iser_free_rx_descriptors+0xd3/0xf0 [ib_iser]
> iser_free_ib_conn_res+0x75/0xb0 [ib_iser]
> iser_cleanup_handler+0x41/0x70 [ib_iser]
> iser_cma_handler+0x1c9/0x220 [ib_iser]
> cma_remove_id_dev+0x8f/0xa0 [rdma_cm]
> cma_process_remove+0x127/0x170 [rdma_cm]
> ? kobject_cleanup+0x82/0x1b0
> ? kobject_release+0xd/0x10
> cma_remove_one+0x6f/0x90 [rdma_cm]
> ib_unregister_device+0xe7/0x190 [ib_core]
> c4iw_unregister_device+0x79/0x90 [iw_cxgb4]
> c4iw_remove+0x45/0x6c [iw_cxgb4]
> c4iw_exit_module+0x31/0x75 [iw_cxgb4]
> SyS_delete_module+0x183/0x1d0
> ? syscall_trace_enter+0x154/0x1f0
> ? SyS_munmap+0x6e/0x90
> do_syscall_64+0x6c/0x160
> entry_SYSCALL64_slow_path+0x25/0x25
> RIP: 0033:0x37d22e8ee7
> RSP: 002b:00007ffedd1877b8 EFLAGS: 00000206 ORIG_RAX: 00000000000000b0
> RAX: ffffffffffffffda RBX: 00007ffedd1877c0 RCX: 00000037d22e8ee7
> RDX: 00007ffedd1877af RSI: 0000000000000880 RDI: 00007ffedd1877c0
> RBP: 00007ffedd187810 R08: 00007f0120b48700 R09: 0000000000000100
> R10: 0000000000000011 R11: 0000000000000206 R12: 0000000000000880
> R13: 00007ffedd188735 R14: 0000000000000000 R15: 0000000000000001
> ---[ end trace 9bdbdddd5759d7e6 ]---
>
>
> Steps to reproduce:
> 1. Bring up the iser target setup
> 2. Bring up the iser initiator setup
> 3. From DUT(initiator) login to all the Targets and start IOzone traffic on all the mounted luns.
> 4. Now unload iw_cxgb4 module on the iser initiator setup.
>
>
> This is a generic issue, seen with other vendors also.
>
> Could you give me a few pointers on how to debug it further to address this issue?
> I am happy to provide any details further.
>
> Thank you for any help you can provide,
> -Raju
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
> the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

--------------837C7D55C691C7053700761A
Content-Type: text/plain; charset="UTF-8";
	name="0001-IB-iser-access-active_qps-atomically.patch"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="0001-IB-iser-access-active_qps-atomically.patch"

>From c1ec2dc3660fbd3e99dfc4aa3d766a526205aa6d Mon Sep 17 00:00:00 2001
From: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Wed, 1 Feb 2017 13:09:48 +0200
Subject: [PATCH 1/1] IB/iser: access active_qps field atomically

Signed-off-by: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_verbs.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index 6a9d1cb..30b622f 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -597,7 +597,9 @@ static void iser_free_ib_conn_res(struct iser_conn *iser_conn,
 		  iser_conn, ib_conn->cma_id, ib_conn->qp);
 
 	if (ib_conn->qp != NULL) {
+		mutex_lock(&ig.connlist_mutex);
 		ib_conn->comp->active_qps--;
+		mutex_unlock(&ig.connlist_mutex);
 		rdma_destroy_qp(ib_conn->cma_id);
 		ib_conn->qp = NULL;
 	}
-- 
1.7.1


--------------837C7D55C691C7053700761A--
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
