From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/16] staging/rdma/hfi1: avoid passing pmtu
Date: Sun, 14 Feb 2016 12:45:09 -0800
Message-ID: <20160214204505.29247.34527.stgit@scvm10.sc.intel.com>
References: <20160214203612.29247.59915.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160214203612.29247.59915.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

It is in the qp.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/rc.c |    6 +++---
 1 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/rc.c b/drivers/staging/rdma/hfi1/rc.c
index c075e85..d54d3ad 100644
--- a/drivers/staging/rdma/hfi1/rc.c
+++ b/drivers/staging/rdma/hfi1/rc.c
@@ -200,7 +200,6 @@ static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
  * @dev: the device for this QP
  * @qp: a pointer to the QP
  * @ohdr: a pointer to the IB header being constructed
- * @pmtu: the path MTU
  * @ps: the xmit packet state
  *
  * Return 1 if constructed; otherwise, return 0.
@@ -208,7 +207,7 @@ static u32 restart_sge(struct rvt_sge_state *ss, struct rvt_swqe *wqe,
  * Note the QP s_lock must be held.
  */
 static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
-		       struct hfi1_other_headers *ohdr, u32 pmtu,
+		       struct hfi1_other_headers *ohdr,
 		       struct hfi1_pkt_state *ps)
 {
 	struct rvt_ack_entry *e;
@@ -217,6 +216,7 @@ static int make_rc_ack(struct hfi1_ibdev *dev, struct rvt_qp *qp,
 	u32 bth0;
 	u32 bth2;
 	int middle = 0;
+	u32 pmtu = qp->pmtu;
 
 	/* Don't send an ACK if we aren't supposed to. */
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_RECV_OK))
@@ -400,7 +400,7 @@ int hfi1_make_rc_req(struct rvt_qp *qp, struct hfi1_pkt_state *ps)
 
 	/* Sending responses has higher priority over sending requests. */
 	if ((qp->s_flags & RVT_S_RESP_PENDING) &&
-	    make_rc_ack(dev, qp, ohdr, pmtu, ps))
+	    make_rc_ack(dev, qp, ohdr, ps))
 		return 1;
 
 	if (!(ib_rvt_state_ops[qp->state] & RVT_PROCESS_SEND_OK)) {

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
