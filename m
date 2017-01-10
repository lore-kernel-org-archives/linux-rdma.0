From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 04/15] IB/rxe: Remove an unused variable and an unused argument
Date: Tue, 10 Jan 2017 11:15:43 -0800
Message-ID: <20170110191554.17359-5-bart.vanassche@sandisk.com>
References: <20170110191554.17359-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170110191554.17359-1-bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The variable 'av' is not used so remove it. Since that change
removes the last user of the 'wqe' argument, remove that argument
too.

Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Cc: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_req.c | 11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_req.c b/drivers/infiniband/sw/rxe/rxe_req.c
index 73d4a97603a1..310cd3350578 100644
--- a/drivers/infiniband/sw/rxe/rxe_req.c
+++ b/drivers/infiniband/sw/rxe/rxe_req.c
@@ -361,19 +361,14 @@ static inline int check_init_depth(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
 	return -EAGAIN;
 }
 
-static inline int get_mtu(struct rxe_qp *qp, struct rxe_send_wqe *wqe)
+static inline int get_mtu(struct rxe_qp *qp)
 {
 	struct rxe_dev *rxe = to_rdev(qp->ibqp.device);
-	struct rxe_port *port;
-	struct rxe_av *av;
 
 	if ((qp_type(qp) == IB_QPT_RC) || (qp_type(qp) == IB_QPT_UC))
 		return qp->mtu;
 
-	av = &wqe->av;
-	port = &rxe->port;
-
-	return port->mtu_cap;
+	return rxe->port.mtu_cap;
 }
 
 static struct sk_buff *init_req_packet(struct rxe_qp *qp,
@@ -679,7 +674,7 @@ int rxe_requester(void *arg)
 			goto exit;
 	}
 
-	mtu = get_mtu(qp, wqe);
+	mtu = get_mtu(qp);
 	payload = (mask & RXE_WRITE_OR_SEND) ? wqe->dma.resid : 0;
 	if (payload > mtu) {
 		if (qp_type(qp) == IB_QPT_UD) {
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
