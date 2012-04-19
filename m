From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] RDS: correct ib api use with sg_dma_address/sg_dma_len
Date: Thu, 19 Apr 2012 12:15:17 -0400
Message-ID: <20120419161517.713.76674.stgit@kop-dev-sles11-04.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: venkat.x.venkatsubra-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, rds-devel-N0ozoZBvEnrZJqsBc5GL+g@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>

0b088e00 ("RDS: Use page_remainder_alloc() for recv bufs")
added uses of sg_dma_len() and sg_dma_address().

IB ulps should use ib_sg_dma_len() and ib_sg_dma_address
respectively since some HCAs overload ib_sg_dma* operations.

Signed-off-by: Mike Marciniszyn <mike.marciniszyn-h88ZbnxC6KDQT0dZR+AlfA@public.gmane.org>
---
 net/rds/ib_recv.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/net/rds/ib_recv.c b/net/rds/ib_recv.c
index 8d19491..cd44ed3 100644
--- a/net/rds/ib_recv.c
+++ b/net/rds/ib_recv.c
@@ -339,8 +339,8 @@ static int rds_ib_recv_refill_one(struct rds_connection *conn,
 	sge->length = sizeof(struct rds_header);
 
 	sge = &recv->r_sge[1];
-	sge->addr = sg_dma_address(&recv->r_frag->f_sg);
-	sge->length = sg_dma_len(&recv->r_frag->f_sg);
+	sge->addr = ib_sg_dma_address(ic->i_cm_id->device, &recv->r_frag->f_sg);
+	sge->length = ib_sg_dma_len(ic->i_cm_id->device, &recv->r_frag->f_sg);
 
 	ret = 0;
 out:
@@ -381,7 +381,10 @@ void rds_ib_recv_refill(struct rds_connection *conn, int prefill)
 		ret = ib_post_recv(ic->i_cm_id->qp, &recv->r_wr, &failed_wr);
 		rdsdebug("recv %p ibinc %p page %p addr %lu ret %d\n", recv,
 			 recv->r_ibinc, sg_page(&recv->r_frag->f_sg),
-			 (long) sg_dma_address(&recv->r_frag->f_sg), ret);
+			 (long) ib_sg_dma_address(
+				ic->i_cm_id->device,
+				&recv->r_frag->f_sg),
+			ret);
 		if (ret) {
 			rds_ib_conn_error(conn, "recv post on "
 			       "%pI4 returned %d, disconnecting and "


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
