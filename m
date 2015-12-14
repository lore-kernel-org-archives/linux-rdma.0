From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [RFC PATCH 08/15] IB/hfi1: Use correct rdmavt header files after
 move.
Date: Mon, 14 Dec 2015 12:28:47 -0500
Message-ID: <20151214172846.11576.43466.stgit@phlsvslse11.ph.intel.com>
References: <20151214172509.11576.19722.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20151214172509.11576.19722.stgit-K+u1se/DcYrLESAwzcoQNrvm/XP+8Wra@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: devel-gWbeCf7V1WCQmaza687I9mD2FQJk+8+b@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: gregkh-hQyY1W1yCW8ekmWlsbkhG0B+6BGkLq7r@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Rdmavt split the header files to be based on ibta object. This patch
makes changes in hfi1 to account for the move.

The actual removal of HFI1 code continues in the following patch.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/driver.c |    3 ++-
 drivers/staging/rdma/hfi1/mad.c    |    4 ++--
 drivers/staging/rdma/hfi1/qp.c     |    5 +++--
 drivers/staging/rdma/hfi1/ud.c     |   14 +++++++-------
 drivers/staging/rdma/hfi1/verbs.c  |    4 ++--
 5 files changed, 16 insertions(+), 14 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index 4f0103b..fb52d07 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -56,6 +56,7 @@
 #include <linux/vmalloc.h>
 #include <linux/module.h>
 #include <linux/prefetch.h>
+#include <rdma/ib_verbs.h>
 
 #include "hfi.h"
 #include "trace.h"
