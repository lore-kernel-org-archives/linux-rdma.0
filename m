From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v2 08/33] RDMA/netlink: Simplify the put_msg and put_attr
Date: Thu, 10 Aug 2017 14:08:02 +0300
Message-ID: <20170810110827.9952-9-leon@kernel.org>
References: <20170810110827.9952-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170810110827.9952-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Reuse standard macros to cancel the netlink message
in case of error.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/netlink.c | 27 ++++++---------------------
 1 file changed, 6 insertions(+), 21 deletions(-)

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index c5ee62a24960..e2395a1d9f45 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -126,36 +126,21 @@ EXPORT_SYMBOL(rdma_nl_unregister);
 void *ibnl_put_msg(struct sk_buff *skb, struct nlmsghdr **nlh, int seq,
 		   int len, int client, int op, int flags)
 {
-	unsigned char *prev_tail;
-
-	prev_tail = skb_tail_pointer(skb);
-	*nlh = nlmsg_put(skb, 0, seq, RDMA_NL_GET_TYPE(client, op),
-			 len, flags);
+	*nlh = nlmsg_put(skb, 0, seq, RDMA_NL_GET_TYPE(client, op), len, flags);
 	if (!*nlh)
-		goto out_nlmsg_trim;
-	(*nlh)->nlmsg_len = skb_tail_pointer(skb) - prev_tail;
+		return NULL;
 	return nlmsg_data(*nlh);
-
-out_nlmsg_trim:
-	nlmsg_trim(skb, prev_tail);
-	return NULL;
 }
 EXPORT_SYMBOL(ibnl_put_msg);
 
 int ibnl_put_attr(struct sk_buff *skb, struct nlmsghdr *nlh,
 		  int len, void *data, int type)
 {
-	unsigned char *prev_tail;
-
-	prev_tail = skb_tail_pointer(skb);
-	if (nla_put(skb, type, len, data))
-		goto nla_put_failure;
-	nlh->nlmsg_len += skb_tail_pointer(skb) - prev_tail;
+	if (nla_put(skb, type, len, data)) {
+		nlmsg_cancel(skb, nlh);
+		return -EMSGSIZE;
+	}
 	return 0;
-
-nla_put_failure:
-	nlmsg_trim(skb, prev_tail - nlh->nlmsg_len);
-	return -EMSGSIZE;
 }
 EXPORT_SYMBOL(ibnl_put_attr);
 
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
