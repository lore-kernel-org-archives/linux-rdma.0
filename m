From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1 for-next 3/3] mlx4: Enhance the QP creation path to use a given GFP directive
Date: Sun, 11 May 2014 15:15:12 +0300
Message-ID: <1399810512-30774-4-git-send-email-ogerlitz@mellanox.com>
References: <1399810512-30774-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1399810512-30774-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, saeedm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>, Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>

Modify the various routines used to allocate memory resources which
serve QPs in mlx4 to get an input GFP directive. Have the Ethernet
driver to use GFP_KERNEL in it's QP allocations as done prior to
this commit, and the IB driver to use GFP_NOIO when the IB verbs
IB_QP_CREATE_USE_GFP_NOIO QP creation flag is provided.

Signed-off-by: Mel Gorman <mgorman-l3A5Bk7waGM@public.gmane.org>
Signed-off-by: Jiri Kosina <jkosina-AlSwsSmVLrQ@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c                    |    6 ++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h               |    1 +
 drivers/infiniband/hw/mlx4/qp.c                    |   30 +++++++++++--------
 drivers/infiniband/hw/mlx4/srq.c                   |    7 ++--
 drivers/net/ethernet/mellanox/mlx4/alloc.c         |   27 +++++++++--------
 drivers/net/ethernet/mellanox/mlx4/cq.c            |    4 +-
 drivers/net/ethernet/mellanox/mlx4/en_rx.c         |    6 ++--
 drivers/net/ethernet/mellanox/mlx4/en_tx.c         |    2 +-
 drivers/net/ethernet/mellanox/mlx4/icm.c           |    7 ++--
 drivers/net/ethernet/mellanox/mlx4/icm.h           |    3 +-
 drivers/net/ethernet/mellanox/mlx4/mlx4.h          |    4 +-
 drivers/net/ethernet/mellanox/mlx4/mr.c            |   17 ++++++-----
 drivers/net/ethernet/mellanox/mlx4/qp.c            |   20 ++++++------
 .../net/ethernet/mellanox/mlx4/resource_tracker.c  |    4 +-
 drivers/net/ethernet/mellanox/mlx4/srq.c           |    4 +-
 include/linux/mlx4/device.h                        |   10 ++++--
 16 files changed, 82 insertions(+), 70 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 5f64081..1066eec 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -102,7 +102,7 @@ static int mlx4_ib_alloc_cq_buf(struct mlx4_ib_dev *dev, struct mlx4_ib_cq_buf *
 	int err;
 
 	err = mlx4_buf_alloc(dev->dev, nent * dev->dev->caps.cqe_size,
-			     PAGE_SIZE * 2, &buf->buf);
+			     PAGE_SIZE * 2, &buf->buf, GFP_KERNEL);
 
 	if (err)
 		goto out;
