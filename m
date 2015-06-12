From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH v6 4/4] IB/sa: Route SA pathrecord query through netlink
Date: Fri, 12 Jun 2015 10:06:06 -0400
Message-ID: <1434117966-17978-5-git-send-email-kaike.wan@intel.com>
References: <1434117966-17978-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1434117966-17978-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
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
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c |  533 +++++++++++++++++++++++++++++++++++-
 1 files changed, 532 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 17e1cf7..17390cf 100644
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
@@ -80,8 +89,24 @@ struct ib_sa_query {
 	struct ib_mad_send_buf *mad_buf;
 	struct ib_sa_sm_ah     *sm_ah;
 	int			id;
+	u32			flags;
 };
 
+#define IB_SA_ENABLE_LOCAL_SERVICE	0x00000001
+#define IB_SA_CANCEL			0x00000002
+
+#define IB_SA_LOCAL_SVC_ENABLED(query) \
+	((query)->flags & IB_SA_ENABLE_LOCAL_SERVICE)
+#define IB_SA_ENABLE_LOCAL_SVC(query) \
+	((query)->flags |= IB_SA_ENABLE_LOCAL_SERVICE)
+#define IB_SA_DISABLE_LOCAL_SVC(query) \
+	((query)->flags &= ~IB_SA_ENABLE_LOCAL_SERVICE)
+
+#define IB_SA_QUERY_CANCELLED(query) \
+	((query)->flags & IB_SA_CANCEL)
+#define IB_SA_CANCEL_QUERY(query) \
+	((query)->flags |= IB_SA_CANCEL)
+
 struct ib_sa_service_query {
 	void (*callback)(int, struct ib_sa_service_rec *, void *);
 	void *context;
@@ -106,6 +131,26 @@ struct ib_sa_mcmember_query {
 	struct ib_sa_query sa_query;
 };
 
+struct ib_nl_request_info {
+	struct list_head list;
+	u32 seq;
+	unsigned long timeout;
+	struct ib_sa_query *query;
+};
+
+struct ib_nl_attr_info {
+	u16 len;	/* Total attr len: header + payload + padding */
+	ib_sa_comp_mask comp_mask;
+	void *input;
+	void (*set_attrs)(struct sk_buff *skb, struct ib_nl_attr_info *info);
+};
+
+static LIST_HEAD(ib_nl_request_list);
+static DEFINE_SPINLOCK(ib_nl_request_lock);
+static atomic_t ib_nl_sa_request_seq;
+static struct workqueue_struct *ib_nl_wq;
+static struct delayed_work ib_nl_timed_work;
+
 static void ib_sa_add_one(struct ib_device *device);
 static void ib_sa_remove_one(struct ib_device *device);
 
@@ -381,6 +426,451 @@ static const struct ib_field guidinfo_rec_table[] = {
 	  .size_bits    = 512 },
 };
 
