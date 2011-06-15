From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 9/17] rdma/uverbs: Export XRC TGT QPs to user space
Date: Wed, 15 Jun 2011 06:28:04 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237302102D@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Allow user space to operate on XRC TGT QPs the same as other
types of QPs, with one notable exception.  Since XRC TGT QPs
may be shared among multiple processes, the XRC TGT QP is
allowed to exist beyond the lifetime of the creating process.

The process that creates the qp is allowed to destroy it, but
if the process exits without destroying the qp, then the qp
will be left bound to the lifetime of the XRCD.

TGT QPs are not associated with CQs or a PD.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/uverbs_cmd.c  |  103 +++++++++++++++++++++------------
 drivers/infiniband/core/uverbs_main.c |    8 ++-
 2 files changed, 71 insertions(+), 40 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_cmd.c b/drivers/infiniband/core/uverbs_cmd.c
index 257607e..b9fe077 100644
--- a/drivers/infiniband/core/uverbs_cmd.c
+++ b/drivers/infiniband/core/uverbs_cmd.c
@@ -1371,8 +1371,11 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	struct ib_uverbs_create_qp_resp resp;
 	struct ib_udata                 udata;
 	struct ib_uqp_object           *obj;
-	struct ib_pd                   *pd;
-	struct ib_cq                   *scq, *rcq = NULL;
+	struct ib_device	       *device;
+	struct ib_pd                   *pd = NULL;
+	struct ib_xrcd		       *xrcd = NULL;
+	struct ib_uobject	       *uninitialized_var(xrcd_uobj);
+	struct ib_cq                   *scq = NULL, *rcq = NULL;
 	struct ib_srq                  *srq = NULL;
 	struct ib_qp                   *qp;
 	struct ib_qp_init_attr          attr;
@@ -1395,29 +1398,40 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	init_uobj(&obj->uevent.uobject, cmd.user_handle, file->ucontext, &qp_lock_key);
 	down_write(&obj->uevent.uobject.mutex);
 
