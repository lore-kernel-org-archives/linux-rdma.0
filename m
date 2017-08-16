From: Li Dongyang <dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
Subject: [PATCH v2 1/2] IB/mlx5: use kvmalloc_array for mlx5_ib_wq
Date: Wed, 16 Aug 2017 23:31:22 +1000
Message-ID: <20170816133123.20497-1-dongyang.li@anu.edu.au>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We observed multiple times on our Lustre OSS servers that when
the system memory is fragmented, kmalloc() in create_kernel_qp()
could fail order 4/5 allocations while we still have many free pages.

Switch to kvmalloc_array() to allow the operation to contine.

Signed-off-by: Li Dongyang <dongyang.li-FCV4sgi5zeUQrrorzV6ljw@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c  | 35 ++++++++++++++++++++---------------
 drivers/infiniband/hw/mlx5/srq.c |  4 ++--
 2 files changed, 22 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 0889ff367c86..07b10a95bffd 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -959,11 +959,16 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 		goto err_free;
 	}
 
-	qp->sq.wrid = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wrid), GFP_KERNEL);
-	qp->sq.wr_data = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wr_data), GFP_KERNEL);
-	qp->rq.wrid = kmalloc(qp->rq.wqe_cnt * sizeof(*qp->rq.wrid), GFP_KERNEL);
-	qp->sq.w_list = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.w_list), GFP_KERNEL);
-	qp->sq.wqe_head = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wqe_head), GFP_KERNEL);
+	qp->sq.wrid = kvmalloc_array(qp->sq.wqe_cnt,
+				     sizeof(*qp->sq.wrid), GFP_KERNEL);
+	qp->sq.wr_data = kvmalloc_array(qp->sq.wqe_cnt,
+					sizeof(*qp->sq.wr_data), GFP_KERNEL);
+	qp->rq.wrid = kvmalloc_array(qp->rq.wqe_cnt,
+				     sizeof(*qp->rq.wrid), GFP_KERNEL);
+	qp->sq.w_list = kvmalloc_array(qp->sq.wqe_cnt,
+				       sizeof(*qp->sq.w_list), GFP_KERNEL);
+	qp->sq.wqe_head = kvmalloc_array(qp->sq.wqe_cnt,
+					 sizeof(*qp->sq.wqe_head), GFP_KERNEL);
 
 	if (!qp->sq.wrid || !qp->sq.wr_data || !qp->rq.wrid ||
 	    !qp->sq.w_list || !qp->sq.wqe_head) {
@@ -975,11 +980,11 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 	return 0;
 
 err_wrid:
-	kfree(qp->sq.wqe_head);
-	kfree(qp->sq.w_list);
-	kfree(qp->sq.wrid);
-	kfree(qp->sq.wr_data);
-	kfree(qp->rq.wrid);
+	kvfree(qp->sq.wqe_head);
+	kvfree(qp->sq.w_list);
+	kvfree(qp->sq.wrid);
+	kvfree(qp->sq.wr_data);
+	kvfree(qp->rq.wrid);
 	mlx5_db_free(dev->mdev, &qp->db);
 
 err_free:
@@ -992,11 +997,11 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 
 static void destroy_qp_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp)
 {
-	kfree(qp->sq.wqe_head);
-	kfree(qp->sq.w_list);
-	kfree(qp->sq.wrid);
-	kfree(qp->sq.wr_data);
-	kfree(qp->rq.wrid);
+	kvfree(qp->sq.wqe_head);
+	kvfree(qp->sq.w_list);
+	kvfree(qp->sq.wrid);
+	kvfree(qp->sq.wr_data);
+	kvfree(qp->rq.wrid);
 	mlx5_db_free(dev->mdev, &qp->db);
 	mlx5_buf_free(dev->mdev, &qp->buf);
 }
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 43707b101f47..30b3ddd8e1ab 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -196,7 +196,7 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 	}
 	mlx5_fill_page_array(&srq->buf, in->pas);
 
-	srq->wrid = kmalloc(srq->msrq.max * sizeof(u64), GFP_KERNEL);
+	srq->wrid = kvmalloc_array(srq->msrq.max, sizeof(u64), GFP_KERNEL);
 	if (!srq->wrid) {
 		err = -ENOMEM;
 		goto err_in;
@@ -230,7 +230,7 @@ static void destroy_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq)
 
 static void destroy_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq)
 {
-	kfree(srq->wrid);
+	kvfree(srq->wrid);
 	mlx5_buf_free(dev->mdev, &srq->buf);
 	mlx5_db_free(dev->mdev, &srq->db);
 }
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
