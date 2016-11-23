From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v2 4/8] IB/rxe: Unblock loopback by moving skb_out increment
Date: Wed, 23 Nov 2016 12:39:20 -0500
Message-ID: <1479922764-13091-5-git-send-email-andrew.boyer@dell.com>
References: <1479922764-13091-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479922764-13091-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

skb_out is decremented in rxe_skb_tx_dtor(), which is not called in the
loopback() path. Move the increment to the send() path rather than
rxe_xmit_packet().

Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Acked-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_loc.h | 2 --
 drivers/infiniband/sw/rxe/rxe_net.c | 2 ++
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_loc.h b/drivers/infiniband/sw/rxe/rxe_loc.h
index 73849a5a..efe4c6a 100644
--- a/drivers/infiniband/sw/rxe/rxe_loc.h
+++ b/drivers/infiniband/sw/rxe/rxe_loc.h
@@ -266,8 +266,6 @@ static inline int rxe_xmit_packet(struct rxe_dev *rxe, struct rxe_qp *qp,
 		return err;
 	}
 
-	atomic_inc(&qp->skb_out);
-
 	if ((qp_type(qp) != IB_QPT_RC) &&
 	    (pkt->mask & RXE_END_MASK)) {
 		pkt->wqe->state = wqe_state_done;
diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index ffff5a5..332ce52 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -455,6 +455,8 @@ static int send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
 		return -EAGAIN;
 	}
 
+	if (pkt->qp)
+		atomic_inc(&pkt->qp->skb_out);
 	kfree_skb(skb);
 
 	return 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
