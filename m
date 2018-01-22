From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next v5 4/8] RDMA/core: Add resource tracking for create and destroy QPs
Date: Mon, 22 Jan 2018 14:51:15 +0200
Message-ID: <20180122125119.26419-5-leon@kernel.org>
References: <20180122125119.26419-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180122125119.26419-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Track create and destroy operations of QP objects.

Reviewed-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h  | 20 ++++++++++++++++++++
 drivers/infiniband/core/uverbs_cmd.c |  3 +--
 drivers/infiniband/core/verbs.c      |  5 ++---
 3 files changed, 23 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 2b1372da708a..e906afd18d79 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -301,4 +301,24 @@ struct ib_device *ib_device_get_by_index(u32 ifindex);
 /* RDMA device netlink */
 void nldev_init(void);
 void nldev_exit(void);
+
+static inline struct ib_qp *_ib_create_qp(struct ib_device *dev,
+					  struct ib_pd *pd,
+					  struct ib_qp_init_attr *attr,
+					  struct ib_udata *udata)
+{
+	struct ib_qp *qp;
+
+	qp = dev->create_qp(pd, attr, udata);
+	if (!IS_ERR(qp)) {
+		qp->device = dev;
+		qp->pd	   = pd;
+		if (attr->qp_type < IB_QPT_MAX) {
+			qp->res.type = RDMA_RESTRACK_QP;
+			rdma_restrack_add(&qp->res);
+		}
+	}
+
+	return qp;
+}
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 4ddd61d90507..825325c764a1 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1514,7 +1514,7 @@ static int create_qp(struct ib_uverbs_file *file,
 	if (cmd->qp_type == IB_QPT_XRC_TGT)
 		qp = ib_create_qp(pd, &attr);
 	else
-		qp = device->create_qp(pd, &attr, uhw);
+		qp = _ib_create_qp(device, pd, &attr, uhw);
 
 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
@@ -1527,7 +1527,6 @@ static int create_qp(struct ib_uverbs_file *file,
 			goto err_cb;
 
 		qp->real_qp	  = qp;
-		qp->device	  = device;
 		qp->pd		  = pd;
 		qp->send_cq	  = attr.send_cq;
 		qp->recv_cq	  = attr.recv_cq;
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 098bde906dfd..fbdf086e342e 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -883,7 +883,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	if (qp_init_attr->cap.max_rdma_ctxs)
 		rdma_rw_init_qp(device, qp_init_attr);
 
-	qp = device->create_qp(pd, qp_init_attr, NULL);
+	qp = _ib_create_qp(device, pd, qp_init_attr, NULL);
 	if (IS_ERR(qp))
 		return qp;
 
@@ -893,7 +893,6 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 		return ERR_PTR(ret);
 	}
 
-	qp->device     = device;
 	qp->real_qp    = qp;
 	qp->uobject    = NULL;
 	qp->qp_type    = qp_init_attr->qp_type;
@@ -923,7 +922,6 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 			atomic_inc(&qp_init_attr->srq->usecnt);
 	}
 
-	qp->pd	    = pd;
 	qp->send_cq = qp_init_attr->send_cq;
 	qp->xrcd    = NULL;
 
@@ -1539,6 +1537,7 @@ int ib_destroy_qp(struct ib_qp *qp)
 	if (!qp->uobject)
 		rdma_rw_cleanup_mrs(qp);
 
+	rdma_restrack_del(&qp->res);
 	ret = qp->device->destroy_qp(qp);
 	if (!ret) {
 		if (pd)
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
