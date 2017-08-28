From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v2 08/11] IB/rxe: Remove unneeded initialization in prepare6()
Date: Mon, 28 Aug 2017 16:11:56 -0400
Message-ID: <1503951119-25573-9-git-send-email-andrew.boyer@dell.com>
References: <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
 <1503951119-25573-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503951119-25573-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Fixes: 4ed6ad1eb30e ("IB/rxe: Cache dst in QP instead of getting it...")
Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Reviewed-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index 3fbbadc..3ba76e7 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -393,7 +393,7 @@ static int prepare6(struct rxe_dev *rxe, struct rxe_pkt_info *pkt,
 		    struct sk_buff *skb, struct rxe_av *av)
 {
 	struct rxe_qp *qp = pkt->qp;
-	struct dst_entry *dst = NULL;
+	struct dst_entry *dst;
 	struct in6_addr *saddr = &av->sgid_addr._sockaddr_in6.sin6_addr;
 	struct in6_addr *daddr = &av->dgid_addr._sockaddr_in6.sin6_addr;
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
