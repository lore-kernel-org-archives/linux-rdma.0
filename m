From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 2/3] net/mlx4_core: Implement srq object lookup from srqn
Date: Wed, 10 Apr 2013 17:26:47 +0300
Message-ID: <1365604008-22455-3-git-send-email-ogerlitz@mellanox.com>
References: <1365604008-22455-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1365604008-22455-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, shlomop-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org, Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Expose a new API mlx4_srq_lookup to retrive a SRQ based on its number.
This API is needed in the mlx4_ib driver CQ polling logic, when a
work completion is associated with a XRC TGT QP. Since a target QP
may redirect to more than one XRC SRQ, the srq field in the QP has
no usage and the real XRC SRQ need to be retrived using the information
from the XRCETH IB header which is placed in the HW CQE.

Signed-off-by: Shlomo Pongratz <shlomop-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/net/ethernet/mellanox/mlx4/srq.c |   15 +++++++++++++++
 include/linux/mlx4/srq.h                 |    2 ++
 2 files changed, 17 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/srq.c b/drivers/net/ethernet/mellanox/mlx4/srq.c
index e329fe1..79fd269 100644
--- a/drivers/net/ethernet/mellanox/mlx4/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/srq.c
@@ -298,3 +298,18 @@ void mlx4_cleanup_srq_table(struct mlx4_dev *dev)
 		return;
 	mlx4_bitmap_cleanup(&mlx4_priv(dev)->srq_table.bitmap);
 }
+
+struct mlx4_srq *mlx4_srq_lookup(struct mlx4_dev *dev, u32 srqn)
+{
+	struct mlx4_srq_table *srq_table = &mlx4_priv(dev)->srq_table;
+	struct mlx4_srq *srq;
+	unsigned long flags;
+
+	spin_lock_irqsave(&srq_table->lock, flags);
+	srq = radix_tree_lookup(&srq_table->tree,
+				srqn & (dev->caps.num_srqs - 1));
+	spin_unlock_irqrestore(&srq_table->lock, flags);
+
+	return srq;
+}
+EXPORT_SYMBOL_GPL(mlx4_srq_lookup);
diff --git a/include/linux/mlx4/srq.h b/include/linux/mlx4/srq.h
index 799a069..192e0f7 100644
--- a/include/linux/mlx4/srq.h
+++ b/include/linux/mlx4/srq.h
@@ -39,4 +39,6 @@ struct mlx4_wqe_srq_next_seg {
 	u32			reserved2[3];
 };
 
+struct mlx4_srq *mlx4_srq_lookup(struct mlx4_dev *dev, u32 srqn);
+
 #endif /* MLX4_SRQ_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
