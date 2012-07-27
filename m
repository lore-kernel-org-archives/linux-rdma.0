From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] RDMA/ocrdma: Fix check of GSI CQs
Date: Fri, 27 Jul 2012 13:17:26 -0700
Message-ID: <1343420246-12012-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Parav Pandit <parav.pandit-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Mahesh Vardhamanaiah <mahesh.vardhamanaiah-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>

It looks like one check was accidentally duplicated, and the other 3
checks were left out.  This was detected by scripts/coccinelle/tests/doubletest.cocci:

    drivers/infiniband/hw/ocrdma/ocrdma_verbs.c:895:6-54: duplicated argument to && or ||

Reported-by: Fengguang Wu <fengguang.wu-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index b2f9784..cb5b7f7 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -893,7 +893,9 @@ static int ocrdma_check_qp_params(struct ib_pd *ibpd, struct ocrdma_dev *dev,
 	/* verify consumer QPs are not trying to use GSI QP's CQ */
 	if ((attrs->qp_type != IB_QPT_GSI) && (dev->gsi_qp_created)) {
 		if ((dev->gsi_sqcq == get_ocrdma_cq(attrs->send_cq)) ||
-		    (dev->gsi_sqcq == get_ocrdma_cq(attrs->send_cq))) {
+		    (dev->gsi_sqcq == get_ocrdma_cq(attrs->recv_cq)) ||
+		    (dev->gsi_rqcq == get_ocrdma_cq(attrs->send_cq)) ||
+		    (dev->gsi_rqcq == get_ocrdma_cq(attrs->recv_cq))) {
 			ocrdma_err("%s(%d) Consumer QP cannot use GSI CQs.\n",
 				   __func__, dev->id);
 			return -EINVAL;
-- 
1.7.10.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
