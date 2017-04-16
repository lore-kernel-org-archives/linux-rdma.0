From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next] IB/cma: Send MRA for reply messages
Date: Sun, 16 Apr 2017 07:31:34 +0300
Message-ID: <20170416043134.18860-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Current implementation of RDMA_CM sends MRA (Message Receipt
Acknowledgment) only for request messages but not for response messages.

As a result, a slow active side of the connection may send a ready-to-use
message to the passive side in a delay that is too long for the passive
side to wait for.

This patch adds a call to ib_send_cm_mra() upon receiving a response
message and by this tells the other side to modify the service timeout
to a bigger value, 16 times than before. As in the request case, MRA
for reply will be sent only if a duplicate response has arrived.

Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Matan Barak <matan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index acd10d666f1c..c1a90f0194f4 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1755,6 +1755,9 @@ static int cma_ib_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 		event.status = -ETIMEDOUT;
 		break;
 	case IB_CM_REP_RECEIVED:
+		if (cma_comp(id_priv, RDMA_CM_CONNECT) &&
+		    (id_priv->id.qp_type != IB_QPT_UD))
+			ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
 		if (id_priv->id.qp) {
 			event.status = cma_rep_recv(id_priv);
 			event.event = event.status ? RDMA_CM_EVENT_CONNECT_ERROR :
--
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
