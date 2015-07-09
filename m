From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v8 2/4] IB/core: Add rdma netlink helper functions
Date: Thu,  9 Jul 2015 13:34:26 -0400
Message-ID: <1436463268-32365-3-git-send-email-kaike.wan@intel.com>
References: <1436463268-32365-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1436463268-32365-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch adds a function to check if listeners for a netlink multicast
group are present. It also adds a function to receive netlink response
messages.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/netlink.c |   55 +++++++++++++++++++++++++++++++++++++
 include/rdma/rdma_netlink.h       |    7 +++++
 2 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 23dd5a5..d47df93 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -49,6 +49,14 @@ static DEFINE_MUTEX(ibnl_mutex);
 static struct sock *nls;
 static LIST_HEAD(client_list);
 
+int ibnl_chk_listeners(unsigned int group)
+{
+	if (netlink_has_listeners(nls, group) == 0)
+		return -1;
+	return 0;
+}
+EXPORT_SYMBOL(ibnl_chk_listeners);
+
 int ibnl_add_client(int index, int nops,
 		    const struct ibnl_client_cbs cb_table[])
 {
@@ -151,6 +159,23 @@ static int ibnl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 			    !client->cb_table[op].dump)
 				return -EINVAL;
 
+			/*
+			 * For response or local service set_timeout request,
+			 * there is no need to use netlink_dump_start.
+			 */
+			if (!(nlh->nlmsg_flags & NLM_F_REQUEST) ||
+			    (index == RDMA_NL_LS &&
+			     op == RDMA_NL_LS_OP_SET_TIMEOUT)) {
+				struct netlink_callback cb = {
+					.skb = skb,
+					.nlh = nlh,
+					.dump = client->cb_table[op].dump,
+					.module = client->cb_table[op].module,
+				};
+
+				return cb.dump(skb, &cb);
+			}
+
 			{
 				struct netlink_dump_control c = {
 					.dump = client->cb_table[op].dump,
@@ -165,9 +190,39 @@ static int ibnl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 	return -EINVAL;
 }
 
+static void ibnl_rcv_reply_skb(struct sk_buff *skb)
+{
+	struct nlmsghdr *nlh;
+	int msglen;
+
+	/*
+	 * Process responses until there is no more message or the first
+	 * request. Generally speaking, it is not recommended to mix responses
+	 * with requests.
+	 */
+	while (skb->len >= nlmsg_total_size(0)) {
+		nlh = nlmsg_hdr(skb);
+
+		if (nlh->nlmsg_len < NLMSG_HDRLEN || skb->len < nlh->nlmsg_len)
+			return;
+
+		/* Handle response only */
+		if (nlh->nlmsg_flags & NLM_F_REQUEST)
+			return;
+
+		ibnl_rcv_msg(skb, nlh);
+
+		msglen = NLMSG_ALIGN(nlh->nlmsg_len);
+		if (msglen > skb->len)
+			msglen = skb->len;
+		skb_pull(skb, msglen);
+	}
+}
+
 static void ibnl_rcv(struct sk_buff *skb)
 {
 	mutex_lock(&ibnl_mutex);
+	ibnl_rcv_reply_skb(skb);
 	netlink_rcv_skb(skb, &ibnl_rcv_msg);
 	mutex_unlock(&ibnl_mutex);
 }
diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index 0790882..5852661 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -77,4 +77,11 @@ int ibnl_unicast(struct sk_buff *skb, struct nlmsghdr *nlh,
 int ibnl_multicast(struct sk_buff *skb, struct nlmsghdr *nlh,
 			unsigned int group, gfp_t flags);
 
+/**
+ * Check if there are any listeners to the netlink group
+ * @group: the netlink group ID
+ * Returns 0 on success or a negative for no listeners.
+ */
+int ibnl_chk_listeners(unsigned int group);
+
 #endif /* _RDMA_NETLINK_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
