From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 7/7] IB/qib: remove s_lock around header validation
Date: Fri, 23 Sep 2011 13:17:00 -0400
Message-ID: <20110923171659.14542.55265.stgit@kop-dev-sles11-04.qlogic.org>
References: <20110923171623.14542.78747.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20110923171623.14542.78747.stgit-hIFRcJ1SNwcXGO8/Qfapyjg/wwJxntczYPYVAmT7z5s@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Observation in qib_ruc_check_hdr() shows that the s_lock is not required
in the normal case.   The r_lock is held in all cases, and protects
the qp fields that are read.

The s_lock will be needed to around the call to qib_migrate_qp() to
insure that the send engine sees a consistent set of fields.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_driver.c |    5 -----
 drivers/infiniband/hw/qib/qib_rc.c     |    4 +---
 drivers/infiniband/hw/qib/qib_ruc.c    |    7 ++++++-
 drivers/infiniband/hw/qib/qib_uc.c     |    7 +------
 4 files changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index 1ba9da9..8191925 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -313,7 +313,6 @@ static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
 		u32 opcode;
 		u32 psn;
 		int diff;
-		unsigned long flags;
 
 		/* Sanity check packet */
 		if (tlen < 24)
@@ -368,7 +367,6 @@ static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
 
 			switch (qp->ibqp.qp_type) {
 			case IB_QPT_RC:
-				spin_lock_irqsave(&qp->s_lock, flags);
 				ruc_res =
 					qib_ruc_check_hdr(
 						ibp, hdr,
@@ -376,11 +374,8 @@ static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
 						qp,
 						be32_to_cpu(ohdr->bth[0]));
 				if (ruc_res) {
-					spin_unlock_irqrestore(&qp->s_lock,
-							       flags);
 					goto unlock;
 				}
-				spin_unlock_irqrestore(&qp->s_lock, flags);
 
 				/* Only deal with RDMA Writes for now */
 				if (opcode <
diff --git a/drivers/infiniband/hw/qib/qib_rc.c b/drivers/infiniband/hw/qib/qib_rc.c
index a75b713..23c905e 100644
--- a/drivers/infiniband/hw/qib/qib_rc.c
+++ b/drivers/infiniband/hw/qib/qib_rc.c
@@ -1889,10 +1889,8 @@ void qib_rc_rcv(struct qib_ctxtdata *rcd, struct qib_ib_header *hdr,
 	}
 
 	opcode = be32_to_cpu(ohdr->bth[0]);
-	spin_lock_irqsave(&qp->s_lock, flags);
 	if (qib_ruc_check_hdr(ibp, hdr, has_grh, qp, opcode))
-		goto sunlock;
-	spin_unlock_irqrestore(&qp->s_lock, flags);
+		return;
 
 	psn = be32_to_cpu(ohdr->bth[2]);
 	opcode >>= 24;
diff --git a/drivers/infiniband/hw/qib/qib_ruc.c b/drivers/infiniband/hw/qib/qib_ruc.c
index eb78d93..b4b37e4 100644
--- a/drivers/infiniband/hw/qib/qib_ruc.c
+++ b/drivers/infiniband/hw/qib/qib_ruc.c
@@ -260,12 +260,15 @@ static int gid_ok(union ib_gid *gid, __be64 gid_prefix, __be64 id)
 
 /*
  *
- * This should be called with the QP s_lock held.
+ * This should be called with the QP r_lock held.
+ *
+ * The s_lock will be acquired around the qib_migrate_qp() call.
  */
 int qib_ruc_check_hdr(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 		      int has_grh, struct qib_qp *qp, u32 bth0)
 {
 	__be64 guid;
+	unsigned long flags;
 
 	if (qp->s_mig_state == IB_MIG_ARMED && (bth0 & IB_BTH_MIG_REQ)) {
 		if (!has_grh) {
@@ -295,7 +298,9 @@ int qib_ruc_check_hdr(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 		if (be16_to_cpu(hdr->lrh[3]) != qp->alt_ah_attr.dlid ||
 		    ppd_from_ibp(ibp)->port != qp->alt_ah_attr.port_num)
 			goto err;
+		spin_lock_irqsave(&qp->s_lock, flags);
 		qib_migrate_qp(qp);
+		spin_unlock_irqrestore(&qp->s_lock, flags);
 	} else {
 		if (!has_grh) {
 			if (qp->remote_ah_attr.ah_flags & IB_AH_GRH)
diff --git a/drivers/infiniband/hw/qib/qib_uc.c b/drivers/infiniband/hw/qib/qib_uc.c
index 7aa346f..56fa7a9 100644
--- a/drivers/infiniband/hw/qib/qib_uc.c
+++ b/drivers/infiniband/hw/qib/qib_uc.c
@@ -243,7 +243,6 @@ void qib_uc_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 		int has_grh, void *data, u32 tlen, struct qib_qp *qp)
 {
 	struct qib_other_headers *ohdr;
-	unsigned long flags;
 	u32 opcode;
 	u32 hdrsize;
 	u32 psn;
@@ -263,10 +262,8 @@ void qib_uc_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 	}
 
 	opcode = be32_to_cpu(ohdr->bth[0]);
-	spin_lock_irqsave(&qp->s_lock, flags);
 	if (qib_ruc_check_hdr(ibp, hdr, has_grh, qp, opcode))
-		goto sunlock;
-	spin_unlock_irqrestore(&qp->s_lock, flags);
+		return;
 
 	psn = be32_to_cpu(ohdr->bth[2]);
 	opcode >>= 24;
@@ -555,6 +552,4 @@ op_err:
 	qib_rc_error(qp, IB_WC_LOC_QP_OP_ERR);
 	return;
 
-sunlock:
-	spin_unlock_irqrestore(&qp->s_lock, flags);
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
