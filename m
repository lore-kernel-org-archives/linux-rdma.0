From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 16/20 v2] rdma/mlx4: Add support for XRC domains
Date: Fri, 19 Aug 2011 02:14:06 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41A7A@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Support creating and destroying XRC domains.  Any sharing of the
xrcd is managed above the low-level driver.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    |   59 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/hw/mlx4/mlx4_ib.h |   12 +++++++
 drivers/net/mlx4/fw.c                |    6 +++
 drivers/net/mlx4/fw.h                |    2 +
 drivers/net/mlx4/main.c              |   18 ++++++++++
 drivers/net/mlx4/mlx4.h              |    3 ++
 drivers/net/mlx4/pd.c                |   30 +++++++++++++++++
 include/linux/mlx4/device.h          |    5 +++
 8 files changed, 134 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index fbe1973..1b911aa 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -566,6 +566,57 @@ static int mlx4_ib_dealloc_pd(struct ib_pd *pd)
 	return 0;
 }
 
+static struct ib_xrcd *mlx4_ib_alloc_xrcd(struct ib_device *ibdev,
+					  struct ib_ucontext *context,
+					  struct ib_udata *udata)
+{
+	struct mlx4_ib_xrcd *xrcd;
+	int err;
+
+	if (!(to_mdev(ibdev)->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC))
+		return ERR_PTR(-ENOSYS);
+
+	xrcd = kmalloc(sizeof *xrcd, GFP_KERNEL);
+	if (!xrcd)
+		return ERR_PTR(-ENOMEM);
+
+	err = mlx4_xrcd_alloc(to_mdev(ibdev)->dev, &xrcd->xrcdn);
+	if (err)
+		goto err1;
+
+	xrcd->pd = ib_alloc_pd(ibdev);
+	if (IS_ERR(xrcd->pd)) {
+		err = PTR_ERR(xrcd->pd);
+		goto err2;
+	}
+
+	xrcd->cq = ib_create_cq(ibdev, NULL, NULL, xrcd, 1, 0);
+	if (IS_ERR(xrcd->cq)) {
+		err = PTR_ERR(xrcd->cq);
+		goto err3;
+	}
+
+	return &xrcd->ibxrcd;
+
+err3:
+	ib_dealloc_pd(xrcd->pd);
+err2:
+	mlx4_xrcd_free(to_mdev(ibdev)->dev, xrcd->xrcdn);
+err1:
+	kfree(xrcd);
+	return ERR_PTR(err);
+}
+
+static int mlx4_ib_dealloc_xrcd(struct ib_xrcd *xrcd)
+{
+	ib_destroy_cq(to_mxrcd(xrcd)->cq);
+	ib_dealloc_pd(to_mxrcd(xrcd)->pd);
+	mlx4_xrcd_free(to_mdev(xrcd->device)->dev, to_mxrcd(xrcd)->xrcdn);
+	kfree(xrcd);
+
+	return 0;
+}
+
 static int add_gid_entry(struct ib_qp *ibqp, union ib_gid *gid)
 {
 	struct mlx4_ib_qp *mqp = to_mqp(ibqp);
@@ -1093,6 +1144,14 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.unmap_fmr		= mlx4_ib_unmap_fmr;
 	ibdev->ib_dev.dealloc_fmr	= mlx4_ib_fmr_dealloc;
 
+	if (dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC) {
+		ibdev->ib_dev.alloc_xrcd = mlx4_ib_alloc_xrcd;
+		ibdev->ib_dev.dealloc_xrcd = mlx4_ib_dealloc_xrcd;
+		ibdev->ib_dev.uverbs_cmd_mask |=
+			(1ull << IB_USER_VERBS_CMD_OPEN_XRCD) |
+			(1ull << IB_USER_VERBS_CMD_CLOSE_XRCD);
+	}
+
 	spin_lock_init(&iboe->lock);
 
 	if (init_node_data(ibdev))
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 2a322f2..57ea82d 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -56,6 +56,13 @@ struct mlx4_ib_pd {
 	u32			pdn;
 };
 
+struct mlx4_ib_xrcd {
+	struct ib_xrcd		ibxrcd;
+	u32			xrcdn;
+	struct ib_pd	       *pd;
+	struct ib_cq	       *cq;
+};
+
 struct mlx4_ib_cq_buf {
 	struct mlx4_buf		buf;
 	struct mlx4_mtt		mtt;
@@ -210,6 +217,11 @@ static inline struct mlx4_ib_pd *to_mpd(struct ib_pd *ibpd)
 	return container_of(ibpd, struct mlx4_ib_pd, ibpd);
 }
 
+static inline struct mlx4_ib_xrcd *to_mxrcd(struct ib_xrcd *ibxrcd)
+{
+	return container_of(ibxrcd, struct mlx4_ib_xrcd, ibxrcd);
+}
+
 static inline struct mlx4_ib_cq *to_mcq(struct ib_cq *ibcq)
 {
 	return container_of(ibcq, struct mlx4_ib_cq, ibcq);
diff --git a/drivers/net/mlx4/fw.c b/drivers/net/mlx4/fw.c
index 67a209b..8462ef3 100644
--- a/drivers/net/mlx4/fw.c
+++ b/drivers/net/mlx4/fw.c
@@ -199,6 +199,8 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 #define QUERY_DEV_CAP_MAX_MCG_OFFSET		0x63
 #define QUERY_DEV_CAP_RSVD_PD_OFFSET		0x64
 #define QUERY_DEV_CAP_MAX_PD_OFFSET		0x65
+#define QUERY_DEV_CAP_RSVD_XRC_OFFSET		0x66
+#define QUERY_DEV_CAP_MAX_XRC_OFFSET		0x67
 #define QUERY_DEV_CAP_RDMARC_ENTRY_SZ_OFFSET	0x80
 #define QUERY_DEV_CAP_QPC_ENTRY_SZ_OFFSET	0x82
 #define QUERY_DEV_CAP_AUX_ENTRY_SZ_OFFSET	0x84
@@ -317,6 +319,10 @@ int mlx4_QUERY_DEV_CAP(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	dev_cap->reserved_pds = field >> 4;
 	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_PD_OFFSET);
 	dev_cap->max_pds = 1 << (field & 0x3f);
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_RSVD_XRC_OFFSET);
+	dev_cap->reserved_xrcds = field >> 4;
+	MLX4_GET(field, outbox, QUERY_DEV_CAP_MAX_PD_OFFSET);
+	dev_cap->max_xrcds = 1 << (field & 0x1f);
 
 	MLX4_GET(size, outbox, QUERY_DEV_CAP_RDMARC_ENTRY_SZ_OFFSET);
 	dev_cap->rdmarc_entry_sz = size;
diff --git a/drivers/net/mlx4/fw.h b/drivers/net/mlx4/fw.h
index 88003eb..60c5747 100644
--- a/drivers/net/mlx4/fw.h
+++ b/drivers/net/mlx4/fw.h
@@ -98,6 +98,8 @@ struct mlx4_dev_cap {
 	int max_mcgs;
 	int reserved_pds;
 	int max_pds;
+	int reserved_xrcds;
+	int max_xrcds;
 	int qpc_entry_sz;
 	int rdmarc_entry_sz;
 	int altc_entry_sz;
diff --git a/drivers/net/mlx4/main.c b/drivers/net/mlx4/main.c
index 3814fc9..a48e81e 100644
--- a/drivers/net/mlx4/main.c
+++ b/drivers/net/mlx4/main.c
@@ -219,6 +219,10 @@ static int mlx4_dev_cap(struct mlx4_dev *dev, struct mlx4_dev_cap *dev_cap)
 	dev->caps.reserved_mrws	     = dev_cap->reserved_mrws;
 	dev->caps.reserved_uars	     = dev_cap->reserved_uars;
 	dev->caps.reserved_pds	     = dev_cap->reserved_pds;
+	dev->caps.reserved_xrcds     = (dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC) ?
+					dev_cap->reserved_xrcds : 0;
+	dev->caps.max_xrcds          = (dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC) ?
+					dev_cap->max_xrcds : 0;
 	dev->caps.mtt_entry_sz	     = dev->caps.mtts_per_seg * dev_cap->mtt_entry_sz;
 	dev->caps.max_msg_sz         = dev_cap->max_msg_sz;
 	dev->caps.page_size_cap	     = ~(u32) (dev_cap->min_page_sz - 1);
@@ -875,11 +879,18 @@ static int mlx4_setup_hca(struct mlx4_dev *dev)
 		goto err_kar_unmap;
 	}
 
+	err = mlx4_init_xrcd_table(dev);
+	if (err) {
+		mlx4_err(dev, "Failed to initialize "
+			 "reliable connection domain table, aborting.\n");
+		goto err_pd_table_free;
+	}
+
 	err = mlx4_init_mr_table(dev);
 	if (err) {
 		mlx4_err(dev, "Failed to initialize "
 			 "memory region table, aborting.\n");
-		goto err_pd_table_free;
+		goto err_xrcd_table_free;
 	}
 
 	err = mlx4_init_eq_table(dev);
@@ -987,6 +998,9 @@ err_eq_table_free:
 err_mr_table_free:
 	mlx4_cleanup_mr_table(dev);
 
+err_xrcd_table_free:
+	mlx4_cleanup_xrcd_table(dev);
+
 err_pd_table_free:
 	mlx4_cleanup_pd_table(dev);
 
@@ -1306,6 +1320,7 @@ err_port:
 	mlx4_cmd_use_polling(dev);
 	mlx4_cleanup_eq_table(dev);
 	mlx4_cleanup_mr_table(dev);
+	mlx4_cleanup_xrcd_table(dev);
 	mlx4_cleanup_pd_table(dev);
 	mlx4_cleanup_uar_table(dev);
 
@@ -1366,6 +1381,7 @@ static void mlx4_remove_one(struct pci_dev *pdev)
 		mlx4_cmd_use_polling(dev);
 		mlx4_cleanup_eq_table(dev);
 		mlx4_cleanup_mr_table(dev);
+		mlx4_cleanup_xrcd_table(dev);
 		mlx4_cleanup_pd_table(dev);
 
 		iounmap(priv->kar);
diff --git a/drivers/net/mlx4/mlx4.h b/drivers/net/mlx4/mlx4.h
index dd7d745..8186891 100644
--- a/drivers/net/mlx4/mlx4.h
+++ b/drivers/net/mlx4/mlx4.h
@@ -335,6 +335,7 @@ struct mlx4_priv {
 	struct mlx4_cmd		cmd;
 
 	struct mlx4_bitmap	pd_bitmap;
+	struct mlx4_bitmap	xrcd_bitmap;
 	struct mlx4_uar_table	uar_table;
 	struct mlx4_mr_table	mr_table;
 	struct mlx4_cq_table	cq_table;
@@ -383,6 +384,7 @@ int mlx4_alloc_eq_table(struct mlx4_dev *dev);
 void mlx4_free_eq_table(struct mlx4_dev *dev);
 
 int mlx4_init_pd_table(struct mlx4_dev *dev);
+int mlx4_init_xrcd_table(struct mlx4_dev *dev);
 int mlx4_init_uar_table(struct mlx4_dev *dev);
 int mlx4_init_mr_table(struct mlx4_dev *dev);
 int mlx4_init_eq_table(struct mlx4_dev *dev);
@@ -392,6 +394,7 @@ int mlx4_init_srq_table(struct mlx4_dev *dev);
 int mlx4_init_mcg_table(struct mlx4_dev *dev);
 
 void mlx4_cleanup_pd_table(struct mlx4_dev *dev);
+void mlx4_cleanup_xrcd_table(struct mlx4_dev *dev);
 void mlx4_cleanup_uar_table(struct mlx4_dev *dev);
 void mlx4_cleanup_mr_table(struct mlx4_dev *dev);
 void mlx4_cleanup_eq_table(struct mlx4_dev *dev);
diff --git a/drivers/net/mlx4/pd.c b/drivers/net/mlx4/pd.c
index 1286b88..3736163 100644
--- a/drivers/net/mlx4/pd.c
+++ b/drivers/net/mlx4/pd.c
@@ -61,6 +61,24 @@ void mlx4_pd_free(struct mlx4_dev *dev, u32 pdn)
 }
 EXPORT_SYMBOL_GPL(mlx4_pd_free);
 
+int mlx4_xrcd_alloc(struct mlx4_dev *dev, u32 *xrcdn)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	*xrcdn = mlx4_bitmap_alloc(&priv->xrcd_bitmap);
+	if (*xrcdn == -1)
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(mlx4_xrcd_alloc);
+
+void mlx4_xrcd_free(struct mlx4_dev *dev, u32 xrcdn)
+{
+	mlx4_bitmap_free(&mlx4_priv(dev)->xrcd_bitmap, xrcdn);
+}
+EXPORT_SYMBOL_GPL(mlx4_xrcd_free);
+
 int mlx4_init_pd_table(struct mlx4_dev *dev)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
@@ -74,6 +92,18 @@ void mlx4_cleanup_pd_table(struct mlx4_dev *dev)
 	mlx4_bitmap_cleanup(&mlx4_priv(dev)->pd_bitmap);
 }
 
