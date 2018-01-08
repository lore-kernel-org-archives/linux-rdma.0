From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH 7/8] verbs: Convert all providers to use verbs_set_ops
Date: Mon,  8 Jan 2018 14:26:31 -0700
Message-ID: <20180108212632.5183-8-jgg@ziepe.ca>
References: <20180108212632.5183-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180108212632.5183-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Devesh Sharma <Devesh.sharma-dY08KVG/lbpWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tatyana Nikolova <Tatyana.E.Nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Ariel Elior <Ariel.Elior-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, intel-opa-hn68Rpc1hR1g9hUCZPvPmw@public.gmane.org, infinipath-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Using verbs_set_ops ensures the provider does not replace the dummy
function set by the core code with NULL.

Some providers have multiple sets of ops, those call verbs_set_ops multiple
times, and the calls overlap exactly as before.

This also fixes a few providers that were writing to the ops structure in
.data so we can also make them all const now.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 providers/bnxt_re/main.c           |  4 +--
 providers/cxgb3/iwch.c             | 27 +++++++++++-------
 providers/cxgb4/dev.c              | 18 +++++++-----
 providers/hfi1verbs/hfiverbs.c     | 37 +++++++++++++-----------
 providers/i40iw/i40iw_umain.c      |  9 ++----
 providers/ipathverbs/ipathverbs.c  | 35 ++++++++++++-----------
 providers/mlx4/mlx4.c              | 42 +++++++++++++--------------
 providers/mlx5/mlx5.c              | 58 ++++++++++++++++++++------------------
 providers/mthca/mthca.c            | 39 +++++++++++++------------
 providers/nes/nes_umain.c          | 15 +++++-----
 providers/ocrdma/ocrdma_main.c     |  5 ++--
 providers/qedr/qelr_main.c         |  5 ++--
 providers/rxe/rxe.c                |  5 ++--
 providers/vmw_pvrdma/pvrdma_main.c |  5 ++--
 14 files changed, 161 insertions(+), 143 deletions(-)

diff --git a/providers/bnxt_re/main.c b/providers/bnxt_re/main.c
index d689b392d05b5d..520bf572621d18 100644
--- a/providers/bnxt_re/main.c
+++ b/providers/bnxt_re/main.c
@@ -75,7 +75,7 @@ static const struct verbs_match_ent cna_table[] = {
 	{}
 };
 
