From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 1/8] IB/SRP: Avoid using IB_MR_TYPE_SG_GAPS
Date: Tue, 14 Feb 2017 10:56:29 -0800
Message-ID: <20170214185636.29250-2-bart.vanassche@sandisk.com>
References: <20170214185636.29250-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170214185636.29250-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, "# 4 . 7+" <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Tests have shown that the following error message is reported when
using SG-GAPS registration with an mlx5 adapter:

scsi host1: ib_srp: failed RECV status WR flushed (5) for CQE ffff880bd4270eb0
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 0f007806 2500002a ad9fafd1
scsi host1: ib_srp: reconnect succeeded
mlx5_0:dump_cqe:262:(pid 7369): dump error cqe
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 00000000 00000000 00000000
00000000 0f007806 25000032 00105dd0
scsi host1: ib_srp: failed FAST REG status memory management operation error (6) for CQE ffff880b92860138

Hence avoid using SG-GAPS memory registrations. Additionally,
always configure the blk_queue_virt_boundary() to avoid to trigger
a mapping failure when using adapters that support SG-GAPS (e.g.
mlx5).

Fixes: commit ad8e66b4a801 ("IB/srp: fix mr allocation when the device supports sg gaps")
Fixes: commit 509c5f33f4f6 ("IB/srp: Prevent mapping failures")
Reported-by: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Israel Rukshin <israelr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Max Gurtovoy <maxg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 4.7+
---
 drivers/infiniband/ulp/srp/ib_srp.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 79bf48477ddb..07e3613e4798 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -371,7 +371,6 @@ static struct srp_fr_pool *srp_create_fr_pool(struct ib_device *device,
 	struct srp_fr_desc *d;
 	struct ib_mr *mr;
 	int i, ret = -EINVAL;
-	enum ib_mr_type mr_type;
 
 	if (pool_size <= 0)
 		goto err;
@@ -385,13 +384,9 @@ static struct srp_fr_pool *srp_create_fr_pool(struct ib_device *device,
 	spin_lock_init(&pool->lock);
 	INIT_LIST_HEAD(&pool->free_list);
 
-	if (device->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG)
-		mr_type = IB_MR_TYPE_SG_GAPS;
-	else
-		mr_type = IB_MR_TYPE_MEM_REG;
-
 	for (i = 0, d = &pool->desc[0]; i < pool->size; i++, d++) {
-		mr = ib_alloc_mr(pd, mr_type, max_page_list_len);
+		mr = ib_alloc_mr(pd, IB_MR_TYPE_MEM_REG,
+				 max_page_list_len);
 		if (IS_ERR(mr)) {
 			ret = PTR_ERR(mr);
 			if (ret == -ENOMEM)
@@ -2666,7 +2661,7 @@ static int srp_slave_alloc(struct scsi_device *sdev)
 	struct srp_device *srp_dev = target->srp_host->srp_dev;
 	struct ib_device *ibdev = srp_dev->dev;
 
-	if (!(ibdev->attrs.device_cap_flags & IB_DEVICE_SG_GAPS_REG))
+	if (true)
 		blk_queue_virt_boundary(sdev->request_queue,
 					~srp_dev->mr_page_mask);
 
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
