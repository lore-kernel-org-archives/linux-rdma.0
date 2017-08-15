From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v1 10/11] IB/mlx5: Support IB_SRQT_TM
Date: Tue, 15 Aug 2017 11:59:11 +0300
Message-ID: <20170815085912.10181-11-leon@kernel.org>
References: <20170815085912.10181-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815085912.10181-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Pass to mlx5_core flag to enable rendezvous offload, list_size and CQ
when SRQ created with IB_SRQT_TM.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yossi Itigin <yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/qp.c  |  9 +++++++--
 drivers/infiniband/hw/mlx5/srq.c | 18 +++++++++++++++---
 2 files changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 5c7ce9bd466e..ebbfd721661d 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -1718,10 +1718,15 @@ static int create_qp_common(struct mlx5_ib_dev *dev, struct ib_pd *pd,
 
 	MLX5_SET(qpc, qpc, rq_type, get_rx_type(qp, init_attr));
 
-	if (qp->sq.wqe_cnt)
+	if (qp->sq.wqe_cnt) {
 		MLX5_SET(qpc, qpc, log_sq_size, ilog2(qp->sq.wqe_cnt));
-	else
+	} else {
 		MLX5_SET(qpc, qpc, no_sq, 1);
+		if (init_attr->srq &&
+		    init_attr->srq->srq_type == IB_SRQT_TM)
+			MLX5_SET(qpc, qpc, offload_type,
+				 MLX5_QPC_OFFLOAD_TYPE_RNDV);
+	}
 
 	/* Set default resources */
 	switch (init_attr->qp_type) {
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 022b4c642047..d9af04100362 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -101,7 +101,7 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 				 udata->inlen - sizeof(ucmd)))
 		return -EINVAL;
 
-	if (in->type == IB_SRQT_XRC) {
+	if (in->type != IB_SRQT_BASIC) {
 		err = get_srq_user_index(to_mucontext(pd->uobject->context),
 					 &ucmd, udata->inlen, &uidx);
 		if (err)
@@ -145,7 +145,7 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	in->log_page_size = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 	in->page_offset = offset;
 	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
-	    in->type == IB_SRQT_XRC)
+	    in->type != IB_SRQT_BASIC)
 		in->user_index = uidx;
 
 	return 0;
@@ -205,7 +205,7 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 
 	in->log_page_size = srq->buf.page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
-	    in->type == IB_SRQT_XRC)
+	    in->type != IB_SRQT_BASIC)
 		in->user_index = MLX5_IB_DEFAULT_UIDX;
 
 	return 0;
@@ -298,6 +298,18 @@ struct ib_srq *mlx5_ib_create_srq(struct ib_pd *pd,
 	else
 		in.xrcd = to_mxrcd(dev->devr.x0)->xrcdn;
 
+	if (init_attr->srq_type == IB_SRQT_TM) {
+		in.tm_log_list_size =
+			ilog2(init_attr->ext.tag_matching.max_num_tags) + 1;
+		if (in.tm_log_list_size >
+		    MLX5_CAP_GEN(dev->mdev, log_tag_matching_list_sz)) {
+			mlx5_ib_dbg(dev, "TM SRQ max_num_tags exceeding limit\n");
+			err = -EINVAL;
+			goto err_usr_kern_srq;
+		}
+		in.flags |= MLX5_SRQ_FLAG_RNDV;
+	}
+
 	if (ib_srq_has_cq(init_attr->srq_type))
 		in.cqn = to_mcq(init_attr->ext.cq)->mcq.cqn;
 	else
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
