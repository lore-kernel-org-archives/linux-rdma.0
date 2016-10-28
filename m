From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] qedr: Fix possible memory leak in qedr_create_qp()
Date: Fri, 28 Oct 2016 16:33:47 +0000
Message-ID: <1477672427-31575-1-git-send-email-weiyj.lk@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Ram Amrani <Ram.Amrani-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>, Rajesh Borundia <rajesh.borundia-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
Cc: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>

'qp' is malloced in qedr_create_qp() and should be freed before leaving
from the error handling cases, otherwise it will cause memory leak.

Signed-off-by: Wei Yongjun <weiyongjun1-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/verbs.c | 12 ++++++++----
 1 file changed, 8 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index a615142..b60f145 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -1477,6 +1477,7 @@ struct ib_qp *qedr_create_qp(struct ib_pd *ibpd,
 	struct qedr_ucontext *ctx = NULL;
 	struct qedr_create_qp_ureq ureq;
 	struct qedr_qp *qp;
+	struct ib_qp *ibqp;
 	int rc = 0;
 
 	DP_DEBUG(dev, QEDR_MSG_QP, "create qp: called from %s, pd=%p\n",
@@ -1486,13 +1487,13 @@ struct ib_qp *qedr_create_qp(struct ib_pd *ibpd,
 	if (rc)
 		return ERR_PTR(rc);
 
+	if (attrs->srq)
+		return ERR_PTR(-EINVAL);
+
 	qp = kzalloc(sizeof(*qp), GFP_KERNEL);
 	if (!qp)
 		return ERR_PTR(-ENOMEM);
 
-	if (attrs->srq)
-		return ERR_PTR(-EINVAL);
-
 	DP_DEBUG(dev, QEDR_MSG_QP,
 		 "create qp: sq_cq=%p, sq_icid=%d, rq_cq=%p, rq_icid=%d\n",
 		 get_qedr_cq(attrs->send_cq),
@@ -1508,7 +1509,10 @@ struct ib_qp *qedr_create_qp(struct ib_pd *ibpd,
 			       "create qp: unexpected udata when creating GSI QP\n");
 			goto err0;
 		}
-		return qedr_create_gsi_qp(dev, attrs, qp);
+		ibqp = qedr_create_gsi_qp(dev, attrs, qp);
+		if (IS_ERR(ibqp))
+			kfree(qp);
+		return ibqp;
 	}
 
 	memset(&in_params, 0, sizeof(in_params));

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
