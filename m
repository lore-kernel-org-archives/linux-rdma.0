From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] ib_qib: fix QP check when looping back to/from QP1
Date: Wed, 18 Dec 2013 08:41:37 -0800
Message-ID: <20131218084137.ce18a72cc25857d533599530@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


The GSI QP type is compatible with and should be allowed to send data to/from any
UD QP.  This was found when testing ibacm on the same node as an SA.

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Reviewed-by: Marciniszyn, Mike <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/qib/qib_ud.c |    9 ++++++++-
 1 files changed, 8 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/qib/qib_ud.c b/drivers/infiniband/hw/qib/qib_ud.c
index d6c7fe7..3ad651c 100644
--- a/drivers/infiniband/hw/qib/qib_ud.c
+++ b/drivers/infiniband/hw/qib/qib_ud.c
@@ -57,13 +57,20 @@ static void qib_ud_loopback(struct qib_qp *sqp, struct qib_swqe *swqe)
 	struct qib_sge *sge;
 	struct ib_wc wc;
 	u32 length;
+	enum ib_qp_type sqptype, dqptype;
 
 	qp = qib_lookup_qpn(ibp, swqe->wr.wr.ud.remote_qpn);
 	if (!qp) {
 		ibp->n_pkt_drops++;
 		return;
 	}
-	if (qp->ibqp.qp_type != sqp->ibqp.qp_type ||
+
+	sqptype = sqp->ibqp.qp_type == IB_QPT_GSI ?
+			IB_QPT_UD : sqp->ibqp.qp_type;
+	dqptype = qp->ibqp.qp_type == IB_QPT_GSI ?
+			IB_QPT_UD : qp->ibqp.qp_type;
+
+	if (dqptype != sqptype ||
 	    !(ib_qib_state_ops[qp->state] & QIB_PROCESS_RECV_OK)) {
 		ibp->n_pkt_drops++;
 		goto drop;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