@@ -316,7 +317,7 @@ static void rcv_hdrerr(struct hfi1_ctxtdata *rcd, struct hfi1_pportdata *ppd,
 
 		/* Get the destination QP number. */
 		qp_num = be32_to_cpu(ohdr->bth[1]) & HFI1_QPN_MASK;
-		if (lid < HFI1_MULTICAST_LID_BASE) {
+		if (lid < be16_to_cpu(IB_MULTICAST_LID_BASE)) {
 			struct hfi1_qp *qp;
 			unsigned long flags;
 
diff --git a/drivers/staging/rdma/hfi1/mad.c b/drivers/staging/rdma/hfi1/mad.c
index 1c34396..0a3f291 100644
--- a/drivers/staging/rdma/hfi1/mad.c
+++ b/drivers/staging/rdma/hfi1/mad.c
@@ -1096,7 +1096,7 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 
 	/* Must be a valid unicast LID address. */
 	if ((lid == 0 && ls_old > IB_PORT_INIT) ||
-	     lid >= HFI1_MULTICAST_LID_BASE) {
+	     lid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) {
 		smp->status |= IB_SMP_INVALID_FIELD;
 		pr_warn("SubnSet(OPA_PortInfo) lid invalid 0x%x\n",
 			lid);
@@ -1129,7 +1129,7 @@ static int __subn_set_opa_portinfo(struct opa_smp *smp, u32 am, u8 *data,
 
 	/* Must be a valid unicast LID address. */
 	if ((smlid == 0 && ls_old > IB_PORT_INIT) ||
-	     smlid >= HFI1_MULTICAST_LID_BASE) {
+	     smlid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) {
 		smp->status |= IB_SMP_INVALID_FIELD;
 		pr_warn("SubnSet(OPA_PortInfo) smlid invalid 0x%x\n", smlid);
 	} else if (smlid != ibp->sm_lid || msl != ibp->sm_sl) {
diff --git a/drivers/staging/rdma/hfi1/qp.c b/drivers/staging/rdma/hfi1/qp.c
index d49b1e9..7c356e4 100644
--- a/drivers/staging/rdma/hfi1/qp.c
+++ b/drivers/staging/rdma/hfi1/qp.c
@@ -640,7 +640,7 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if (attr_mask & IB_QP_AV) {
 		u8 sc;
 
-		if (attr->ah_attr.dlid >= HFI1_MULTICAST_LID_BASE)
+		if (attr->ah_attr.dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE))
 			goto inval;
 		if (hfi1_check_ah(qp->ibqp.device, &attr->ah_attr))
 			goto inval;
@@ -653,7 +653,8 @@ int hfi1_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	if (attr_mask & IB_QP_ALT_PATH) {
 		u8 sc;
 
-		if (attr->alt_ah_attr.dlid >= HFI1_MULTICAST_LID_BASE)
+		if (attr->alt_ah_attr.dlid >=
+		    be16_to_cpu(IB_MULTICAST_LID_BASE))
 			goto inval;
 		if (hfi1_check_ah(qp->ibqp.device, &attr->alt_ah_attr))
 			goto inval;
diff --git a/drivers/staging/rdma/hfi1/ud.c b/drivers/staging/rdma/hfi1/ud.c
index ba8a557..aad4e49 100644
--- a/drivers/staging/rdma/hfi1/ud.c
+++ b/drivers/staging/rdma/hfi1/ud.c
@@ -243,7 +243,7 @@ static void ud_loopback(struct hfi1_qp *sqp, struct hfi1_swqe *swqe)
 	wc.slid = ppd->lid | (ah_attr->src_path_bits & ((1 << ppd->lmc) - 1));
 	/* Check for loopback when the port lid is not set */
 	if (wc.slid == 0 && sqp->ibqp.qp_type == IB_QPT_GSI)
-		wc.slid = HFI1_PERMISSIVE_LID;
+		wc.slid = be16_to_cpu(IB_LID_PERMISSIVE);
 	wc.sl = ah_attr->sl;
 	wc.dlid_path_bits = ah_attr->dlid & ((1 << ppd->lmc) - 1);
 	wc.port_num = qp->port_num;
@@ -311,11 +311,11 @@ int hfi1_make_ud_req(struct hfi1_qp *qp)
 	ibp = to_iport(qp->ibqp.device, qp->port_num);
 	ppd = ppd_from_ibp(ibp);
 	ah_attr = &to_iah(wqe->ud_wr.ah)->attr;
-	if (ah_attr->dlid < HFI1_MULTICAST_LID_BASE ||
-	    ah_attr->dlid == HFI1_PERMISSIVE_LID) {
+	if (ah_attr->dlid < be16_to_cpu(IB_MULTICAST_LID_BASE) ||
+	    ah_attr->dlid == be16_to_cpu(IB_LID_PERMISSIVE)) {
 		lid = ah_attr->dlid & ~((1 << ppd->lmc) - 1);
 		if (unlikely(!loopback && (lid == ppd->lid ||
-		    (lid == HFI1_PERMISSIVE_LID &&
+		    (lid == be16_to_cpu(IB_LID_PERMISSIVE) &&
 		     qp->ibqp.qp_type == IB_QPT_GSI)))) {
 			/*
 			 * If DMAs are in progress, we can't generate
@@ -667,8 +667,8 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	qkey = be32_to_cpu(ohdr->u.ud.deth[0]);
 	src_qp = be32_to_cpu(ohdr->u.ud.deth[1]) & HFI1_QPN_MASK;
 	dlid = be16_to_cpu(hdr->lrh[1]);
-	is_mcast = (dlid > HFI1_MULTICAST_LID_BASE) &&
-			(dlid != HFI1_PERMISSIVE_LID);
+	is_mcast = (dlid > be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
+			(dlid != be16_to_cpu(IB_LID_PERMISSIVE));
 	bth1 = be32_to_cpu(ohdr->bth[1]);
 	if (unlikely(bth1 & HFI1_BECN_SMASK)) {
 		/*
@@ -873,7 +873,7 @@ void hfi1_ud_rcv(struct hfi1_packet *packet)
 	/*
 	 * Save the LMC lower bits if the destination LID is a unicast LID.
 	 */
-	wc.dlid_path_bits = dlid >= HFI1_MULTICAST_LID_BASE ? 0 :
+	wc.dlid_path_bits = dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE) ? 0 :
 		dlid & ((1 << ppd_from_ibp(ibp)->lmc) - 1);
 	wc.port_num = qp->port_num;
 	/* Signal completion event if the solicited bit is set. */
diff --git a/drivers/staging/rdma/hfi1/verbs.c b/drivers/staging/rdma/hfi1/verbs.c
index 1477d00..644950e 100644
--- a/drivers/staging/rdma/hfi1/verbs.c
+++ b/drivers/staging/rdma/hfi1/verbs.c
@@ -646,8 +646,8 @@ void hfi1_ib_rcv(struct hfi1_packet *packet)
 	/* Get the destination QP number. */
 	qp_num = be32_to_cpu(packet->ohdr->bth[1]) & HFI1_QPN_MASK;
 	lid = be16_to_cpu(hdr->lrh[1]);
-	if (unlikely((lid >= HFI1_MULTICAST_LID_BASE) &&
-	    (lid != HFI1_PERMISSIVE_LID))) {
+	if (unlikely((lid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) &&
+		     (lid != be16_to_cpu(IB_LID_PERMISSIVE)))) {
 		struct hfi1_mcast *mcast;
 		struct hfi1_mcast_qp *p;
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
