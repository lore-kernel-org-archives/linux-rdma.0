From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [rdma-next,V1 4/4] IB/core: Add IP to GID netlink offload
Date: Wed, 18 May 2016 17:57:26 +0300
Message-ID: <1463583446-30027-5-git-send-email-markb@mellanox.com>
References: <1463583446-30027-1-git-send-email-markb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463583446-30027-1-git-send-email-markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

There is an assumption that rdmacm is used only between nodes
in the same IB subnet, this why ARP resolution can be used to turn
IP to GID in rdmacm.

When dealing with IB communication between subnets this assumption
is no longer valid. ARP resolution will get us the next hop device
address and not the peer node's device address.

To solve this issue, we will check user space if it can provide the
GID of the peer node, and fail if not.

We add a sequence number to identify each request and fill in the GID
upon answer from userspace.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/addr.c | 225 ++++++++++++++++++++++++++++++++++++-----
 1 file changed, 201 insertions(+), 24 deletions(-)

diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 3a203ee..547c870 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -46,6 +46,8 @@
 #include <net/ip6_route.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib.h>
+#include <rdma/rdma_netlink.h>
+#include <net/netlink.h>
 
 struct addr_req {
 	struct list_head list;
@@ -58,8 +60,11 @@ struct addr_req {
 			 struct rdma_dev_addr *addr, void *context);
 	unsigned long timeout;
 	int status;
+	u32 seq;
 };
 
+static atomic_t ib_nl_addr_request_seq;
+
 static void process_req(struct work_struct *work);
 
 static DEFINE_MUTEX(lock);
@@ -67,6 +72,130 @@ static LIST_HEAD(req_list);
 static DECLARE_DELAYED_WORK(work, process_req);
 static struct workqueue_struct *addr_wq;
 
