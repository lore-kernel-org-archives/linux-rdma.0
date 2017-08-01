From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [rdma-next 17/33] RDMA/netlink: Convert LS to doit callback
Date: Tue,  1 Aug 2017 15:05:20 +0300
Message-ID: <20170801120536.540-18-leon@kernel.org>
References: <20170801120536.540-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170801120536.540-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

RDMA_NL_LS protocol is actually does not dump anything,
but sets data and it should be handled by doit callback.

This patch actually converts RDMA_NL_LS to doit callback, while
preserving IWCM and RDMA_CM flows through netlink_dump_start().

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/addr.c      |  5 ++---
 drivers/infiniband/core/core_priv.h |  9 ++++++---
 drivers/infiniband/core/device.c    |  6 +++---
 drivers/infiniband/core/netlink.c   | 28 ++++++++++------------------
 drivers/infiniband/core/sa_query.c  |  8 ++++----
 5 files changed, 25 insertions(+), 31 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 7310ece99cd9..16b3bdffeb96 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -129,10 +129,9 @@ static void ib_nl_process_good_ip_rsep(const struct nlmsghdr *nlh)
 }
 
 int ib_nl_handle_ip_res_resp(struct sk_buff *skb,
-			     struct netlink_callback *cb)
+			     struct nlmsghdr *nlh,
+			     struct netlink_ext_ack *extack)
 {
-	const struct nlmsghdr *nlh = (struct nlmsghdr *)cb->nlh;
-
 	if ((nlh->nlmsg_flags & NLM_F_REQUEST) ||
 	    !(NETLINK_CB(skb).sk))
 		return -EPERM;
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index cbdcc81e1df8..57beb1cceda3 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -198,11 +198,14 @@ void rdma_nl_exit(void);
 int ibnl_chk_listeners(unsigned int group);
 
 int ib_nl_handle_resolve_resp(struct sk_buff *skb,
-			      struct netlink_callback *cb);
+			      struct nlmsghdr *nlh,
+			      struct netlink_ext_ack *extack);
 int ib_nl_handle_set_timeout(struct sk_buff *skb,
-			     struct netlink_callback *cb);
+			     struct nlmsghdr *nlh,
+			     struct netlink_ext_ack *extack);
 int ib_nl_handle_ip_res_resp(struct sk_buff *skb,
-			     struct netlink_callback *cb);
+			     struct nlmsghdr *nlh,
+			     struct netlink_ext_ack *extack);
 
 int ib_get_cached_subnet_prefix(struct ib_device *device,
 				u8                port_num,
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 41eebd6ca0ff..5a3ff941c86c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1148,15 +1148,15 @@ EXPORT_SYMBOL(ib_get_net_dev_by_params);
 
 static const struct rdma_nl_cbs ibnl_ls_cb_table[] = {
 	[RDMA_NL_LS_OP_RESOLVE] = {
-		.dump = ib_nl_handle_resolve_resp,
+		.doit = ib_nl_handle_resolve_resp,
 		.flags = RDMA_NL_ADMIN_PERM,
 	},
 	[RDMA_NL_LS_OP_SET_TIMEOUT] = {
-		.dump = ib_nl_handle_set_timeout,
+		.doit = ib_nl_handle_set_timeout,
 		.flags = RDMA_NL_ADMIN_PERM,
 	},
 	[RDMA_NL_LS_OP_IP_RESOLVE] = {
-		.dump = ib_nl_handle_ip_res_resp,
+		.doit = ib_nl_handle_ip_res_resp,
 		.flags = RDMA_NL_ADMIN_PERM,
 	},
 };
diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 6c3bb2693afa..3efa161bf4a6 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -155,38 +155,30 @@ static int rdma_nl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int type = nlh->nlmsg_type;
 	unsigned int index = RDMA_NL_GET_CLIENT(type);
 	unsigned int op = RDMA_NL_GET_OP(type);
-	struct netlink_callback cb = {};
-	struct netlink_dump_control c = {};
 	const struct rdma_nl_cbs *cb_table;
-	int ret;
 
 	if (!is_nl_valid(index, op))
 		return -EINVAL;
 
-	cb_table = rdma_nl_types[type].cb_table;
+	cb_table = rdma_nl_types[index].cb_table;
 
 	if ((cb_table[op].flags & RDMA_NL_ADMIN_PERM) &&
 	    !netlink_capable(skb, CAP_NET_ADMIN))
 		return -EPERM;
 
-	/*
-	 * For response or local service set_timeout request,
-	 * there is no need to use netlink_dump_start.
-	 */
-	if (!(nlh->nlmsg_flags & NLM_F_REQUEST) ||
-	    (index == RDMA_NL_LS && op == RDMA_NL_LS_OP_SET_TIMEOUT)) {
-		cb.skb = skb;
-		cb.nlh = nlh;
-		cb.dump = cb_table[op].dump;
-		return cb.dump(skb, &cb);
-	} else {
-		c.dump = cb_table[op].dump;
+	/* FIXME: Convert IWCM to properly handle doit callbacks */
+	if ((nlh->nlmsg_flags & NLM_F_DUMP) || index == RDMA_NL_RDMA_CM ||
+	    index == RDMA_NL_IWCM) {
+		struct netlink_dump_control c = {
+			.dump = cb_table[op].dump,
+		};
 		return netlink_dump_start(nls, skb, nlh, &c);
 	}
+
 	if (cb_table[op].doit)
-		ret = cb_table[op].doit(skb, nlh, extack);
-	return ret;
+		return cb_table[op].doit(skb, nlh, extack);
 
+	return 0;
 }
 
 /*
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 2cc85c2b74b7..da29e2863c84 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1021,9 +1021,9 @@ static void ib_nl_request_timeout(struct work_struct *work)
 }
 
 int ib_nl_handle_set_timeout(struct sk_buff *skb,
-			     struct netlink_callback *cb)
+			     struct nlmsghdr *nlh,
+			     struct netlink_ext_ack *extack)
 {
-	const struct nlmsghdr *nlh = (struct nlmsghdr *)cb->nlh;
 	int timeout, delta, abs_delta;
 	const struct nlattr *attr;
 	unsigned long flags;
@@ -1097,9 +1097,9 @@ static inline int ib_nl_is_good_resolve_resp(const struct nlmsghdr *nlh)
 }
 
 int ib_nl_handle_resolve_resp(struct sk_buff *skb,
-			      struct netlink_callback *cb)
+			      struct nlmsghdr *nlh,
+			      struct netlink_ext_ack *extack)
 {
-	const struct nlmsghdr *nlh = (struct nlmsghdr *)cb->nlh;
 	unsigned long flags;
 	struct ib_sa_query *query;
 	struct ib_mad_send_buf *send_buf;
-- 
2.13.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
