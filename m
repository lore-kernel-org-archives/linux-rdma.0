From: kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 3/3] IB/sa: route SA pathrecord query through netlink
Date: Mon, 18 May 2015 15:00:16 -0400
Message-ID: <1431975616-23529-4-git-send-email-kaike.wan@intel.com>
References: <1431975616-23529-1-git-send-email-kaike.wan@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431975616-23529-1-git-send-email-kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This patch routes a SA pathrecord query to netlink first and processes the
response appropriately. If a failure is returned, the request will be sent
through IB. The decision whether to route the request to netlink first is
determined by the presence of a listener for the MAD netlink multicast
group. If the user-space MAD netlink multicast group listener is not
present, the request will be sent through IB, just like what is currently
being done.

Signed-off-by: Kaike Wan <kaike.wan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: John Fleck <john.fleck-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sa_query.c |  334 +++++++++++++++++++++++++++++++++++-
 1 files changed, 329 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index c38f030..69fcd28 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -45,12 +45,22 @@
 #include <uapi/linux/if_ether.h>
 #include <rdma/ib_pack.h>
 #include <rdma/ib_cache.h>
+#include <rdma/rdma_netlink.h>
+#include <net/netlink.h>
+#include <rdma/rdma_netlink.h>
 #include "sa.h"
 
 MODULE_AUTHOR("Roland Dreier");
 MODULE_DESCRIPTION("InfiniBand subnet administration query support");
 MODULE_LICENSE("Dual BSD/GPL");
 