-	pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
-	scq = idr_read_cq(cmd.send_cq_handle, file->ucontext, 0);
-	if (!pd || !scq ) {
-		ret = -EINVAL;
-		goto err_put;
-	}
-
-	if (cmd.qp_type == IB_QPT_XRC_INI) {
-		cmd.max_recv_wr = cmd.max_recv_sge = 0;
+	if (cmd.qp_type == IB_QPT_XRC_TGT) {
+		srq = idr_read_srq(cmd.srq_handle, file->ucontext);
+		xrcd = idr_read_xrcd(cmd.pd_handle, file->ucontext, &xrcd_uobj);
+		if (!xrcd || !srq || srq->srq_type != IB_SRQT_XRC) {
+			ret = -EINVAL;
+			goto err_put;
+		}
+		device = xrcd->device;
 	} else {
-		if (cmd.is_srq) {
-			srq = idr_read_srq(cmd.srq_handle, file->ucontext);
-			if (!srq || srq->srq_type != IB_SRQT_BASIC) {
+		pd  = idr_read_pd(cmd.pd_handle, file->ucontext);
+		scq = idr_read_cq(cmd.send_cq_handle, file->ucontext, 0);
+		if (!pd || !scq ) {
+			ret = -EINVAL;
+			goto err_put;
+		}
+
+		if (cmd.qp_type == IB_QPT_XRC_INI) {
+			cmd.max_recv_wr = cmd.max_recv_sge = 0;
+		} else {
+			if (cmd.is_srq) {
+				srq = idr_read_srq(cmd.srq_handle, file->ucontext);
+				if (!srq || srq->srq_type != IB_SRQT_BASIC) {
+					ret = -EINVAL;
+					goto err_put;
+				}
+			}
+			rcq = (cmd.recv_cq_handle == cmd.send_cq_handle) ?
+			       scq : idr_read_cq(cmd.recv_cq_handle, file->ucontext, 1);
+			if (!rcq) {
 				ret = -EINVAL;
 				goto err_put;
 			}
 		}
-		rcq = (cmd.recv_cq_handle == cmd.send_cq_handle) ?
-		       scq : idr_read_cq(cmd.recv_cq_handle, file->ucontext, 1);
-		if (!rcq) {
-			ret = -EINVAL;
-			goto err_put;
-		}
+		device = pd->device;
 	}
 
 	attr.event_handler = ib_uverbs_qp_event_handler;
@@ -1425,6 +1439,7 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	attr.send_cq       = scq;
 	attr.recv_cq       = rcq;
 	attr.srq           = srq;
+	attr.xrcd	   = xrcd;
 	attr.sq_sig_type   = cmd.sq_sig_all ? IB_SIGNAL_ALL_WR : IB_SIGNAL_REQ_WR;
 	attr.qp_type       = cmd.qp_type;
 	attr.create_flags  = 0;
@@ -1439,27 +1454,33 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 	INIT_LIST_HEAD(&obj->uevent.event_list);
 	INIT_LIST_HEAD(&obj->mcast_list);
 
-	qp = pd->device->create_qp(pd, &attr, &udata);
+	if (cmd.qp_type == IB_QPT_XRC_TGT)
+		qp = ib_create_qp(pd, &attr);
+	else
+		qp = device->create_qp(pd, &attr, &udata);
+
 	if (IS_ERR(qp)) {
 		ret = PTR_ERR(qp);
 		goto err_put;
 	}
 
-	qp->device     	  = pd->device;
-	qp->pd         	  = pd;
-	qp->send_cq    	  = attr.send_cq;
-	qp->recv_cq    	  = attr.recv_cq;
-	qp->srq	       	  = attr.srq;
-	qp->uobject       = &obj->uevent.uobject;
-	qp->event_handler = attr.event_handler;
-	qp->qp_context    = attr.qp_context;
-	qp->qp_type	  = attr.qp_type;
-	atomic_inc(&pd->usecnt);
-	atomic_inc(&attr.send_cq->usecnt);
-	if (attr.recv_cq)
-		atomic_inc(&attr.recv_cq->usecnt);
-	if (attr.srq)
-		atomic_inc(&attr.srq->usecnt);
+	if (cmd.qp_type != IB_QPT_XRC_TGT) {
+		qp->device     	  = device;
+		qp->pd         	  = pd;
+		qp->send_cq    	  = attr.send_cq;
+		qp->recv_cq    	  = attr.recv_cq;
+		qp->srq	       	  = attr.srq;
+		qp->event_handler = attr.event_handler;
+		qp->qp_context    = attr.qp_context;
+		qp->qp_type	  = attr.qp_type;
+		atomic_inc(&pd->usecnt);
+		atomic_inc(&attr.send_cq->usecnt);
+		if (attr.recv_cq)
+			atomic_inc(&attr.recv_cq->usecnt);
+		if (attr.srq)
+			atomic_inc(&attr.srq->usecnt);
+	}
+	qp->uobject = &obj->uevent.uobject;
 
 	obj->uevent.uobject.object = qp;
 	ret = idr_add_uobj(&ib_uverbs_qp_idr, &obj->uevent.uobject);
@@ -1481,8 +1502,12 @@ ssize_t ib_uverbs_create_qp(struct ib_uverbs_file *file,
 		goto err_copy;
 	}
 
-	put_pd_read(pd);
-	put_cq_read(scq);
+	if (xrcd)
+		put_xrcd_read(xrcd_uobj);
+	if (pd)
+		put_pd_read(pd);
+	if (scq)
+		put_cq_read(scq);
 	if (rcq && rcq != scq)
 		put_cq_read(rcq);
 	if (srq)
@@ -1505,6 +1530,8 @@ err_destroy:
 	ib_destroy_qp(qp);
 
 err_put:
+	if (xrcd)
+		put_xrcd_read(xrcd_uobj);
 	if (pd)
 		put_pd_read(pd);
 	if (scq)
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index dbe9064..ca879d7 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -206,8 +206,12 @@ static int ib_uverbs_cleanup_ucontext(struct ib_uverbs_file *file,
 			container_of(uobj, struct ib_uqp_object, uevent.uobject);
 
 		idr_remove_uobj(&ib_uverbs_qp_idr, uobj);
-		ib_uverbs_detach_umcast(qp, uqp);
-		ib_destroy_qp(qp);
+		if (qp->qp_type == IB_QPT_XRC_TGT) {
+			ib_release_qp(qp);
+		} else {
+			ib_uverbs_detach_umcast(qp, uqp);
+			ib_destroy_qp(qp);
+		}
 		ib_uverbs_release_uevent(file, &uqp->uevent);
 		kfree(uqp);
 	}


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
