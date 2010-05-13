From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 2/3] mlx4: Default value for automatic completion vector
	selection
Date: Thu, 13 May 2010 12:25:17 +0300
Message-ID: <4BEBC57D.7000600@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When the vector number passed to mlx4_cq_alloc is MLX4_LEAST_ATTACHED_VECTOR (0xffffffff),
the driver selects the completion vector that has the least CQ's attached
to it and attaches the CQ to the chosen vector.
The mlx4_ib module receives a cq allocation request with IB_CQ_VECTOR_LEAST_ATTACHED as cq number,
it passes it to mlx4_core as MLX4_LEAST_ATTACHED_VECTOR.

Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c |    4 +++-
 drivers/net/mlx4/cq.c           |   27 +++++++++++++++++++++++----
 drivers/net/mlx4/mlx4.h         |    1 +
 include/linux/mlx4/device.h     |    2 ++
 4 files changed, 29 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index cc2ddd2..ac6b866 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -223,7 +223,9 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev, int entries, int vector
 	}
 
 	err = mlx4_cq_alloc(dev->dev, entries, &cq->buf.mtt, uar,
-			    cq->db.dma, &cq->mcq, vector, 0);
+			    cq->db.dma, &cq->mcq,
+			    vector == IB_CQ_VECTOR_LEAST_ATTACHED ?
+			    MLX4_LEAST_ATTACHED_VECTOR : vector, 0);
 	if (err)
 		goto err_dbmap;
 
diff --git a/drivers/net/mlx4/cq.c b/drivers/net/mlx4/cq.c
index 7cd34e9..a6f03f9 100644
--- a/drivers/net/mlx4/cq.c
+++ b/drivers/net/mlx4/cq.c
@@ -187,6 +187,22 @@ int mlx4_cq_resize(struct mlx4_dev *dev, struct mlx4_cq *cq,
 }
 EXPORT_SYMBOL_GPL(mlx4_cq_resize);
 
+static int mlx4_find_least_loaded_vector(struct mlx4_priv *priv)
+{
+	int i;
+	int index = 0;
+	int min = priv->eq_table.eq[0].load;
+
+	for (i = 1; i < priv->dev.caps.num_comp_vectors; i++) {
+		if (priv->eq_table.eq[i].load < min) {
+			index = i;
+			min = priv->eq_table.eq[i].load;
+		}
+	}
+
+	return index;
+}
+
 int mlx4_cq_alloc(struct mlx4_dev *dev, int nent, struct mlx4_mtt *mtt,
 		  struct mlx4_uar *uar, u64 db_rec, struct mlx4_cq *cq,
 		  unsigned vector, int collapsed)
@@ -198,10 +214,11 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent, struct mlx4_mtt *mtt,
 	u64 mtt_addr;
 	int err;
 
-	if (vector >= dev->caps.num_comp_vectors)
-		return -EINVAL;
+	cq->vector = (vector == MLX4_LEAST_ATTACHED_VECTOR) ?
+		mlx4_find_least_loaded_vector(priv) : vector;
 
-	cq->vector = vector;
+	if (cq->vector >= dev->caps.num_comp_vectors)
+		return -EINVAL;
 
 	cq->cqn = mlx4_bitmap_alloc(&cq_table->bitmap);
 	if (cq->cqn == -1)
@@ -232,7 +249,7 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent, struct mlx4_mtt *mtt,
 
 	cq_context->flags	    = cpu_to_be32(!!collapsed << 18);
 	cq_context->logsize_usrpage = cpu_to_be32((ilog2(nent) << 24) | uar->index);
-	cq_context->comp_eqn	    = priv->eq_table.eq[vector].eqn;
+	cq_context->comp_eqn	    = priv->eq_table.eq[cq->vector].eqn;
 	cq_context->log_page_size   = mtt->page_shift - MLX4_ICM_PAGE_SHIFT;
 
 	mtt_addr = mlx4_mtt_addr(dev, mtt);
@@ -245,6 +262,7 @@ int mlx4_cq_alloc(struct mlx4_dev *dev, int nent, struct mlx4_mtt *mtt,
 	if (err)
 		goto err_radix;
 
+	priv->eq_table.eq[cq->vector].load++;
 	cq->cons_index = 0;
 	cq->arm_sn     = 1;
 	cq->uar        = uar;
@@ -282,6 +300,7 @@ void mlx4_cq_free(struct mlx4_dev *dev, struct mlx4_cq *cq)
 		mlx4_warn(dev, "HW2SW_CQ failed (%d) for CQN %06x\n", err, cq->cqn);
 
 	synchronize_irq(priv->eq_table.eq[cq->vector].irq);
+	priv->eq_table.eq[cq->vector].load--;
 
 	spin_lock_irq(&cq_table->lock);
 	radix_tree_delete(&cq_table->tree, cq->cqn);
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index bc72d6e..969a6a7 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -137,6 +137,7 @@ struct mlx4_eq {
 	u16			irq;
 	u16			have_irq;
 	int			nent;
+	int			load;
 	struct mlx4_buf_list   *page_list;
 	struct mlx4_mtt		mtt;
 };
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index e92d1bf..89ae31d 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -171,6 +171,8 @@ enum {
 	MLX4_NUM_FEXCH          = 64 * 1024,
 };
 
+#define MLX4_LEAST_ATTACHED_VECTOR	0xffffffff
+
 static inline u64 mlx4_fw_ver(u64 major, u64 minor, u64 subminor)
 {
 	return (major << 32) | (minor << 16) | subminor;
-- 
1.6.1.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