-static struct ibv_context_ops bnxt_re_cntx_ops = {
+static const struct verbs_context_ops bnxt_re_cntx_ops = {
 	.query_device  = bnxt_re_query_device,
 	.query_port    = bnxt_re_query_port,
 	.alloc_pd      = bnxt_re_alloc_pd,
@@ -136,7 +136,7 @@ static struct verbs_context *bnxt_re_alloc_context(struct ibv_device *vdev,
 	}
 	pthread_mutex_init(&cntx->shlock, NULL);
 
-	cntx->ibvctx.context.ops = bnxt_re_cntx_ops;
+	verbs_set_ops(&cntx->ibvctx, &bnxt_re_cntx_ops);
 
 	return &cntx->ibvctx;
 
diff --git a/providers/cxgb3/iwch.c b/providers/cxgb3/iwch.c
index d4d5a96ffd524e..8e2405f1c0ff60 100644
--- a/providers/cxgb3/iwch.c
+++ b/providers/cxgb3/iwch.c
@@ -75,7 +75,7 @@ static const struct verbs_match_ent hca_table[] = {
 	{},
 };
 
-static struct ibv_context_ops iwch_ctx_ops = {
+static const struct verbs_context_ops iwch_ctx_common_ops = {
 	.query_device = iwch_query_device,
 	.query_port = iwch_query_port,
 	.alloc_pd = iwch_alloc_pd,
@@ -100,6 +100,19 @@ static struct ibv_context_ops iwch_ctx_ops = {
 	.req_notify_cq = iwch_arm_cq,
 };
 
+static const struct verbs_context_ops iwch_ctx_t3a_ops = {
+	.poll_cq = t3a_poll_cq,
+	.post_recv = t3a_post_recv,
+	.post_send = t3a_post_send,
+};
+
+static const struct verbs_context_ops iwch_ctx_t3b_ops = {
+	.async_event = t3b_async_event,
+	.poll_cq = t3b_poll_cq,
+	.post_recv = t3b_post_recv,
+	.post_send = t3b_post_send,
+};
+
 unsigned long iwch_page_size;
 unsigned long iwch_page_shift;
 unsigned long iwch_page_mask;
@@ -120,22 +133,16 @@ static struct verbs_context *iwch_alloc_context(struct ibv_device *ibdev,
 				&resp.ibv_resp, sizeof resp))
 		goto err_free;
 
-	context->ibv_ctx.context.ops = iwch_ctx_ops;
+	verbs_set_ops(&context->ibv_ctx, &iwch_ctx_common_ops);
 
 	switch (rhp->hca_type) {
 	case CHELSIO_T3B:
 		PDBG("%s T3B device\n", __FUNCTION__);
-		context->ibv_ctx.context.ops.async_event = t3b_async_event;
-		context->ibv_ctx.context.ops.post_send = t3b_post_send;
-		context->ibv_ctx.context.ops.post_recv = t3b_post_recv;
-		context->ibv_ctx.context.ops.poll_cq = t3b_poll_cq;
+		verbs_set_ops(&context->ibv_ctx, &iwch_ctx_t3b_ops);
 		break;
 	case CHELSIO_T3A:
 		PDBG("%s T3A device\n", __FUNCTION__);
-		context->ibv_ctx.context.ops.async_event = NULL;
-		context->ibv_ctx.context.ops.post_send = t3a_post_send;
-		context->ibv_ctx.context.ops.post_recv = t3a_post_recv;
-		context->ibv_ctx.context.ops.poll_cq = t3a_poll_cq;
+		verbs_set_ops(&context->ibv_ctx, &iwch_ctx_t3a_ops);
 		break;
 	default:
 		PDBG("%s unknown hca type %d\n", __FUNCTION__, rhp->hca_type);
diff --git a/providers/cxgb4/dev.c b/providers/cxgb4/dev.c
index 3c309d9f5defb5..4d6032768e4893 100644
--- a/providers/cxgb4/dev.c
+++ b/providers/cxgb4/dev.c
@@ -71,7 +71,7 @@ int t5_en_wc = 1;
 
 static LIST_HEAD(devices);
 
-static struct ibv_context_ops c4iw_ctx_ops = {
+static const struct verbs_context_ops  c4iw_ctx_common_ops = {
 	.query_device = c4iw_query_device,
 	.query_port = c4iw_query_port,
 	.alloc_pd = c4iw_alloc_pd,
@@ -96,6 +96,14 @@ static struct ibv_context_ops c4iw_ctx_ops = {
 	.req_notify_cq = c4iw_arm_cq,
 };
 
+static const struct verbs_context_ops c4iw_ctx_t4_ops = {
+	.async_event = c4iw_async_event,
+	.poll_cq = c4iw_poll_cq,
+	.post_recv = c4iw_post_receive,
+	.post_send = c4iw_post_send,
+	.req_notify_cq = c4iw_arm_cq,
+};
+
 static struct verbs_context *c4iw_alloc_context(struct ibv_device *ibdev,
 						int cmd_fd)
 {
@@ -130,7 +138,7 @@ static struct verbs_context *c4iw_alloc_context(struct ibv_device *ibdev,
 			goto err_free;
 	} 
 
-	context->ibv_ctx.context.ops = c4iw_ctx_ops;
+	verbs_set_ops(&context->ibv_ctx, &c4iw_ctx_common_ops);
 
 	switch (rhp->chip_version) {
 	case CHELSIO_T6:
@@ -139,11 +147,7 @@ static struct verbs_context *c4iw_alloc_context(struct ibv_device *ibdev,
 		PDBG("%s T5/T4 device\n", __FUNCTION__);
 	case CHELSIO_T4:
 		PDBG("%s T4 device\n", __FUNCTION__);
-		context->ibv_ctx.context.ops.async_event = c4iw_async_event;
-		context->ibv_ctx.context.ops.post_send = c4iw_post_send;
-		context->ibv_ctx.context.ops.post_recv = c4iw_post_receive;
-		context->ibv_ctx.context.ops.poll_cq = c4iw_poll_cq;
-		context->ibv_ctx.context.ops.req_notify_cq = c4iw_arm_cq;
+		verbs_set_ops(&context->ibv_ctx, &c4iw_ctx_t4_ops);
 		break;
 	default:
 		PDBG("%s unknown hca type %d\n", __FUNCTION__,
diff --git a/providers/hfi1verbs/hfiverbs.c b/providers/hfi1verbs/hfiverbs.c
index 6117f99fbc27a2..e9d3261f599e3f 100644
--- a/providers/hfi1verbs/hfiverbs.c
+++ b/providers/hfi1verbs/hfiverbs.c
@@ -85,7 +85,7 @@ static const struct verbs_match_ent hca_table[] = {
 	{}
 };
 
-static struct ibv_context_ops hfi1_ctx_ops = {
+static const struct verbs_context_ops hfi1_ctx_common_ops = {
 	.query_device	= hfi1_query_device,
 	.query_port	= hfi1_query_port,
 
@@ -98,7 +98,6 @@ static struct ibv_context_ops hfi1_ctx_ops = {
 	.create_cq	= hfi1_create_cq,
 	.poll_cq	= hfi1_poll_cq,
 	.req_notify_cq	= ibv_cmd_req_notify_cq,
-	.cq_event	= NULL,
 	.resize_cq	= hfi1_resize_cq,
 	.destroy_cq	= hfi1_destroy_cq,
 
@@ -123,6 +122,20 @@ static struct ibv_context_ops hfi1_ctx_ops = {
 	.detach_mcast	= ibv_cmd_detach_mcast
 };
 
+static const struct verbs_context_ops hfi1_ctx_v1_ops = {
+	.create_cq = hfi1_create_cq_v1,
+	.create_qp = hfi1_create_qp_v1,
+	.create_srq = hfi1_create_srq_v1,
+	.destroy_cq = hfi1_destroy_cq_v1,
+	.destroy_qp = hfi1_destroy_qp_v1,
+	.destroy_srq = hfi1_destroy_srq_v1,
+	.modify_srq = hfi1_modify_srq_v1,
+	.poll_cq = ibv_cmd_poll_cq,
+	.post_recv = ibv_cmd_post_recv,
+	.post_srq_recv = ibv_cmd_post_srq_recv,
+	.resize_cq = hfi1_resize_cq_v1,
+};
+
 static struct verbs_context *hfi1_alloc_context(struct ibv_device *ibdev,
 						int cmd_fd)
 {
@@ -139,22 +152,12 @@ static struct verbs_context *hfi1_alloc_context(struct ibv_device *ibdev,
 				sizeof cmd, &resp, sizeof resp))
 		goto err_free;
 
-	context->ibv_ctx.context.ops = hfi1_ctx_ops;
+	verbs_set_ops(&context->ibv_ctx, &hfi1_ctx_common_ops);
+
 	dev = to_idev(ibdev);
-	if (dev->abi_version == 1) {
-		context->ibv_ctx.context.ops.create_cq = hfi1_create_cq_v1;
-		context->ibv_ctx.context.ops.poll_cq = ibv_cmd_poll_cq;
-		context->ibv_ctx.context.ops.resize_cq = hfi1_resize_cq_v1;
-		context->ibv_ctx.context.ops.destroy_cq = hfi1_destroy_cq_v1;
-		context->ibv_ctx.context.ops.create_srq = hfi1_create_srq_v1;
-		context->ibv_ctx.context.ops.destroy_srq = hfi1_destroy_srq_v1;
-		context->ibv_ctx.context.ops.modify_srq = hfi1_modify_srq_v1;
-		context->ibv_ctx.context.ops.post_srq_recv =
-			ibv_cmd_post_srq_recv;
-		context->ibv_ctx.context.ops.create_qp = hfi1_create_qp_v1;
-		context->ibv_ctx.context.ops.destroy_qp = hfi1_destroy_qp_v1;
-		context->ibv_ctx.context.ops.post_recv = ibv_cmd_post_recv;
-	}
+	if (dev->abi_version == 1)
+		verbs_set_ops(&context->ibv_ctx, &hfi1_ctx_v1_ops);
+
 	return &context->ibv_ctx;
 
 err_free:
diff --git a/providers/i40iw/i40iw_umain.c b/providers/i40iw/i40iw_umain.c
index 6ec40895efcfe0..6e2526711ae211 100644
--- a/providers/i40iw/i40iw_umain.c
+++ b/providers/i40iw/i40iw_umain.c
@@ -91,7 +91,7 @@ static const struct verbs_match_ent hca_table[] = {
 	{}
 };
 
-static struct ibv_context_ops i40iw_uctx_ops = {
+static const struct verbs_context_ops i40iw_uctx_ops = {
 	.query_device	= i40iw_uquery_device,
 	.query_port	= i40iw_uquery_port,
 	.alloc_pd	= i40iw_ualloc_pd,
@@ -104,11 +104,6 @@ static struct ibv_context_ops i40iw_uctx_ops = {
 	.cq_event	= i40iw_cq_event,
 	.resize_cq	= i40iw_uresize_cq,
 	.destroy_cq	= i40iw_udestroy_cq,
-	.create_srq	= NULL,
-	.modify_srq	= NULL,
-	.query_srq	= NULL,
-	.destroy_srq	= NULL,
-	.post_srq_recv	= NULL,
 	.create_qp	= i40iw_ucreate_qp,
 	.query_qp	= i40iw_uquery_qp,
 	.modify_qp	= i40iw_umodify_qp,
@@ -161,7 +156,7 @@ static struct verbs_context *i40iw_ualloc_context(struct ibv_device *ibdev,
 		goto err_free;
 	}
 
-	iwvctx->ibv_ctx.context.ops = i40iw_uctx_ops;
+	verbs_set_ops(&iwvctx->ibv_ctx, &i40iw_uctx_ops);
 	iwvctx->max_pds = resp.max_pds;
 	iwvctx->max_qps = resp.max_qps;
 	iwvctx->wq_size = resp.wq_size;
diff --git a/providers/ipathverbs/ipathverbs.c b/providers/ipathverbs/ipathverbs.c
index 3f7f170ed6b986..f2c96187d8cb5d 100644
--- a/providers/ipathverbs/ipathverbs.c
+++ b/providers/ipathverbs/ipathverbs.c
@@ -84,7 +84,7 @@ static const struct verbs_match_ent hca_table[] = {
 	{}
 };
 
-static struct ibv_context_ops ipath_ctx_ops = {
+static const struct verbs_context_ops ipath_ctx_common_ops = {
 	.query_device	= ipath_query_device,
 	.query_port	= ipath_query_port,
 
@@ -97,7 +97,6 @@ static struct ibv_context_ops ipath_ctx_ops = {
 	.create_cq	= ipath_create_cq,
 	.poll_cq	= ipath_poll_cq,
 	.req_notify_cq	= ibv_cmd_req_notify_cq,
-	.cq_event	= NULL,
 	.resize_cq	= ipath_resize_cq,
 	.destroy_cq	= ipath_destroy_cq,
 
@@ -122,6 +121,20 @@ static struct ibv_context_ops ipath_ctx_ops = {
 	.detach_mcast	= ibv_cmd_detach_mcast
 };
 
+static const struct verbs_context_ops ipath_ctx_v1_ops = {
+	.create_cq = ipath_create_cq_v1,
+	.poll_cq = ibv_cmd_poll_cq,
+	.resize_cq = ipath_resize_cq_v1,
+	.destroy_cq = ipath_destroy_cq_v1,
+	.create_srq = ipath_create_srq_v1,
+	.destroy_srq = ipath_destroy_srq_v1,
+	.modify_srq = ipath_modify_srq_v1,
+	.post_srq_recv = ibv_cmd_post_srq_recv,
+	.create_qp = ipath_create_qp_v1,
+	.destroy_qp = ipath_destroy_qp_v1,
+	.post_recv = ibv_cmd_post_recv,
+};
+
 static struct verbs_context *ipath_alloc_context(struct ibv_device *ibdev,
 						 int cmd_fd)
 {
@@ -138,22 +151,10 @@ static struct verbs_context *ipath_alloc_context(struct ibv_device *ibdev,
 				sizeof cmd, &resp, sizeof resp))
 		goto err_free;
 
-	context->ibv_ctx.context.ops = ipath_ctx_ops;
+	verbs_set_ops(&context->ibv_ctx, &ipath_ctx_common_ops);
 	dev = to_idev(ibdev);
-	if (dev->abi_version == 1) {
-		context->ibv_ctx.context.ops.create_cq = ipath_create_cq_v1;
-		context->ibv_ctx.context.ops.poll_cq = ibv_cmd_poll_cq;
-		context->ibv_ctx.context.ops.resize_cq = ipath_resize_cq_v1;
-		context->ibv_ctx.context.ops.destroy_cq = ipath_destroy_cq_v1;
-		context->ibv_ctx.context.ops.create_srq = ipath_create_srq_v1;
-		context->ibv_ctx.context.ops.destroy_srq = ipath_destroy_srq_v1;
-		context->ibv_ctx.context.ops.modify_srq = ipath_modify_srq_v1;
-		context->ibv_ctx.context.ops.post_srq_recv =
-			ibv_cmd_post_srq_recv;
-		context->ibv_ctx.context.ops.create_qp = ipath_create_qp_v1;
-		context->ibv_ctx.context.ops.destroy_qp = ipath_destroy_qp_v1;
-		context->ibv_ctx.context.ops.post_recv = ibv_cmd_post_recv;
-	}
+	if (dev->abi_version == 1)
+		verbs_set_ops(&context->ibv_ctx, &ipath_ctx_v1_ops);
 	return &context->ibv_ctx;
 
 err_free:
diff --git a/providers/mlx4/mlx4.c b/providers/mlx4/mlx4.c
index f0d63b57792602..dd7b98b040185a 100644
--- a/providers/mlx4/mlx4.c
+++ b/providers/mlx4/mlx4.c
@@ -81,7 +81,7 @@ static const struct verbs_match_ent hca_table[] = {
 	{}
 };
 
-static struct ibv_context_ops mlx4_ctx_ops = {
+static const struct verbs_context_ops mlx4_ctx_ops = {
 	.query_device  = mlx4_query_device,
 	.query_port    = mlx4_query_port,
 	.alloc_pd      = mlx4_alloc_pd,
@@ -112,7 +112,25 @@ static struct ibv_context_ops mlx4_ctx_ops = {
 	.create_ah     = mlx4_create_ah,
 	.destroy_ah    = mlx4_destroy_ah,
 	.attach_mcast  = ibv_cmd_attach_mcast,
-	.detach_mcast  = ibv_cmd_detach_mcast
+	.detach_mcast  = ibv_cmd_detach_mcast,
+
+	.close_xrcd = mlx4_close_xrcd,
+	.create_cq_ex = mlx4_create_cq_ex,
+	.create_flow = mlx4_create_flow,
+	.create_qp_ex = mlx4_create_qp_ex,
+	.create_rwq_ind_table = mlx4_create_rwq_ind_table,
+	.create_srq_ex = mlx4_create_srq_ex,
+	.create_wq = mlx4_create_wq,
+	.destroy_flow = mlx4_destroy_flow,
+	.destroy_rwq_ind_table = mlx4_destroy_rwq_ind_table,
+	.destroy_wq = mlx4_destroy_wq,
+	.get_srq_num = verbs_get_srq_num,
+	.modify_cq = mlx4_modify_cq,
+	.modify_wq = mlx4_modify_wq,
+	.open_qp = mlx4_open_qp,
+	.open_xrcd = mlx4_open_xrcd,
+	.query_device_ex = mlx4_query_device_ex,
+	.query_rt_values = mlx4_query_rt_values,
 };
 
 static void mlx4_read_env(void)
@@ -226,7 +244,7 @@ static struct verbs_context *mlx4_alloc_context(struct ibv_device *ibdev,
 		context->bf_buf_size = 0;
 	}
 
-	verbs_ctx->context.ops = mlx4_ctx_ops;
+	verbs_set_ops(verbs_ctx, &mlx4_ctx_ops);
 
 	context->hca_core_clock = NULL;
 	memset(&dev_attrs, 0, sizeof(dev_attrs));
@@ -238,24 +256,6 @@ static struct verbs_context *mlx4_alloc_context(struct ibv_device *ibdev,
 			mlx4_map_internal_clock(dev, &verbs_ctx->context);
 	}
 
-	verbs_ctx->close_xrcd = mlx4_close_xrcd;
-	verbs_ctx->open_xrcd = mlx4_open_xrcd;
-	verbs_ctx->create_srq_ex = mlx4_create_srq_ex;
-	verbs_ctx->get_srq_num = verbs_get_srq_num;
-	verbs_ctx->create_qp_ex = mlx4_create_qp_ex;
-	verbs_ctx->open_qp = mlx4_open_qp;
-	verbs_ctx->ibv_create_flow = mlx4_create_flow;
-	verbs_ctx->ibv_destroy_flow = mlx4_destroy_flow;
-	verbs_ctx->create_cq_ex = mlx4_create_cq_ex;
-	verbs_ctx->query_device_ex = mlx4_query_device_ex;
-	verbs_ctx->query_rt_values = mlx4_query_rt_values;
-	verbs_ctx->create_wq = mlx4_create_wq;
-	verbs_ctx->modify_wq = mlx4_modify_wq;
-	verbs_ctx->destroy_wq = mlx4_destroy_wq;
-	verbs_ctx->create_rwq_ind_table = mlx4_create_rwq_ind_table;
-	verbs_ctx->destroy_rwq_ind_table = mlx4_destroy_rwq_ind_table;
-	verbs_ctx->modify_cq = mlx4_modify_cq;
-
 	return verbs_ctx;
 
 failed:
diff --git a/providers/mlx5/mlx5.c b/providers/mlx5/mlx5.c
index 41b484fce29683..34d17d91da1b5d 100644
--- a/providers/mlx5/mlx5.c
+++ b/providers/mlx5/mlx5.c
@@ -81,7 +81,7 @@ static const struct verbs_match_ent hca_table[] = {
 uint32_t mlx5_debug_mask = 0;
 int mlx5_freeze_on_error_cqe;
 
-static struct ibv_context_ops mlx5_ctx_ops = {
+static const struct verbs_context_ops mlx5_ctx_common_ops = {
 	.query_device  = mlx5_query_device,
 	.query_port    = mlx5_query_port,
 	.alloc_pd      = mlx5_alloc_pd,
@@ -112,7 +112,29 @@ static struct ibv_context_ops mlx5_ctx_ops = {
 	.create_ah     = mlx5_create_ah,
 	.destroy_ah    = mlx5_destroy_ah,
 	.attach_mcast  = mlx5_attach_mcast,
-	.detach_mcast  = mlx5_detach_mcast
+	.detach_mcast  = mlx5_detach_mcast,
+
+	.close_xrcd = mlx5_close_xrcd,
+	.create_cq_ex = mlx5_create_cq_ex,
+	.create_qp_ex = mlx5_create_qp_ex,
+	.create_rwq_ind_table = mlx5_create_rwq_ind_table,
+	.create_srq_ex = mlx5_create_srq_ex,
+	.create_wq = mlx5_create_wq,
+	.destroy_rwq_ind_table = mlx5_destroy_rwq_ind_table,
+	.destroy_wq = mlx5_destroy_wq,
+	.get_srq_num = mlx5_get_srq_num,
+	.create_flow = mlx5_create_flow,
+	.destroy_flow = mlx5_destroy_flow,
+	.modify_cq = mlx5_modify_cq,
+	.modify_wq = mlx5_modify_wq,
+	.open_xrcd = mlx5_open_xrcd,
+	.post_srq_ops = mlx5_post_srq_ops,
+	.query_device_ex = mlx5_query_device_ex,
+	.query_rt_values = mlx5_query_rt_values,
+};
+
+static const struct verbs_context_ops mlx5_ctx_cqev1_ops = {
+	.poll_cq = mlx5_poll_cq_v1,
 };
 
 static int read_number_from_line(const char *line, int *value)
@@ -932,12 +954,6 @@ static struct verbs_context *mlx5_alloc_context(struct ibv_device *ibdev,
 	context->max_srq_recv_wr = resp.max_srq_recv_wr;
 
 	context->cqe_version = resp.cqe_version;
-	if (context->cqe_version) {
-		if (context->cqe_version == MLX5_CQE_VERSION_V1)
-			mlx5_ctx_ops.poll_cq = mlx5_poll_cq_v1;
-		else
-			goto err_free;
-	}
 
 	adjust_uar_info(mdev, context, resp);
 
@@ -1009,25 +1025,13 @@ static struct verbs_context *mlx5_alloc_context(struct ibv_device *ibdev,
 	mlx5_spinlock_init(&context->hugetlb_lock);
 	list_head_init(&context->hugetlb_list);
 
-	v_ctx->context.ops = mlx5_ctx_ops;
-
-	v_ctx->create_qp_ex = mlx5_create_qp_ex;
-	v_ctx->open_xrcd = mlx5_open_xrcd;
-	v_ctx->close_xrcd = mlx5_close_xrcd;
-	v_ctx->create_srq_ex = mlx5_create_srq_ex;
-	v_ctx->get_srq_num = mlx5_get_srq_num;
-	v_ctx->query_device_ex = mlx5_query_device_ex;
-	v_ctx->query_rt_values = mlx5_query_rt_values;
-	v_ctx->ibv_create_flow = mlx5_create_flow;
-	v_ctx->ibv_destroy_flow = mlx5_destroy_flow;
-	v_ctx->create_cq_ex = mlx5_create_cq_ex;
-	v_ctx->create_wq = mlx5_create_wq;
-	v_ctx->modify_wq = mlx5_modify_wq;
-	v_ctx->destroy_wq = mlx5_destroy_wq;
-	v_ctx->create_rwq_ind_table = mlx5_create_rwq_ind_table;
-	v_ctx->destroy_rwq_ind_table = mlx5_destroy_rwq_ind_table;
-	v_ctx->post_srq_ops = mlx5_post_srq_ops;
-	v_ctx->modify_cq = mlx5_modify_cq;
+	verbs_set_ops(v_ctx, &mlx5_ctx_common_ops);
+	if (context->cqe_version) {
+		if (context->cqe_version == MLX5_CQE_VERSION_V1)
+			verbs_set_ops(v_ctx, &mlx5_ctx_cqev1_ops);
+		else
+			goto err_free;
+	}
 
 	memset(&device_attr, 0, sizeof(device_attr));
 	if (!mlx5_query_device_ex(&v_ctx->context, NULL, &device_attr,
diff --git a/providers/mthca/mthca.c b/providers/mthca/mthca.c
index 15827391986d3a..25cf31622dcb28 100644
--- a/providers/mthca/mthca.c
+++ b/providers/mthca/mthca.c
@@ -89,7 +89,7 @@ static const struct verbs_match_ent hca_table[] = {
 	{}
 };
 
-static struct ibv_context_ops mthca_ctx_ops = {
+static const struct verbs_context_ops mthca_ctx_common_ops = {
 	.query_device  = mthca_query_device,
 	.query_port    = mthca_query_port,
 	.alloc_pd      = mthca_alloc_pd,
@@ -114,6 +114,21 @@ static struct ibv_context_ops mthca_ctx_ops = {
 	.detach_mcast  = ibv_cmd_detach_mcast
 };
 
+static const struct verbs_context_ops mthca_ctx_arbel_ops = {
+	.cq_event = mthca_arbel_cq_event,
+	.post_recv = mthca_arbel_post_recv,
+	.post_send = mthca_arbel_post_send,
+	.post_srq_recv = mthca_arbel_post_srq_recv,
+	.req_notify_cq = mthca_arbel_arm_cq,
+};
+
+static const struct verbs_context_ops mthca_ctx_tavor_ops = {
+	.post_recv = mthca_tavor_post_recv,
+	.post_send = mthca_tavor_post_send,
+	.post_srq_recv = mthca_tavor_post_srq_recv,
+	.req_notify_cq = mthca_tavor_arm_cq,
+};
+
 static struct verbs_context *mthca_alloc_context(struct ibv_device *ibdev,
 						 int cmd_fd)
 {
@@ -158,23 +173,11 @@ static struct verbs_context *mthca_alloc_context(struct ibv_device *ibdev,
 
 	context->pd->context = &context->ibv_ctx.context;
 
-	context->ibv_ctx.context.ops = mthca_ctx_ops;
-
-	if (mthca_is_memfree(&context->ibv_ctx.context)) {
-		context->ibv_ctx.context.ops.req_notify_cq = mthca_arbel_arm_cq;
-		context->ibv_ctx.context.ops.cq_event = mthca_arbel_cq_event;
-		context->ibv_ctx.context.ops.post_send = mthca_arbel_post_send;
-		context->ibv_ctx.context.ops.post_recv = mthca_arbel_post_recv;
-		context->ibv_ctx.context.ops.post_srq_recv =
-			mthca_arbel_post_srq_recv;
-	} else {
-		context->ibv_ctx.context.ops.req_notify_cq = mthca_tavor_arm_cq;
-		context->ibv_ctx.context.ops.cq_event = NULL;
-		context->ibv_ctx.context.ops.post_send = mthca_tavor_post_send;
-		context->ibv_ctx.context.ops.post_recv = mthca_tavor_post_recv;
-		context->ibv_ctx.context.ops.post_srq_recv =
-			mthca_tavor_post_srq_recv;
-	}
+	verbs_set_ops(&context->ibv_ctx, &mthca_ctx_common_ops);
+	if (mthca_is_memfree(&context->ibv_ctx.context))
+		verbs_set_ops(&context->ibv_ctx, &mthca_ctx_arbel_ops);
+	else
+		verbs_set_ops(&context->ibv_ctx, &mthca_ctx_tavor_ops);
 
 	return &context->ibv_ctx;
 
diff --git a/providers/nes/nes_umain.c b/providers/nes/nes_umain.c
index a5ae678ecfe11c..c2c8b03ebb58db 100644
--- a/providers/nes/nes_umain.c
+++ b/providers/nes/nes_umain.c
@@ -63,7 +63,7 @@ static const struct verbs_match_ent hca_table[] = {
 	{},
 };
 
-static struct ibv_context_ops nes_uctx_ops = {
+static const struct verbs_context_ops nes_uctx_ops = {
 	.query_device = nes_uquery_device,
 	.query_port = nes_uquery_port,
 	.alloc_pd = nes_ualloc_pd,
@@ -76,11 +76,6 @@ static struct ibv_context_ops nes_uctx_ops = {
 	.cq_event = nes_cq_event,
 	.resize_cq = nes_uresize_cq,
 	.destroy_cq = nes_udestroy_cq,
-	.create_srq = NULL,
-	.modify_srq = NULL,
-	.query_srq = NULL,
-	.destroy_srq = NULL,
-	.post_srq_recv = NULL,
 	.create_qp = nes_ucreate_qp,
 	.query_qp = nes_uquery_qp,
 	.modify_qp = nes_umodify_qp,
@@ -94,6 +89,10 @@ static struct ibv_context_ops nes_uctx_ops = {
 	.async_event = nes_async_event
 };
 
+static const struct verbs_context_ops nes_uctx_no_db_ops = {
+	.poll_cq = nes_upoll_cq_no_db_read,
+};
+
 
 /**
  * nes_ualloc_context
@@ -134,10 +133,10 @@ static struct verbs_context *nes_ualloc_context(struct ibv_device *ibdev,
 			sscanf(value, "%d", &nes_drv_opt);
 	}
 
+	verbs_set_ops(&nesvctx->ibv_ctx, &nes_uctx_ops);
 	if (nes_drv_opt & NES_DRV_OPT_NO_DB_READ)
-		nes_uctx_ops.poll_cq = nes_upoll_cq_no_db_read;
+		verbs_set_ops(&nesvctx->ibv_ctx, &nes_uctx_no_db_ops);
 
-	nesvctx->ibv_ctx.context.ops = nes_uctx_ops;
 	nesvctx->max_pds = resp.max_pds;
 	nesvctx->max_qps = resp.max_qps;
 	nesvctx->wq_size = resp.wq_size;
diff --git a/providers/ocrdma/ocrdma_main.c b/providers/ocrdma/ocrdma_main.c
index 5bb17eb8665bfc..5fb57149b1e802 100644
--- a/providers/ocrdma/ocrdma_main.c
+++ b/providers/ocrdma/ocrdma_main.c
@@ -64,7 +64,7 @@ static const struct verbs_match_ent ucna_table[] = {
 	{}
 };
 
-static struct ibv_context_ops ocrdma_ctx_ops = {
+static const struct verbs_context_ops ocrdma_ctx_ops = {
 	.query_device = ocrdma_query_device,
 	.query_port = ocrdma_query_port,
 	.alloc_pd = ocrdma_alloc_pd,
@@ -121,7 +121,8 @@ static struct verbs_context *ocrdma_alloc_context(struct ibv_device *ibdev,
 				&resp.ibv_resp, sizeof(resp)))
 		goto cmd_err;
 
-	ctx->ibv_ctx.context.ops = ocrdma_ctx_ops;
+	verbs_set_ops(&ctx->ibv_ctx, &ocrdma_ctx_ops);
+
 	get_ocrdma_dev(ibdev)->id = resp.dev_id;
 	get_ocrdma_dev(ibdev)->max_inline_data = resp.max_inline_data;
 	get_ocrdma_dev(ibdev)->wqe_size = resp.wqe_size;
diff --git a/providers/qedr/qelr_main.c b/providers/qedr/qelr_main.c
index 92a635cdcfca94..9926f52207ad85 100644
--- a/providers/qedr/qelr_main.c
+++ b/providers/qedr/qelr_main.c
@@ -80,7 +80,7 @@ static const struct verbs_match_ent hca_table[] = {
 	{}
 };
 
-static struct ibv_context_ops qelr_ctx_ops = {
+static const struct verbs_context_ops qelr_ctx_ops = {
 	.query_device = qelr_query_device,
 	.query_port = qelr_query_port,
 	.alloc_pd = qelr_alloc_pd,
@@ -176,8 +176,9 @@ static struct verbs_context *qelr_alloc_context(struct ibv_device *ibdev,
 				&resp.ibv_resp, sizeof(resp)))
 		goto cmd_err;
 
+	verbs_set_ops(&ctx->ibv_ctx, &qelr_ctx_ops);
+
 	ctx->kernel_page_size = sysconf(_SC_PAGESIZE);
-	ctx->ibv_ctx.context.ops = qelr_ctx_ops;
 	ctx->db_pa = resp.db_pa;
 	ctx->db_size = resp.db_size;
 	ctx->max_send_wr = resp.max_send_wr;
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index 5cfdf1aac08a86..2856afc48cc243 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -828,7 +828,7 @@ static int rxe_destroy_ah(struct ibv_ah *ibah)
 	return 0;
 }
 
-static struct ibv_context_ops rxe_ctx_ops = {
+static const struct verbs_context_ops rxe_ctx_ops = {
 	.query_device = rxe_query_device,
 	.query_port = rxe_query_port,
 	.alloc_pd = rxe_alloc_pd,
@@ -838,7 +838,6 @@ static struct ibv_context_ops rxe_ctx_ops = {
 	.create_cq = rxe_create_cq,
 	.poll_cq = rxe_poll_cq,
 	.req_notify_cq = ibv_cmd_req_notify_cq,
-	.cq_event = NULL,
 	.resize_cq = rxe_resize_cq,
 	.destroy_cq = rxe_destroy_cq,
 	.create_srq = rxe_create_srq,
@@ -873,7 +872,7 @@ static struct verbs_context *rxe_alloc_context(struct ibv_device *ibdev,
 				sizeof cmd, &resp, sizeof resp))
 		goto out;
 
-	context->ibv_ctx.context.ops = rxe_ctx_ops;
+	verbs_set_ops(&context->ibv_ctx, &rxe_ctx_ops);
 
 	return &context->ibv_ctx;
 
diff --git a/providers/vmw_pvrdma/pvrdma_main.c b/providers/vmw_pvrdma/pvrdma_main.c
index 08b1d4e6d34f07..ab23bec592b214 100644
--- a/providers/vmw_pvrdma/pvrdma_main.c
+++ b/providers/vmw_pvrdma/pvrdma_main.c
@@ -51,7 +51,7 @@
 #define PCI_VENDOR_ID_VMWARE		0x15AD
 #define PCI_DEVICE_ID_VMWARE_PVRDMA	0x0820
 
-static struct ibv_context_ops pvrdma_ctx_ops = {
+static const struct verbs_context_ops pvrdma_ctx_ops = {
 	.query_device = pvrdma_query_device,
 	.query_port = pvrdma_query_port,
 	.alloc_pd = pvrdma_alloc_pd,
@@ -129,7 +129,8 @@ static int pvrdma_init_context_shared(struct pvrdma_context *context,
 	}
 
 	pthread_spin_init(&context->uar_lock, PTHREAD_PROCESS_PRIVATE);
-	context->ibv_ctx.context.ops = pvrdma_ctx_ops;
+
+	verbs_set_ops(&context->ibv_ctx, &pvrdma_ctx_ops);
 
 	return 0;
 }
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
