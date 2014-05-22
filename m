From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/5] IB/mlx5: Add MR to radix tree in reg_mr_callback
Date: Thu, 22 May 2014 14:50:09 +0300
Message-ID: <1400759412-13205-3-git-send-email-haggaie@mellanox.com>
References: <1400759412-13205-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1400759412-13205-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

For memory regions that are allocated using reg_umr, the suffix of
mlx5_core_create_mkey isn't being called. Instead the creation is completed in
a callback function (reg_mr_callback). This means that these MRs aren't being
added to the MR radix tree. The patch add them in the callback.

Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mr.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index ad58985..9d932a2 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -73,6 +73,8 @@ static void reg_mr_callback(int status, void *context)
 	struct mlx5_cache_ent *ent = &cache->ent[c];
 	u8 key;
 	unsigned long flags;
+	struct mlx5_mr_table *table = &dev->mdev.priv.mr_table;
+	int err;
 
 	spin_lock_irqsave(&ent->lock, flags);
 	ent->pending--;
@@ -107,6 +109,13 @@ static void reg_mr_callback(int status, void *context)
 	ent->cur++;
 	ent->size++;
 	spin_unlock_irqrestore(&ent->lock, flags);
+
+	write_lock_irqsave(&table->lock, flags);
+	err = radix_tree_insert(&table->tree, mlx5_base_mkey(mr->mmr.key),
+				&mr->mmr);
+	if (err)
+		pr_err("Error inserting to mr tree. 0x%x\n", -err);
+	write_unlock_irqrestore(&table->lock, flags);
 }
 
 static int add_keys(struct mlx5_ib_dev *dev, int c, int num)
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
