From: SF Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Subject: [PATCH 28/29] IB/mlx5: Less function calls in create_kernel_qp()
 after error detection
Date: Sat, 18 Feb 2017 22:18:16 +0100
Message-ID: <01c34ad6-5a61-84dd-8749-ea2b69eb2381@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1935365a-bd7c-461e-6a84-0c5d3a501fff-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: LKML <linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, kernel-janitors-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
Date: Sat, 18 Feb 2017 21:00:50 +0100

The kfree() function was called in up to five cases
by the create_kernel_qp() function during error handling
even if the passed data structure member contained a null pointer.

* Adjust jump targets according to the Linux coding style convention.

* Split a condition check for memory allocation failures so that
  each pointer from these function calls will be checked immediately.

  See also background information:
  Topic "CWE-754: Improper check for unusual or exceptional conditions"
  Link: https://cwe.mitre.org/data/definitions/754.html

Signed-off-by: Markus Elfring <elfring-Rn4VEauK+AKRv+LV9MX5uipxlwaOVQ5f@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c | 43 ++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e6e9b468b206..c47afce5fc6a 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -930,7 +930,7 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 	*in = mlx5_vzalloc(*inlen);
 	if (!*in) {
 		err = -ENOMEM;
-		goto err_buf;
+		goto free_buffer;
 	}
 
 	qpc = MLX5_ADDR_OF(create_qp_in, *in, qpc);
@@ -952,45 +952,56 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 	err = mlx5_db_alloc(dev->mdev, &qp->db);
 	if (err) {
 		mlx5_ib_dbg(dev, "err %d\n", err);
-		goto err_free;
+		goto vfree_in;
 	}
 
 	qp->sq.wrid = kmalloc_array(qp->sq.wqe_cnt,
 				    sizeof(*qp->sq.wrid),
 				    GFP_KERNEL);
+	if (!qp->sq.wrid)
+		goto free_db;
+
 	qp->sq.wr_data = kmalloc_array(qp->sq.wqe_cnt,
 				       sizeof(*qp->sq.wr_data),
 				       GFP_KERNEL);
+	if (!qp->sq.wr_data)
+		goto free_sq_wrid;
+
 	qp->rq.wrid = kmalloc_array(qp->rq.wqe_cnt,
 				    sizeof(*qp->rq.wrid),
 				    GFP_KERNEL);
+	if (!qp->rq.wrid)
+		goto free_sq_wr_data;
+
 	qp->sq.w_list = kmalloc_array(qp->sq.wqe_cnt,
 				      sizeof(*qp->sq.w_list),
 				      GFP_KERNEL);
+	if (!qp->sq.w_list)
+		goto free_rq_wrid;
+
 	qp->sq.wqe_head = kmalloc_array(qp->sq.wqe_cnt,
 					sizeof(*qp->sq.wqe_head),
 					GFP_KERNEL);
-	if (!qp->sq.wrid || !qp->sq.wr_data || !qp->rq.wrid ||
-	    !qp->sq.w_list || !qp->sq.wqe_head) {
-		err = -ENOMEM;
-		goto err_wrid;
-	}
+	if (!qp->sq.wqe_head)
+		goto free_sq_w_list;
+
 	qp->create_type = MLX5_QP_KERNEL;
 
 	return 0;
-
-err_wrid:
-	kfree(qp->sq.wqe_head);
+free_sq_w_list:
 	kfree(qp->sq.w_list);
-	kfree(qp->sq.wrid);
-	kfree(qp->sq.wr_data);
+free_rq_wrid:
 	kfree(qp->rq.wrid);
+free_sq_wr_data:
+	kfree(qp->sq.wr_data);
+free_sq_wrid:
+	kfree(qp->sq.wrid);
+free_db:
 	mlx5_db_free(dev->mdev, &qp->db);
-
-err_free:
+	err = -ENOMEM;
+vfree_in:
 	kvfree(*in);
-
-err_buf:
+free_buffer:
 	mlx5_buf_free(dev->mdev, &qp->buf);
 	return err;
 }
-- 
2.11.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
