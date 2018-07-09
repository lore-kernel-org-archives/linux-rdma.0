From: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
Subject: [PATCH] ib/mlx4: adjust gfp flags for DMA allocations
Date: Mon,  9 Jul 2018 16:51:13 +0300
Message-ID: <1531144273-25959-1-git-send-email-jan.dakinevich@virtuozzo.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <netdev-owner@vger.kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Yishai Hadas <yishaih@mellanox.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>, Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Cc: Denis Lunev <den@virtuozzo.com>, Konstantin Khorenko <khorenko@virtuozzo.com>, Jan Dakinevich <jan.dakinevich@virtuozzo.com>
List-Id: linux-rdma@vger.kernel.org

For most cases it is enough to use common GFP_KERNEL flag. However,
there is one place with defined fallback path on unsuccessful allocation.
In this case it would be preferred to append on first allocation attempt
__GFP_NOWARN and __GFP_NORETRY flags to suppress possible warnings and
to shorten the path to the fallback in a case of memory pressure.

Signed-off-by: Jan Dakinevich <jan.dakinevich@virtuozzo.com>
---
 drivers/infiniband/hw/mlx4/cq.c            |  2 +-
 drivers/infiniband/hw/mlx4/qp.c            |  6 ++++--
 drivers/infiniband/hw/mlx4/srq.c           |  2 +-
 drivers/net/ethernet/mellanox/mlx4/alloc.c | 12 ++++++------
 include/linux/mlx4/device.h                |  2 +-
 5 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 82adc0d..609f126 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -102,7 +102,7 @@ static int mlx4_ib_alloc_cq_buf(struct mlx4_ib_dev *dev, struct mlx4_ib_cq_buf *
 	int err;
 
 	err = mlx4_buf_alloc(dev->dev, nent * dev->dev->caps.cqe_size,
-			     PAGE_SIZE * 2, &buf->buf);
+			     PAGE_SIZE * 2, &buf->buf, GFP_KERNEL);
 
 	if (err)
 		goto out;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index 3b8045f..1893753 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1193,7 +1193,8 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 		}
 
 		if (mlx4_buf_alloc(dev->dev, qp->buf_size, qp->buf_size,
-				   &qp->buf)) {
+				   &qp->buf, __GFP_NOWARN | __GFP_NORETRY |
+				   GFP_KERNEL)) {
 			memcpy(&init_attr->cap, &backup_cap,
 			       sizeof(backup_cap));
 			err = set_kernel_sq_size(dev, &init_attr->cap, qp_type,
@@ -1202,7 +1203,8 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 				goto err_db;
 
 			if (mlx4_buf_alloc(dev->dev, qp->buf_size,
-					   PAGE_SIZE * 2, &qp->buf)) {
+					   PAGE_SIZE * 2, &qp->buf,
+					   GFP_KERNEL)) {
 				err = -ENOMEM;
 				goto err_db;
 			}
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index ebee56c..4c7c9c5 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -141,7 +141,7 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 		*srq->db.db = 0;
 
 		if (mlx4_buf_alloc(dev->dev, buf_size, PAGE_SIZE * 2,
-				   &srq->buf)) {
+				   &srq->buf, GFP_KERNEL)) {
 			err = -ENOMEM;
 			goto err_db;
 		}
diff --git a/drivers/net/ethernet/mellanox/mlx4/alloc.c b/drivers/net/ethernet/mellanox/mlx4/alloc.c
index 4bdf250..94bd27e 100644
--- a/drivers/net/ethernet/mellanox/mlx4/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx4/alloc.c
@@ -576,7 +576,7 @@ u32 mlx4_zone_free_entries_unique(struct mlx4_zone_allocator *zones, u32 obj, u3
 }
 
 static int mlx4_buf_direct_alloc(struct mlx4_dev *dev, int size,
-				 struct mlx4_buf *buf)
+				 struct mlx4_buf *buf, gfp_t gfp)
 {
 	dma_addr_t t;
 
@@ -585,7 +585,7 @@ static int mlx4_buf_direct_alloc(struct mlx4_dev *dev, int size,
 	buf->page_shift   = get_order(size) + PAGE_SHIFT;
 	buf->direct.buf   =
 		dma_zalloc_coherent(&dev->persist->pdev->dev,
-				    size, &t, GFP_KERNEL);
+				    size, &t, gfp);
 	if (!buf->direct.buf)
 		return -ENOMEM;
 
@@ -605,10 +605,10 @@ static int mlx4_buf_direct_alloc(struct mlx4_dev *dev, int size,
  *  multiple pages, so we don't require too much contiguous memory.
  */
 int mlx4_buf_alloc(struct mlx4_dev *dev, int size, int max_direct,
-		   struct mlx4_buf *buf)
+		   struct mlx4_buf *buf, gfp_t gfp)
 {
 	if (size <= max_direct) {
-		return mlx4_buf_direct_alloc(dev, size, buf);
+		return mlx4_buf_direct_alloc(dev, size, buf, gfp);
 	} else {
 		dma_addr_t t;
 		int i;
@@ -625,7 +625,7 @@ int mlx4_buf_alloc(struct mlx4_dev *dev, int size, int max_direct,
 		for (i = 0; i < buf->nbufs; ++i) {
 			buf->page_list[i].buf =
 				dma_zalloc_coherent(&dev->persist->pdev->dev,
-						    PAGE_SIZE, &t, GFP_KERNEL);
+						    PAGE_SIZE, &t, gfp);
 			if (!buf->page_list[i].buf)
 				goto err_free;
 
@@ -783,7 +783,7 @@ int mlx4_alloc_hwq_res(struct mlx4_dev *dev, struct mlx4_hwq_resources *wqres,
 
 	*wqres->db.db = 0;
 
-	err = mlx4_buf_direct_alloc(dev, size, &wqres->buf);
+	err = mlx4_buf_direct_alloc(dev, size, &wqres->buf, GFP_KERNEL);
 	if (err)
 		goto err_db;
 
diff --git a/include/linux/mlx4/device.h b/include/linux/mlx4/device.h
index 122e7e9..a146b95 100644
--- a/include/linux/mlx4/device.h
+++ b/include/linux/mlx4/device.h
@@ -1079,7 +1079,7 @@ static inline int mlx4_is_eth(struct mlx4_dev *dev, int port)
 }
 
 int mlx4_buf_alloc(struct mlx4_dev *dev, int size, int max_direct,
-		   struct mlx4_buf *buf);
+		   struct mlx4_buf *buf, gfp_t gfp);
 void mlx4_buf_free(struct mlx4_dev *dev, int size, struct mlx4_buf *buf);
 static inline void *mlx4_buf_offset(struct mlx4_buf *buf, int offset)
 {
-- 
2.1.4
