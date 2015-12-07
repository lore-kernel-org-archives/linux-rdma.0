From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 20/37] IB/rdamvt: Add post send and recv stubs
Date: Mon, 07 Dec 2015 15:44:26 -0500
Message-ID: <20151207204425.8144.34725.stgit@phlsvslse11.ph.intel.com>
References: <20151207204046.8144.18752.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151207204046.8144.18752.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This adds the post sned and recv function stubs.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/sw/rdmavt/qp.c |   62 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/qp.h |    7 ++++
 drivers/infiniband/sw/rdmavt/vt.c |    3 ++
 3 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index 23479d3..d393a38 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -121,3 +121,65 @@ int rvt_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 {
 	return -EINVAL;
 }
+
+/**
+ * rvt_post_receive - post a receive on a QP
+ * @ibqp: the QP to post the receive on
+ * @wr: the WR to post
+ * @bad_wr: the first bad WR is put here
+ *
+ * This may be called from interrupt context.
+ */
+int rvt_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
+		  struct ib_recv_wr **bad_wr)
+{
+	/*
+	 * When a packet arrives the driver needs to call up to rvt to process
+	 * the packet. The UD, RC, UC processing will be done in rvt, however
+	 * the driver should be able to override this if it so choses. Perhaps a
+	 * set of function pointers set up at registration time.
+	 */
+
+	return -EINVAL;
+}
+
+/**
+ * rvt_post_send - post a send on a QP
+ * @ibqp: the QP to post the send on
+ * @wr: the list of work requests to post
+ * @bad_wr: the first bad WR is put here
+ *
+ * This may be called from interrupt context.
+ */
+int rvt_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
+		  struct ib_send_wr **bad_wr)
+{
+	/*
+	 * VT-DRIVER-API: do_send()
+	 * Driver needs to have a do_send() call which is a single entry point
+	 * to take an already formed packet and throw it out on the wire. Once
+	 * the packet is sent the driver needs to make an upcall to rvt so the
+	 * completion queue can be notified and/or any other outstanding
+	 * work/book keeping can be finished.
+	 *
+	 * Note that there should also be a way for rvt to protect itself
+	 * against hangs in the driver layer. If a send doesn't actually
+	 * complete in a timely manor rvt needs to return an error event.
+	 */
+
+	return -EINVAL;
+}
+
+/**
+ * rvt_post_srq_receive - post a receive on a shared receive queue
+ * @ibsrq: the SRQ to post the receive on
+ * @wr: the list of work requests to post
+ * @bad_wr: A pointer to the first WR to cause a problem is put here
+ *
+ * This may be called from interrupt context.
+ */
+int rvt_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
+		      struct ib_recv_wr **bad_wr)
+{
+	return -EINVAL;
+}
diff --git a/drivers/infiniband/sw/rdmavt/qp.h b/drivers/infiniband/sw/rdmavt/qp.h
index 93f2f2e..4e4709f 100644
--- a/drivers/infiniband/sw/rdmavt/qp.h
+++ b/drivers/infiniband/sw/rdmavt/qp.h
@@ -66,5 +66,10 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 int rvt_destroy_qp(struct ib_qp *ibqp);
 int rvt_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		 int attr_mask, struct ib_qp_init_attr *init_attr);
-
+int rvt_post_recv(struct ib_qp *ibqp, struct ib_recv_wr *wr,
+		  struct ib_recv_wr **bad_wr);
+int rvt_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
+		  struct ib_send_wr **bad_wr);
+int rvt_post_srq_recv(struct ib_srq *ibsrq, struct ib_recv_wr *wr,
+		      struct ib_recv_wr **bad_wr);
 #endif          /* DEF_RVTQP_H */
diff --git a/drivers/infiniband/sw/rdmavt/vt.c b/drivers/infiniband/sw/rdmavt/vt.c
index f996389..a1667ea 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -238,6 +238,9 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CDR(rdi, modify_qp);
 	CDR(rdi, destroy_qp);
 	CDR(rdi, query_qp);
+	CDR(rdi, post_send);
+	CDR(rdi, post_recv);
+	CDR(rdi, post_srq_recv);
 
 	/* Address Handle */
 	CDR(rdi, create_ah);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
