From: <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5] RDMA/ocrdma: Set bad_wr in error case.
Date: Mon, 10 Jun 2013 10:12:40 +0530
Message-ID: <d0b5c6a0-995e-4771-aed1-65350beb614a@CMEXHTCAS2.ad.emulex.com>
References: <1370839362-3871-1-git-send-email-bgottumukkala@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1370839362-3871-1-git-send-email-bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Fixed post_send to set the bad_wr in error case.

Signed-off-by: Naresh Gottumukkala <bgottumukkala-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 882a819..0621530 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -1734,12 +1734,14 @@ int ocrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	spin_lock_irqsave(&qp->q_lock, flags);
 	if (qp->state != OCRDMA_QPS_RTS && qp->state != OCRDMA_QPS_SQD) {
 		spin_unlock_irqrestore(&qp->q_lock, flags);
+		*bad_wr = wr;
 		return -EINVAL;
 	}
 
 	while (wr) {
 		if (ocrdma_hwq_free_cnt(&qp->sq) == 0 ||
 		    wr->num_sge > qp->sq.max_sges) {
+			*bad_wr = wr;
 			status = -ENOMEM;
 			break;
 		}
-- 
1.8.2.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
