From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next v1 04/33] RDMA/netlink: Avoid double pass for RDMA netlink messages
Date: Wed,  9 Aug 2017 19:03:36 +0300
Message-ID: <20170809160405.25142-5-leon@kernel.org>
References: <20170809160405.25142-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170809160405.25142-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The standard netlink_rcv_skb function skips messages without
NLM_F_REQUEST flag in it, while SA netlink client issues them.

In commit bc10ed7d3d19 ("IB/core: Add rdma netlink helper functions")
the local function was introduced to allow such messages.

This led to double pass for every incoming message.

In this patch, we unify that local implementation and netlink_rcv_skb
functions, so there will be no need for double pass anymore.

As a outcome, this combined function gained more strict check
for NLM_F_REQUEST flag and it is now allowed for SA pathquery
client only.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/netlink.c | 62 +++++++++++++++++++++++++++------------
 1 file changed, 44 insertions(+), 18 deletions(-)

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index cd9b7e7b7d2c..826fbd612c7d 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -159,8 +159,8 @@ int ibnl_put_attr(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 EXPORT_SYMBOL(ibnl_put_attr);
 
-static int ibnl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
-			struct netlink_ext_ack *extack)
+static int rdma_nl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
+			   struct netlink_ext_ack *extack)
 {
 	int type = nlh->nlmsg_type;
 	unsigned int index = RDMA_NL_GET_CLIENT(type);
@@ -187,40 +187,66 @@ static int ibnl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	return netlink_dump_start(nls, skb, nlh, &c);
 }
 
-static void ibnl_rcv_reply_skb(struct sk_buff *skb)
+/*
+ * This function is similar to netlink_rcv_skb with one exception:
+ * It calls to the callback for the netlink messages without NLM_F_REQUEST
+ * flag. These messages are intended for RDMA_NL_LS consumer, so it is allowed
+ * for that consumer only.
+ */
+static int rdma_nl_rcv_skb(struct sk_buff *skb, int (*cb)(struct sk_buff *,
+						   struct nlmsghdr *,
+						   struct netlink_ext_ack *))
 {
+	struct netlink_ext_ack extack = {};
 	struct nlmsghdr *nlh;
-	int msglen;
+	int err;
 
-	/*
-	 * Process responses until there is no more message or the first
-	 * request. Generally speaking, it is not recommended to mix responses
-	 * with requests.
-	 */
 	while (skb->len >= nlmsg_total_size(0)) {
+		int msglen;
+
 		nlh = nlmsg_hdr(skb);
+		err = 0;
 
 		if (nlh->nlmsg_len < NLMSG_HDRLEN || skb->len < nlh->nlmsg_len)
-			return;
+			return 0;
 
-		/* Handle response only */
-		if (nlh->nlmsg_flags & NLM_F_REQUEST)
-			return;
+		/*
+		 * Generally speaking, the only requests are handled
+		 * by the kernel, but RDMA_NL_LS is different, because it
+		 * runs backward netlink scheme. Kernel initiates messages
+		 * and waits for reply with data to keep pathrecord cache
+		 * in sync.
+		 */
+		if (!(nlh->nlmsg_flags & NLM_F_REQUEST) &&
+		    (RDMA_NL_GET_CLIENT(nlh->nlmsg_type) != RDMA_NL_LS))
+			goto ack;
+
+		/* Skip control messages */
+		if (nlh->nlmsg_type < NLMSG_MIN_TYPE)
+			goto ack;
 
-		ibnl_rcv_msg(skb, nlh, NULL);
+		err = cb(skb, nlh, &extack);
+		if (err == -EINTR)
+			goto skip;
 
+ack:
+		if (nlh->nlmsg_flags & NLM_F_ACK || err)
+			netlink_ack(skb, nlh, err, &extack);
+
+skip:
 		msglen = NLMSG_ALIGN(nlh->nlmsg_len);
 		if (msglen > skb->len)
 			msglen = skb->len;
 		skb_pull(skb, msglen);
 	}
+
+	return 0;
 }
 
-static void ibnl_rcv(struct sk_buff *skb)
+static void rdma_nl_rcv(struct sk_buff *skb)
 {
 	mutex_lock(&rdma_nl_mutex);
-	ibnl_rcv_reply_skb(skb);
-	netlink_rcv_skb(skb, &ibnl_rcv_msg);
+	rdma_nl_rcv_skb(skb, &rdma_nl_rcv_msg);
 	mutex_unlock(&rdma_nl_mutex);
 }
 
@@ -254,7 +280,7 @@ EXPORT_SYMBOL(ibnl_multicast);
 int __init rdma_nl_init(void)
 {
 	struct netlink_kernel_cfg cfg = {
-		.input	= ibnl_rcv,
+		.input	= rdma_nl_rcv,
 	};
 
 	nls = netlink_kernel_create(&init_net, NETLINK_RDMA, &cfg);
-- 
2.14.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
