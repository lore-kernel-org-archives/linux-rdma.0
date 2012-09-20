From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 3/3] Fix resource leaks in the pingpong examples present in the failure/error flows.
Date: Thu, 20 Sep 2012 23:30:34 +0300
Message-ID: <1348173034-11929-4-git-send-email-ogerlitz@mellanox.com>
References: <1348173034-11929-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1348173034-11929-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Signed-off-by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 examples/rc_pingpong.c  |   43 ++++++++++++++++++++++++++++++++-------
 examples/srq_pingpong.c |   51 ++++++++++++++++++++++++++++++++++++++--------
 examples/uc_pingpong.c  |   43 ++++++++++++++++++++++++++++++++-------
 examples/ud_pingpong.c  |   43 ++++++++++++++++++++++++++++++++-------
 4 files changed, 147 insertions(+), 33 deletions(-)

diff --git a/examples/rc_pingpong.c b/examples/rc_pingpong.c
index 0b7f3e0..15494a1 100644
--- a/examples/rc_pingpong.c
+++ b/examples/rc_pingpong.c
@@ -325,7 +325,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	ctx->buf = memalign(page_size, size);
 	if (!ctx->buf) {
 		fprintf(stderr, "Couldn't allocate work buf.\n");
-		return NULL;
+		goto clean_ctx;
 	}
 
 	/* FIXME memset(ctx->buf, 0, size); */
@@ -335,14 +335,14 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	if (!ctx->context) {
 		fprintf(stderr, "Couldn't get context for %s\n",
 			ibv_get_device_name(ib_dev));
-		return NULL;
+		goto clean_buffer;
 	}
 
 	if (use_event) {
 		ctx->channel = ibv_create_comp_channel(ctx->context);
 		if (!ctx->channel) {
 			fprintf(stderr, "Couldn't create completion channel\n");
-			return NULL;
+			goto clean_device;
 		}
 	} else
 		ctx->channel = NULL;
@@ -350,20 +350,20 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	ctx->pd = ibv_alloc_pd(ctx->context);
 	if (!ctx->pd) {
 		fprintf(stderr, "Couldn't allocate PD\n");
-		return NULL;
+		goto clean_comp_channel;
 	}
 
 	ctx->mr = ibv_reg_mr(ctx->pd, ctx->buf, size, IBV_ACCESS_LOCAL_WRITE);
 	if (!ctx->mr) {
 		fprintf(stderr, "Couldn't register MR\n");
-		return NULL;
+		goto clean_pd;
 	}
 
 	ctx->cq = ibv_create_cq(ctx->context, rx_depth + 1, NULL,
 				ctx->channel, 0);
 	if (!ctx->cq) {
 		fprintf(stderr, "Couldn't create CQ\n");
-		return NULL;
+		goto clean_mr;
 	}
 
 	{
@@ -382,7 +382,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		ctx->qp = ibv_create_qp(ctx->pd, &attr);
 		if (!ctx->qp)  {
 			fprintf(stderr, "Couldn't create QP\n");
-			return NULL;
+			goto clean_cq;
 		}
 	}
 
@@ -400,11 +400,38 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 				  IBV_QP_PORT               |
 				  IBV_QP_ACCESS_FLAGS)) {
 			fprintf(stderr, "Failed to modify QP to INIT\n");
-			return NULL;
+			goto clean_qp;
 		}
 	}
 
 	return ctx;
+
+clean_qp:
+	ibv_destroy_qp(ctx->qp);
+
+clean_cq:
+	ibv_destroy_cq(ctx->cq);
+
+clean_mr:
+	ibv_dereg_mr(ctx->mr);
+
+clean_pd:
+	ibv_dealloc_pd(ctx->pd);
+
+clean_comp_channel:
+	if (ctx->channel)
+		ibv_destroy_comp_channel(ctx->channel);
+
+clean_device:
+	ibv_close_device(ctx->context);
+
+clean_buffer:
+	free(ctx->buf);
+
+clean_ctx:
+	free(ctx);
+
+	return NULL;
 }
 
 int pp_close_ctx(struct pingpong_context *ctx)
diff --git a/examples/srq_pingpong.c b/examples/srq_pingpong.c
index 298dca4..6e00f8c 100644
--- a/examples/srq_pingpong.c
+++ b/examples/srq_pingpong.c
@@ -357,7 +357,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	ctx->buf = memalign(page_size, size);
 	if (!ctx->buf) {
 		fprintf(stderr, "Couldn't allocate work buf.\n");
-		return NULL;
+		goto clean_ctx;
 	}
 
 	memset(ctx->buf, 0, size);
