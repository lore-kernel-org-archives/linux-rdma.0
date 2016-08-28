From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 02/10] IB/core: Make CQ separate part of SRQ context
Date: Sun, 28 Aug 2016 14:00:42 +0300
Message-ID: <1472382050-25908-3-git-send-email-leon@kernel.org>
References: <1472382050-25908-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472382050-25908-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Before this change CQ attached to SRQ was part of XRC specific extension.
Moving CQ out makes it available to other types extending SRQ
functionality.

Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |  2 +-
 drivers/infiniband/core/verbs.c      | 16 +++++++++-------
 drivers/infiniband/hw/mlx5/main.c    |  8 ++++----
 include/rdma/ib_verbs.h              | 19 +++++++++++++------
 4 files changed, 27 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index f664731..e1fb1cd 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -3847,7 +3847,7 @@ static int __uverbs_create_xsrq(struct ib_uverbs_file *file,
 	srq->srq_context   = attr.srq_context;
 
 	if (cmd->srq_type == IB_SRQT_XRC) {
-		srq->ext.xrc.cq   = attr.ext.xrc.cq;
+		srq->ext.cq       = attr.ext.xrc.cq;
 		srq->ext.xrc.xrcd = attr.ext.xrc.xrcd;
 		atomic_inc(&attr.ext.xrc.cq->usecnt);
 		atomic_inc(&attr.ext.xrc.xrcd->usecnt);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f2b776e..3349ffb 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -596,11 +596,13 @@ struct ib_srq *ib_create_srq(struct ib_pd *pd,
 		srq->event_handler = srq_init_attr->event_handler;
 		srq->srq_context   = srq_init_attr->srq_context;
 		srq->srq_type      = srq_init_attr->srq_type;
+		if (ib_srq_has_cq(srq->srq_type)) {
+			srq->ext.cq   = srq_init_attr->ext.xrc.cq;
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
@@ -641,18 +643,18 @@ int ib_destroy_srq(struct ib_srq *srq)
 
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
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index f02a975..77ca218 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -2387,9 +2387,9 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
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
 
@@ -2408,9 +2408,9 @@ static int create_dev_resources(struct mlx5_ib_resources *devr)
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
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 000f57d..8b92698 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -935,6 +935,11 @@ enum ib_srq_type {
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
@@ -1457,12 +1462,14 @@ struct ib_srq {
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
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
