From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 04/10] IB/qib: Remove most uses of QIB_PERMISSIVE_LID and
 QIB_MULTICAST_LID_BASE
Date: Wed, 06 Jan 2016 10:07:57 -0800
Message-ID: <20160106180754.15836.81251.stgit@scvm10.sc.intel.com>
References: <20160106180541.15836.58173.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160106180541.15836.58173.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch removes most of the uses of QIB_PERMISSIBVE_LID and
QIB_MULTICAST_LID_BASE in favor of the recently added IB_* versions.
There are still minor uses in AH functions as well as the QIB_* defines
but those will be removed in a follow on patch.

Reviewed-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_driver.c |    2 +-
 drivers/infiniband/hw/qib/qib_mad.c    |    4 ++--
 drivers/infiniband/hw/qib/qib_qp.c     |    5 +++--
 drivers/infiniband/hw/qib/qib_ud.c     |   11 ++++++-----
 drivers/infiniband/hw/qib/qib_verbs.c  |    2 +-
 5 files changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_driver.c b/drivers/infiniband/hw/qib/qib_driver.c
index f58fdc3..57b19ea 100644
--- a/drivers/infiniband/hw/qib/qib_driver.c
+++ b/drivers/infiniband/hw/qib/qib_driver.c
@@ -319,7 +319,7 @@ static u32 qib_rcv_hdrerr(struct qib_ctxtdata *rcd, struct qib_pportdata *ppd,
 		if (tlen < 24)
 			goto drop;
 
-		if (lid < QIB_MULTICAST_LID_BASE) {
+		if (lid < be16_to_cpu(IB_MULTICAST_LID_BASE)) {
 			lid &= ~((1 << ppd->lmc) - 1);
 			if (unlikely(lid != ppd->lid))
 				goto drop;
diff --git a/drivers/infiniband/hw/qib/qib_mad.c b/drivers/infiniband/hw/qib/qib_mad.c
index c65d3aa..70fc1b2 100644
--- a/drivers/infiniband/hw/qib/qib_mad.c
+++ b/drivers/infiniband/hw/qib/qib_mad.c
@@ -691,7 +691,7 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 
 	lid = be16_to_cpu(pip->lid);
 	/* Must be a valid unicast LID address. */
-	if (lid == 0 || lid >= QIB_MULTICAST_LID_BASE)
+	if (lid == 0 || lid >= be16_to_cpu(IB_MULTICAST_LID_BASE))
 		smp->status |= IB_SMP_INVALID_FIELD;
 	else if (ppd->lid != lid || ppd->lmc != (pip->mkeyprot_resv_lmc & 7)) {
 		if (ppd->lid != lid)
@@ -706,7 +706,7 @@ static int subn_set_portinfo(struct ib_smp *smp, struct ib_device *ibdev,
 	smlid = be16_to_cpu(pip->sm_lid);
 	msl = pip->neighbormtu_mastersmsl & 0xF;
 	/* Must be a valid unicast LID address. */
-	if (smlid == 0 || smlid >= QIB_MULTICAST_LID_BASE)
+	if (smlid == 0 || smlid >= be16_to_cpu(IB_MULTICAST_LID_BASE))
 		smp->status |= IB_SMP_INVALID_FIELD;
 	else if (smlid != ibp->sm_lid || msl != ibp->sm_sl) {
 		spin_lock_irqsave(&ibp->lock, flags);
diff --git a/drivers/infiniband/hw/qib/qib_qp.c b/drivers/infiniband/hw/qib/qib_qp.c
index 40f85bb..e6544dc 100644
--- a/drivers/infiniband/hw/qib/qib_qp.c
+++ b/drivers/infiniband/hw/qib/qib_qp.c
@@ -589,14 +589,15 @@ int qib_modify_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 		goto inval;
 
 	if (attr_mask & IB_QP_AV) {
-		if (attr->ah_attr.dlid >= QIB_MULTICAST_LID_BASE)
+		if (attr->ah_attr.dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE))
 			goto inval;
 		if (qib_check_ah(qp->ibqp.device, &attr->ah_attr))
 			goto inval;
 	}
 
 	if (attr_mask & IB_QP_ALT_PATH) {
-		if (attr->alt_ah_attr.dlid >= QIB_MULTICAST_LID_BASE)
+		if (attr->alt_ah_attr.dlid >=
+		    be16_to_cpu(IB_MULTICAST_LID_BASE))
 			goto inval;
 		if (qib_check_ah(qp->ibqp.device, &attr->alt_ah_attr))
 			goto inval;
diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index 59193f6..32fc80c 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -32,6 +32,7 @@
  */
 
 #include <rdma/ib_smi.h>
+#include <rdma/ib_verbs.h>
 
 #include "qib.h"
 #include "qib_mad.h"
@@ -278,8 +279,8 @@ int qib_make_ud_req(struct qib_qp *qp)
 	ibp = to_iport(qp->ibqp.device, qp->port_num);
 	ppd = ppd_from_ibp(ibp);
 	ah_attr = &to_iah(wqe->ud_wr.ah)->attr;
-	if (ah_attr->dlid >= QIB_MULTICAST_LID_BASE) {
-		if (ah_attr->dlid != QIB_PERMISSIVE_LID)
+	if (ah_attr->dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE)) {
+		if (ah_attr->dlid != be16_to_cpu(IB_LID_PERMISSIVE))
 			this_cpu_inc(ibp->pmastats->n_multicast_xmit);
 		else
 			this_cpu_inc(ibp->pmastats->n_unicast_xmit);
@@ -368,8 +369,8 @@ int qib_make_ud_req(struct qib_qp *qp)
 	/*
 	 * Use the multicast QP if the destination LID is a multicast LID.
 	 */
-	ohdr->bth[1] = ah_attr->dlid >= QIB_MULTICAST_LID_BASE &&
-		ah_attr->dlid != QIB_PERMISSIVE_LID ?
+	ohdr->bth[1] = ah_attr->dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE) &&
+		ah_attr->dlid != be16_to_cpu(IB_LID_PERMISSIVE) ?
 		cpu_to_be32(QIB_MULTICAST_QPN) :
 		cpu_to_be32(wqe->ud_wr.remote_qpn);
 	ohdr->bth[2] = cpu_to_be32(qp->s_next_psn++ & QIB_PSN_MASK);
@@ -576,7 +577,7 @@ void qib_ud_rcv(struct qib_ibport *ibp, struct qib_ib_header *hdr,
 	/*
 	 * Save the LMC lower bits if the destination LID is a unicast LID.
 	 */
-	wc.dlid_path_bits = dlid >= QIB_MULTICAST_LID_BASE ? 0 :
+	wc.dlid_path_bits = dlid >= be16_to_cpu(IB_MULTICAST_LID_BASE) ? 0 :
 		dlid & ((1 << ppd_from_ibp(ibp)->lmc) - 1);
 	wc.port_num = qp->port_num;
 	/* Signal completion event if the solicited bit is set. */
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 1aaafea..2578473 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -641,7 +641,7 @@ void qib_ib_rcv(struct qib_ctxtdata *rcd, void *rhdr, void *data, u32 tlen)
 
 	/* Check for a valid destination LID (see ch. 7.11.1). */
 	lid = be16_to_cpu(hdr->lrh[1]);
-	if (lid < QIB_MULTICAST_LID_BASE) {
+	if (lid < be16_to_cpu(IB_MULTICAST_LID_BASE)) {
 		lid &= ~((1 << ppd->lmc) - 1);
 		if (unlikely(lid != ppd->lid))
 			goto drop;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
