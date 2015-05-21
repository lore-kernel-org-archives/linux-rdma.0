From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 09/11] IB/mlx4: Add support for timestamp in cq creation
Date: Thu, 21 May 2015 17:56:40 +0300
Message-ID: <1432220202-9834-10-git-send-email-ogerlitz@mellanox.com>
References: <1432220202-9834-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432220202-9834-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Support allocation of CQ with IB_CQ_FLAGS_TIMESTAMP
creation flag.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c      |    9 ++++++---
 drivers/infiniband/hw/mlx4/mlx4_ib.h |    1 +
 2 files changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 8e44aaa..a1f50e1 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -166,6 +166,7 @@ err_buf:
 	return err;
 }
 
+#define CQ_CREATE_FLAGS_SUPPORTED IB_CQ_FLAGS_TIMESTAMP
 struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
 				const struct ib_cq_init_attr *attr,
 				struct ib_ucontext *context,
@@ -178,10 +179,10 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
 	struct mlx4_uar *uar;
 	int err;
 
-	if (attr->flags)
+	if (entries < 1 || entries > dev->dev->caps.max_cqes)
 		return ERR_PTR(-EINVAL);
 
-	if (entries < 1 || entries > dev->dev->caps.max_cqes)
+	if (attr->flags & ~CQ_CREATE_FLAGS_SUPPORTED)
 		return ERR_PTR(-EINVAL);
 
 	cq = kmalloc(sizeof *cq, GFP_KERNEL);
@@ -194,6 +195,7 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
 	spin_lock_init(&cq->lock);
 	cq->resize_buf = NULL;
 	cq->resize_umem = NULL;
+	cq->create_flags = attr->flags;
 	INIT_LIST_HEAD(&cq->send_qp_list);
 	INIT_LIST_HEAD(&cq->recv_qp_list);
 
@@ -237,7 +239,8 @@ struct ib_cq *mlx4_ib_create_cq(struct ib_device *ibdev,
 		vector = dev->eq_table[vector % ibdev->num_comp_vectors];
 
 	err = mlx4_cq_alloc(dev->dev, entries, &cq->buf.mtt, uar,
-			    cq->db.dma, &cq->mcq, vector, 0, 0);
+			    cq->db.dma, &cq->mcq, vector, 0,
+			    !!(cq->create_flags & IB_CQ_FLAGS_TIMESTAMP));
 	if (err)
 		goto err_dbmap;
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index f127efc..ae04dad 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -110,6 +110,7 @@ struct mlx4_ib_cq {
 	struct mutex		resize_mutex;
 	struct ib_umem	       *umem;
 	struct ib_umem	       *resize_umem;
+	int			create_flags;
 	/* List of qps that it serves.*/
 	struct list_head		send_qp_list;
 	struct list_head		recv_qp_list;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
