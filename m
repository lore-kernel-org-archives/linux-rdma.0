From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v9 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Fri, 14 Aug 2015 08:52:09 -0400
Message-ID: <1439556729-27876-5-git-send-email-kaike.wan@intel.com>
References: <1439556729-27876-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439556729-27876-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch routes a SA pathrecord query to netlink first and processes the
response appropriately. If a failure is returned, the request will be sent
through IB. The decision whether to route the request to netlink first is
determined by the presence of a listener for the local service netlink
multicast group. If the user-space local service netlink multicast group
listener is not present, the request will be sent through IB, just like
what is currently being done.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c |  501 +++++++++++++++++++++++++++++++++++-
 1 files changed, 500 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 968c66f..edcf568 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -45,12 +45,21 @@
 #include <uapi/linux/if_ether.h>
 #include <rdma/ib_pack.h>
 #include <rdma/ib_cache.h>
+#include <rdma/rdma_netlink.h>
+#include <net/netlink.h>
+#include <uapi/rdma/ib_user_sa.h>
+#include <rdma/ib_marshall.h>
 #include "sa.h"
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand subnet administration query support");
 MODULE_LICENSE("Dual BSD/GPL");
 
+#define IB_SA_LOCAL_SVC_TIMEOUT_MIN		100
+#define IB_SA_LOCAL_SVC_TIMEOUT_DEFAULT		2000
+#define IB_SA_LOCAL_SVC_TIMEOUT_MAX		200000
+static int sa_local_svc_timeout_ms = IB_SA_LOCAL_SVC_TIMEOUT_DEFAULT;
+
 struct ib_sa_sm_ah {
 	struct ib_ah        *ah;
 	struct kref          ref;
@@ -80,8 +89,16 @@ struct ib_sa_query {
 	struct ib_mad_send_buf *mad_buf;
 	struct ib_sa_sm_ah     *sm_ah;
 	int			id;
+	u32			flags;
+	struct list_head	list; /* Local svc request list */
+	u32			seq; /* Local svc request sequence number */
+	unsigned long		timeout; /* Local svc timeout */
+	u8			path_use; /* How will the pathrecord be used */
 };
 
+#define IB_SA_ENABLE_LOCAL_SERVICE	0x00000001
+#define IB_SA_CANCEL			0x00000002
+
 struct ib_sa_service_query {
 	void (*callback)(int, struct ib_sa_service_rec *, void *);
 	void *context;
@@ -106,6 +123,26 @@ struct ib_sa_mcmember_query {
 	struct ib_sa_query sa_query;
 };
 
+static LIST_HEAD(ib_nl_request_list);
+static DEFINE_SPINLOCK(ib_nl_request_lock);
+static atomic_t ib_nl_sa_request_seq;
+static struct workqueue_struct *ib_nl_wq;
+static struct delayed_work ib_nl_timed_work;
+static const struct nla_policy ib_nl_policy[LS_NLA_TYPE_MAX] = {
+	[LS_NLA_TYPE_PATH_RECORD]	= {.type = NLA_BINARY,
+		.len = sizeof(struct ib_path_rec_data)},
+	[LS_NLA_TYPE_TIMEOUT]		= {.type = NLA_U32},
+	[LS_NLA_TYPE_SERVICE_ID]	= {.type = NLA_U64},
+	[LS_NLA_TYPE_DGID]		= {.type = NLA_BINARY,
+		.len = sizeof(struct rdma_nla_ls_gid)},
+	[LS_NLA_TYPE_SGID]		= {.type = NLA_BINARY,
+		.len = sizeof(struct rdma_nla_ls_gid)},
+	[LS_NLA_TYPE_TCLASS]		= {.type = NLA_U8},
+	[LS_NLA_TYPE_PKEY]		= {.type = NLA_U16},
+	[LS_NLA_TYPE_QOS_CLASS]		= {.type = NLA_U16},
+};
+
+
 static void ib_sa_add_one(struct ib_device *device);
 static void ib_sa_remove_one(struct ib_device *device, void *client_data);
 
@@ -381,6 +418,427 @@ static const struct ib_field guidinfo_rec_table[] = {
 	  .size_bits    = 512 },
 };
 
+static inline void ib_sa_disable_local_svc(struct ib_sa_query *query)
+{
+	query->flags &= ~IB_SA_ENABLE_LOCAL_SERVICE;
+}
+
+static inline int ib_sa_query_cancelled(struct ib_sa_query *query)
+{
+	return (query->flags & IB_SA_CANCEL);
+}
+
+static void ib_nl_set_path_rec_attrs(struct sk_buff *skb,
+				     struct ib_sa_query *query)
+{
+	struct ib_sa_path_rec *sa_rec = query->mad_buf->context[1];
+	struct ib_sa_mad *mad = query->mad_buf->mad;
+	ib_sa_comp_mask comp_mask = mad->sa_hdr.comp_mask;
+	u16 val16;
+	u64 val64;
+	struct rdma_ls_resolve_header *header;
+
+	query->mad_buf->context[1] = NULL;
+
+	/* Construct the family header first */
+	header = (struct rdma_ls_resolve_header *)
+		skb_put(skb, NLMSG_ALIGN(sizeof(*header)));
+	memcpy(header->device_name, query->port->agent->device->name,
+	       LS_DEVICE_NAME_MAX);
+	header->port_num = query->port->port_num;
+
+	if ((comp_mask & IB_SA_PATH_REC_REVERSIBLE) &&
+	    sa_rec->reversible != 0)
+		query->path_use = LS_RESOLVE_PATH_USE_GMP;
+	else
+		query->path_use = LS_RESOLVE_PATH_USE_UNIDIRECTIONAL;
+	header->path_use = query->path_use;
+
+	/* Now build the attributes */
+	if (comp_mask & IB_SA_PATH_REC_SERVICE_ID) {
+		val64 = be64_to_cpu(sa_rec->service_id);
+		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SERVICE_ID,
+			sizeof(val64), &val64);
+	}
+	if (comp_mask & IB_SA_PATH_REC_DGID)
+		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_DGID,
+			sizeof(sa_rec->dgid), &sa_rec->dgid);
+	if (comp_mask & IB_SA_PATH_REC_SGID)
+		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SGID,
+			sizeof(sa_rec->sgid), &sa_rec->sgid);
+	if (comp_mask & IB_SA_PATH_REC_TRAFFIC_CLASS)
+		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_TCLASS,
+			sizeof(sa_rec->traffic_class), &sa_rec->traffic_class);
+
+	if (comp_mask & IB_SA_PATH_REC_PKEY) {
+		val16 = be16_to_cpu(sa_rec->pkey);
+		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_PKEY,
+			sizeof(val16), &val16);
+	}
+	if (comp_mask & IB_SA_PATH_REC_QOS_CLASS) {
+		val16 = be16_to_cpu(sa_rec->qos_class);
+		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_QOS_CLASS,
+			sizeof(val16), &val16);
+	}
+}
+
+static int ib_nl_get_path_rec_attrs_len(ib_sa_comp_mask comp_mask)
+{
+	int len = 0;
+
+	if (comp_mask & IB_SA_PATH_REC_SERVICE_ID)
+		len += nla_total_size(sizeof(u64));
+	if (comp_mask & IB_SA_PATH_REC_DGID)
+		len += nla_total_size(sizeof(struct rdma_nla_ls_gid));
+	if (comp_mask & IB_SA_PATH_REC_SGID)
+		len += nla_total_size(sizeof(struct rdma_nla_ls_gid));
+	if (comp_mask & IB_SA_PATH_REC_TRAFFIC_CLASS)
+		len += nla_total_size(sizeof(u8));
+	if (comp_mask & IB_SA_PATH_REC_PKEY)
+		len += nla_total_size(sizeof(u16));
+	if (comp_mask & IB_SA_PATH_REC_QOS_CLASS)
+		len += nla_total_size(sizeof(u16));
+
+	/*
+	 * Make sure that at least some of the required comp_mask bits are
+	 * set.
+	 */
+	if (WARN_ON(len == 0))
+		return len;
+
+	/* Add the family header */
+	len += NLMSG_ALIGN(sizeof(struct rdma_ls_resolve_header));
+
+	return len;
+}
+
+static int ib_nl_send_msg(struct ib_sa_query *query)
+{
+	struct sk_buff *skb = NULL;
+	struct nlmsghdr *nlh;
+	void *data;
+	int ret = 0;
+	struct ib_sa_mad *mad;
+	int len;
+
+	mad = query->mad_buf->mad;
+	len = ib_nl_get_path_rec_attrs_len(mad->sa_hdr.comp_mask);
+	if (len <= 0)
+		return -EMSGSIZE;
+
+	skb = nlmsg_new(len, GFP_KERNEL);
+	if (!skb)
+		return -ENOMEM;
+
+	/* Put nlmsg header only for now */
+	data = ibnl_put_msg(skb, &nlh, query->seq, 0, RDMA_NL_LS,
+			    RDMA_NL_LS_OP_RESOLVE, (int) GFP_KERNEL);
+	if (!data) {
+		kfree_skb(skb);
+		return -EMSGSIZE;
+	}
+
+	/* Add attributes */
+	ib_nl_set_path_rec_attrs(skb, query);
+
+	/* Repair the nlmsg header length */
+	nlmsg_end(skb, nlh);
+
+	ret = ibnl_multicast(skb, nlh, RDMA_NL_GROUP_LS, GFP_KERNEL);
+	if (!ret)
+		ret = len;
+	else
+		ret = 0;
+
+	return ret;
+}
+
+static int ib_nl_make_request(struct ib_sa_query *query)
+{
+	unsigned long flags;
+	unsigned long delay;
+	int ret;
+
+	INIT_LIST_HEAD(&query->list);
+	query->seq = (u32)atomic_inc_return(&ib_nl_sa_request_seq);
+
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
+	ret = ib_nl_send_msg(query);
+	if (ret <= 0) {
+		ret = -EIO;
+		goto request_out;
+	} else {
+		ret = 0;
+	}
+
+	delay = msecs_to_jiffies(sa_local_svc_timeout_ms);
+	query->timeout = delay + jiffies;
+	list_add_tail(&query->list, &ib_nl_request_list);
+	/* Start the timeout if this is the only request */
+	if (ib_nl_request_list.next == &query->list)
+		queue_delayed_work(ib_nl_wq, &ib_nl_timed_work, delay);
+
+request_out:
+	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+
+	return ret;
+}
+
+static int ib_nl_cancel_request(struct ib_sa_query *query)
+{
+	unsigned long flags;
+	struct ib_sa_query *wait_query;
+	int found = 0;
+
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
+	list_for_each_entry(wait_query, &ib_nl_request_list, list) {
+		/* Let the timeout to take care of the callback */
+		if (query == wait_query) {
+			query->flags |= IB_SA_CANCEL;
+			query->timeout = jiffies;
+			list_move(&query->list, &ib_nl_request_list);
+			found = 1;
+			mod_delayed_work(ib_nl_wq, &ib_nl_timed_work, 1);
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+
+	return found;
+}
+
+static void send_handler(struct ib_mad_agent *agent,
+			 struct ib_mad_send_wc *mad_send_wc);
+
+static void ib_nl_process_good_resolve_rsp(struct ib_sa_query *query,
+					   const struct nlmsghdr *nlh)
+{
+	struct ib_mad_send_wc mad_send_wc;
+	struct ib_sa_mad *mad = NULL;
+	const struct nlattr *head, *curr;
+	struct ib_path_rec_data  *rec;
+	int len, rem;
+	u32 mask = 0;
+	int status = -EIO;
+
+	if (query->callback) {
+		head = (const struct nlattr *) nlmsg_data(nlh);
+		len = nlmsg_len(nlh);
+		switch (query->path_use) {
+		case LS_RESOLVE_PATH_USE_UNIDIRECTIONAL:
+			mask = IB_PATH_PRIMARY | IB_PATH_OUTBOUND;
+			break;
+
+		case LS_RESOLVE_PATH_USE_ALL:
+		case LS_RESOLVE_PATH_USE_GMP:
+		default:
+			mask = IB_PATH_PRIMARY | IB_PATH_GMP |
+				IB_PATH_BIDIRECTIONAL;
+			break;
+		}
+		nla_for_each_attr(curr, head, len, rem) {
+			if (curr->nla_type == LS_NLA_TYPE_PATH_RECORD) {
+				rec = nla_data(curr);
+				/*
+				 * Get the first one. In the future, we may
+				 * need to get up to 6 pathrecords.
+				 */
+				if ((rec->flags & mask) == mask) {
+					mad = query->mad_buf->mad;
+					mad->mad_hdr.method |=
+						IB_MGMT_METHOD_RESP;
+					memcpy(mad->data, rec->path_rec,
+					       sizeof(rec->path_rec));
+					status = 0;
+					break;
+				}
+			}
+		}
+		query->callback(query, status, mad);
+	}
+
+	mad_send_wc.send_buf = query->mad_buf;
+	mad_send_wc.status = IB_WC_SUCCESS;
+	send_handler(query->mad_buf->mad_agent, &mad_send_wc);
+}
+
+static void ib_nl_request_timeout(struct work_struct *work)
+{
+	unsigned long flags;
+	struct ib_sa_query *query;
+	unsigned long delay;
+	struct ib_mad_send_wc mad_send_wc;
+	int ret;
+
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
+	while (!list_empty(&ib_nl_request_list)) {
+		query = list_entry(ib_nl_request_list.next,
+				   struct ib_sa_query, list);
+
+		if (time_after(query->timeout, jiffies)) {
+			delay = query->timeout - jiffies;
+			if ((long)delay <= 0)
+				delay = 1;
+			queue_delayed_work(ib_nl_wq, &ib_nl_timed_work, delay);
+			break;
+		}
+
+		list_del(&query->list);
+		ib_sa_disable_local_svc(query);
+		/* Hold the lock to protect against query cancellation */
+		if (ib_sa_query_cancelled(query))
+			ret = -1;
+		else
+			ret = ib_post_send_mad(query->mad_buf, NULL);
+		if (ret) {
+			mad_send_wc.send_buf = query->mad_buf;
+			mad_send_wc.status = IB_WC_WR_FLUSH_ERR;
+			spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+			send_handler(query->port->agent, &mad_send_wc);
+			spin_lock_irqsave(&ib_nl_request_lock, flags);
+		}
+	}
+	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+}
+
+static int ib_nl_handle_set_timeout(struct sk_buff *skb,
+				    struct netlink_callback *cb)
+{
+	const struct nlmsghdr *nlh = (struct nlmsghdr *)cb->nlh;
+	int timeout, delta, abs_delta;
+	const struct nlattr *attr;
+	unsigned long flags;
+	struct ib_sa_query *query;
+	long delay = 0;
+	struct nlattr *tb[LS_NLA_TYPE_MAX];
+	int ret;
+
+	if (!netlink_capable(skb, CAP_NET_ADMIN))
+		return -EPERM;
+
+	ret = nla_parse(tb, LS_NLA_TYPE_MAX - 1, nlmsg_data(nlh),
+			nlmsg_len(nlh), ib_nl_policy);
+	attr = (const struct nlattr *)tb[LS_NLA_TYPE_TIMEOUT];
+	if (ret || !attr)
+		goto settimeout_out;
+
+	timeout = *(int *) nla_data(attr);
+	if (timeout < IB_SA_LOCAL_SVC_TIMEOUT_MIN)
+		timeout = IB_SA_LOCAL_SVC_TIMEOUT_MIN;
+	if (timeout > IB_SA_LOCAL_SVC_TIMEOUT_MAX)
+		timeout = IB_SA_LOCAL_SVC_TIMEOUT_MAX;
+
+	delta = timeout - sa_local_svc_timeout_ms;
+	if (delta < 0)
+		abs_delta = -delta;
+	else
+		abs_delta = delta;
+
+	if (delta != 0) {
+		spin_lock_irqsave(&ib_nl_request_lock, flags);
+		sa_local_svc_timeout_ms = timeout;
+		list_for_each_entry(query, &ib_nl_request_list, list) {
+			if (delta < 0 && abs_delta > query->timeout)
+				query->timeout = 0;
+			else
+				query->timeout += delta;
+
+			/* Get the new delay from the first entry */
+			if (!delay) {
+				delay = query->timeout - jiffies;
+				if (delay <= 0)
+					delay = 1;
+			}
+		}
+		if (delay)
+			mod_delayed_work(ib_nl_wq, &ib_nl_timed_work,
+					 (unsigned long)delay);
+		spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+	}
+
+settimeout_out:
+	return skb->len;
+}
+
+static inline int ib_nl_is_good_resolve_resp(const struct nlmsghdr *nlh)
+{
+	struct nlattr *tb[LS_NLA_TYPE_MAX];
+	int ret;
+
+	if (nlh->nlmsg_flags & RDMA_NL_LS_F_ERR)
+		return 0;
+
+	ret = nla_parse(tb, LS_NLA_TYPE_MAX - 1, nlmsg_data(nlh),
+			nlmsg_len(nlh), ib_nl_policy);
+	if (ret)
+		return 0;
+
+	return 1;
+}
+
+static int ib_nl_handle_resolve_resp(struct sk_buff *skb,
+				     struct netlink_callback *cb)
+{
+	const struct nlmsghdr *nlh = (struct nlmsghdr *)cb->nlh;
+	unsigned long flags;
+	struct ib_sa_query *query;
+	struct ib_mad_send_buf *send_buf;
+	struct ib_mad_send_wc mad_send_wc;
+	int found = 0;
+	int ret;
+
+	if (!netlink_capable(skb, CAP_NET_ADMIN))
+		return -EPERM;
+
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
+	list_for_each_entry(query, &ib_nl_request_list, list) {
+		/*
+		 * If the query is cancelled, let the timeout routine
+		 * take care of it.
+		 */
+		if (nlh->nlmsg_seq == query->seq) {
+			found = !ib_sa_query_cancelled(query);
+			if (found)
+				list_del(&query->list);
+			break;
+		}
+	}
+
+	if (!found) {
+		spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+		goto resp_out;
+	}
+
+	send_buf = query->mad_buf;
+
+	if (!ib_nl_is_good_resolve_resp(nlh)) {
+		/* if the result is a failure, send out the packet via IB */
+		ib_sa_disable_local_svc(query);
+		ret = ib_post_send_mad(query->mad_buf, NULL);
+		spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+		if (ret) {
+			mad_send_wc.send_buf = send_buf;
+			mad_send_wc.status = IB_WC_GENERAL_ERR;
+			send_handler(query->port->agent, &mad_send_wc);
+		}
+	} else {
+		spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+		ib_nl_process_good_resolve_rsp(query, nlh);
+	}
+
+resp_out:
+	return skb->len;
+}
+
+static struct ibnl_client_cbs ib_sa_cb_table[] = {
+	[RDMA_NL_LS_OP_RESOLVE] = {
+		.dump = ib_nl_handle_resolve_resp,
+		.module = THIS_MODULE },
+	[RDMA_NL_LS_OP_SET_TIMEOUT] = {
+		.dump = ib_nl_handle_set_timeout,
+		.module = THIS_MODULE },
+};
+
 static void free_sm_ah(struct kref *kref)
 {
 	struct ib_sa_sm_ah *sm_ah = container_of(kref, struct ib_sa_sm_ah, ref);
@@ -502,7 +960,13 @@ void ib_sa_cancel_query(int id, struct ib_sa_query *query)
 	mad_buf = query->mad_buf;
 	spin_unlock_irqrestore(&idr_lock, flags);
 
-	ib_cancel_mad(agent, mad_buf);
+	/*
+	 * If the query is still on the netlink request list, schedule
+	 * it to be cancelled by the timeout routine. Otherwise, it has been
+	 * sent to the MAD layer and has to be cancelled from there.
+	 */
+	if (!ib_nl_cancel_request(query))
+		ib_cancel_mad(agent, mad_buf);
 }
 EXPORT_SYMBOL(ib_sa_cancel_query);
 
@@ -639,6 +1103,14 @@ static int send_mad(struct ib_sa_query *query, int timeout_ms, gfp_t gfp_mask)
 	query->mad_buf->context[0] = query;
 	query->id = id;
 
+	if (query->flags & IB_SA_ENABLE_LOCAL_SERVICE) {
+		if (!ibnl_chk_listeners(RDMA_NL_GROUP_LS)) {
+			if (!ib_nl_make_request(query))
+				return id;
+		}
+		ib_sa_disable_local_svc(query);
+	}
+
 	ret = ib_post_send_mad(query->mad_buf, NULL);
 	if (ret) {
 		spin_lock_irqsave(&idr_lock, flags);
@@ -767,6 +1239,9 @@ int ib_sa_path_rec_get(struct ib_sa_client *client,
 
 	*sa_query = &query->sa_query;
 
+	query->sa_query.flags |= IB_SA_ENABLE_LOCAL_SERVICE;
+	query->sa_query.mad_buf->context[1] = rec;
+
 	ret = send_mad(&query->sa_query, timeout_ms, gfp_mask);
 	if (ret < 0)
 		goto err2;
@@ -1251,6 +1726,8 @@ static int __init ib_sa_init(void)
 
 	get_random_bytes(&tid, sizeof tid);
 
+	atomic_set(&ib_nl_sa_request_seq, 0);
+
 	ret = ib_register_client(&sa_client);
 	if (ret) {
 		printk(KERN_ERR "Couldn't register ib_sa client\n");
@@ -1263,7 +1740,25 @@ static int __init ib_sa_init(void)
 		goto err2;
 	}
 
+	ib_nl_wq = create_singlethread_workqueue("ib_nl_sa_wq");
+	if (!ib_nl_wq) {
+		ret = -ENOMEM;
+		goto err3;
+	}
+
+	if (ibnl_add_client(RDMA_NL_LS, RDMA_NL_LS_NUM_OPS,
+			    ib_sa_cb_table)) {
+		pr_err("Failed to add netlink callback\n");
+		ret = -EINVAL;
+		goto err4;
+	}
+	INIT_DELAYED_WORK(&ib_nl_timed_work, ib_nl_request_timeout);
+
 	return 0;
+err4:
+	destroy_workqueue(ib_nl_wq);
+err3:
+	mcast_cleanup();
 err2:
 	ib_unregister_client(&sa_client);
 err1:
@@ -1272,6 +1767,10 @@ err1:
 
 static void __exit ib_sa_cleanup(void)
 {
+	ibnl_remove_client(RDMA_NL_LS);
+	cancel_delayed_work(&ib_nl_timed_work);
+	flush_workqueue(ib_nl_wq);
+	destroy_workqueue(ib_nl_wq);
 	mcast_cleanup();
 	ib_unregister_client(&sa_client);
 	idr_destroy(&query_idr);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