+int mlx4_init_xrcd_table(struct mlx4_dev *dev)
+{
+	struct mlx4_priv *priv = mlx4_priv(dev);
+
+	return mlx4_bitmap_init(&priv->xrcd_bitmap, (1 << 16),
+				(1 << 16) - 1, dev->caps.reserved_xrcds + 1, 0);
+}
+
+void mlx4_cleanup_xrcd_table(struct mlx4_dev *dev)
+{
+	mlx4_bitmap_cleanup(&mlx4_priv(dev)->xrcd_bitmap);
+}
 
 int mlx4_uar_alloc(struct mlx4_dev *dev, struct mlx4_uar *uar)
 {
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 8985768..33a3516 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -61,6 +61,7 @@ enum {
 	MLX4_DEV_CAP_FLAG_RC		= 1 <<  0,
 	MLX4_DEV_CAP_FLAG_UC		= 1 <<  1,
 	MLX4_DEV_CAP_FLAG_UD		= 1 <<  2,
+	MLX4_DEV_CAP_FLAG_XRC		= 1 <<  3,
 	MLX4_DEV_CAP_FLAG_SRQ		= 1 <<  6,
 	MLX4_DEV_CAP_FLAG_IPOIB_CSUM	= 1 <<  7,
 	MLX4_DEV_CAP_FLAG_BAD_PKEY_CNTR	= 1 <<  8,
@@ -250,6 +251,8 @@ struct mlx4_caps {
 	int			num_qp_per_mgm;
 	int			num_pds;
 	int			reserved_pds;
+	int			max_xrcds;
+	int			reserved_xrcds;
 	int			mtt_entry_sz;
 	u32			max_msg_sz;
 	u32			page_size_cap;
@@ -486,6 +489,8 @@ static inline void *mlx4_buf_offset(struct mlx4_buf *buf, int offset)
 
 int mlx4_pd_alloc(struct mlx4_dev *dev, u32 *pdn);
 void mlx4_pd_free(struct mlx4_dev *dev, u32 pdn);
+int mlx4_xrcd_alloc(struct mlx4_dev *dev, u32 *xrcdn);
+void mlx4_xrcd_free(struct mlx4_dev *dev, u32 xrcdn);
 
 int mlx4_uar_alloc(struct mlx4_dev *dev, struct mlx4_uar *uar);
 void mlx4_uar_free(struct mlx4_dev *dev, struct mlx4_uar *uar);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