+#define IB_SA_LOCAL_SVC_TIMEOUT_MIN		100
+#define IB_SA_LOCAL_SVC_TIMEOUT_DEFAULT		2000
+static int sa_local_svc_timeout_ms = IB_SA_LOCAL_SVC_TIMEOUT_DEFAULT;
+
+module_param_named(local_svc_timeout_ms, sa_local_svc_timeout_ms, int, 0644);
+MODULE_PARM_DESC(local_svc_timeout_ms, "Local service timeout in millisecond");
+
 struct ib_sa_sm_ah {
 	struct ib_ah        *ah;
 	struct kref          ref;
@@ -80,8 +90,24 @@ struct ib_sa_query {
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
@@ -106,6 +132,24 @@ struct ib_sa_mcmember_query {
 	struct ib_sa_query sa_query;
 };
 
+struct ib_nl_request_info {
+	struct list_head list;
+	u32 seq;
+	unsigned long timeout;
+	struct ib_sa_query *query;
+};
+
+struct rdma_nl_resp_msg {
+	struct nlmsghdr nl_hdr;
+	struct ib_sa_mad sa_mad;
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
 
@@ -381,6 +425,244 @@ static const struct ib_field guidinfo_rec_table[] = {
 	  .size_bits    = 512 },
 };
 
+static int ib_nl_send_mad(void *mad, int len, u32 seq)
+{
+	struct sk_buff *skb = NULL;
+	struct nlmsghdr *nlh;
+	void *data;
+	int ret = 0;
+
+	skb = nlmsg_new(len, GFP_KERNEL);
+	if (!skb) {
+		pr_err("alloc failed ret=%d\n", ret);
+		return -ENOMEM;
+	}
+
+	data = ibnl_put_msg(skb, &nlh, seq, len, RDMA_NL_MAD,
+			    RDMA_NL_MAD_REQUEST, GFP_KERNEL);
+	if (!data) {
+		kfree_skb(skb);
+		return -EMSGSIZE;
+	}
+	memcpy(data, mad, len);
+
+	ret = ibnl_multicast(skb, nlh, RDMA_NL_GROUP_MAD, GFP_KERNEL);
+	if (!ret) {
+		ret = len;
+	} else {
+		if (ret != -ESRCH)
+			pr_err("ibnl_multicast failed l=%d, r=%d\n", len, ret);
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
+static int ib_nl_send_request(struct ib_nl_request_info *rinfo)
+{
+	struct ib_mad_send_buf *send_buf;
+	unsigned long flags;
+	unsigned long delay;
+	int ret;
+
+	send_buf = rinfo->query->mad_buf;
+
+	delay = msecs_to_jiffies(sa_local_svc_timeout_ms);
+	spin_lock_irqsave(&ib_nl_request_lock, flags);
+	ret = ib_nl_send_mad(send_buf->mad,
+			     (send_buf->data_len + send_buf->hdr_len),
+			     rinfo->seq);
+
+	if (ret != (send_buf->data_len + send_buf->hdr_len)) {
+		kfree(rinfo);
+		ret = -EIO;
+		goto request_out;
+	} else {
+		ret = 0;
+	}
+
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
+
+	rinfo = ib_nl_alloc_request(query);
+	if (IS_ERR(rinfo))
+		return -ENOMEM;
+
+	return ib_nl_send_request(rinfo);
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
+
+static int ib_nl_handle_mad_resp(struct sk_buff *skb,
+				 struct netlink_callback *cb);
+static struct ibnl_client_cbs ib_sa_cb_table[] = {
+	[RDMA_NL_MAD_REQUEST] = {
+		.dump = ib_nl_handle_mad_resp,
+		.module = THIS_MODULE },
+};
+
+static void send_handler(struct ib_mad_agent *agent,
+			 struct ib_mad_send_wc *mad_send_wc);
+
+static void ib_nl_process_good_rsp(struct ib_sa_query *query,
+				   struct ib_sa_mad *rsp)
+{
+	struct ib_mad_send_wc mad_send_wc;
+
+	if (query->callback)
+		query->callback(query, 0, rsp);
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
+static int ib_nl_handle_mad_resp(struct sk_buff *skb,
+				 struct netlink_callback *cb)
+{
+	struct rdma_nl_resp_msg *nl_msg = (struct rdma_nl_resp_msg *)cb->nlh;
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
+		if (nl_msg->nl_hdr.nlmsg_seq == rinfo->seq) {
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
+	if (nl_msg->sa_mad.mad_hdr.status != 0) {
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
+		ib_nl_process_good_rsp(query, &nl_msg->sa_mad);
+	}
+
+	kfree(rinfo);
+resp_out:
+	return skb->len;
+}
+
 static void free_sm_ah(struct kref *kref)
 {
 	struct ib_sa_sm_ah *sm_ah = container_of(kref, struct ib_sa_sm_ah, ref);
@@ -502,7 +784,13 @@ void ib_sa_cancel_query(int id, struct ib_sa_query *query)
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
 
@@ -638,6 +926,14 @@ static int send_mad(struct ib_sa_query *query, int timeout_ms, gfp_t gfp_mask)
 	query->mad_buf->context[0] = query;
 	query->id = id;
 
+	if (IB_SA_LOCAL_SVC_ENABLED(query)) {
+		if (!ibnl_chk_listeners(RDMA_NL_GROUP_MAD)) {
+			if (!ib_nl_make_request(query))
+				return id;
+		}
+		IB_SA_DISABLE_LOCAL_SVC(query);
+	}
+
 	ret = ib_post_send_mad(query->mad_buf, NULL);
 	if (ret) {
 		spin_lock_irqsave(&idr_lock, flags);
@@ -739,7 +1035,7 @@ int ib_sa_path_rec_get(struct ib_sa_client *client,
 	port  = &sa_dev->port[port_num - sa_dev->start_port];
 	agent = port->agent;
 
-	query = kmalloc(sizeof *query, gfp_mask);
+	query = kzalloc(sizeof(*query), gfp_mask);
 	if (!query)
 		return -ENOMEM;
 
@@ -766,6 +1062,8 @@ int ib_sa_path_rec_get(struct ib_sa_client *client,
 
 	*sa_query = &query->sa_query;
 
+	IB_SA_ENABLE_LOCAL_SVC(&query->sa_query);
+
 	ret = send_mad(&query->sa_query, timeout_ms, gfp_mask);
 	if (ret < 0)
 		goto err2;
@@ -861,7 +1159,7 @@ int ib_sa_service_rec_query(struct ib_sa_client *client,
 	    method != IB_SA_METHOD_DELETE)
 		return -EINVAL;
 
-	query = kmalloc(sizeof *query, gfp_mask);
+	query = kzalloc(sizeof(*query), gfp_mask);
 	if (!query)
 		return -ENOMEM;
 
@@ -953,7 +1251,7 @@ int ib_sa_mcmember_rec_query(struct ib_sa_client *client,
 	port  = &sa_dev->port[port_num - sa_dev->start_port];
 	agent = port->agent;
 
-	query = kmalloc(sizeof *query, gfp_mask);
+	query = kzalloc(sizeof(*query), gfp_mask);
 	if (!query)
 		return -ENOMEM;
 
@@ -1050,7 +1348,7 @@ int ib_sa_guid_info_rec_query(struct ib_sa_client *client,
 	port  = &sa_dev->port[port_num - sa_dev->start_port];
 	agent = port->agent;
 
-	query = kmalloc(sizeof *query, gfp_mask);
+	query = kzalloc(sizeof(*query), gfp_mask);
 	if (!query)
 		return -ENOMEM;
 
@@ -1250,6 +1548,10 @@ static int __init ib_sa_init(void)
 
 	get_random_bytes(&tid, sizeof tid);
 
+	atomic_set(&ib_nl_sa_request_seq, 0);
+	sa_local_svc_timeout_ms = max(sa_local_svc_timeout_ms,
+				       IB_SA_LOCAL_SVC_TIMEOUT_MIN);
+
 	ret = ib_register_client(&sa_client);
 	if (ret) {
 		printk(KERN_ERR "Couldn't register ib_sa client\n");
@@ -1262,7 +1564,25 @@ static int __init ib_sa_init(void)
 		goto err2;
 	}
 
+	ib_nl_wq = create_singlethread_workqueue("ib_nl_sa_wq");
+	if (!ib_nl_wq) {
+		ret = -ENOMEM;
+		goto err3;
+	}
+
+	if (ibnl_add_client(RDMA_NL_MAD, RDMA_NL_MAD_NUM_OPS,
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
@@ -1271,6 +1591,10 @@ err1:
 
 static void __exit ib_sa_cleanup(void)
 {
+	ibnl_remove_client(RDMA_NL_MAD);
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
