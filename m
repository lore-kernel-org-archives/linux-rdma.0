From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/2] IB/mlx5: Avoid using user-index for SRQs
Date: Sun, 14 Feb 2016 18:35:51 +0200
Message-ID: <1455467752-3170-2-git-send-email-matanb@mellanox.com>
References: <1455467752-3170-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1455467752-3170-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Normal SRQs, unlike XRC SRQs, don't have user-index, therefore
avoid verifying it and using it.

Fixes: cfb5e088e26a ('IB/mlx5: Add CQE version 1 support to user QPs and SRQs')
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/srq.c | 30 +++++++++++++++++++-----------
 1 file changed, 19 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 4659256..a1b7122 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -75,7 +75,8 @@ static void mlx5_ib_srq_event(struct mlx5_core_srq *srq, enum mlx5_event type)
 
 static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 			   struct mlx5_create_srq_mbox_in **in,
-			   struct ib_udata *udata, int buf_size, int *inlen)
+			   struct ib_udata *udata, int buf_size, int *inlen,
+			   int is_xrc)
 {
 	struct mlx5_ib_dev *dev = to_mdev(pd->device);
 	struct mlx5_ib_create_srq ucmd = {};
@@ -108,10 +109,12 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 				 drv_data - sizeof(ucmd)))
 		return -EINVAL;
 
-	err = get_srq_user_index(to_mucontext(pd->uobject->context),
-				 &ucmd, udata->inlen, &uidx);
-	if (err)
-		return err;
+	if (is_xrc) {
+		err = get_srq_user_index(to_mucontext(pd->uobject->context),
+					 &ucmd, udata->inlen, &uidx);
+		if (err)
+			return err;
+	}
 
 	srq->wq_sig = !!(ucmd.flags & MLX5_SRQ_FLAG_SIGNATURE);
 
@@ -151,7 +154,8 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	(*in)->ctx.log_pg_sz = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 	(*in)->ctx.pgoff_cqn = cpu_to_be32(offset << 26);
 
-	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1) {
+	if ((MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1) &&
+	     is_xrc){
 		xsrqc = MLX5_ADDR_OF(create_xrc_srq_in, *in,
 				     xrc_srq_context_entry);
 		MLX5_SET(xrc_srqc, xsrqc, user_index, uidx);
@@ -170,7 +174,7 @@ err_umem:
 
 static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 			     struct mlx5_create_srq_mbox_in **in, int buf_size,
-			     int *inlen)
+			     int *inlen, int is_xrc)
 {
 	int err;
 	int i;
@@ -224,7 +228,8 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 
 	(*in)->ctx.log_pg_sz = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 
-	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1) {
+	if ((MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1) &&
+	     is_xrc){
 		xsrqc = MLX5_ADDR_OF(create_xrc_srq_in, *in,
 				     xrc_srq_context_entry);
 		/* 0xffffff means we ask to work with cqe version 0 */
@@ -302,10 +307,14 @@ struct ib_srq *mlx5_ib_create_srq(struct ib_pd *pd,
 		    desc_size, init_attr->attr.max_wr, srq->msrq.max, srq->msrq.max_gs,
 		    srq->msrq.max_avail_gather);
 
+	is_xrc = (init_attr->srq_type == IB_SRQT_XRC);
+
 	if (pd->uobject)
-		err = create_srq_user(pd, srq, &in, udata, buf_size, &inlen);
+		err = create_srq_user(pd, srq, &in, udata, buf_size, &inlen,
+				      is_xrc);
 	else
-		err = create_srq_kernel(dev, srq, &in, buf_size, &inlen);
+		err = create_srq_kernel(dev, srq, &in, buf_size, &inlen,
+					is_xrc);
 
 	if (err) {
 		mlx5_ib_warn(dev, "create srq %s failed, err %d\n",
@@ -313,7 +322,6 @@ struct ib_srq *mlx5_ib_create_srq(struct ib_pd *pd,
 		goto err_srq;
 	}
 
-	is_xrc = (init_attr->srq_type == IB_SRQT_XRC);
 	in->ctx.state_log_sz = ilog2(srq->msrq.max);
 	flgs = ((srq->msrq.wqe_shift - 4) | (is_xrc << 5) | (srq->wq_sig << 7)) << 24;
 	xrcdn = 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