+static const struct nla_policy ib_nl_addr_policy[LS_NLA_TYPE_MAX] = {
+	[LS_NLA_TYPE_DGID]		= {.type = NLA_BINARY,
+		.len = sizeof(struct rdma_nla_ls_gid)},
+};
+
+static inline int ib_nl_is_good_ip_resp(const struct nlmsghdr *nlh)
+{
+	struct nlattr *tb[LS_NLA_TYPE_MAX] = {};
+	int ret;
+
+	if (nlh->nlmsg_flags & RDMA_NL_LS_F_ERR)
+		return 0;
+
+	ret = nla_parse(tb, LS_NLA_TYPE_MAX - 1, nlmsg_data(nlh),
+			nlmsg_len(nlh), ib_nl_addr_policy);
+	if (ret)
+		return 0;
+
+	return 1;
+}
+
+static void ib_nl_process_good_ip_rsep(const struct nlmsghdr *nlh)
+{
+	const struct nlattr *head, *curr;
+	union ib_gid gid;
+	struct addr_req *req;
+	int len, rem;
+	int found = 0;
+
+	head = (const struct nlattr *)nlmsg_data(nlh);
+	len = nlmsg_len(nlh);
+
+	nla_for_each_attr(curr, head, len, rem) {
+		if (curr->nla_type == LS_NLA_TYPE_DGID)
+			memcpy(&gid, nla_data(curr), nla_len(curr));
+	}
+
+	mutex_lock(&lock);
+	list_for_each_entry(req, &req_list, list) {
+		if (nlh->nlmsg_seq != req->seq)
+			continue;
+		/* We set the DGID part, the rest was set earlier */
+		rdma_addr_set_dgid(req->addr, &gid);
+		req->status = 0;
+		found = 1;
+		break;
+	}
+	mutex_unlock(&lock);
+
+	if (!found)
+		pr_info("Couldn't find request waiting for DGID: %pI6\n",
+			&gid);
+}
+
+static int ib_nl_handle_ip_res_resp(struct sk_buff *skb,
+				    struct netlink_callback *cb)
+{
+	const struct nlmsghdr *nlh = (struct nlmsghdr *)cb->nlh;
+
+	if ((nlh->nlmsg_flags & NLM_F_REQUEST) ||
+	    !(NETLINK_CB(skb).sk) ||
+	    !netlink_capable(skb, CAP_NET_ADMIN))
+		return -EPERM;
+
+	if (ib_nl_is_good_ip_resp(nlh))
+		ib_nl_process_good_ip_rsep(nlh);
+
+	return skb->len;
+}
+
+static struct ibnl_client_cbs ib_addr_cb_table[RDMA_NL_LS_NUM_OPS] = {
+	[RDMA_NL_LS_OP_IP_RESOLVE] = {
+		.dump = ib_nl_handle_ip_res_resp,
+		.module = THIS_MODULE },
+};
+
+static int ib_nl_ip_send_msg(struct rdma_dev_addr *dev_addr,
+			     const void *daddr,
+			     u32 seq, u16 family)
+{
+	struct sk_buff *skb = NULL;
+	struct nlmsghdr *nlh;
+	struct rdma_ls_ip_resolve_header *header;
+	void *data;
+	size_t size;
+	int attrtype;
+	int len;
+
+	if (family == AF_INET) {
+		size = sizeof(struct in_addr);
+		attrtype = RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_IPV4;
+	} else {
+		size = sizeof(struct in6_addr);
+		attrtype = RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_IPV6;
+	}
+
+	len = nla_total_size(sizeof(size));
+	len += NLMSG_ALIGN(sizeof(*header));
+
+	skb = nlmsg_new(len, GFP_KERNEL);
+
+	data = ibnl_put_msg(skb, &nlh, seq, 0, RDMA_NL_LS,
+			    RDMA_NL_LS_OP_IP_RESOLVE, NLM_F_REQUEST);
+	if (!data) {
+		nlmsg_free(skb);
+		return -ENODATA;
+	}
+
+	/* Construct the family header first */
+	header = (struct rdma_ls_ip_resolve_header *)
+		skb_put(skb, NLMSG_ALIGN(sizeof(*header)));
+	header->ifindex = dev_addr->bound_dev_if;
+	nla_put(skb, attrtype, size, daddr);
+
+	/* Repair the nlmsg header length */
+	nlmsg_end(skb, nlh);
+	ibnl_multicast(skb, nlh, RDMA_NL_GROUP_LS, GFP_KERNEL);
+
+	/* Make the request retry, so when we get the response from userspace
+	 * we will have something.
+	 */
+	return -ENODATA;
+}
+
 int rdma_addr_size(struct sockaddr *addr)
 {
 	switch (addr->sa_family) {
@@ -195,6 +324,17 @@ static void queue_req(struct addr_req *req)
 	mutex_unlock(&lock);
 }
 
+static int ib_nl_fetch_ha(struct dst_entry *dst, struct rdma_dev_addr *dev_addr,
+			  const void *daddr, u32 seq, u16 family)
+{
+	if (ibnl_chk_listeners(RDMA_NL_GROUP_LS))
+		return -EADDRNOTAVAIL;
+
+	/* We fill in what we can, the response will fill the rest */
+	rdma_copy_addr(dev_addr, dst->dev, NULL);
+	return ib_nl_ip_send_msg(dev_addr, daddr, seq, family);
+}
+
 static int dst_fetch_ha(struct dst_entry *dst, struct rdma_dev_addr *dev_addr,
 			const void *daddr)
 {
@@ -219,6 +359,39 @@ static int dst_fetch_ha(struct dst_entry *dst, struct rdma_dev_addr *dev_addr,
 	return ret;
 }
 
+static bool has_gateway(struct dst_entry *dst, sa_family_t family)
+{
+	struct rtable *rt;
+	struct rt6_info *rt6;
+
+	if (family == AF_INET) {
+		rt = container_of(dst, struct rtable, dst);
+		return rt->rt_uses_gateway;
+	}
+
+	rt6 = container_of(dst, struct rt6_info, dst);
+	return rt6->rt6i_flags & RTF_GATEWAY;
+}
+
+static int fetch_ha(struct dst_entry *dst, struct rdma_dev_addr *dev_addr,
+		    const struct sockaddr *dst_in, u32 seq)
+{
+	const struct sockaddr_in *dst_in4 =
+		(const struct sockaddr_in *)dst_in;
+	const struct sockaddr_in6 *dst_in6 =
+		(const struct sockaddr_in6 *)dst_in;
+	const void *daddr = (dst_in->sa_family == AF_INET) ?
+		(const void *)&dst_in4->sin_addr.s_addr :
+		(const void *)&dst_in6->sin6_addr;
+	sa_family_t family = dst_in->sa_family;
+
+	/* Gateway + ARPHRD_INFINIBAND -> IB router */
+	if (has_gateway(dst, family) && dst->dev->type == ARPHRD_INFINIBAND)
+		return ib_nl_fetch_ha(dst, dev_addr, daddr, seq, family);
+	else
+		return dst_fetch_ha(dst, dev_addr, daddr);
+}
+
 static int addr4_resolve(struct sockaddr_in *src_in,
 			 const struct sockaddr_in *dst_in,
 			 struct rdma_dev_addr *addr,
@@ -242,10 +415,11 @@ static int addr4_resolve(struct sockaddr_in *src_in,
 	src_in->sin_family = AF_INET;
 	src_in->sin_addr.s_addr = fl4.saddr;
 
-	/* If there's a gateway, we're definitely in RoCE v2 (as RoCE v1 isn't
-	 * routable) and we could set the network type accordingly.
+	/* If there's a gateway and type of device not ARPHRD_INFINIBAND, we're
+	 * definitely in RoCE v2 (as RoCE v1 isn't routable) set the network
+	 * type accordingly.
 	 */
-	if (rt->rt_uses_gateway)
+	if (rt->rt_uses_gateway && rt->dst.dev->type != ARPHRD_INFINIBAND)
 		addr->network = RDMA_NETWORK_IPV4;
 
 	addr->hoplimit = ip4_dst_hoplimit(&rt->dst);
@@ -287,10 +461,12 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 		src_in->sin6_addr = fl6.saddr;
 	}
 
-	/* If there's a gateway, we're definitely in RoCE v2 (as RoCE v1 isn't
-	 * routable) and we could set the network type accordingly.
+	/* If there's a gateway and type of device not ARPHRD_INFINIBAND, we're
+	 * definitely in RoCE v2 (as RoCE v1 isn't routable) set the network
+	 * type accordingly.
 	 */
-	if (rt->rt6i_flags & RTF_GATEWAY)
+	if (rt->rt6i_flags & RTF_GATEWAY &&
+	    ip6_dst_idev(dst)->dev->type != ARPHRD_INFINIBAND)
 		addr->network = RDMA_NETWORK_IPV6;
 
 	addr->hoplimit = ip6_dst_hoplimit(dst);
@@ -313,7 +489,8 @@ static int addr6_resolve(struct sockaddr_in6 *src_in,
 
 static int addr_resolve_neigh(struct dst_entry *dst,
 			      const struct sockaddr *dst_in,
-			      struct rdma_dev_addr *addr)
+			      struct rdma_dev_addr *addr,
+			      u32 seq)
 {
 	if (dst->dev->flags & IFF_LOOPBACK) {
 		int ret;
@@ -327,17 +504,8 @@ static int addr_resolve_neigh(struct dst_entry *dst,
 	}
 
 	/* If the device doesn't do ARP internally */
-	if (!(dst->dev->flags & IFF_NOARP)) {
-		const struct sockaddr_in *dst_in4 =
-			(const struct sockaddr_in *)dst_in;
-		const struct sockaddr_in6 *dst_in6 =
-			(const struct sockaddr_in6 *)dst_in;
-
-		return dst_fetch_ha(dst, addr,
-				    dst_in->sa_family == AF_INET ?
-				    (const void *)&dst_in4->sin_addr.s_addr :
-				    (const void *)&dst_in6->sin6_addr);
-	}
+	if (!(dst->dev->flags & IFF_NOARP))
+		return fetch_ha(dst, addr, dst_in, seq);
 
 	return rdma_copy_addr(addr, dst->dev, NULL);
 }
@@ -345,7 +513,8 @@ static int addr_resolve_neigh(struct dst_entry *dst,
 static int addr_resolve(struct sockaddr *src_in,
 			const struct sockaddr *dst_in,
 			struct rdma_dev_addr *addr,
-			bool resolve_neigh)
+			bool resolve_neigh,
+			u32 seq)
 {
 	struct net_device *ndev;
 	struct dst_entry *dst;
@@ -362,7 +531,7 @@ static int addr_resolve(struct sockaddr *src_in,
 			return ret;
 
 		if (resolve_neigh)
-			ret = addr_resolve_neigh(&rt->dst, dst_in, addr);
+			ret = addr_resolve_neigh(&rt->dst, dst_in, addr, seq);
 
 		ndev = rt->dst.dev;
 		dev_hold(ndev);
@@ -379,7 +548,7 @@ static int addr_resolve(struct sockaddr *src_in,
 			return ret;
 
 		if (resolve_neigh)
-			ret = addr_resolve_neigh(dst, dst_in, addr);
+			ret = addr_resolve_neigh(dst, dst_in, addr, seq);
 
 		ndev = dst->dev;
 		dev_hold(ndev);
@@ -408,7 +577,7 @@ static void process_req(struct work_struct *work)
 			src_in = (struct sockaddr *) &req->src_addr;
 			dst_in = (struct sockaddr *) &req->dst_addr;
 			req->status = addr_resolve(src_in, dst_in, req->addr,
-						   true);
+						   true, req->seq);
 			if (req->status && time_after_eq(jiffies, req->timeout))
 				req->status = -ETIMEDOUT;
 			else if (req->status == -ENODATA)
@@ -467,8 +636,9 @@ int rdma_resolve_ip(struct rdma_addr_client *client,
 	req->context = context;
 	req->client = client;
 	atomic_inc(&client->refcount);
+	req->seq = (u32)atomic_inc_return(&ib_nl_addr_request_seq);
 
-	req->status = addr_resolve(src_in, dst_in, addr, true);
+	req->status = addr_resolve(src_in, dst_in, addr, true, req->seq);
 	switch (req->status) {
 	case 0:
 		req->timeout = jiffies;
@@ -506,7 +676,7 @@ int rdma_resolve_ip_route(struct sockaddr *src_addr,
 		src_in->sa_family = dst_addr->sa_family;
 	}
 
-	return addr_resolve(src_in, dst_addr, addr, false);
+	return addr_resolve(src_in, dst_addr, addr, false, 0);
 }
 EXPORT_SYMBOL(rdma_resolve_ip_route);
 
@@ -636,13 +806,20 @@ int addr_init(void)
 	if (!addr_wq)
 		return -ENOMEM;
 
+	atomic_set(&ib_nl_addr_request_seq, 0);
 	register_netevent_notifier(&nb);
 	rdma_addr_register_client(&self);
+	if (ibnl_add_client(RDMA_NL_LS, RDMA_NL_LS_NUM_OPS,
+			    ib_addr_cb_table)) {
+		pr_warn("RDMA ADDR: failed to add netlink callback\n");
+	}
+
 	return 0;
 }
 
 void addr_cleanup(void)
 {
+	ibnl_remove_client(RDMA_NL_LS, RDMA_NL_LS_NUM_OPS, ib_addr_cb_table);
 	rdma_addr_unregister_client(&self);
 	unregister_netevent_notifier(&nb);
 	destroy_workqueue(addr_wq);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
