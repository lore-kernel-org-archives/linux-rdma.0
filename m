From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH WIP 43/43] iser: Move unaligned counter increment
Date: Wed, 22 Jul 2015 09:55:43 +0300
Message-ID: <1437548143-24893-44-git-send-email-sagig@mellanox.com>
References: <1437548143-24893-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1437548143-24893-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Oren Duer <oren-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We don't always use bounce buffers, still we update
this counter.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 690f840..4d3dc1c 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -487,11 +487,8 @@ static int fall_to_bounce_buf(struct iscsi_iser_task *iser_task,
 			      struct iser_data_buf *mem,
 			      enum iser_data_dir cmd_dir)
 {
-	struct iscsi_conn *iscsi_conn = iser_task->iser_conn->iscsi_conn;
 	struct iser_device *device = iser_task->iser_conn->ib_conn.device;
 
-	iscsi_conn->fmr_unalign_cnt++;
-
 	if (iser_debug_level > 0)
 		iser_data_buf_dump(mem, device->ib_device);
 
@@ -781,6 +778,7 @@ iser_handle_unaligned_buf(struct iscsi_iser_task *task,
 	aligned_len = iser_data_buf_aligned_len(mem, device->ib_device,
 						iser_conn->scsi_sg_tablesize);
 	if (aligned_len != mem->dma_nents) {
+		iser_conn->iscsi_conn->fmr_unalign_cnt++;
 		if (device->dev_attr.device_cap_flags & IB_DEVICE_MAP_ARB_SG)
 			/* Arbitrary sg support, no need to bounce :) */
 			return 0;
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
