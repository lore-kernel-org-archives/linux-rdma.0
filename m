From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v2 1/8] IB/rxe: Remove buffer used for printing IP address
Date: Wed, 23 Nov 2016 12:39:17 -0500
Message-ID: <1479922764-13091-2-git-send-email-andrew.boyer@dell.com>
References: <1479922764-13091-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1479922764-13091-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid smashing the stack when an ICRC error occurs on an IPv6 network.

Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_recv.c | 11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index 46f0628..252b4d6 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -391,16 +391,15 @@ int rxe_rcv(struct sk_buff *skb)
 			     payload_size(pkt));
 	calc_icrc = cpu_to_be32(~calc_icrc);
 	if (unlikely(calc_icrc != pack_icrc)) {
-		char saddr[sizeof(struct in6_addr)];
-
 		if (skb->protocol == htons(ETH_P_IPV6))
-			sprintf(saddr, "%pI6", &ipv6_hdr(skb)->saddr);
+			pr_warn_ratelimited("bad ICRC from %pI6c\n",
+					    &ipv6_hdr(skb)->saddr);
 		else if (skb->protocol == htons(ETH_P_IP))
-			sprintf(saddr, "%pI4", &ip_hdr(skb)->saddr);
+			pr_warn_ratelimited("bad ICRC from %pI4\n",
+					    &ip_hdr(skb)->saddr);
 		else
-			sprintf(saddr, "unknown");
+			pr_warn_ratelimited("bad ICRC from unknown\n");
 
-		pr_warn_ratelimited("bad ICRC from %s\n", saddr);
 		goto drop;
 	}
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
