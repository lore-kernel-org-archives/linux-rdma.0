From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 20/36] IB/rdmavt: Add post send and recv stubs
Date: Wed, 06 Jan 2016 10:01:17 -0800
Message-ID: <20160106180047.8747.6862.stgit@scvm10.sc.intel.com>
References: <20160106174638.8747.47197.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106174638.8747.47197.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This adds the post sned and recv function stubs.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
Changes since v1:
Fix typo in subject
Change stubs to return EOPNOTSUPP

 drivers/infiniband/sw/rdmavt/qp.c |   62 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/sw/rdmavt/qp.h |    7 ++++
 drivers/infiniband/sw/rdmavt/vt.c |    3 ++
 3 files changed, 71 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/sw/rdmavt/qp.c b/drivers/infiniband/sw/rdmavt/qp.c
index a59f28d..23a5f68 100644
--- a/drivers/infiniband/sw/rdmavt/qp.c
+++ b/drivers/infiniband/sw/rdmavt/qp.c
@@ -118,3 +118,65 @@ int rvt_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 {
 	return -EOPNOTSUPP;
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
+	return -EOPNOTSUPP;
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
+	return -EOPNOTSUPP;
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
+	return -EOPNOTSUPP;
+}
diff --git a/drivers/infiniband/sw/rdmavt/qp.h b/drivers/infiniband/sw/rdmavt/qp.h
index 43acba0..10bc636 100644
--- a/drivers/infiniband/sw/rdmavt/qp.h
+++ b/drivers/infiniband/sw/rdmavt/qp.h
@@ -63,5 +63,10 @@ int rvt_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
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
index 7fd879f..367bc45 100644
--- a/drivers/infiniband/sw/rdmavt/vt.c
+++ b/drivers/infiniband/sw/rdmavt/vt.c
@@ -232,6 +232,9 @@ int rvt_register_device(struct rvt_dev_info *rdi)
 	CHECK_DRIVER_OVERRIDE(rdi, modify_qp);
 	CHECK_DRIVER_OVERRIDE(rdi, destroy_qp);
 	CHECK_DRIVER_OVERRIDE(rdi, query_qp);
+	CHECK_DRIVER_OVERRIDE(rdi, post_send);
+	CHECK_DRIVER_OVERRIDE(rdi, post_recv);
+	CHECK_DRIVER_OVERRIDE(rdi, post_srq_recv);
 
 	/* Address Handle */
 	CHECK_DRIVER_OVERRIDE(rdi, create_ah);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
