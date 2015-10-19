From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 12/23] staging/rdma/hfi1: Add a schedule in send thread
Date: Mon, 19 Oct 2015 12:43:36 -0400
Message-ID: <1445273027-29634-13-git-send-email-ira.weiny@intel.com>
References: <1445273027-29634-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1445273027-29634-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

When under heavy load, the send handler can run too long without allowing other
tasks to run.  Add a conditional resched to break this up.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/chip.c  | 10 ++++++++++
 drivers/staging/rdma/hfi1/chip.h  |  1 +
 drivers/staging/rdma/hfi1/ruc.c   | 12 ++++++++++++
 drivers/staging/rdma/hfi1/verbs.h |  1 +
 4 files changed, 24 insertions(+)

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 93ca13fceb51..3c48294abd20 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -1530,6 +1530,14 @@ static u64 access_sw_kmem_wait(const struct cntr_entry *entry,
 	return dd->verbs_dev.n_kmem_wait;
 }
 
+static u64 access_sw_send_schedule(const struct cntr_entry *entry,
+			       void *context, int vl, int mode, u64 data)
+{
+	struct hfi1_devdata *dd = (struct hfi1_devdata *)context;
+
+	return dd->verbs_dev.n_send_schedule;
+}
+
 #define def_access_sw_cpu(cntr) \
 static u64 access_sw_cpu_##cntr(const struct cntr_entry *entry,		      \
 			      void *context, int vl, int mode, u64 data)      \
@@ -1720,6 +1728,8 @@ static struct cntr_entry dev_cntrs[DEV_CNTR_LAST] = {
 			    access_sw_pio_wait),
 [C_SW_KMEM_WAIT] = CNTR_ELEM("KmemWait", 0, 0, CNTR_NORMAL,
 			    access_sw_kmem_wait),
+[C_SW_SEND_SCHED] = CNTR_ELEM("SendSched", 0, 0, CNTR_NORMAL,
+			    access_sw_send_schedule),
 };
 
 static struct cntr_entry port_cntrs[PORT_CNTR_LAST] = {
diff --git a/drivers/staging/rdma/hfi1/chip.h b/drivers/staging/rdma/hfi1/chip.h
index 497c5de23d53..ebf9041a1c5e 100644
--- a/drivers/staging/rdma/hfi1/chip.h
+++ b/drivers/staging/rdma/hfi1/chip.h
@@ -787,6 +787,7 @@ enum {
 	C_SW_VTX_WAIT,
 	C_SW_PIO_WAIT,
 	C_SW_KMEM_WAIT,
+	C_SW_SEND_SCHED,
 	DEV_CNTR_LAST  /* Must be kept last */
 };
 
diff --git a/drivers/staging/rdma/hfi1/ruc.c b/drivers/staging/rdma/hfi1/ruc.c
index faad1b93703e..8614b070545c 100644
--- a/drivers/staging/rdma/hfi1/ruc.c
+++ b/drivers/staging/rdma/hfi1/ruc.c
@@ -820,6 +820,9 @@ void hfi1_make_ruc_header(struct hfi1_qp *qp, struct hfi1_other_headers *ohdr,
 	ohdr->bth[2] = cpu_to_be32(bth2);
 }
 
+/* when sending, force a reschedule every one of these periods */
+#define SEND_RESCHED_TIMEOUT (5 * HZ)  /* 5s in jiffies */
+
 /**
  * hfi1_do_send - perform a send on a QP
  * @work: contains a pointer to the QP
@@ -836,6 +839,7 @@ void hfi1_do_send(struct work_struct *work)
 	struct hfi1_pportdata *ppd = ppd_from_ibp(ibp);
 	int (*make_req)(struct hfi1_qp *qp);
 	unsigned long flags;
+	unsigned long timeout;
 
 	if ((qp->ibqp.qp_type == IB_QPT_RC ||
 	     qp->ibqp.qp_type == IB_QPT_UC) &&
@@ -864,6 +868,7 @@ void hfi1_do_send(struct work_struct *work)
 
 	spin_unlock_irqrestore(&qp->s_lock, flags);
 
+	timeout = jiffies + SEND_RESCHED_TIMEOUT;
 	do {
 		/* Check for a constructed packet to be sent. */
 		if (qp->s_hdrwords != 0) {
@@ -877,6 +882,13 @@ void hfi1_do_send(struct work_struct *work)
 			/* Record that s_hdr is empty. */
 			qp->s_hdrwords = 0;
 		}
+
+		/* allow other tasks to run */
+		if (unlikely(time_after(jiffies, timeout))) {
+			cond_resched();
+			ppd->dd->verbs_dev.n_send_schedule++;
+			timeout = jiffies + SEND_RESCHED_TIMEOUT;
+		}
 	} while (make_req(qp));
 }
 
diff --git a/drivers/staging/rdma/hfi1/verbs.h b/drivers/staging/rdma/hfi1/verbs.h
index afaa0fe619fe..e4a8a0d4ccf8 100644
--- a/drivers/staging/rdma/hfi1/verbs.h
+++ b/drivers/staging/rdma/hfi1/verbs.h
@@ -754,6 +754,7 @@ struct hfi1_ibdev {
 	u64 n_piowait;
 	u64 n_txwait;
 	u64 n_kmem_wait;
+	u64 n_send_schedule;
 
 	u32 n_pds_allocated;    /* number of PDs allocated for device */
 	spinlock_t n_pds_lock;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