+static int ib_nl_send_msg(int opcode, struct ib_nl_attr_info *attrs, u32 seq)
+{
+	struct sk_buff *skb = NULL;
+	struct nlmsghdr *nlh;
+	void *data;
+	int ret = 0;
+
+	if (attrs->len <= 0)
+		return -EMSGSIZE;
+
+	skb = nlmsg_new(attrs->len, GFP_KERNEL);
+	if (!skb) {
+		pr_err("alloc failed ret=%d\n", ret);
+		return -ENOMEM;
+	}
+
+	/* Put nlmsg header only for now */
+	data = ibnl_put_msg(skb, &nlh, seq, 0, RDMA_NL_SA,
+			    opcode, GFP_KERNEL);
+	if (!data) {
+		kfree_skb(skb);
+		return -EMSGSIZE;
+	}
+
+	/* Add attributes */
+	attrs->set_attrs(skb, attrs);
+
+	/* Repair the nlmsg header length */
+	nlmsg_end(skb, nlh);
+
+	ret = ibnl_multicast(skb, nlh, RDMA_NL_GROUP_LS, GFP_KERNEL);
+	if (!ret) {
+		ret = attrs->len;
+	} else {
+		if (ret != -ESRCH)
+			pr_err("ibnl_multicast failed l=%d, r=%d\n",
+			       attrs->len, ret);
+		ret = 0;
+	}
+	return ret;
+}
+
+static struct ib_nl_request_info *
+ib_nl_alloc_request(struct ib_sa_query *query)
+{
+	struct ib_nl_request_info *rinfo;
+
+	rinfo = kzalloc(sizeof(*rinfo), GFP_ATOMIC);
+	if (rinfo == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	INIT_LIST_HEAD(&rinfo->list);
+	rinfo->seq = (u32)atomic_inc_return(&ib_nl_sa_request_seq);
+	rinfo->query = query;
+
+	return rinfo;
+}
+
+static void ib_nl_set_path_rec_attrs(struct sk_buff *skb,
+				     struct ib_nl_attr_info *info)
+{
+	struct ib_sa_path_rec *sa_rec = info->input;
+	__u8 val1;
+	__u16 val2;
+	__u64 val3;
+
+	if (info->comp_mask & IB_SA_PATH_REC_SERVICE_ID) {
+		val3 = be64_to_cpu(sa_rec->service_id);
+		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SERVICE_ID,
+			sizeof(val3), &val3);
+	}
+	if (info->comp_mask & IB_SA_PATH_REC_DGID)
+		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_DGID,
+			sizeof(sa_rec->dgid), &sa_rec->dgid);
+	if (info->comp_mask & IB_SA_PATH_REC_SGID)
+		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_SGID,
+			sizeof(sa_rec->sgid), &sa_rec->sgid);
+	if (info->comp_mask & IB_SA_PATH_REC_TRAFFIC_CLASS)
+		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_TCLASS,
+			sizeof(sa_rec->traffic_class), &sa_rec->traffic_class);
+
+	if ((info->comp_mask & IB_SA_PATH_REC_REVERSIBLE) &&
+	    sa_rec->reversible != 0) {
+		if ((info->comp_mask & IB_SA_PATH_REC_NUMB_PATH) &&
+		    sa_rec->numb_path > 1)
+			val1 = LS_NLA_PATH_USE_ALL;
+		else
+			val1 = LS_NLA_PATH_USE_GMP;
+	} else {
+		val1 = LS_NLA_PATH_USE_UNIDIRECTIONAL;
+	}
+	nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_PATH_USE, sizeof(val1),
+		&val1);
+
+	if (info->comp_mask & IB_SA_PATH_REC_PKEY) {
+		val2 = be16_to_cpu(sa_rec->pkey);
+		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_PKEY,
+			sizeof(val2), &val2);
+	}
+	if (info->comp_mask & IB_SA_PATH_REC_QOS_CLASS) {
+		val2 = be16_to_cpu(sa_rec->qos_class);
+		nla_put(skb, RDMA_NLA_F_MANDATORY | LS_NLA_TYPE_QOS_CLASS,
+			sizeof(val2), &val2);
+	}
+}
+
+static int ib_nl_get_path_rec_attrs_len(struct ib_nl_attr_info *info)
+{
+	int len = 0;
+
+	if (info->comp_mask & IB_SA_PATH_REC_SERVICE_ID)
+		len += nla_total_size(sizeof(struct rdma_nla_ls_service_id));
+	if (info->comp_mask & IB_SA_PATH_REC_DGID)
+		len += nla_total_size(sizeof(struct rdma_nla_ls_gid));
+	if (info->comp_mask & IB_SA_PATH_REC_SGID)
+		len += nla_total_size(sizeof(struct rdma_nla_ls_gid));
+	if (info->comp_mask & IB_SA_PATH_REC_TRAFFIC_CLASS)
+		len += nla_total_size(sizeof(struct rdma_nla_ls_tclass));
+	if (info->comp_mask & IB_SA_PATH_REC_PKEY)
+		len += nla_total_size(sizeof(struct rdma_nla_ls_pkey));
+	if (info->comp_mask & IB_SA_PATH_REC_QOS_CLASS)
+		len += nla_total_size(sizeof(struct rdma_nla_ls_qos_class));
+
+	/*
+	 * We need path use attribute no matter reversible or numb_path is
+	 * set or not, as long as some other fields get set
+	 */
+	if (len > 0)
+		len += nla_total_size(sizeof(struct rdma_nla_ls_path_use));
+
+	return len;
+}
+
+static int ib_nl_send_request(struct ib_nl_request_info *rinfo)
+{
+	struct ib_nl_attr_info info;
+	int opcode;
+	struct ib_sa_mad *mad;
+	unsigned long flags;
+	unsigned long delay;
+	int ret;
+
+	mad = rinfo->query->mad_buf->mad;
+	switch (mad->mad_hdr.attr_id) {
+	case cpu_to_be16(IB_SA_ATTR_PATH_REC):
+		opcode = RDMA_NL_LS_OP_RESOLVE;
+		mad = rinfo->query->mad_buf->mad;
+		info.comp_mask = mad->sa_hdr.comp_mask;
+		info.input = rinfo->query->mad_buf->context[1];
+		rinfo->query->mad_buf->context[1] = NULL;
+		info.len = ib_nl_get_path_rec_attrs_len(&info);
+		info.set_attrs = ib_nl_set_path_rec_attrs;
+		break;
+	default:
+		return -EINVAL;
+	}
+
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
+	ret = ib_nl_send_msg(opcode, &info, rinfo->seq);
+	if (ret <= 0) {
+		ret = -EIO;
+		goto request_out;
+	} else {
+		ret = 0;
+	}
+
+	delay = msecs_to_jiffies(sa_local_svc_timeout_ms);
+	rinfo->timeout = delay + jiffies;
+	list_add_tail(&rinfo->list, &ib_nl_request_list);
+	/* Start the timeout if this is the only request */
+	if (ib_nl_request_list.next == &rinfo->list)
+		queue_delayed_work(ib_nl_wq, &ib_nl_timed_work, delay);
+
+request_out:
+	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+
+	return ret;
+}
+
+static int ib_nl_make_request(struct ib_sa_query *query)
+{
+	struct ib_nl_request_info *rinfo;
+	int ret;
+
+	rinfo = ib_nl_alloc_request(query);
+	if (IS_ERR(rinfo))
+		return -ENOMEM;
+
+	ret = ib_nl_send_request(rinfo);
+	if (ret)
+		kfree(rinfo);
+
+	return ret;
+}
+
+static int ib_nl_cancel_request(struct ib_sa_query *query)
+{
+	unsigned long flags;
+	struct ib_nl_request_info *rinfo;
+	int found = 0;
+
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
+	list_for_each_entry(rinfo, &ib_nl_request_list, list) {
+		/* Let the timeout to take care of the callback */
+		if (query == rinfo->query) {
+			IB_SA_CANCEL_QUERY(query);
+			rinfo->timeout = jiffies;
+			list_move(&rinfo->list, &ib_nl_request_list);
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
+
+	if (query->callback) {
+		head = (const struct nlattr *) nlmsg_data(nlh);
+		len = nlmsg_len(nlh);
+		nla_for_each_attr(curr, head, len, rem) {
+			if (curr->nla_type == LS_NLA_TYPE_PATH_RECORD) {
+				rec = nla_data(curr);
+				if (rec->flags && IB_PATH_PRIMARY) {
+					mad = query->mad_buf->mad;
+					mad->mad_hdr.method |=
+						IB_MGMT_METHOD_RESP;
+					memcpy(mad->data, rec->path_rec,
+					       sizeof(rec->path_rec));
+					query->callback(query, 0, mad);
+					break;
+				}
+			}
+		}
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
+	struct ib_nl_request_info *rinfo;
+	struct ib_sa_query *query;
+	unsigned long delay;
+	struct ib_mad_send_wc mad_send_wc;
+	int ret;
+
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
+	while (!list_empty(&ib_nl_request_list)) {
+		rinfo = list_entry(ib_nl_request_list.next,
+				   struct ib_nl_request_info, list);
+
+		if (time_after(rinfo->timeout, jiffies)) {
+			delay = rinfo->timeout - jiffies;
+			if ((long)delay <= 0)
+				delay = 1;
+			queue_delayed_work(ib_nl_wq, &ib_nl_timed_work, delay);
+			break;
+		}
+
+		list_del(&rinfo->list);
+		query = rinfo->query;
+		IB_SA_DISABLE_LOCAL_SVC(query);
+		/* Hold the lock to protect against query cancellation */
+		if (IB_SA_QUERY_CANCELLED(query))
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
+		kfree(rinfo);
+	}
+	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+}
+
+static inline int ib_nl_is_good_resolve_resp(const struct nlmsghdr *nlh)
+{
+	const struct nlattr *head, *curr;
+	struct ib_path_rec_data  *rec;
+	int len, rem;
+
+	if (nlh->nlmsg_flags & RDMA_NL_LS_F_ERR)
+		return 0;
+
+	if (!(nlh->nlmsg_flags & RDMA_NL_LS_F_OK))
+		return 0;
+
+	if (nlmsg_len(nlh) < nla_attr_size(sizeof(*rec)))
+		return 0;
+
+	head = (const struct nlattr *) nlmsg_data(nlh);
+	len = nlmsg_len(nlh);
+	nla_for_each_attr(curr, head, len, rem) {
+		if (curr->nla_type == LS_NLA_TYPE_PATH_RECORD) {
+			rec = nla_data(curr);
+			if (rec->flags && IB_PATH_PRIMARY)
+				return 1;
+		}
+	}
+
+	return 0;
+}
+
+static int ib_nl_handle_set_timeout(struct sk_buff *skb,
+				    struct netlink_callback *cb)
+{
+	const struct nlmsghdr *nlh = (struct nlmsghdr *)cb->nlh;
+	int timeout, delta, abs_delta;
+	const struct nlattr *attr;
+	struct rdma_nla_ls_timeout *to_attr;
+	unsigned long flags;
+	struct ib_nl_request_info *rinfo;
+	long delay = 0;
+
+	if (nlmsg_len(nlh) < nla_attr_size(sizeof(*to_attr)))
+		goto settimeout_out;
+
+	attr = (const struct nlattr *) nlmsg_data(nlh);
+	if (attr->nla_type != LS_NLA_TYPE_TIMEOUT ||
+	    nla_len(attr) != sizeof(*to_attr))
+		goto settimeout_out;
+
+	to_attr = (struct rdma_nla_ls_timeout *) nla_data(attr);
+	timeout = (int) to_attr->timeout;
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
+		list_for_each_entry(rinfo, &ib_nl_request_list, list) {
+			if (delta < 0 && abs_delta > rinfo->timeout)
+				rinfo->timeout = 0;
+			else
+				rinfo->timeout += delta;
+
+			/* Get the new delay from the first entry */
+			if (!delay) {
+				delay = rinfo->timeout - jiffies;
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
+static int ib_nl_handle_resolve_resp(struct sk_buff *skb,
+				     struct netlink_callback *cb)
+{
+	const struct nlmsghdr *nlh = (struct nlmsghdr *)cb->nlh;
+	unsigned long flags;
+	struct ib_nl_request_info *rinfo;
+	struct ib_sa_query *query;
+	struct ib_mad_send_buf *send_buf;
+	struct ib_mad_send_wc mad_send_wc;
+	int found = 0;
+	int ret;
+
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
+	list_for_each_entry(rinfo, &ib_nl_request_list, list) {
+		/*
+		 * If the query is cancelled, let the timeout routine
+		 * take care of it.
+		 */
+		if (nlh->nlmsg_seq == rinfo->seq) {
+			found = !IB_SA_QUERY_CANCELLED(rinfo->query);
+			if (found)
+				list_del(&rinfo->list);
+			break;
+		}
+	}
+
+	if (!found) {
+		spin_unlock_irqrestore(&ib_nl_request_lock, flags);
+		goto resp_out;
+	}
+
+	query = rinfo->query;
+	send_buf = query->mad_buf;
+
+	if (!ib_nl_is_good_resolve_resp(nlh)) {
+		/* if the result is a failure, send out the packet via IB */
+		IB_SA_DISABLE_LOCAL_SVC(query);
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
+	kfree(rinfo);
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
@@ -502,7 +992,13 @@ void ib_sa_cancel_query(int id, struct ib_sa_query *query)
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
 
@@ -638,6 +1134,14 @@ static int send_mad(struct ib_sa_query *query, int timeout_ms, gfp_t gfp_mask)
 	query->mad_buf->context[0] = query;
 	query->id = id;
 
+	if (IB_SA_LOCAL_SVC_ENABLED(query)) {
+		if (!ibnl_chk_listeners(RDMA_NL_GROUP_LS)) {
+			if (!ib_nl_make_request(query))
+				return id;
+		}
+		IB_SA_DISABLE_LOCAL_SVC(query);
+	}
+
 	ret = ib_post_send_mad(query->mad_buf, NULL);
 	if (ret) {
 		spin_lock_irqsave(&idr_lock, flags);
@@ -766,6 +1270,9 @@ int ib_sa_path_rec_get(struct ib_sa_client *client,
 
 	*sa_query = &query->sa_query;
 
+	IB_SA_ENABLE_LOCAL_SVC(&query->sa_query);
+	query->sa_query.mad_buf->context[1] = rec;
+
 	ret = send_mad(&query->sa_query, timeout_ms, gfp_mask);
 	if (ret < 0)
 		goto err2;
@@ -1250,6 +1757,8 @@ static int __init ib_sa_init(void)
 
 	get_random_bytes(&tid, sizeof tid);
 
+	atomic_set(&ib_nl_sa_request_seq, 0);
+
 	ret = ib_register_client(&sa_client);
 	if (ret) {
 		printk(KERN_ERR "Couldn't register ib_sa client\n");
@@ -1262,7 +1771,25 @@ static int __init ib_sa_init(void)
 		goto err2;
 	}
 
+	ib_nl_wq = create_singlethread_workqueue("ib_nl_sa_wq");
+	if (!ib_nl_wq) {
+		ret = -ENOMEM;
+		goto err3;
+	}
+
+	if (ibnl_add_client(RDMA_NL_SA, RDMA_NL_LS_NUM_OPS,
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
@@ -1271,6 +1798,10 @@ err1:
 
 static void __exit ib_sa_cleanup(void)
 {
+	ibnl_remove_client(RDMA_NL_SA);
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
