From: SF Markus Elfring <elfring@users.sourceforge.net>
Subject: [PATCH v2 17/17] IB/mlx5: Less function calls in create_kernel_qp()
 after error detection
Date: Fri, 21 Apr 2017 20:55:33 +0200
Message-ID: <6a9ba778-b496-fd09-2fec-c36ba036bf3c@users.sourceforge.net>
References: <1935365a-bd7c-461e-6a84-0c5d3a501fff@users.sourceforge.net>
 <1492720654.3041.16.camel@redhat.com>
 <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <a56f9301-e116-c59c-681a-9108519920e5@users.sourceforge.net>
Content-Language: en-GB
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Leon Romanovsky <leonro@mellanox.com>, Majd Dibbiny <majd@mellanox.com>, Matan Barak <matanb@mellanox.com>, Sean Hefty <sean.hefty@intel.com>, Yishai Hadas <yishaih@mellanox.com>, linux-rdma@vger.kernel.org
Cc: LKML <linux-kernel@vger.kernel.org>, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Markus Elfring <elfring@users.sourceforge.net>
Date: Fri, 21 Apr 2017 19:19:20 +0200

The kfree() function was called in up to five cases
by the create_kernel_qp() function during error handling
even if the passed data structure member contained a null pointer.

* Adjust jump targets according to the Linux coding style convention.

* Split a condition check for memory allocation failures so that
  each pointer from these function calls will be checked immediately.

  See also background information:
  Topic "CWE-754: Improper check for unusual or exceptional conditions"
  Link: https://cwe.mitre.org/data/definitions/754.html

Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>
---
 drivers/infiniband/hw/mlx5/qp.c | 43 ++++++++++++++++++++++++++---------------
 1 file changed, 27 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 1e98a8c9fab8..c7bfa8ffaf0d 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -934,7 +934,7 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
 	*in = mlx5_vzalloc(*inlen);
 	if (!*in) {
 		err = -ENOMEM;
-		goto err_buf;
+		goto free_buffer;
 	}
 
 	qpc = MLX5_ADDR_OF(create_qp_in, *in, qpc);
@@ -956,45 +956,56 @@ static int create_kernel_qp(struct mlx5_ib_dev *dev,
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
2.12.2
