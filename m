From: Eli Cohen <eli-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH for-next 01/14] IB/mlx5: Remove unused coded in mr.c
Date: Tue, 14 Jan 2014 17:45:10 +0200
Message-ID: <1389714323-20130-2-git-send-email-eli@mellanox.com>
References: <1389714323-20130-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1389714323-20130-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org, ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The variable start in struct mlx5_ib_mr is never used. Remove it.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h | 1 -
 drivers/infiniband/hw/mlx5/mr.c      | 1 -
 2 files changed, 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 4c134d9..5acef30 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -264,7 +264,6 @@ struct mlx5_ib_mr {
 	enum ib_wc_status	status;
 	struct mlx5_ib_dev     *dev;
 	struct mlx5_create_mkey_mbox_out out;
-	unsigned long		start;
 };
 
 struct mlx5_ib_fast_reg_page_list {
diff --git a/drivers/infiniband/hw/mlx5/mr.c b/drivers/infiniband/hw/mlx5/mr.c
index 039c3e4..7c95ca1 100644
--- a/drivers/infiniband/hw/mlx5/mr.c
+++ b/drivers/infiniband/hw/mlx5/mr.c
@@ -146,7 +146,6 @@ static int add_keys(struct mlx5_ib_dev *dev, int c, int num)
 		spin_lock_irq(&ent->lock);
 		ent->pending++;
 		spin_unlock_irq(&ent->lock);
-		mr->start = jiffies;
 		err = mlx5_core_create_mkey(&dev->mdev, &mr->mmr, in,
 					    sizeof(*in), reg_mr_callback,
 					    mr, &mr->out);
-- 
1.8.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
