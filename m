From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [PATCH mlx5-next 4/4] net/mlx5: Remove spinlock support from mlx5_write64
Date: Fri, 18 Jan 2019 16:33:13 -0800
Message-ID: <20190119003313.16711-5-saeedm@mellanox.com>
References: <20190119003313.16711-1-saeedm@mellanox.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20190119003313.16711-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: Leon Romanovsky <leonro@mellanox.com>, saeedm@mellanox.com
Cc: netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Jason Gunthorpe <jgg@mellanox.com>, Maxim Mikityanskiy <maximmi@mellanox.com>, Eran Ben Elisha <eranbe@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Maxim Mikityanskiy <maximmi@mellanox.com>

As there is no user of mlx5_write64 that passes a spinlock to
mlx5_write64, remove this functionality and simplify the function.

Signed-off-by: Maxim Mikityanskiy <maximmi@mellanox.com>
Reviewed-by: Eran Ben Elisha <eranbe@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c               |  2 +-
 drivers/net/ethernet/mellanox/mlx5/core/en.h  |  2 +-
 .../ethernet/mellanox/mlx5/core/fpga/conn.c   |  2 +-
 include/linux/mlx5/cq.h                       |  2 +-
 include/linux/mlx5/doorbell.h                 | 28 ++++---------------
 5 files changed, 9 insertions(+), 27 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index dd2ae640bc84..816c34ee91cf 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -5015,7 +5015,7 @@ static int _mlx5_ib_post_send(struct ib_qp *ibqp, const struct ib_send_wr *wr,
 		wmb();
 
 		/* currently we support only regular doorbells */
-		mlx5_write64((__be32 *)ctrl, bf->bfreg->map + bf->offset, NULL);
+		mlx5_write64((__be32 *)ctrl, bf->bfreg->map + bf->offset);
 		/* Make sure doorbells don't leak out of SQ spinlock
 		 * and reach the HCA out of order.
 		 */
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en.h b/drivers/net/ethernet/mellanox/mlx5/core/en.h
index 8fa8fdd30b85..2623d3fb6b96 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en.h
@@ -916,7 +916,7 @@ void mlx5e_notify_hw(struct mlx5_wq_cyc *wq, u16 pc,
 	 */
 	wmb();
 
-	mlx5_write64((__be32 *)ctrl, uar_map, NULL);
+	mlx5_write64((__be32 *)ctrl, uar_map);
 }
 
 static inline void mlx5e_cq_arm(struct mlx5e_cq *cq)
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index 873541ef4c1b..ca2296a2f9ee 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -135,7 +135,7 @@ static void mlx5_fpga_conn_notify_hw(struct mlx5_fpga_conn *conn, void *wqe)
 	*conn->qp.wq.sq.db = cpu_to_be32(conn->qp.sq.pc);
 	/* Make sure that doorbell record is visible before ringing */
 	wmb();
-	mlx5_write64(wqe, conn->fdev->conn_res.uar->map + MLX5_BF_OFFSET, NULL);
+	mlx5_write64(wqe, conn->fdev->conn_res.uar->map + MLX5_BF_OFFSET);
 }
 
 static void mlx5_fpga_conn_post_send(struct mlx5_fpga_conn *conn,
diff --git a/include/linux/mlx5/cq.h b/include/linux/mlx5/cq.h
index 612c8c2f2466..769326ea1d9b 100644
--- a/include/linux/mlx5/cq.h
+++ b/include/linux/mlx5/cq.h
@@ -170,7 +170,7 @@ static inline void mlx5_cq_arm(struct mlx5_core_cq *cq, u32 cmd,
 	doorbell[0] = cpu_to_be32(sn << 28 | cmd | ci);
 	doorbell[1] = cpu_to_be32(cq->cqn);
 
-	mlx5_write64(doorbell, uar_page + MLX5_CQ_DOORBELL, NULL);
+	mlx5_write64(doorbell, uar_page + MLX5_CQ_DOORBELL);
 }
 
 static inline void mlx5_cq_hold(struct mlx5_core_cq *cq)
diff --git a/include/linux/mlx5/doorbell.h b/include/linux/mlx5/doorbell.h
index 9ef3f9d00154..c12523cc8102 100644
--- a/include/linux/mlx5/doorbell.h
+++ b/include/linux/mlx5/doorbell.h
@@ -36,38 +36,20 @@
 #define MLX5_BF_OFFSET	      0x800
 #define MLX5_CQ_DOORBELL      0x20
 
-#if BITS_PER_LONG == 64
 /* Assume that we can just write a 64-bit doorbell atomically.  s390
  * actually doesn't have writeq() but S/390 systems don't even have
- * PCI so we won't worry about it.
+ * PCI so we won't worry about it. Note that the write is not atomic
+ * on 32-bit systems.
  */
 
-static inline void mlx5_write64(__be32 val[2], void __iomem *dest,
-				spinlock_t *doorbell_lock)
+static inline void mlx5_write64(__be32 val[2], void __iomem *dest)
 {
+#if BITS_PER_LONG == 64
 	__raw_writeq(*(u64 *)val, dest);
-}
-
 #else
-
-/* Just fall back to a spinlock to protect the doorbell if
- * BITS_PER_LONG is 32 -- there's no portable way to do atomic 64-bit
- * MMIO writes.
- */
-
-static inline void mlx5_write64(__be32 val[2], void __iomem *dest,
-				spinlock_t *doorbell_lock)
-{
-	unsigned long flags;
-
-	if (doorbell_lock)
-		spin_lock_irqsave(doorbell_lock, flags);
 	__raw_writel((__force u32) val[0], dest);
 	__raw_writel((__force u32) val[1], dest + 4);
-	if (doorbell_lock)
-		spin_unlock_irqrestore(doorbell_lock, flags);
-}
-
 #endif
+}
 
 #endif /* MLX5_DOORBELL_H */
-- 
2.20.1