@@ -366,14 +366,14 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	if (!ctx->context) {
 		fprintf(stderr, "Couldn't get context for %s\n",
 			ibv_get_device_name(ib_dev));
-		return NULL;
+		goto clean_buffer;
 	}
 
 	if (use_event) {
 		ctx->channel = ibv_create_comp_channel(ctx->context);
 		if (!ctx->channel) {
 			fprintf(stderr, "Couldn't create completion channel\n");
-			return NULL;
+			goto clean_device;
 		}
 	} else
 		ctx->channel = NULL;
@@ -381,20 +381,20 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	ctx->pd = ibv_alloc_pd(ctx->context);
 	if (!ctx->pd) {
 		fprintf(stderr, "Couldn't allocate PD\n");
-		return NULL;
+		goto clean_comp_channel;
 	}
 
 	ctx->mr = ibv_reg_mr(ctx->pd, ctx->buf, size, IBV_ACCESS_LOCAL_WRITE);
 	if (!ctx->mr) {
 		fprintf(stderr, "Couldn't register MR\n");
-		return NULL;
+		goto clean_pd;
 	}
 
 	ctx->cq = ibv_create_cq(ctx->context, rx_depth + num_qp, NULL,
 				ctx->channel, 0);
 	if (!ctx->cq) {
 		fprintf(stderr, "Couldn't create CQ\n");
-		return NULL;
+		goto clean_mr;
 	}
 
 	{
@@ -408,7 +408,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		ctx->srq = ibv_create_srq(ctx->pd, &attr);
 		if (!ctx->srq)  {
 			fprintf(stderr, "Couldn't create SRQ\n");
-			return NULL;
+			goto clean_cq;
 		}
 	}
 
@@ -427,7 +427,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		ctx->qp[i] = ibv_create_qp(ctx->pd, &attr);
 		if (!ctx->qp[i])  {
 			fprintf(stderr, "Couldn't create QP[%d]\n", i);
-			return NULL;
+			goto clean_qps;
 		}
 	}
 
@@ -445,11 +445,44 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 				  IBV_QP_PORT               |
 				  IBV_QP_ACCESS_FLAGS)) {
 			fprintf(stderr, "Failed to modify QP[%d] to INIT\n", i);
-			return NULL;
+			goto clean_qps_full;
 		}
 	}
 
 	return ctx;
+
+clean_qps_full:
+	i = num_qp;
+
+clean_qps:
+	for (--i; i >= 0; --i)
+		ibv_destroy_qp(ctx->qp[i]);
+
+	ibv_destroy_srq(ctx->srq);
+
+clean_cq:
+	ibv_destroy_cq(ctx->cq);
+
+clean_mr:
+	ibv_dereg_mr(ctx->mr);
+
+clean_pd:
+	ibv_dealloc_pd(ctx->pd);
+
+clean_comp_channel:
+	if (ctx->channel)
+		ibv_destroy_comp_channel(ctx->channel);
+
+clean_device:
+	ibv_close_device(ctx->context);
+
+clean_buffer:
+	free(ctx->buf);
+
+clean_ctx:
+	free(ctx);
+
+	return NULL;
 }
 
 int pp_close_ctx(struct pingpong_context *ctx, int num_qp)
diff --git a/examples/uc_pingpong.c b/examples/uc_pingpong.c
index 4c3fa32..52c6c28 100644
--- a/examples/uc_pingpong.c
+++ b/examples/uc_pingpong.c
@@ -313,7 +313,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	ctx->buf = memalign(page_size, size);
 	if (!ctx->buf) {
 		fprintf(stderr, "Couldn't allocate work buf.\n");
-		return NULL;
+		goto clean_ctx;
 	}
 
 	/* FIXME memset(ctx->buf, 0, size); */
@@ -323,14 +323,14 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	if (!ctx->context) {
 		fprintf(stderr, "Couldn't get context for %s\n",
 			ibv_get_device_name(ib_dev));
-		return NULL;
+		goto clean_buffer;
 	}
 
 	if (use_event) {
 		ctx->channel = ibv_create_comp_channel(ctx->context);
 		if (!ctx->channel) {
 			fprintf(stderr, "Couldn't create completion channel\n");
-			return NULL;
+			goto clean_device;
 		}
 	} else
 		ctx->channel = NULL;
@@ -338,20 +338,20 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	ctx->pd = ibv_alloc_pd(ctx->context);
 	if (!ctx->pd) {
 		fprintf(stderr, "Couldn't allocate PD\n");
-		return NULL;
+		goto clean_comp_channel;
 	}
 
 	ctx->mr = ibv_reg_mr(ctx->pd, ctx->buf, size, IBV_ACCESS_LOCAL_WRITE);
 	if (!ctx->mr) {
 		fprintf(stderr, "Couldn't register MR\n");
-		return NULL;
+		goto clean_pd;
 	}
 
 	ctx->cq = ibv_create_cq(ctx->context, rx_depth + 1, NULL,
 				ctx->channel, 0);
 	if (!ctx->cq) {
 		fprintf(stderr, "Couldn't create CQ\n");
-		return NULL;
+		goto clean_mr;
 	}
 
 	{
@@ -370,7 +370,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		ctx->qp = ibv_create_qp(ctx->pd, &attr);
 		if (!ctx->qp)  {
 			fprintf(stderr, "Couldn't create QP\n");
-			return NULL;
+			goto clean_cq;
 		}
 	}
 
