From: ira.weiny@intel.com
Subject: [PATCH 7/9] staging/rdma/hfi1: move hfi1_migrate_qp
Date: Fri, 30 Oct 2015 18:41:56 -0400
Message-ID: <1446244918-12089-8-git-send-email-ira.weiny@intel.com>
References: <1446244918-12089-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1446244918-12089-1-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, dennis.dalessandro@intel.com
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn@intel.com>

Move hfi1_migrate_qp from ruc.c to qp.[hc] in prep for modifying the QP
workqueue.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
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
