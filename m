From: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Subject: [PATCH 01/19 V4] mlx4_core: identify function as pf or vf
Date: Thu, 10 Jun 2010 21:58:56 +0300
Message-ID: <4C1135F0.3060406@mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Liran Liss <liranl-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
Signed-off-by: Yevgeny Petrilin <yevgenyp-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
---
 include/linux/mlx4/device.h |   19 +++++++++++++++++++
 1 files changed, 19 insertions(+), 0 deletions(-)

diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 7a7f9c1..84de4a6 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -42,6 +42,9 @@
 enum {
 	MLX4_FLAG_MSI_X		= 1 << 0,
 	MLX4_FLAG_OLD_PORT_CMDS	= 1 << 1,
+	MLX4_FLAG_MASTER	= 1 << 2,
+	MLX4_FLAG_SLAVE		= 1 << 3,
+	MLX4_FLAG_SRIOV		= 1 << 4,
 };
 
 enum {
@@ -376,6 +379,7 @@ struct mlx4_av {
 struct mlx4_dev {
 	struct pci_dev	       *pdev;
 	unsigned long		flags;
+	unsigned long		num_slaves;
 	struct mlx4_caps	caps;
 	struct radix_tree_root	qp_table_tree;
 	u32			rev_id;
@@ -401,6 +405,21 @@ struct mlx4_init_port_param {
 		if (((type) == MLX4_PORT_TYPE_IB ? (dev)->caps.port_mask : \
 		     ~(dev)->caps.port_mask) & 1 << ((port) - 1))
 
+static inline int mlx4_is_slave(struct mlx4_dev *dev)
+{
+	return dev->flags & MLX4_FLAG_SLAVE;
+}
+
+static inline int mlx4_is_master(struct mlx4_dev *dev)
+{
+	return dev->flags & MLX4_FLAG_MASTER;
+}
+
+static inline int mlx4_is_mfunc(struct mlx4_dev *dev)
+{
+	return dev->flags & (MLX4_FLAG_MASTER | MLX4_FLAG_SLAVE);
+}
+
 int mlx4_buf_alloc(struct mlx4_dev *dev, int size, int max_direct,
 		   struct mlx4_buf *buf);
 void mlx4_buf_free(struct mlx4_dev *dev, int size, struct mlx4_buf *buf);
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