@@ -113,7 +113,7 @@ static int mlx4_ib_alloc_cq_buf(struct mlx4_ib_dev *dev, struct mlx4_ib_cq_buf *
 	if (err)
 		goto err_buf;
 
-	err = mlx4_buf_write_mtt(dev->dev, &buf->mtt, &buf->buf);
+	err = mlx4_buf_write_mtt(dev->dev, &buf->mtt, &buf->buf, GFP_KERNEL);
 	if (err)
 		goto err_mtt;
 
@@ -209,7 +209,7 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev, int entries, int vector
 
 		uar = &to_mucontext(context)->uar;
 	} else {
-		err = mlx4_db_alloc(dev->dev, &cq->db, 1);
+		err = mlx4_db_alloc(dev->dev, &cq->db, 1, GFP_KERNEL);
 		if (err)
 			goto err_cq;
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index f589522..bb8c9dd 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -156,6 +156,7 @@ enum mlx4_ib_qp_flags {
 	MLX4_IB_QP_LSO = IB_QP_CREATE_IPOIB_UD_LSO,
 	MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK = IB_QP_CREATE_BLOCK_MULTICAST_LOOPBACK,
 	MLX4_IB_QP_NETIF = IB_QP_CREATE_NETIF_QP,
+	MLX4_IB_QP_CREATE_USE_GFP_NOIO = IB_QP_CREATE_USE_GFP_NOIO,
 	MLX4_IB_SRIOV_TUNNEL_QP = 1 << 30,
 	MLX4_IB_SRIOV_SQP = 1 << 31,
 };
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 41308af..8710baf 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -610,7 +610,8 @@ static int qp_has_rq(struct ib_qp_init_attr *attr)
 
 static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			    struct ib_qp_init_attr *init_attr,
-			    struct ib_udata *udata, int sqpn, struct mlx4_ib_qp **caller_qp)
+			    struct ib_udata *udata, int sqpn, struct mlx4_ib_qp **caller_qp,
+			    gfp_t gfp)
 {
 	int qpn;
 	int err;
@@ -748,14 +749,14 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			goto err;
 
 		if (qp_has_rq(init_attr)) {
-			err = mlx4_db_alloc(dev->dev, &qp->db, 0);
+			err = mlx4_db_alloc(dev->dev, &qp->db, 0, gfp);
 			if (err)
 				goto err;
 
 			*qp->db.db = 0;
 		}
 
-		if (mlx4_buf_alloc(dev->dev, qp->buf_size, PAGE_SIZE * 2, &qp->buf)) {
+		if (mlx4_buf_alloc(dev->dev, qp->buf_size, PAGE_SIZE * 2, &qp->buf, gfp)) {
 			err = -ENOMEM;
 			goto err_db;
 		}
@@ -765,13 +766,12 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		if (err)
 			goto err_buf;
 
-		err = mlx4_buf_write_mtt(dev->dev, &qp->mtt, &qp->buf);
+		err = mlx4_buf_write_mtt(dev->dev, &qp->mtt, &qp->buf, gfp);
 		if (err)
 			goto err_mtt;
 
-		qp->sq.wrid  = kmalloc(qp->sq.wqe_cnt * sizeof (u64), GFP_KERNEL);
-		qp->rq.wrid  = kmalloc(qp->rq.wqe_cnt * sizeof (u64), GFP_KERNEL);
-
+		qp->sq.wrid  = kmalloc(qp->sq.wqe_cnt * sizeof (u64), gfp);
+		qp->rq.wrid  = kmalloc(qp->rq.wqe_cnt * sizeof (u64), gfp);
 		if (!qp->sq.wrid || !qp->rq.wrid) {
 			err = -ENOMEM;
 			goto err_wrid;
@@ -801,7 +801,7 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			goto err_proxy;
 	}
 
-	err = mlx4_qp_alloc(dev->dev, qpn, &qp->mqp);
+	err = mlx4_qp_alloc(dev->dev, qpn, &qp->mqp, gfp);
 	if (err)
 		goto err_qpn;
 
@@ -1040,7 +1040,10 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 	struct mlx4_ib_qp *qp = NULL;
 	int err;
 	u16 xrcdn = 0;
+	gfp_t gfp;
 
+	gfp = (init_attr->create_flags & MLX4_IB_QP_CREATE_USE_GFP_NOIO) ?
+		GFP_NOIO : GFP_KERNEL;
 	/*
 	 * We only support LSO, vendor flag1, and multicast loopback blocking,
 	 * and only for kernel UD QPs.
@@ -1049,7 +1052,8 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 					MLX4_IB_QP_BLOCK_MULTICAST_LOOPBACK |
 					MLX4_IB_SRIOV_TUNNEL_QP |
 					MLX4_IB_SRIOV_SQP |
-					MLX4_IB_QP_NETIF))
+					MLX4_IB_QP_NETIF |
+					MLX4_IB_QP_CREATE_USE_GFP_NOIO))
 		return ERR_PTR(-EINVAL);
 
 	if (init_attr->create_flags & IB_QP_CREATE_NETIF_QP) {
@@ -1059,7 +1063,7 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 
 	if (init_attr->create_flags &&
 	    (udata ||
-	     ((init_attr->create_flags & ~MLX4_IB_SRIOV_SQP) &&
+	     ((init_attr->create_flags & ~(MLX4_IB_SRIOV_SQP | MLX4_IB_QP_CREATE_USE_GFP_NOIO)) &&
 	      init_attr->qp_type != IB_QPT_UD) ||
 	     ((init_attr->create_flags & MLX4_IB_SRIOV_SQP) &&
 	      init_attr->qp_type > IB_QPT_GSI)))
@@ -1079,7 +1083,7 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 	case IB_QPT_RC:
 	case IB_QPT_UC:
 	case IB_QPT_RAW_PACKET:
-		qp = kzalloc(sizeof *qp, GFP_KERNEL);
+		qp = kzalloc(sizeof *qp, gfp);
 		if (!qp)
 			return ERR_PTR(-ENOMEM);
 		qp->pri.vid = 0xFFFF;
@@ -1088,7 +1092,7 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 	case IB_QPT_UD:
 	{
 		err = create_qp_common(to_mdev(pd->device), pd, init_attr,
-				       udata, 0, &qp);
+				       udata, 0, &qp, gfp);
 		if (err)
 			return ERR_PTR(err);
 
@@ -1106,7 +1110,7 @@ struct ib_qp *mlx4_ib_create_qp(struct ib_pd *pd,
 
 		err = create_qp_common(to_mdev(pd->device), pd, init_attr, udata,
 				       get_sqp_num(to_mdev(pd->device), init_attr),
-				       &qp);
+				       &qp, gfp);
 		if (err)
 			return ERR_PTR(err);
 
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index 60c5fb0..62d9285 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -134,13 +134,14 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 		if (err)
 			goto err_mtt;
 	} else {
-		err = mlx4_db_alloc(dev->dev, &srq->db, 0);
+		err = mlx4_db_alloc(dev->dev, &srq->db, 0, GFP_KERNEL);
 		if (err)
 			goto err_srq;
 
 		*srq->db.db = 0;
 
-		if (mlx4_buf_alloc(dev->dev, buf_size, PAGE_SIZE * 2, &srq->buf)) {
+		if (mlx4_buf_alloc(dev->dev, buf_size, PAGE_SIZE * 2, &srq->buf,
+				   GFP_KERNEL)) {
 			err = -ENOMEM;
 			goto err_db;
 		}
@@ -165,7 +166,7 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 		if (err)
 			goto err_buf;
 
-		err = mlx4_buf_write_mtt(dev->dev, &srq->mtt, &srq->buf);
+		err = mlx4_buf_write_mtt(dev->dev, &srq->mtt, &srq->buf, GFP_KERNEL);
 		if (err)
 			goto err_mtt;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/alloc.c b/drivers/net/ethernet/mellanox/mlx4/alloc.c
index c3ad464..b0297da 100644
--- a/drivers/net/ethernet/mellanox/mlx4/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx4/alloc.c
@@ -171,7 +171,7 @@ void mlx4_bitmap_cleanup(struct mlx4_bitmap *bitmap)
  */
 
 int mlx4_buf_alloc(struct mlx4_dev *dev, int size, int max_direct,
-		   struct mlx4_buf *buf)
+		   struct mlx4_buf *buf, gfp_t gfp)
 {
 	dma_addr_t t;
 
@@ -180,7 +180,7 @@ int mlx4_buf_alloc(struct mlx4_dev *dev, int size, int max_direct,
 		buf->npages       = 1;
 		buf->page_shift   = get_order(size) + PAGE_SHIFT;
 		buf->direct.buf   = dma_alloc_coherent(&dev->pdev->dev,
-						       size, &t, GFP_KERNEL);
+						       size, &t, gfp);
 		if (!buf->direct.buf)
 			return -ENOMEM;
 
@@ -200,14 +200,14 @@ int mlx4_buf_alloc(struct mlx4_dev *dev, int size, int max_direct,
 		buf->npages      = buf->nbufs;
 		buf->page_shift  = PAGE_SHIFT;
 		buf->page_list   = kcalloc(buf->nbufs, sizeof(*buf->page_list),
-					   GFP_KERNEL);
+					   gfp);
 		if (!buf->page_list)
 			return -ENOMEM;
 
 		for (i = 0; i < buf->nbufs; ++i) {
 			buf->page_list[i].buf =
 				dma_alloc_coherent(&dev->pdev->dev, PAGE_SIZE,
-						   &t, GFP_KERNEL);
+						   &t, gfp);
 			if (!buf->page_list[i].buf)
 				goto err_free;
 
@@ -218,7 +218,7 @@ int mlx4_buf_alloc(struct mlx4_dev *dev, int size, int max_direct,
 
 		if (BITS_PER_LONG == 64) {
 			struct page **pages;
-			pages = kmalloc(sizeof *pages * buf->nbufs, GFP_KERNEL);
+			pages = kmalloc(sizeof *pages * buf->nbufs, gfp);
 			if (!pages)
 				goto err_free;
 			for (i = 0; i < buf->nbufs; ++i)
@@ -260,11 +260,12 @@ void mlx4_buf_free(struct mlx4_dev *dev, int size, struct mlx4_buf *buf)
 }
 EXPORT_SYMBOL_GPL(mlx4_buf_free);
 
-static struct mlx4_db_pgdir *mlx4_alloc_db_pgdir(struct device *dma_device)
+static struct mlx4_db_pgdir *mlx4_alloc_db_pgdir(struct device *dma_device,
+						 gfp_t gfp)
 {
 	struct mlx4_db_pgdir *pgdir;
 
-	pgdir = kzalloc(sizeof *pgdir, GFP_KERNEL);
+	pgdir = kzalloc(sizeof *pgdir, gfp);
 	if (!pgdir)
 		return NULL;
 
@@ -272,7 +273,7 @@ static struct mlx4_db_pgdir *mlx4_alloc_db_pgdir(struct device *dma_device)
 	pgdir->bits[0] = pgdir->order0;
 	pgdir->bits[1] = pgdir->order1;
 	pgdir->db_page = dma_alloc_coherent(dma_device, PAGE_SIZE,
-					    &pgdir->db_dma, GFP_KERNEL);
+					    &pgdir->db_dma, gfp);
 	if (!pgdir->db_page) {
 		kfree(pgdir);
 		return NULL;
@@ -312,7 +313,7 @@ found:
 	return 0;
 }
 
-int mlx4_db_alloc(struct mlx4_dev *dev, struct mlx4_db *db, int order)
+int mlx4_db_alloc(struct mlx4_dev *dev, struct mlx4_db *db, int order, gfp_t gfp)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_db_pgdir *pgdir;
@@ -324,7 +325,7 @@ int mlx4_db_alloc(struct mlx4_dev *dev, struct mlx4_db *db, int order)
 		if (!mlx4_alloc_db_from_pgdir(pgdir, db, order))
 			goto out;
 
-	pgdir = mlx4_alloc_db_pgdir(&(dev->pdev->dev));
+	pgdir = mlx4_alloc_db_pgdir(&(dev->pdev->dev), gfp);
 	if (!pgdir) {
 		ret = -ENOMEM;
 		goto out;
@@ -376,13 +377,13 @@ int mlx4_alloc_hwq_res(struct mlx4_dev *dev, struct mlx4_hwq_resources *wqres,
 {
 	int err;
 
-	err = mlx4_db_alloc(dev, &wqres->db, 1);
+	err = mlx4_db_alloc(dev, &wqres->db, 1, GFP_KERNEL);
 	if (err)
 		return err;
 
 	*wqres->db.db = 0;
 
-	err = mlx4_buf_alloc(dev, size, max_direct, &wqres->buf);
+	err = mlx4_buf_alloc(dev, size, max_direct, &wqres->buf, GFP_KERNEL);
 	if (err)
 		goto err_db;
 
@@ -391,7 +392,7 @@ int mlx4_alloc_hwq_res(struct mlx4_dev *dev, struct mlx4_hwq_resources *wqres,
 	if (err)
 		goto err_buf;
 
-	err = mlx4_buf_write_mtt(dev, &wqres->mtt, &wqres->buf);
+	err = mlx4_buf_write_mtt(dev, &wqres->mtt, &wqres->buf, GFP_KERNEL);
 	if (err)
 		goto err_mtt;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/cq.c b/drivers/net/ethernet/mellanox/mlx4/cq.c
index 0487121..c90cde5 100644
--- a/drivers/net/ethernet/mellanox/mlx4/cq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/cq.c
@@ -173,11 +173,11 @@ int __mlx4_cq_alloc_icm(struct mlx4_dev *dev, int *cqn)
 	if (*cqn == -1)
 		return -ENOMEM;
 
-	err = mlx4_table_get(dev, &cq_table->table, *cqn);
+	err = mlx4_table_get(dev, &cq_table->table, *cqn, GFP_KERNEL);
 	if (err)
 		goto err_out;
 
-	err = mlx4_table_get(dev, &cq_table->cmpt_table, *cqn);
+	err = mlx4_table_get(dev, &cq_table->cmpt_table, *cqn, GFP_KERNEL);
 	if (err)
 		goto err_put;
 	return 0;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_rx.c b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
index ba049ae..87857a6 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_rx.c
@@ -972,7 +972,7 @@ static int mlx4_en_config_rss_qp(struct mlx4_en_priv *priv, int qpn,
 	if (!context)
 		return -ENOMEM;
 
-	err = mlx4_qp_alloc(mdev->dev, qpn, qp);
+	err = mlx4_qp_alloc(mdev->dev, qpn, qp, GFP_KERNEL);
 	if (err) {
 		en_err(priv, "Failed to allocate qp #%x\n", qpn);
 		goto out;
@@ -1012,7 +1012,7 @@ int mlx4_en_create_drop_qp(struct mlx4_en_priv *priv)
 		en_err(priv, "Failed reserving drop qpn\n");
 		return err;
 	}
-	err = mlx4_qp_alloc(priv->mdev->dev, qpn, &priv->drop_qp);
+	err = mlx4_qp_alloc(priv->mdev->dev, qpn, &priv->drop_qp, GFP_KERNEL);
 	if (err) {
 		en_err(priv, "Failed allocating drop qp\n");
 		mlx4_qp_release_range(priv->mdev->dev, qpn, 1);
@@ -1071,7 +1071,7 @@ int mlx4_en_config_rss_steer(struct mlx4_en_priv *priv)
 	}
 
 	/* Configure RSS indirection qp */
-	err = mlx4_qp_alloc(mdev->dev, priv->base_qpn, &rss_map->indir_qp);
+	err = mlx4_qp_alloc(mdev->dev, priv->base_qpn, &rss_map->indir_qp, GFP_KERNEL);
 	if (err) {
 		en_err(priv, "Failed to allocate RSS indirection QP\n");
 		goto rss_err;
diff --git a/drivers/net/ethernet/mellanox/mlx4/en_tx.c b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
index dd1f6d3..bc0cc1e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/en_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx4/en_tx.c
@@ -113,7 +113,7 @@ int mlx4_en_create_tx_ring(struct mlx4_en_priv *priv,
 	       ring->buf_size, (unsigned long long) ring->wqres.buf.direct.map);
 
 	ring->qpn = qpn;
-	err = mlx4_qp_alloc(mdev->dev, ring->qpn, &ring->qp);
+	err = mlx4_qp_alloc(mdev->dev, ring->qpn, &ring->qp, GFP_KERNEL);
 	if (err) {
 		en_err(priv, "Failed allocating qp %d\n", ring->qpn);
 		goto err_map;
diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.c b/drivers/net/ethernet/mellanox/mlx4/icm.c
index 5fbf492..eb1747e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.c
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.c
@@ -245,7 +245,8 @@ int mlx4_UNMAP_ICM_AUX(struct mlx4_dev *dev)
 			MLX4_CMD_TIME_CLASS_B, MLX4_CMD_NATIVE);
 }
 
-int mlx4_table_get(struct mlx4_dev *dev, struct mlx4_icm_table *table, u32 obj)
+int mlx4_table_get(struct mlx4_dev *dev, struct mlx4_icm_table *table, u32 obj,
+		   int gfp)
 {
 	u32 i = (obj & (table->num_obj - 1)) /
 			(MLX4_TABLE_CHUNK_SIZE / table->obj_size);
@@ -259,7 +260,7 @@ int mlx4_table_get(struct mlx4_dev *dev, struct mlx4_icm_table *table, u32 obj)
 	}
 
 	table->icm[i] = mlx4_alloc_icm(dev, MLX4_TABLE_CHUNK_SIZE >> PAGE_SHIFT,
-				       (table->lowmem ? GFP_KERNEL : GFP_HIGHUSER) |
+				       (table->lowmem ? gfp : GFP_HIGHUSER) |
 				       __GFP_NOWARN, table->coherent);
 	if (!table->icm[i]) {
 		ret = -ENOMEM;
@@ -356,7 +357,7 @@ int mlx4_table_get_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
 	u32 i;
 
 	for (i = start; i <= end; i += inc) {
-		err = mlx4_table_get(dev, table, i);
+		err = mlx4_table_get(dev, table, i, GFP_KERNEL);
 		if (err)
 			goto fail;
 	}
diff --git a/drivers/net/ethernet/mellanox/mlx4/icm.h b/drivers/net/ethernet/mellanox/mlx4/icm.h
index dee67fa..067e6e0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/icm.h
+++ b/drivers/net/ethernet/mellanox/mlx4/icm.h
@@ -71,7 +71,8 @@ struct mlx4_icm *mlx4_alloc_icm(struct mlx4_dev *dev, int npages,
 				gfp_t gfp_mask, int coherent);
 void mlx4_free_icm(struct mlx4_dev *dev, struct mlx4_icm *icm, int coherent);
 
-int mlx4_table_get(struct mlx4_dev *dev, struct mlx4_icm_table *table, u32 obj);
+int mlx4_table_get(struct mlx4_dev *dev, struct mlx4_icm_table *table, u32 obj,
+		   int gfp);
 void mlx4_table_put(struct mlx4_dev *dev, struct mlx4_icm_table *table, u32 obj);
 int mlx4_table_get_range(struct mlx4_dev *dev, struct mlx4_icm_table *table,
 			 u32 start, u32 end);
diff --git a/drivers/net/ethernet/mellanox/mlx4/mlx4.h b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
index f9c4651..627a54e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mlx4.h
+++ b/drivers/net/ethernet/mellanox/mlx4/mlx4.h
@@ -888,7 +888,7 @@ void mlx4_cleanup_cq_table(struct mlx4_dev *dev);
 void mlx4_cleanup_qp_table(struct mlx4_dev *dev);
 void mlx4_cleanup_srq_table(struct mlx4_dev *dev);
 void mlx4_cleanup_mcg_table(struct mlx4_dev *dev);
-int __mlx4_qp_alloc_icm(struct mlx4_dev *dev, int qpn);
+int __mlx4_qp_alloc_icm(struct mlx4_dev *dev, int qpn, gfp_t gfp);
 void __mlx4_qp_free_icm(struct mlx4_dev *dev, int qpn);
 int __mlx4_cq_alloc_icm(struct mlx4_dev *dev, int *cqn);
 void __mlx4_cq_free_icm(struct mlx4_dev *dev, int cqn);
@@ -896,7 +896,7 @@ int __mlx4_srq_alloc_icm(struct mlx4_dev *dev, int *srqn);
 void __mlx4_srq_free_icm(struct mlx4_dev *dev, int srqn);
 int __mlx4_mpt_reserve(struct mlx4_dev *dev);
 void __mlx4_mpt_release(struct mlx4_dev *dev, u32 index);
-int __mlx4_mpt_alloc_icm(struct mlx4_dev *dev, u32 index);
+int __mlx4_mpt_alloc_icm(struct mlx4_dev *dev, u32 index, gfp_t gfp);
 void __mlx4_mpt_free_icm(struct mlx4_dev *dev, u32 index);
 u32 __mlx4_alloc_mtt_range(struct mlx4_dev *dev, int order);
 void __mlx4_free_mtt_range(struct mlx4_dev *dev, u32 first_seg, int order);
diff --git a/drivers/net/ethernet/mellanox/mlx4/mr.c b/drivers/net/ethernet/mellanox/mlx4/mr.c
index 2483585..4c71daf 100644
--- a/drivers/net/ethernet/mellanox/mlx4/mr.c
+++ b/drivers/net/ethernet/mellanox/mlx4/mr.c
@@ -364,14 +364,14 @@ static void mlx4_mpt_release(struct mlx4_dev *dev, u32 index)
 	__mlx4_mpt_release(dev, index);
 }
 
-int __mlx4_mpt_alloc_icm(struct mlx4_dev *dev, u32 index)
+int __mlx4_mpt_alloc_icm(struct mlx4_dev *dev, u32 index, gfp_t gfp)
 {
 	struct mlx4_mr_table *mr_table = &mlx4_priv(dev)->mr_table;
 
-	return mlx4_table_get(dev, &mr_table->dmpt_table, index);
+	return mlx4_table_get(dev, &mr_table->dmpt_table, index, gfp);
 }
 
-static int mlx4_mpt_alloc_icm(struct mlx4_dev *dev, u32 index)
+static int mlx4_mpt_alloc_icm(struct mlx4_dev *dev, u32 index, gfp_t gfp)
 {
 	u64 param = 0;
 
@@ -382,7 +382,7 @@ static int mlx4_mpt_alloc_icm(struct mlx4_dev *dev, u32 index)
 							MLX4_CMD_TIME_CLASS_A,
 							MLX4_CMD_WRAPPED);
 	}
-	return __mlx4_mpt_alloc_icm(dev, index);
+	return __mlx4_mpt_alloc_icm(dev, index, gfp);
 }
 
 void __mlx4_mpt_free_icm(struct mlx4_dev *dev, u32 index)
@@ -469,7 +469,7 @@ int mlx4_mr_enable(struct mlx4_dev *dev, struct mlx4_mr *mr)
 	struct mlx4_mpt_entry *mpt_entry;
 	int err;
 
-	err = mlx4_mpt_alloc_icm(dev, key_to_hw_index(mr->key));
+	err = mlx4_mpt_alloc_icm(dev, key_to_hw_index(mr->key), GFP_KERNEL);
 	if (err)
 		return err;
 
@@ -627,13 +627,14 @@ int mlx4_write_mtt(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
 EXPORT_SYMBOL_GPL(mlx4_write_mtt);
 
 int mlx4_buf_write_mtt(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
-		       struct mlx4_buf *buf)
+		       struct mlx4_buf *buf, gfp_t gfp)
 {
 	u64 *page_list;
 	int err;
 	int i;
 
-	page_list = kmalloc(buf->npages * sizeof *page_list, GFP_KERNEL);
+	page_list = kmalloc(buf->npages * sizeof *page_list,
+			    gfp);
 	if (!page_list)
 		return -ENOMEM;
 
@@ -680,7 +681,7 @@ int mlx4_mw_enable(struct mlx4_dev *dev, struct mlx4_mw *mw)
 	struct mlx4_mpt_entry *mpt_entry;
 	int err;
 
-	err = mlx4_mpt_alloc_icm(dev, key_to_hw_index(mw->key));
+	err = mlx4_mpt_alloc_icm(dev, key_to_hw_index(mw->key), GFP_KERNEL);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index 61d64eb..917f0d0 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -272,29 +272,29 @@ void mlx4_qp_release_range(struct mlx4_dev *dev, int base_qpn, int cnt)
 }
 EXPORT_SYMBOL_GPL(mlx4_qp_release_range);
 
-int __mlx4_qp_alloc_icm(struct mlx4_dev *dev, int qpn)
+int __mlx4_qp_alloc_icm(struct mlx4_dev *dev, int qpn, gfp_t gfp)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_qp_table *qp_table = &priv->qp_table;
 	int err;
 
-	err = mlx4_table_get(dev, &qp_table->qp_table, qpn);
+	err = mlx4_table_get(dev, &qp_table->qp_table, qpn, gfp);
 	if (err)
 		goto err_out;
 
-	err = mlx4_table_get(dev, &qp_table->auxc_table, qpn);
+	err = mlx4_table_get(dev, &qp_table->auxc_table, qpn, gfp);
 	if (err)
 		goto err_put_qp;
 
-	err = mlx4_table_get(dev, &qp_table->altc_table, qpn);
+	err = mlx4_table_get(dev, &qp_table->altc_table, qpn, gfp);
 	if (err)
 		goto err_put_auxc;
 
-	err = mlx4_table_get(dev, &qp_table->rdmarc_table, qpn);
+	err = mlx4_table_get(dev, &qp_table->rdmarc_table, qpn, gfp);
 	if (err)
 		goto err_put_altc;
 
-	err = mlx4_table_get(dev, &qp_table->cmpt_table, qpn);
+	err = mlx4_table_get(dev, &qp_table->cmpt_table, qpn, gfp);
 	if (err)
 		goto err_put_rdmarc;
 
@@ -316,7 +316,7 @@ err_out:
 	return err;
 }
 
-static int mlx4_qp_alloc_icm(struct mlx4_dev *dev, int qpn)
+static int mlx4_qp_alloc_icm(struct mlx4_dev *dev, int qpn, int gfp)
 {
 	u64 param = 0;
 
@@ -326,7 +326,7 @@ static int mlx4_qp_alloc_icm(struct mlx4_dev *dev, int qpn)
 				    MLX4_CMD_ALLOC_RES, MLX4_CMD_TIME_CLASS_A,
 				    MLX4_CMD_WRAPPED);
 	}
-	return __mlx4_qp_alloc_icm(dev, qpn);
+	return __mlx4_qp_alloc_icm(dev, qpn, gfp);
 }
 
 void __mlx4_qp_free_icm(struct mlx4_dev *dev, int qpn)
@@ -355,7 +355,7 @@ static void mlx4_qp_free_icm(struct mlx4_dev *dev, int qpn)
 		__mlx4_qp_free_icm(dev, qpn);
 }
 
-int mlx4_qp_alloc(struct mlx4_dev *dev, int qpn, struct mlx4_qp *qp)
+int mlx4_qp_alloc(struct mlx4_dev *dev, int qpn, struct mlx4_qp *qp, gfp_t gfp)
 {
 	struct mlx4_priv *priv = mlx4_priv(dev);
 	struct mlx4_qp_table *qp_table = &priv->qp_table;
@@ -366,7 +366,7 @@ int mlx4_qp_alloc(struct mlx4_dev *dev, int qpn, struct mlx4_qp *qp)
 
 	qp->qpn = qpn;
 
-	err = mlx4_qp_alloc_icm(dev, qpn);
+	err = mlx4_qp_alloc_icm(dev, qpn, gfp);
 	if (err)
 		return err;
 
diff --git a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
index 3b5f53e..dff9258 100644
--- a/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
+++ b/drivers/net/ethernet/mellanox/mlx4/resource_tracker.c
@@ -1532,7 +1532,7 @@ static int qp_alloc_res(struct mlx4_dev *dev, int slave, int op, int cmd,
 			return err;
 
 		if (!fw_reserved(dev, qpn)) {
-			err = __mlx4_qp_alloc_icm(dev, qpn);
+			err = __mlx4_qp_alloc_icm(dev, qpn, GFP_KERNEL);
 			if (err) {
 				res_abort_move(dev, slave, RES_QP, qpn);
 				return err;
@@ -1619,7 +1619,7 @@ static int mpt_alloc_res(struct mlx4_dev *dev, int slave, int op, int cmd,
 		if (err)
 			return err;
 
-		err = __mlx4_mpt_alloc_icm(dev, mpt->key);
+		err = __mlx4_mpt_alloc_icm(dev, mpt->key, GFP_KERNEL);
 		if (err) {
 			res_abort_move(dev, slave, RES_MPT, id);
 			return err;
diff --git a/drivers/net/ethernet/mellanox/mlx4/srq.c b/drivers/net/ethernet/mellanox/mlx4/srq.c
index 98faf87..6714662 100644
--- a/drivers/net/ethernet/mellanox/mlx4/srq.c
+++ b/drivers/net/ethernet/mellanox/mlx4/srq.c
@@ -103,11 +103,11 @@ int __mlx4_srq_alloc_icm(struct mlx4_dev *dev, int *srqn)
 	if (*srqn == -1)
 		return -ENOMEM;
 
-	err = mlx4_table_get(dev, &srq_table->table, *srqn);
+	err = mlx4_table_get(dev, &srq_table->table, *srqn, GFP_KERNEL);
 	if (err)
 		goto err_out;
 
-	err = mlx4_table_get(dev, &srq_table->cmpt_table, *srqn);
+	err = mlx4_table_get(dev, &srq_table->cmpt_table, *srqn, GFP_KERNEL);
 	if (err)
 		goto err_put;
 	return 0;
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index ba87bd2..be60b00 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -837,7 +837,7 @@ static inline int mlx4_is_slave(struct mlx4_dev *dev)
 }
 
 int mlx4_buf_alloc(struct mlx4_dev *dev, int size, int max_direct,
-		   struct mlx4_buf *buf);
+		   struct mlx4_buf *buf, gfp_t gfp);
 void mlx4_buf_free(struct mlx4_dev *dev, int size, struct mlx4_buf *buf);
 static inline void *mlx4_buf_offset(struct mlx4_buf *buf, int offset)
 {
@@ -874,9 +874,10 @@ int mlx4_mw_enable(struct mlx4_dev *dev, struct mlx4_mw *mw);
 int mlx4_write_mtt(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
 		   int start_index, int npages, u64 *page_list);
 int mlx4_buf_write_mtt(struct mlx4_dev *dev, struct mlx4_mtt *mtt,
-		       struct mlx4_buf *buf);
+		       struct mlx4_buf *buf, gfp_t gfp);
 
-int mlx4_db_alloc(struct mlx4_dev *dev, struct mlx4_db *db, int order);
+int mlx4_db_alloc(struct mlx4_dev *dev, struct mlx4_db *db, int order,
+		  gfp_t gfp);
 void mlx4_db_free(struct mlx4_dev *dev, struct mlx4_db *db);
 
 int mlx4_alloc_hwq_res(struct mlx4_dev *dev, struct mlx4_hwq_resources *wqres,
@@ -892,7 +893,8 @@ void mlx4_cq_free(struct mlx4_dev *dev, struct mlx4_cq *cq);
 int mlx4_qp_reserve_range(struct mlx4_dev *dev, int cnt, int align, int *base);
 void mlx4_qp_release_range(struct mlx4_dev *dev, int base_qpn, int cnt);
 
-int mlx4_qp_alloc(struct mlx4_dev *dev, int qpn, struct mlx4_qp *qp);
+int mlx4_qp_alloc(struct mlx4_dev *dev, int qpn, struct mlx4_qp *qp,
+		  gfp_t gfp);
 void mlx4_qp_free(struct mlx4_dev *dev, struct mlx4_qp *qp);
 
 int mlx4_srq_alloc(struct mlx4_dev *dev, u32 pdn, u32 cqn, u16 xrcdn,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
