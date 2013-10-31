From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 1/6] IB/mlx5: Remove dead code
Date: Thu, 31 Oct 2013 15:26:31 +0200
Message-ID: <1383225996-14828-2-git-send-email-eli@mellanox.com>
References: <1383225996-14828-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1383225996-14828-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yevgenyp-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The value of the local variable index is never used in reg_mr_callback().

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 5 -----
 1 file changed, 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 2c4626f..2fa54d1 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -73,13 +73,8 @@ static void reg_mr_callback(int status, void *context)
 	struct mlx5_cache_ent *ent = &cache->ent[c];
 	u8 key;
 	unsigned long delta = jiffies - mr->start;
-	unsigned long index;
 	unsigned long flags;
 
-	index = find_last_bit(&delta, 8 * sizeof(delta));
-	if (index == 64)
-		index = 0;
-
 	spin_lock_irqsave(&ent->lock, flags);
 	ent->pending--;
 	spin_unlock_irqrestore(&ent->lock, flags);
-- 
1.8.4.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
