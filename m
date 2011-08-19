From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/20 v2] rdma/uverbs: Export XRC INI QP to user space
Date: Fri, 19 Aug 2011 02:14:03 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E41A22@FMSMSX151.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

XRC INI QPs are similar to send only RC QPs.  Allow user space
to create INI QPs.  Note that INI QPs do not require receive CQs.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c |   48 ++++++++++++++++++++++++++--------
 1 files changed, 37 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 095b393..dee81fc 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1372,8 +1372,8 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	struct ib_udata                 udata;
 	struct ib_uqp_object           *obj;
 	struct ib_pd                   *pd;
-	struct ib_cq                   *scq, *rcq;
-	struct ib_srq                  *srq;
+	struct ib_cq                   *scq, *rcq = NULL;
+	struct ib_srq                  *srq = NULL;
 	struct ib_qp                   *qp;
 	struct ib_qp_init_attr          attr;
 	int ret;
@@ -1395,18 +1395,31 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_key);
 	down_write(&obj->uevent.uobject.mutex);
 
-	srq = cmd.is_srq ? idr_read_srq(cmd.srq_handle, file->ucontext) : NULL;
 	pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
 	scq = idr_read_cq(cmd.send_cq_handle, file->ucontext, 0);
-	rcq = cmd.recv_cq_handle == cmd.send_cq_handle ?
-		scq : idr_read_cq(cmd.recv_cq_handle, file->ucontext, 1);
-
-	if (!pd || !scq || !rcq ||
-	    (cmd.is_srq && (!srq || srq->srq_type != IB_SRQT_BASIC))) {
+	if (!pd || !scq ) {
 		ret = -EINVAL;
 		goto err_put;
 	}
 
+	if (cmd.qp_type == IB_QPT_XRC_INI) {
+		cmd.max_recv_wr = cmd.max_recv_sge = 0;
+	} else {
+		if (cmd.is_srq) {
+			srq = idr_read_srq(cmd.srq_handle, file->ucontext);
+			if (!srq || srq->srq_type != IB_SRQT_BASIC) {
+				ret = -EINVAL;
+				goto err_put;
+			}
+		}
+		rcq = (cmd.recv_cq_handle == cmd.send_cq_handle) ?
+		       scq : idr_read_cq(cmd.recv_cq_handle, file->ucontext, 1);
+		if (!rcq) {
+			ret = -EINVAL;
+			goto err_put;
+		}
+	}
+
 	attr.event_handler = ib_uverbs_qp_event_handler;
 	attr.qp_context    = file;
 	attr.send_cq       = scq;
@@ -1443,7 +1456,8 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	qp->qp_type	  = attr.qp_type;
 	atomic_inc(&pd->usecnt);
 	atomic_inc(&attr.send_cq->usecnt);
-	atomic_inc(&attr.recv_cq->usecnt);
+	if (attr.recv_cq)
+		atomic_inc(&attr.recv_cq->usecnt);
 	if (attr.srq)
 		atomic_inc(&attr.srq->usecnt);
 
@@ -1469,7 +1483,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 
 	put_pd_read(pd);
 	put_cq_read(scq);
-	if (rcq != scq)
+	if (rcq && rcq != scq)
 		put_cq_read(rcq);
 	if (srq)
 		put_srq_read(srq);
@@ -1604,6 +1618,17 @@ out:
 	return ret ? ret : in_len;
 }
 
+/* Remove ignored fields set in the attribute mask */
+static int modify_qp_mask(enum ib_qp_type qp_type, int mask)
+{
+	switch (qp_type) {
+	case IB_QPT_XRC_INI:
+		return mask & ~(IB_QP_MAX_DEST_RD_ATOMIC | IB_QP_MIN_RNR_TIMER);
+	default:
+		return mask;
+	}
+}
+
 ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 			    const char __user *buf, int in_len,
 			    int out_len)
@@ -1676,7 +1701,8 @@ ssize_t ib_uverbs_modify_qp(struct ib_uverbs_file *file,
 	attr->alt_ah_attr.ah_flags 	    = cmd.alt_dest.is_global ? IB_AH_GRH : 0;
 	attr->alt_ah_attr.port_num 	    = cmd.alt_dest.port_num;
 
-	ret = qp->device->modify_qp(qp, attr, cmd.attr_mask, &udata);
+	ret = qp->device->modify_qp(qp, attr,
+				    modify_qp_mask(qp->qp_type, cmd.attr_mask), &udata);
 
 	put_qp_read(qp);
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
