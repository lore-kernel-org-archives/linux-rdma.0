From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 10/10] IB/mlx5: Support IB_SRQT_TAG_MATCHING
Date: Sun, 28 Aug 2016 14:00:50 +0300
Message-ID: <1472382050-25908-11-git-send-email-leon@kernel.org>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472382050-25908-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When SRQ created with IB_SRQT_TAG_MATCHING pass to mlx5_core CQ,
list_size and flag to enable rendezvouz offload.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/srq.c | 15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index ed6ac52..82fe622 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -102,7 +102,7 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 				 udata->inlen - sizeof(ucmd)))
 		return -EINVAL;
 
-	if (in->type == IB_SRQT_XRC) {
+	if (in->type != IB_SRQT_BASIC) {
 		err = get_srq_user_index(to_mucontext(pd->uobject->context),
 					 &ucmd, udata->inlen, &uidx);
 		if (err)
@@ -146,7 +146,7 @@ static int create_srq_user(struct ib_pd *pd, struct mlx5_ib_srq *srq,
 	in->log_page_size = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 	in->page_offset = offset;
 	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
-	    in->type == IB_SRQT_XRC)
+	    in->type != IB_SRQT_BASIC)
 		in->user_index = uidx;
 
 	return 0;
@@ -213,7 +213,7 @@ static int create_srq_kernel(struct mlx5_ib_dev *dev, struct mlx5_ib_srq *srq,
 
 	in->log_page_size = page_shift - MLX5_ADAPTER_PAGE_SHIFT;
 	if (MLX5_CAP_GEN(dev->mdev, cqe_version) == MLX5_CQE_VERSION_V1 &&
-	    in->type == IB_SRQT_XRC)
+	    in->type != IB_SRQT_BASIC)
 		in->user_index = MLX5_IB_DEFAULT_UIDX;
 
 	return 0;
@@ -284,6 +284,8 @@ struct ib_srq *mlx5_ib_create_srq(struct ib_pd *pd,
 		    desc_size, init_attr->attr.max_wr, srq->msrq.max, srq->msrq.max_gs,
 		    srq->msrq.max_avail_gather);
 
+	in.type = init_attr->srq_type;
+
 	if (pd->uobject)
 		err = create_srq_user(pd, srq, &in, udata, buf_size);
 	else
@@ -295,7 +297,6 @@ struct ib_srq *mlx5_ib_create_srq(struct ib_pd *pd,
 		goto err_srq;
 	}
 
-	in.type = init_attr->srq_type;
 	in.log_size = ilog2(srq->msrq.max);
 	in.wqe_shift = srq->msrq.wqe_shift - 4;
 	if (srq->wq_sig)
@@ -306,6 +307,12 @@ struct ib_srq *mlx5_ib_create_srq(struct ib_pd *pd,
 	} else if (init_attr->srq_type == IB_SRQT_BASIC) {
 		in.xrcd = to_mxrcd(dev->devr.x0)->xrcdn;
 		in.cqn = to_mcq(dev->devr.c0)->mcq.cqn;
+	} else if (init_attr->srq_type == IB_SRQT_TAG_MATCHING) {
+		in.xrcd = to_mxrcd(dev->devr.x0)->xrcdn;
+		in.cqn = to_mcq(init_attr->ext.tag_matching.cq)->mcq.cqn;
+		in.tm_log_list_size =
+			ilog2(init_attr->ext.tag_matching.list_size);
+		in.flags |= MLX5_SRQ_FLAG_RNDV;
 	}
 
 	in.pd = to_mpd(pd)->pdn;
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
