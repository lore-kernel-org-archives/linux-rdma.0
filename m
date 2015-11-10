From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RESEND PATCH v4 1/3] staging/rdma/hfi1: move hfi1_migrate_qp
Date: Mon,  9 Nov 2015 19:13:57 -0500
Message-ID: <1447114439-10525-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Move hfi1_migrate_qp from ruc.c to qp.[hc] in prep for modifying the QP
workqueue.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
This patch was previously sent as #7/9 but 5/9 failed.

I'm resending 7,8, and 9 as they did not explicitly depend on 5 and 6.

 drivers/staging/rdma/hfi1/qp.c    | 20 ++++++++++++++++++++
 drivers/staging/rdma/hfi1/qp.h    |  2 ++
 drivers/staging/rdma/hfi1/ruc.c   | 20 --------------------
 drivers/staging/rdma/hfi1/verbs.h |  2 --
 4 files changed, 22 insertions(+), 22 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index df1fa56eaf85..6e6c9a8f6b6f 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -1685,3 +1685,23 @@ void qp_comm_est(struct hfi1_qp *qp)
 		qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
 	}
 }
+
+/*
+ * Switch to alternate path.
+ * The QP s_lock should be held and interrupts disabled.
+ */
+void hfi1_migrate_qp(struct hfi1_qp *qp)
+{
+	struct ib_event ev;
+
+	qp->s_mig_state = IB_MIG_MIGRATED;
+	qp->remote_ah_attr = qp->alt_ah_attr;
+	qp->port_num = qp->alt_ah_attr.port_num;
+	qp->s_pkey_index = qp->s_alt_pkey_index;
+	qp->s_flags |= HFI1_S_AHG_CLEAR;
+
+	ev.device = qp->ibqp.device;
+	ev.element.qp = &qp->ibqp;
+	ev.event = IB_EVENT_PATH_MIG;
+	qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
+}
diff --git a/drivers/staging/rdma/hfi1/qp.h b/drivers/staging/rdma/hfi1/qp.h
index b9c1575990aa..bacfa9c5e8a8 100644
--- a/drivers/staging/rdma/hfi1/qp.h
+++ b/drivers/staging/rdma/hfi1/qp.h
@@ -247,4 +247,6 @@ void qp_iter_print(struct seq_file *s, struct qp_iter *iter);
  */
 void qp_comm_est(struct hfi1_qp *qp);
 
+void hfi1_migrate_qp(struct hfi1_qp *qp);
+
 #endif /* _QP_H */
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index 8614b070545c..947ea27332ff 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -241,26 +241,6 @@ bail:
 	return ret;
 }
 
-/*
- * Switch to alternate path.
- * The QP s_lock should be held and interrupts disabled.
- */
-void hfi1_migrate_qp(struct hfi1_qp *qp)
-{
-	struct ib_event ev;
-
-	qp->s_mig_state = IB_MIG_MIGRATED;
-	qp->remote_ah_attr = qp->alt_ah_attr;
-	qp->port_num = qp->alt_ah_attr.port_num;
-	qp->s_pkey_index = qp->s_alt_pkey_index;
-	qp->s_flags |= HFI1_S_AHG_CLEAR;
-
-	ev.device = qp->ibqp.device;
-	ev.element.qp = &qp->ibqp;
-	ev.event = IB_EVENT_PATH_MIG;
-	qp->ibqp.event_handler(&ev, qp->ibqp.qp_context);
-}
-
 static __be64 get_sguid(struct hfi1_ibport *ibp, unsigned index)
 {
 	if (!index) {
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index e4a8a0d4ccf8..9555aab51530 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -1071,8 +1071,6 @@ int hfi1_mmap(struct ib_ucontext *context, struct vm_area_struct *vma);
 
 int hfi1_get_rwqe(struct hfi1_qp *qp, int wr_id_only);
 
-void hfi1_migrate_qp(struct hfi1_qp *qp);
-
 int hfi1_ruc_check_hdr(struct hfi1_ibport *ibp, struct hfi1_ib_header *hdr,
 		       int has_grh, struct hfi1_qp *qp, u32 bth0);
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
