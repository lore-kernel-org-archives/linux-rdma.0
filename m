From: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDMA/nes: correct cap.max_inline_data assignment in nes_query_qp
Date: Thu, 25 Mar 2010 08:39:50 -0500
Message-ID: <20100325133950.GA9752@ctung-MOBL>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


cap.max_inline_data is incorrectly set in init_attr instead
of attr.  Set it in attr so subsequent init_attr.cap assignment
will get the correct value.

Signed-off-by: Chien Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c |    9 ++++-----
 1 files changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 6992829..36348bf 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2820,11 +2820,10 @@ static int nes_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *attr,
 	attr->cap.max_send_wr = nesqp->hwqp.sq_size;
 	attr->cap.max_recv_wr = nesqp->hwqp.rq_size;
 	attr->cap.max_recv_sge = 1;
-	if (nes_drv_opt & NES_DRV_OPT_NO_INLINE_DATA) {
-		init_attr->cap.max_inline_data = 0;
-	} else {
-		init_attr->cap.max_inline_data = 64;
-	}
+	if (nes_drv_opt & NES_DRV_OPT_NO_INLINE_DATA)
+		attr->cap.max_inline_data = 0;
+	else
+		attr->cap.max_inline_data = 64;
 
 	init_attr->event_handler = nesqp->ibqp.event_handler;
 	init_attr->qp_context = nesqp->ibqp.qp_context;
-- 
1.6.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
