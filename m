From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH v2 02/17] IB/mlx: Use kmalloc_array() in six functions
Date: Fri, 21 Apr 2017 20:24:37 +0200
Message-ID: <dc92ac21-de9f-356a-a098-d48888ae23ec@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
 <1492720654.3041.16.camel@redhat.com>
 <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <a56f9301-e116-c59c-681a-9108519920e5-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Content-Language: en-GB
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Fri, 21 Apr 2017 10:45:49 +0200

* Multiplications for the size determination of memory allocations
  indicated that array data structures should be processed.
  Thus use the corresponding function "kmalloc_array".

  This issue was detected by using the Coccinelle software.

* Replace the specification of data types by pointer dereferences
  to make the corresponding size determination a bit safer according to
  the Linux coding style convention.

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---

v2:
Changes were rebased on source files from Linux next-20170421.
These were recombined as requested by Doug Ledford.

 drivers/infiniband/hw/mlx4/main.c | 14 +++++++++-----
 drivers/infiniband/hw/mlx4/qp.c   |  6 +++---
 drivers/infiniband/hw/mlx5/qp.c   | 21 +++++++++++++++------
 drivers/infiniband/hw/mlx5/srq.c  |  5 +++--
 4 files changed, 30 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index fba94df28cf1..30a70fa95fec 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -307,7 +307,9 @@ static int mlx4_ib_add_gid(struct ib_device *device,
 		ctx->refcount++;
 	}
 	if (!ret && hw_update) {
-		gids = kmalloc(sizeof(*gids) * MLX4_MAX_PORT_GIDS, GFP_ATOMIC);
+		gids = kmalloc_array(MLX4_MAX_PORT_GIDS,
+				     sizeof(*gids),
+				     GFP_ATOMIC);
 		if (!gids) {
 			ret = -ENOMEM;
 		} else {
@@ -362,7 +364,9 @@ static int mlx4_ib_del_gid(struct ib_device *device,
 	if (!ret && hw_update) {
 		int i;
 
-		gids = kmalloc(sizeof(*gids) * MLX4_MAX_PORT_GIDS, GFP_ATOMIC);
+		gids = kmalloc_array(MLX4_MAX_PORT_GIDS,
+				     sizeof(*gids),
+				     GFP_ATOMIC);
 		if (!gids) {
 			ret = -ENOMEM;
 		} else {
@@ -2831,9 +2835,9 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 			goto err_counter;
 
 		ibdev->ib_uc_qpns_bitmap =
-			kmalloc(BITS_TO_LONGS(ibdev->steer_qpn_count) *
-				sizeof(long),
-				GFP_KERNEL);
+			kmalloc_array(BITS_TO_LONGS(ibdev->steer_qpn_count),
+				      sizeof(long),
+				      GFP_KERNEL);
 		if (!ibdev->ib_uc_qpns_bitmap)
 			goto err_steer_qp_release;
 
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index c34eebc7db65..1d9d949c66d0 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -554,9 +554,9 @@ static int alloc_proxy_bufs(struct ib_device *dev, struct mlx4_ib_qp *qp)
 {
 	int i;
 
-	qp->sqp_proxy_rcv =
-		kmalloc(sizeof (struct mlx4_ib_buf) * qp->rq.wqe_cnt,
-			GFP_KERNEL);
+	qp->sqp_proxy_rcv = kmalloc_array(qp->rq.wqe_cnt,
+					  sizeof(*qp->sqp_proxy_rcv),
+					  GFP_KERNEL);
 	if (!qp->sqp_proxy_rcv)
 		return -ENOMEM;
 	for (i = 0; i < qp->rq.wqe_cnt; i++) {
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index ed6320186f89..1e98a8c9fab8 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -959,12 +959,21 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 		goto err_free;
 	}
 
-	qp->sq.wrid = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wrid), GFP_KERNEL);
-	qp->sq.wr_data = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wr_data), GFP_KERNEL);
-	qp->rq.wrid = kmalloc(qp->rq.wqe_cnt * sizeof(*qp->rq.wrid), GFP_KERNEL);
-	qp->sq.w_list = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.w_list), GFP_KERNEL);
-	qp->sq.wqe_head = kmalloc(qp->sq.wqe_cnt * sizeof(*qp->sq.wqe_head), GFP_KERNEL);
-
+	qp->sq.wrid = kmalloc_array(qp->sq.wqe_cnt,
+				    sizeof(*qp->sq.wrid),
+				    GFP_KERNEL);
+	qp->sq.wr_data = kmalloc_array(qp->sq.wqe_cnt,
+				       sizeof(*qp->sq.wr_data),
+				       GFP_KERNEL);
+	qp->rq.wrid = kmalloc_array(qp->rq.wqe_cnt,
+				    sizeof(*qp->rq.wrid),
+				    GFP_KERNEL);
+	qp->sq.w_list = kmalloc_array(qp->sq.wqe_cnt,
+				      sizeof(*qp->sq.w_list),
+				      GFP_KERNEL);
+	qp->sq.wqe_head = kmalloc_array(qp->sq.wqe_cnt,
+					sizeof(*qp->sq.wqe_head),
+					GFP_KERNEL);
 	if (!qp->sq.wrid || !qp->sq.wr_data || !qp->rq.wrid ||
 	    !qp->sq.w_list || !qp->sq.wqe_head) {
 		err = -ENOMEM;
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 7cb145f9a6db..8ba1953177af 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -195,8 +195,9 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 		goto err_buf;
 	}
 	mlx5_fill_page_array(&srq->buf, in->pas);
-
-	srq->wrid = kmalloc(srq->msrq.max * sizeof(u64), GFP_KERNEL);
+	srq->wrid = kmalloc_array(srq->msrq.max,
+				  sizeof(*srq->wrid),
+				  GFP_KERNEL);
 	if (!srq->wrid) {
 		err = -ENOMEM;
 		goto err_in;
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
