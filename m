From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 09/15] RDMA/ocrdma: Allow only SEND opcode in case
Date: Wed, 4 Jun 2014 14:22:40 +0530
Message-ID: <477f7849-e09e-4905-84c6-fc9fe572a719@CMEXHTCAS1.ad.emulex.com>
References: <1401871966-20408-1-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-2-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-3-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-4-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-5-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-6-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-7-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-8-git-send-email-selvin.xavier@emulex.com>
 <1401871966-20408-9-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401871966-20408-9-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Mitesh Ahuja <mitesh.ahuja-HfQkIhtri/DQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitesh Ahuja <mitesh.ahuja-HfQkIhtri/DQT0dZR+AlfA@public.gmane.org>

Signed-off-by: Mitesh Ahuja <mitesh.ahuja-HfQkIhtri/DQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 2b68235..7f54d24 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -2055,6 +2055,13 @@ int ocrdma_post_send(struct ib_qp *ibqp, struct ib_send_wr *wr,
 	}
 
 	while (wr) {
+		if (qp->qp_type == IB_QPT_UD &&
+		    (wr->opcode != IB_WR_SEND &&
+		     wr->opcode != IB_WR_SEND_WITH_IMM)) {
+			*bad_wr = wr;
+			status = -EINVAL;
+			break;
+		}
 		if (ocrdma_hwq_free_cnt(&qp->sq) == 0 ||
 		    wr->num_sge > qp->sq.max_sges) {
 			*bad_wr = wr;
-- 
1.7.12.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
