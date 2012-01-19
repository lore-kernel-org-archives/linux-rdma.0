From: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Subject: [PATCH] core/verb.c: fix kernel panic: always initialize struct ib_qp
 *qp->usecnt
Date: Thu, 19 Jan 2012 20:46:41 +0100
Message-ID: <20120119194641.1391553.39048.stgit@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-netdev-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We have just been investigating kernel panics related to
cq->ibcq.event_handler() completion calls.

Reason is that ib_destroy_qp() fails with -EBUSY. Further investigation
revealed qp->usecnt is not initialized. This counter was introduced
in linux-3.2 by commit 0e0ec7e0638ef48e0c661873dfcc8caccab984c6
and is only initialized for IB_QPT_XRC_TGT, but also checked in ib_destroy_qp()
for any qp type.

Signed-off-by: Bernd Schubert <bernd.schubert-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
Signed-off-by: Sven Breuner <sven.breuner-mPn0NPGs4xGatNDF+KUbs4QuADTiUCJX@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 602b1bd..575b780 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -421,6 +421,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 		qp->uobject    = NULL;
 		qp->qp_type    = qp_init_attr->qp_type;
 
+		atomic_set(&qp->usecnt, 0);
 		if (qp_init_attr->qp_type == IB_QPT_XRC_TGT) {
 			qp->event_handler = __ib_shared_qp_event_handler;
 			qp->qp_context = qp;
@@ -430,7 +431,6 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 			qp->xrcd = qp_init_attr->xrcd;
 			atomic_inc(&qp_init_attr->xrcd->usecnt);
 			INIT_LIST_HEAD(&qp->open_list);
-			atomic_set(&qp->usecnt, 0);
 
 			real_qp = qp;
 			qp = __ib_open_qp(real_qp, qp_init_attr->event_handler,

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
