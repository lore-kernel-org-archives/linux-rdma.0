From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 23/23] IB/rdmavt, IB/hfi1,
 IB/qib: Add inlines for mtu division
Date: Wed, 07 Dec 2016 19:34:37 -0800
Message-ID: <20161208033436.21135.8040.stgit@scvm10.sc.intel.com>
References: <20161208032312.21135.66056.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20161208032312.21135.66056.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add rvt_div_round_up_mtu() and rvt_div_mtu() routines to
do the computation based on the pmtu and the log_pmtu.

Change divides in qib, hfi1 to use the new inlines.

Reviewed-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/rc.c    |    3 +--
 drivers/infiniband/hw/qib/qib_rc.c |    3 +--
 include/rdma/rdmavt_qp.h           |   24 +++++++++++++++++++++++-
 3 files changed, 25 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/rc.c b/drivers/infiniband/hw/hfi1/rc.c
index a297f79..809b26e 100644
--- a/drivers/infiniband/hw/hfi1/rc.c
+++ b/drivers/infiniband/hw/hfi1/rc.c
@@ -2377,8 +2377,7 @@ void hfi1_rc_rcv(struct hfi1_packet *packet)
 			 * Update the next expected PSN.  We add 1 later
 			 * below, so only add the remainder here.
 			 */
-			if (len > pmtu)
-				qp->r_psn += (len - 1) / pmtu;
+			qp->r_psn += rvt_div_mtu(qp, len - 1);
 		} else {
 			e->rdma_sge.mr = NULL;
 			e->rdma_sge.vaddr = NULL;
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index e23ee6c..031433c 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -2079,8 +2079,7 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct ib_header *hdr,
 			 * Update the next expected PSN.  We add 1 later
 			 * below, so only add the remainder here.
 			 */
-			if (len > pmtu)
-				qp->r_psn += (len - 1) / pmtu;
+			qp->r_psn += rvt_div_mtu(qp, len - 1);
 		} else {
 			e->rdma_sge.mr = NULL;
 			e->rdma_sge.vaddr = NULL;
diff --git a/include/rdma/rdmavt_qp.h b/include/rdma/rdmavt_qp.h
index 04facda..f3dbd15 100644
--- a/include/rdma/rdmavt_qp.h
+++ b/include/rdma/rdmavt_qp.h
@@ -582,7 +582,29 @@ static inline void rvt_qp_swqe_complete(
 	}
 }
 
-extern const int ib_rvt_state_ops[];
+/**
+ * @qp - the qp pair
+ * @len - the length
+ *
+ * Perform a shift based mtu round up divide
+ */
+static inline u32 rvt_div_round_up_mtu(struct rvt_qp *qp, u32 len)
+{
+	return (len + qp->pmtu - 1) >> qp->log_pmtu;
+}
+
+/**
+ * @qp - the qp pair
+ * @len - the length
+ *
+ * Perform a shift based mtu divide
+ */
+static inline u32 rvt_div_mtu(struct rvt_qp *qp, u32 len)
+{
+	return len >> qp->log_pmtu;
+}
+
+extern const int  ib_rvt_state_ops[];
 
 struct rvt_dev_info;
 int rvt_error_qp(struct rvt_qp *qp, enum ib_wc_status err);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
