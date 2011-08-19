From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/20 v2] rdma/core: Add XRC SRQ type
Date: Fri, 19 Aug 2011 02:14:00 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E419E4@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

XRC defines an SRQ that is specifically used by XRC connections.
Expand the SRQ code to support XRC SRQs.  An XRC SRQ is currently
restricted to XRC use only according to the IB XRC Annex.

Portions of this patch were derived from work by
Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c |   21 ++++++++++++++++++++-
 include/rdma/ib_verbs.h         |   18 +++++++++++++++++-
 2 files changed, 37 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index cbe85dd..25c1c1e 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -251,6 +251,12 @@ struct ib_srq *ib_create_srq(struct ib_pd *pd,
 		srq->event_handler = srq_init_attr->event_handler;
 		srq->srq_context   = srq_init_attr->srq_context;
 		srq->srq_type      = srq_init_attr->srq_type;
+		if (srq->srq_type == IB_SRQT_XRC) {
+			srq->ext.xrc.xrcd = srq_init_attr->ext.xrc.xrcd;
+			srq->ext.xrc.cq   = srq_init_attr->ext.xrc.cq;
+			atomic_inc(&srq->ext.xrc.xrcd->usecnt);
+			atomic_inc(&srq->ext.xrc.cq->usecnt);
+		}
 		atomic_inc(&pd->usecnt);
 		atomic_set(&srq->usecnt, 0);
 	}
@@ -280,16 +286,29 @@ EXPORT_SYMBOL(ib_query_srq);
 int ib_destroy_srq(struct ib_srq *srq)
 {
 	struct ib_pd *pd;
+	enum ib_srq_type srq_type;
+	struct ib_xrcd *uninitialized_var(xrcd);
+	struct ib_cq *uninitialized_var(cq);
 	int ret;
 
 	if (atomic_read(&srq->usecnt))
 		return -EBUSY;
 
 	pd = srq->pd;
+	srq_type = srq->srq_type;
+	if (srq_type == IB_SRQT_XRC) {
+		xrcd = srq->ext.xrc.xrcd;
+		cq = srq->ext.xrc.cq;
+	}
 
 	ret = srq->device->destroy_srq(srq);
-	if (!ret)
+	if (!ret) {
 		atomic_dec(&pd->usecnt);
+		if (srq_type == IB_SRQT_XRC) {
+			atomic_dec(&xrcd->usecnt);
+			atomic_dec(&cq->usecnt);
+		}
+	}
 
 	return ret;
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 1374a66..2a85461 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -523,7 +523,8 @@ enum ib_cq_notify_flags {
 };
 
 enum ib_srq_type {
-	IB_SRQT_BASIC
+	IB_SRQT_BASIC,
+	IB_SRQT_XRC
 };
 
 enum ib_srq_attr_mask {
@@ -542,6 +543,13 @@ struct ib_srq_init_attr {
 	void		       *srq_context;
 	struct ib_srq_attr	attr;
 	enum ib_srq_type	srq_type;
+
+	union {
+		struct {
+			struct ib_xrcd *xrcd;
+			struct ib_cq   *cq;
+		} xrc;
+	} ext;
 };
 
 struct ib_qp_cap {
@@ -894,6 +902,14 @@ struct ib_srq {
 	void		       *srq_context;
 	enum ib_srq_type	srq_type;
 	atomic_t		usecnt;
+
+	union {
+		struct {
+			struct ib_xrcd *xrcd;
+			struct ib_cq   *cq;
+			u32		srq_num;
+		} xrc;
+	} ext;
 };
 
 struct ib_qp {


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
