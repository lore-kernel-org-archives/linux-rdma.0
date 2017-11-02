From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/5] IB/mlx4: Add contig support for control objects
Date: Thu,  2 Nov 2017 15:22:25 +0200
Message-ID: <20171102132228.20985-3-leon@kernel.org>
References: <20171102132228.20985-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171102132228.20985-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Taking advantage of the optimization which was introduced in previous
commit ("IB/mlx4: Use optimal numbers of MTT entries") to optimize the
MTT usage for QP and CQ.

Signed-off-by: Guy Levi <guyle-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/cq.c      | 8 ++++++--
 drivers/infiniband/hw/mlx4/mlx4_ib.h | 2 ++
 drivers/infiniband/hw/mlx4/mr.c      | 5 ++---
 drivers/infiniband/hw/mlx4/qp.c      | 8 ++++++--
 4 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/cq.c b/drivers/infiniband/hw/mlx4/cq.c
index 6d5f405912dd..bf4f14a1b4fc 100644
--- a/drivers/infiniband/hw/mlx4/cq.c
+++ b/drivers/infiniband/hw/mlx4/cq.c
@@ -140,14 +140,18 @@ static int mlx4_ib_get_cq_umem(struct mlx4_ib_dev *dev, struct ib_ucontext *cont
 {
 	int err;
 	int cqe_size = dev->dev->caps.cqe_size;
+	int shift;
+	int n;
 
 	*umem = ib_umem_get(context, buf_addr, cqe * cqe_size,
 			    IB_ACCESS_LOCAL_WRITE, 1);
 	if (IS_ERR(*umem))
 		return PTR_ERR(*umem);
 
-	err = mlx4_mtt_init(dev->dev, ib_umem_page_count(*umem),
-			    (*umem)->page_shift, &buf->mtt);
+	n = ib_umem_page_count(*umem);
+	shift = mlx4_ib_umem_calc_optimal_mtt_size(*umem, 0, &n);
+	err = mlx4_mtt_init(dev->dev, n, shift, &buf->mtt);
+
 	if (err)
 		goto err_buf;
 
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 9a55064ed69a..31ffdb2609d8 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -930,5 +930,7 @@ struct ib_rwq_ind_table
 			      struct ib_rwq_ind_table_init_attr *init_attr,
 			      struct ib_udata *udata);
 int mlx4_ib_destroy_rwq_ind_table(struct ib_rwq_ind_table *wq_ind_table);
+int mlx4_ib_umem_calc_optimal_mtt_size(struct ib_umem *umem, u64 start_va,
+				       int *num_of_mtts);
 
 #endif /* MLX4_IB_H */
diff --git a/drivers/infiniband/hw/mlx4/mr.c b/drivers/infiniband/hw/mlx4/mr.c
index 8f408a02f699..313bfb9ccb71 100644
--- a/drivers/infiniband/hw/mlx4/mr.c
+++ b/drivers/infiniband/hw/mlx4/mr.c
@@ -254,9 +254,8 @@ int mlx4_ib_umem_write_mtt(struct mlx4_ib_dev *dev, struct mlx4_mtt *mtt,
  * middle already handled as part of mtt shift calculation for both their start
  * & end addresses.
  */
-static int mlx4_ib_umem_calc_optimal_mtt_size(struct ib_umem *umem,
-					      u64 start_va,
-					      int *num_of_mtts)
+int mlx4_ib_umem_calc_optimal_mtt_size(struct ib_umem *umem, u64 start_va,
+				       int *num_of_mtts)
 {
 	u64 block_shift = MLX4_MAX_MTT_SHIFT;
 	u64 min_shift = umem->page_shift;
diff --git a/drivers/infiniband/hw/mlx4/qp.c b/drivers/infiniband/hw/mlx4/qp.c
index b6b33d99b0b4..3e030ae6ca4f 100644
--- a/drivers/infiniband/hw/mlx4/qp.c
+++ b/drivers/infiniband/hw/mlx4/qp.c
@@ -1038,6 +1038,8 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			struct mlx4_ib_create_wq wq;
 		} ucmd;
 		size_t copy_len;
+		int shift;
+		int n;
 
 		copy_len = (src == MLX4_IB_QP_SRC) ?
 			   sizeof(struct mlx4_ib_create_qp) :
@@ -1100,8 +1102,10 @@ static int create_qp_common(struct mlx4_ib_dev *dev, struct ib_pd *pd,
 			goto err;
 		}
 
-		err = mlx4_mtt_init(dev->dev, ib_umem_page_count(qp->umem),
-				    qp->umem->page_shift, &qp->mtt);
+		n = ib_umem_page_count(qp->umem);
+		shift = mlx4_ib_umem_calc_optimal_mtt_size(qp->umem, 0, &n);
+		err = mlx4_mtt_init(dev->dev, n, shift, &qp->mtt);
+
 		if (err)
 			goto err_buf;
 
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