@@ -388,11 +388,38 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 				  IBV_QP_PORT               |
 				  IBV_QP_ACCESS_FLAGS)) {
 			fprintf(stderr, "Failed to modify QP to INIT\n");
-			return NULL;
+			goto clean_qp;
 		}
 	}
 
 	return ctx;
+
+clean_qp:
+	ibv_destroy_qp(ctx->qp);
+
+clean_cq:
+	ibv_destroy_cq(ctx->cq);
+
+clean_mr:
+	ibv_dereg_mr(ctx->mr);
+
+clean_pd:
+	ibv_dealloc_pd(ctx->pd);
+
+clean_comp_channel:
+	if (ctx->channel)
+		ibv_destroy_comp_channel(ctx->channel);
+
+clean_device:
+	ibv_close_device(ctx->context);
+
+clean_buffer:
+	free(ctx->buf);
+
+clean_ctx:
+	free(ctx);
+
+	return NULL;
 }
 
 int pp_close_ctx(struct pingpong_context *ctx)
diff --git a/examples/ud_pingpong.c b/examples/ud_pingpong.c
index 71b152d..c279ddb 100644
--- a/examples/ud_pingpong.c
+++ b/examples/ud_pingpong.c
@@ -311,7 +311,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	ctx->buf = memalign(page_size, size + 40);
 	if (!ctx->buf) {
 		fprintf(stderr, "Couldn't allocate work buf.\n");
-		return NULL;
+		goto clean_ctx;
 	}
 
 	/* FIXME memset(ctx->buf, 0, size + 40); */
@@ -321,14 +321,14 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	if (!ctx->context) {
 		fprintf(stderr, "Couldn't get context for %s\n",
 			ibv_get_device_name(ib_dev));
-		return NULL;
+		goto clean_buffer;
 	}
 
 	if (use_event) {
 		ctx->channel = ibv_create_comp_channel(ctx->context);
 		if (!ctx->channel) {
 			fprintf(stderr, "Couldn't create completion channel\n");
-			return NULL;
+			goto clean_device;
 		}
 	} else
 		ctx->channel = NULL;
@@ -336,20 +336,20 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 	ctx->pd = ibv_alloc_pd(ctx->context);
 	if (!ctx->pd) {
 		fprintf(stderr, "Couldn't allocate PD\n");
-		return NULL;
+		goto clean_comp_channel;
 	}
 
 	ctx->mr = ibv_reg_mr(ctx->pd, ctx->buf, size + 40, IBV_ACCESS_LOCAL_WRITE);
 	if (!ctx->mr) {
 		fprintf(stderr, "Couldn't register MR\n");
-		return NULL;
+		goto clean_pd;
 	}
 
 	ctx->cq = ibv_create_cq(ctx->context, rx_depth + 1, NULL,
 				ctx->channel, 0);
 	if (!ctx->cq) {
 		fprintf(stderr, "Couldn't create CQ\n");
-		return NULL;
+		goto clean_mr;
 	}
 
 	{
@@ -368,7 +368,7 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 		ctx->qp = ibv_create_qp(ctx->pd, &attr);
 		if (!ctx->qp)  {
 			fprintf(stderr, "Couldn't create QP\n");
-			return NULL;
+			goto clean_cq;
 		}
 	}
 
@@ -386,11 +386,38 @@ static struct pingpong_context *pp_init_ctx(struct ibv_device *ib_dev, int size,
 				  IBV_QP_PORT               |
 				  IBV_QP_QKEY)) {
 			fprintf(stderr, "Failed to modify QP to INIT\n");
-			return NULL;
+			goto clean_qp;
 		}
 	}
 
 	return ctx;
+
+clean_qp:
+	ibv_destroy_qp(ctx->qp);
+
+clean_cq:
+	ibv_destroy_cq(ctx->cq);
+
+clean_mr:
+	ibv_dereg_mr(ctx->mr);
+
+clean_pd:
+	ibv_dealloc_pd(ctx->pd);
+
+clean_comp_channel:
+	if (ctx->channel)
+		ibv_destroy_comp_channel(ctx->channel);
+
+clean_device:
+	ibv_close_device(ctx->context);
+
+clean_buffer:
+	free(ctx->buf);
+
+clean_ctx:
+	free(ctx);
+
+	return NULL;
 }
 
 int pp_close_ctx(struct pingpong_context *ctx)
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
