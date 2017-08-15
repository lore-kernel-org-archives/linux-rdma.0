From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v1 03/11] IB/core: Separate CQ handle in SRQ context
Date: Tue, 15 Aug 2017 11:59:04 +0300
Message-ID: <20170815085912.10181-4-leon@kernel.org>
References: <20170815085912.10181-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170815085912.10181-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Before this change CQ attached to SRQ was part of XRC specific extension.
Moving CQ handle out makes it available to other types extending SRQ
functionality.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yossi Itigin <yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c | 27 +++++++++++++++++----------
 drivers/infiniband/core/verbs.c      | 16 +++++++++-------
 drivers/infiniband/hw/mlx4/srq.c     |  4 ++--
 drivers/infiniband/hw/mlx5/main.c    | 10 +++++-----
 drivers/infiniband/hw/mlx5/srq.c     | 11 +++++++----
 include/rdma/ib_verbs.h              | 31 ++++++++++++++++++++-----------
 6 files changed, 60 insertions(+), 39 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 515425a50059..afa4c1b7891a 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3479,10 +3479,12 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 
 		obj->uxrcd = container_of(xrcd_uobj, struct ib_uxrcd_object, uobject);
 		atomic_inc(&obj->uxrcd->refcnt);
+	}
 
-		attr.ext.xrc.cq  = uobj_get_obj_read(cq, cmd->cq_handle,
-						     file->ucontext);
-		if (!attr.ext.xrc.cq) {
+	if (ib_srq_has_cq(cmd->srq_type)) {
+		attr.ext.cq  = uobj_get_obj_read(cq, cmd->cq_handle,
+						 file->ucontext);
+		if (!attr.ext.cq) {
 			ret = -EINVAL;
 			goto err_put_xrcd;
 		}
@@ -3517,10 +3519,13 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	srq->event_handler = attr.event_handler;
 	srq->srq_context   = attr.srq_context;
 
+	if (ib_srq_has_cq(cmd->srq_type)) {
+		srq->ext.cq       = attr.ext.cq;
+		atomic_inc(&attr.ext.cq->usecnt);
+	}
+
 	if (cmd->srq_type == IB_SRQT_XRC) {
-		srq->ext.xrc.cq   = attr.ext.xrc.cq;
 		srq->ext.xrc.xrcd = attr.ext.xrc.xrcd;
-		atomic_inc(&attr.ext.xrc.cq->usecnt);
 		atomic_inc(&attr.ext.xrc.xrcd->usecnt);
 	}
 
@@ -3543,10 +3548,12 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	if (cmd->srq_type == IB_SRQT_XRC) {
+	if (cmd->srq_type == IB_SRQT_XRC)
 		uobj_put_read(xrcd_uobj);
-		uobj_put_obj_read(attr.ext.xrc.cq);
-	}
+
+	if (ib_srq_has_cq(cmd->srq_type))
+		uobj_put_obj_read(attr.ext.cq);
+
 	uobj_put_obj_read(pd);
 	uobj_alloc_commit(&obj->uevent.uobject);
 
@@ -3559,8 +3566,8 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	uobj_put_obj_read(pd);
 
 err_put_cq:
-	if (cmd->srq_type == IB_SRQT_XRC)
-		uobj_put_obj_read(attr.ext.xrc.cq);
+	if (ib_srq_has_cq(cmd->srq_type))
+		uobj_put_obj_read(attr.ext.cq);
 
 err_put_xrcd:
 	if (cmd->srq_type == IB_SRQT_XRC) {
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index e3aa9c60bcc5..cc955b16027f 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -620,11 +620,13 @@ struct ib_srq *ib_create_srq(struct ib_pd *pd,
 		srq->event_handler = srq_init_attr->event_handler;
 		srq->srq_context   = srq_init_attr->srq_context;
 		srq->srq_type      = srq_init_attr->srq_type;
+		if (ib_srq_has_cq(srq->srq_type)) {
+			srq->ext.cq   = srq_init_attr->ext.cq;
+			atomic_inc(&srq->ext.cq->usecnt);
+		}
 		if (srq->srq_type == IB_SRQT_XRC) {
 			srq->ext.xrc.xrcd = srq_init_attr->ext.xrc.xrcd;
-			srq->ext.xrc.cq   = srq_init_attr->ext.xrc.cq;
 			atomic_inc(&srq->ext.xrc.xrcd->usecnt);
-			atomic_inc(&srq->ext.xrc.cq->usecnt);
 		}
 		atomic_inc(&pd->usecnt);
 		atomic_set(&srq->usecnt, 0);
@@ -665,18 +667,18 @@ int ib_destroy_srq(struct ib_srq *srq)
 
 	pd = srq->pd;
 	srq_type = srq->srq_type;
-	if (srq_type == IB_SRQT_XRC) {
+	if (ib_srq_has_cq(srq_type))
+		cq = srq->ext.cq;
+	if (srq_type == IB_SRQT_XRC)
 		xrcd = srq->ext.xrc.xrcd;
-		cq = srq->ext.xrc.cq;
-	}
 
 	ret = srq->device->destroy_srq(srq);
 	if (!ret) {
 		atomic_dec(&pd->usecnt);
-		if (srq_type == IB_SRQT_XRC) {
+		if (srq_type == IB_SRQT_XRC)
 			atomic_dec(&xrcd->usecnt);
+		if (ib_srq_has_cq(srq_type))
 			atomic_dec(&cq->usecnt);
-		}
 	}
 
 	return ret;
diff --git a/drivers/infiniband/hw/mlx4/srq.c b/drivers/infiniband/hw/mlx4/srq.c
index 0facaf5f6d23..210fe964a65d 100644
--- a/drivers/infiniband/hw/mlx4/srq.c
+++ b/drivers/infiniband/hw/mlx4/srq.c
@@ -183,8 +183,8 @@ struct ib_srq *mlx4_ib_create_srq(struct ib_pd *pd,
 		}
 	}
 
-	cqn = (init_attr->srq_type == IB_SRQT_XRC) ?
-		to_mcq(init_attr->ext.xrc.cq)->mcq.cqn : 0;
+	cqn = ib_srq_has_cq(init_attr->srq_type) ?
+		to_mcq(init_attr->ext.cq)->mcq.cqn : 0;
 	xrcdn = (init_attr->srq_type == IB_SRQT_XRC) ?
 		to_mxrcd(init_attr->ext.xrc.xrcd)->xrcdn :
 		(u16) dev->dev->caps.reserved_xrcds;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 47cf622c6d24..e9ea759f35dd 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -3154,7 +3154,7 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 	attr.attr.max_sge = 1;
 	attr.attr.max_wr = 1;
 	attr.srq_type = IB_SRQT_XRC;
-	attr.ext.xrc.cq = devr->c0;
+	attr.ext.cq = devr->c0;
 	attr.ext.xrc.xrcd = devr->x0;
 
 	devr->s0 = mlx5_ib_create_srq(devr->p0, &attr, NULL);
@@ -3169,9 +3169,9 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 	devr->s0->srq_context   = NULL;
 	devr->s0->srq_type      = IB_SRQT_XRC;
 	devr->s0->ext.xrc.xrcd	= devr->x0;
-	devr->s0->ext.xrc.cq	= devr->c0;
+	devr->s0->ext.cq	= devr->c0;
 	atomic_inc(&devr->s0->ext.xrc.xrcd->usecnt);
-	atomic_inc(&devr->s0->ext.xrc.cq->usecnt);
+	atomic_inc(&devr->s0->ext.cq->usecnt);
 	atomic_inc(&devr->p0->usecnt);
 	atomic_set(&devr->s0->usecnt, 0);
 
@@ -3190,9 +3190,9 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
 	devr->s1->event_handler = NULL;
 	devr->s1->srq_context   = NULL;
 	devr->s1->srq_type      = IB_SRQT_BASIC;
-	devr->s1->ext.xrc.cq	= devr->c0;
+	devr->s1->ext.cq	= devr->c0;
 	atomic_inc(&devr->p0->usecnt);
-	atomic_set(&devr->s0->usecnt, 0);
+	atomic_set(&devr->s1->usecnt, 0);
 
 	for (port = 0; port < ARRAY_SIZE(devr->ports); ++port) {
 		INIT_WORK(&devr->ports[port].pkey_change_work,
diff --git a/drivers/infiniband/hw/mlx5/srq.c b/drivers/infiniband/hw/mlx5/srq.c
index 43707b101f47..022b4c642047 100644
--- a/drivers/infiniband/hw/mlx5/srq.c
+++ b/drivers/infiniband/hw/mlx5/srq.c
@@ -292,13 +292,16 @@ struct ib_srq *mlx5_ib_create_srq(struct ib_pd *pd,
 	in.wqe_shift = srq->msrq.wqe_shift - 4;
 	if (srq->wq_sig)
 		in.flags |= MLX5_SRQ_FLAG_WQ_SIG;
-	if (init_attr->srq_type == IB_SRQT_XRC) {
+
+	if (init_attr->srq_type == IB_SRQT_XRC)
 		in.xrcd = to_mxrcd(init_attr->ext.xrc.xrcd)->xrcdn;
-		in.cqn = to_mcq(init_attr->ext.xrc.cq)->mcq.cqn;
-	} else if (init_attr->srq_type == IB_SRQT_BASIC) {
+	else
 		in.xrcd = to_mxrcd(dev->devr.x0)->xrcdn;
+
+	if (ib_srq_has_cq(init_attr->srq_type))
+		in.cqn = to_mcq(init_attr->ext.cq)->mcq.cqn;
+	else
 		in.cqn = to_mcq(dev->devr.c0)->mcq.cqn;
-	}
 
 	in.pd = to_mpd(pd)->pdn;
 	in.db_record = srq->db.dma;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index f539a6fe298c..f0e9d30bb0b9 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -989,6 +989,11 @@ enum ib_srq_type {
 	IB_SRQT_XRC
 };
 
+static inline bool ib_srq_has_cq(enum ib_srq_type srq_type)
+{
+	return srq_type == IB_SRQT_XRC;
+}
+
 enum ib_srq_attr_mask {
 	IB_SRQ_MAX_WR	= 1 << 0,
 	IB_SRQ_LIMIT	= 1 << 1,
@@ -1006,11 +1011,13 @@ struct ib_srq_init_attr {
 	struct ib_srq_attr	attr;
 	enum ib_srq_type	srq_type;
 
-	union {
-		struct {
-			struct ib_xrcd *xrcd;
-			struct ib_cq   *cq;
-		} xrc;
+	struct {
+		struct ib_cq   *cq;
+		union {
+			struct {
+				struct ib_xrcd *xrcd;
+			} xrc;
+		};
 	} ext;
 };
 
@@ -1549,12 +1556,14 @@ struct ib_srq {
 	enum ib_srq_type	srq_type;
 	atomic_t		usecnt;
 
-	union {
-		struct {
-			struct ib_xrcd *xrcd;
-			struct ib_cq   *cq;
-			u32		srq_num;
-		} xrc;
+	struct {
+		struct ib_cq   *cq;
+		union {
+			struct {
+				struct ib_xrcd *xrcd;
+				u32		srq_num;
+			} xrc;
+		};
 	} ext;
 };
 
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
