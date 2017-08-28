From: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
Subject: [PATCH v2 06/11] IB/rxe: Add dst_clone() in prepare_ipv6_hdr()
Date: Mon, 28 Aug 2017 16:11:54 -0400
Message-ID: <1503951119-25573-7-git-send-email-andrew.boyer@dell.com>
References: <1503687956-7110-1-git-send-email-andrew.boyer@dell.com>
 <1503951119-25573-1-git-send-email-andrew.boyer@dell.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1503951119-25573-1-git-send-email-andrew.boyer-8PEkshWhKlo@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Otherwise the reference count goes negative as IPv6 packets complete.

Fixes: 4ed6ad1eb30e ("IB/rxe: Cache dst in QP instead of getting it...")
Signed-off-by: Andrew Boyer <andrew.boyer-8PEkshWhKlo@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_net.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_net.c b/drivers/infiniband/sw/rxe/rxe_net.c
index a93ae3a..3fbbadc 100644
--- a/drivers/infiniband/sw/rxe/rxe_net.c
+++ b/drivers/infiniband/sw/rxe/rxe_net.c
@@ -342,7 +342,7 @@ static void prepare_ipv6_hdr(struct dst_entry *dst, struct sk_buff *skb,
 	memset(&(IPCB(skb)->opt), 0, sizeof(IPCB(skb)->opt));
 	IPCB(skb)->flags &= ~(IPSKB_XFRM_TUNNEL_SIZE | IPSKB_XFRM_TRANSFORMED
 			    | IPSKB_REROUTED);
-	skb_dst_set(skb, dst);
+	skb_dst_set(skb, dst_clone(dst));
 
 	__skb_push(skb, sizeof(*ip6h));
 	skb_reset_network_header(skb);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
