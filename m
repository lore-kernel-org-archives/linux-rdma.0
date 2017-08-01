From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 16/33] RDMA/netlink: Reduce indirection access to cb_table
Date: Tue,  1 Aug 2017 15:05:19 +0300
Message-ID: <20170801120536.540-17-leon@kernel.org>
References: <20170801120536.540-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801120536.540-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Introduce intermediate variable to store access to fields
of cb_table.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/netlink.c | 13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index f98f9fe86d0a..6c3bb2693afa 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -157,12 +157,15 @@ static int rdma_nl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	unsigned int op = RDMA_NL_GET_OP(type);
 	struct netlink_callback cb = {};
 	struct netlink_dump_control c = {};
+	const struct rdma_nl_cbs *cb_table;
 	int ret;
 
 	if (!is_nl_valid(index, op))
 		return -EINVAL;
 
-	if ((rdma_nl_types[index].cb_table[op].flags & RDMA_NL_ADMIN_PERM) &&
+	cb_table = rdma_nl_types[type].cb_table;
+
+	if ((cb_table[op].flags & RDMA_NL_ADMIN_PERM) &&
 	    !netlink_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
@@ -174,14 +177,14 @@ static int rdma_nl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	    (index == RDMA_NL_LS && op == RDMA_NL_LS_OP_SET_TIMEOUT)) {
 		cb.skb = skb;
 		cb.nlh = nlh;
-		cb.dump = rdma_nl_types[index].cb_table[op].dump;
+		cb.dump = cb_table[op].dump;
 		return cb.dump(skb, &cb);
 	} else {
-		c.dump = rdma_nl_types[index].cb_table[op].dump;
+		c.dump = cb_table[op].dump;
 		return netlink_dump_start(nls, skb, nlh, &c);
 	}
-	if (rdma_nl_types[index].cb_table[op].doit)
-		ret = rdma_nl_types[index].cb_table[op].doit(skb, nlh, extack);
+	if (cb_table[op].doit)
+		ret = cb_table[op].doit(skb, nlh, extack);
 	return ret;
 
 }
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
