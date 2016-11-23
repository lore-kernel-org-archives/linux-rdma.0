From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v2 8/8] IB/rxe: Fix ref leak in duplicate_request()
Date: Wed, 23 Nov 2016 12:39:24 -0500
Message-ID: <1479922764-13091-9-git-send-email-andrew.boyer@dell.com>
References: <1479922764-13091-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479922764-13091-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

A ref was added after the call to skb_clone().

Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_resp.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_resp.c b/drivers/infiniband/sw/rxe/rxe_resp.c
index a5e9ce3..8643797 100644
--- a/drivers/infiniband/sw/rxe/rxe_resp.c
+++ b/drivers/infiniband/sw/rxe/rxe_resp.c
@@ -1145,6 +1145,7 @@ static enum resp_states duplicate_request(struct rxe_qp *qp,
 					     pkt, skb_copy);
 			if (rc) {
 				pr_err("Failed resending result. This flow is not handled - skb ignored\n");
+				rxe_drop_ref(qp);
 				kfree_skb(skb_copy);
 				rc = RESPST_CLEANUP;
 				goto out;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
