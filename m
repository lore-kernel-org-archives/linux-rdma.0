From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH 1/3] IB/rxe: Use BTH_PSN_MASK when ACKing duplicate sends
Date: Thu, 22 Dec 2016 08:54:36 -0500
Message-ID: <1482414878-6892-2-git-send-email-andrew.boyer@dell.com>
References: <1482414878-6892-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482414878-6892-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index 7a36ec9..3435eff 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -1070,12 +1070,13 @@ static enum resp_states duplicate_request(struct rxe_qp *qp,
 					  struct rxe_pkt_info *pkt)
 {
 	enum resp_states rc;
+	u32 prev_psn = (qp->resp.psn - 1) & BTH_PSN_MASK;
 
 	if (pkt->mask & RXE_SEND_MASK ||
 	    pkt->mask & RXE_WRITE_MASK) {
 		/* SEND. Ack again and cleanup. C9-105. */
 		if (bth_ack(pkt))
-			send_ack(qp, pkt, AETH_ACK_UNLIMITED, qp->resp.psn - 1);
+			send_ack(qp, pkt, AETH_ACK_UNLIMITED, prev_psn);
 		rc = RESPST_CLEANUP;
 		goto out;
 	} else if (pkt->mask & RXE_READ_MASK) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
