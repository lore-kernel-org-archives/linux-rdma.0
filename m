From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH 3/3] IB/rxe: Don't check for null ptr in send()
Date: Thu, 22 Dec 2016 08:54:38 -0500
Message-ID: <1482414878-6892-4-git-send-email-andrew.boyer@dell.com>
References: <1482414878-6892-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1482414878-6892-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

pkt->qp was already dereferenced earlier in the function.

Fixes Smatch complaint:
drivers/infiniband/sw/rxe/rxe_net.c:458 send()
	 warn: variable dereferenced before check 'pkt->qp' (see line 441)

Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 16967cd..342e781 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -455,8 +455,7 @@ static int send(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
 		return -EAGAIN;
 	}
 
-	if (pkt->qp)
-		atomic_inc(&pkt->qp->skb_out);
+	atomic_inc(&pkt->qp->skb_out);
 	kfree_skb(skb);
 
 	return 0;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
