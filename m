From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next V2 1/5] RDMA/netlink: Remove netlink clients infrastructure
Date: Tue, 13 Jun 2017 11:59:23 +0300
Message-ID: <20170613085927.2908-2-leon@kernel.org>
References: <20170613085927.2908-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170613085927.2908-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

RDMA netlink has complicated infrastructure to add and remove netlink
clients to NETLINK_RDMA family. This complicates the code and not in
use because not many clients are available (3 clients) and most of them
(2 clients) are statically compiled together with netlink.c.

The following patch refactors RDMA netlink and opens door for the future
patches which will be able to get rid of a lot of dead iwcm* code.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Chien Tin Tung <chien.tin.tung-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c     |   6 +-
 drivers/infiniband/core/device.c  |  41 +++------
 drivers/infiniband/core/iwcm.c    |  10 +--
 drivers/infiniband/core/netlink.c | 185 ++++++++++++++++++--------------------
 include/rdma/rdma_netlink.h       |  17 ++--
 5 files changed, 110 insertions(+), 149 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 91b7a2fe5a55..d7e29d86469b 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4531,9 +4531,7 @@ static int __init cma_init(void)
 	if (ret)
 		goto err;
 
-	if (ibnl_add_client(RDMA_NL_RDMA_CM, ARRAY_SIZE(cma_cb_table),
-			    cma_cb_table))
-		pr_warn("RDMA CMA: failed to add netlink callback\n");
+	rdma_nl_register(RDMA_NL_RDMA_CM, cma_cb_table);
 	cma_configfs_init();
 
 	return 0;
@@ -4550,7 +4548,7 @@ static int __init cma_init(void)
 static void __exit cma_cleanup(void)
 {
 	cma_configfs_exit();
-	ibnl_remove_client(RDMA_NL_RDMA_CM);
+	rdma_nl_unregister(RDMA_NL_RDMA_CM);
 	ib_unregister_client(&cma_client);
 	unregister_netdevice_notifier(&cma_nb);
 	rdma_addr_unregister_client(&addr_client);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 81d447da0048..5c70ea49d5ad 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1008,29 +1008,15 @@ struct net_device *ib_get_net_dev_by_params(struct ib_device *dev,
 }
 EXPORT_SYMBOL(ib_get_net_dev_by_params);
 
-static struct ibnl_client_cbs ibnl_ls_cb_table[] = {
+static const struct ibnl_client_cbs ibnl_ls_cb_table[] = {
 	[RDMA_NL_LS_OP_RESOLVE] = {
-		.dump = ib_nl_handle_resolve_resp,
-		.module = THIS_MODULE },
+		.dump = ib_nl_handle_resolve_resp},
 	[RDMA_NL_LS_OP_SET_TIMEOUT] = {
-		.dump = ib_nl_handle_set_timeout,
-		.module = THIS_MODULE },
+		.dump = ib_nl_handle_set_timeout},
 	[RDMA_NL_LS_OP_IP_RESOLVE] = {
-		.dump = ib_nl_handle_ip_res_resp,
-		.module = THIS_MODULE },
+		.dump = ib_nl_handle_ip_res_resp},
 };
 
-static int ib_add_ibnl_clients(void)
-{
-	return ibnl_add_client(RDMA_NL_LS, ARRAY_SIZE(ibnl_ls_cb_table),
-			       ibnl_ls_cb_table);
-}
-
-static void ib_remove_ibnl_clients(void)
-{
-	ibnl_remove_client(RDMA_NL_LS);
-}
-
 static int __init ib_core_init(void)
 {
 	int ret;
@@ -1052,9 +1038,9 @@ static int __init ib_core_init(void)
 		goto err_comp;
 	}
 
-	ret = ibnl_init();
+	ret = rdma_nl_init();
 	if (ret) {
-		pr_warn("Couldn't init IB netlink interface\n");
+		pr_warn("Couldn't init IB netlink interface %d\n", ret);
 		goto err_sysfs;
 	}
 
@@ -1076,24 +1062,17 @@ static int __init ib_core_init(void)
 		goto err_mad;
 	}
 
-	ret = ib_add_ibnl_clients();
-	if (ret) {
-		pr_warn("Couldn't register ibnl clients\n");
-		goto err_sa;
-	}
-
+	rdma_nl_register(RDMA_NL_LS, ibnl_ls_cb_table);
 	ib_cache_setup();
 
 	return 0;
 
-err_sa:
-	ib_sa_cleanup();
 err_mad:
 	ib_mad_cleanup();
 err_addr:
 	addr_cleanup();
 err_ibnl:
-	ibnl_cleanup();
+	rdma_nl_exit();
 err_sysfs:
 	class_unregister(&ib_class);
 err_comp:
@@ -1106,11 +1085,11 @@ static int __init ib_core_init(void)
 static void __exit ib_core_cleanup(void)
 {
 	ib_cache_cleanup();
-	ib_remove_ibnl_clients();
+	rdma_nl_unregister(RDMA_NL_LS);
 	ib_sa_cleanup();
 	ib_mad_cleanup();
 	addr_cleanup();
-	ibnl_cleanup();
+	rdma_nl_exit();
 	class_unregister(&ib_class);
 	destroy_workqueue(ib_comp_wq);
 	/* Make sure that any pending umem accounting work is done. */
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 31661b5c1743..8599271d8be6 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -1175,12 +1175,8 @@ static int __init iw_cm_init(void)
 	ret = iwpm_init(RDMA_NL_IWCM);
 	if (ret)
 		pr_err("iw_cm: couldn't init iwpm\n");
-
-	ret = ibnl_add_client(RDMA_NL_IWCM, ARRAY_SIZE(iwcm_nl_cb_table),
-			      iwcm_nl_cb_table);
-	if (ret)
-		pr_err("iw_cm: couldn't register netlink callbacks\n");
-
+	else
+		rdma_nl_register(RDMA_NL_IWCM, iwcm_nl_cb_table);
 	iwcm_wq = alloc_ordered_workqueue("iw_cm_wq", WQ_MEM_RECLAIM);
 	if (!iwcm_wq)
 		return -ENOMEM;
@@ -1200,7 +1196,7 @@ static void __exit iw_cm_cleanup(void)
 {
 	unregister_net_sysctl_table(iwcm_ctl_table_hdr);
 	destroy_workqueue(iwcm_wq);
-	ibnl_remove_client(RDMA_NL_IWCM);
+	rdma_nl_unregister(RDMA_NL_IWCM);
 	iwpm_exit(RDMA_NL_IWCM);
 }
 
diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index fcc9702efd38..ea5d46c34054 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -38,16 +38,13 @@
 #include <net/sock.h>
 #include <rdma/rdma_netlink.h>
 
-struct ibnl_client {
-	struct list_head		list;
-	int				index;
-	int				nops;
-	const struct ibnl_client_cbs   *cb_table;
-};
+#include "core_priv.h"
 
-static DEFINE_MUTEX(ibnl_mutex);
+static DEFINE_MUTEX(rdma_nl_mutex);
 static struct sock *nls;
-static LIST_HEAD(client_list);
+static struct {
+	const struct ibnl_client_cbs   *cb_table;
+} rdma_nl_types[RDMA_NL_NUM_CLIENTS];
 
 int ibnl_chk_listeners(unsigned int group)
 {
@@ -57,58 +54,74 @@ int ibnl_chk_listeners(unsigned int group)
 }
 EXPORT_SYMBOL(ibnl_chk_listeners);
 
-int ibnl_add_client(int index, int nops,
-		    const struct ibnl_client_cbs cb_table[])
+static bool is_nl_msg_valid(unsigned int type, unsigned int op)
 {
-	struct ibnl_client *cur;
-	struct ibnl_client *nl_client;
+	static const unsigned int max_num_ops[RDMA_NL_NUM_CLIENTS - 1] = {
+				  RDMA_NL_RDMA_CM_NUM_OPS,
+				  RDMA_NL_IWPM_NUM_OPS,
+				  0,
+				  RDMA_NL_LS_NUM_OPS,
+				  0 };
 
-	nl_client = kmalloc(sizeof *nl_client, GFP_KERNEL);
-	if (!nl_client)
-		return -ENOMEM;
+	/*
+	 * This BUILD_BUG_ON is intended to catch addition of new
+	 * RDMA netlink protocol without updating the array above.
+	 */
+	BUILD_BUG_ON(RDMA_NL_NUM_CLIENTS != 6);
 
-	nl_client->index	= index;
-	nl_client->nops		= nops;
-	nl_client->cb_table	= cb_table;
+	if (type > RDMA_NL_NUM_CLIENTS - 1)
+		return false;
 
-	mutex_lock(&ibnl_mutex);
+	return (op < max_num_ops[type - 1]) ? true : false;
+}
 
-	list_for_each_entry(cur, &client_list, list) {
-		if (cur->index == index) {
-			pr_warn("Client for %d already exists\n", index);
-			mutex_unlock(&ibnl_mutex);
-			kfree(nl_client);
-			return -EINVAL;
-		}
-	}
+static bool is_nl_valid(unsigned int type, unsigned int op)
+{
+	if (!is_nl_msg_valid(type, op) ||
+	    !rdma_nl_types[type].cb_table ||
+	    !rdma_nl_types[type].cb_table[op].dump)
+		return false;
+	return true;
+}
 
-	list_add_tail(&nl_client->list, &client_list);
+void rdma_nl_register(unsigned int index,
+		      const struct ibnl_client_cbs cb_table[])
+{
+	mutex_lock(&rdma_nl_mutex);
+	if (!is_nl_msg_valid(index, 0)) {
+		/*
+		 * All clients are not interesting in success/failure of
+		 * this call. They want to see the print to error log and
+		 * continue their initialization. Print warning for them,
+		 * because it is programmer's error to be here.
+		 */
+		mutex_unlock(&rdma_nl_mutex);
+		WARN(true,
+		     "The not-valid %u index was supplied to RDMA netlink\n",
+		     index);
+		return;
+	}
 
-	mutex_unlock(&ibnl_mutex);
+	if (rdma_nl_types[index].cb_table) {
+		mutex_unlock(&rdma_nl_mutex);
+		WARN(true,
+		     "The %u index is already registered in RDMA netlink\n",
+		     index);
+		return;
+	}
 
-	return 0;
+	rdma_nl_types[index].cb_table = cb_table;
+	mutex_unlock(&rdma_nl_mutex);
 }
-EXPORT_SYMBOL(ibnl_add_client);
+EXPORT_SYMBOL(rdma_nl_register);
 
-int ibnl_remove_client(int index)
+void rdma_nl_unregister(unsigned int index)
 {
-	struct ibnl_client *cur, *next;
-
-	mutex_lock(&ibnl_mutex);
-	list_for_each_entry_safe(cur, next, &client_list, list) {
-		if (cur->index == index) {
-			list_del(&(cur->list));
-			mutex_unlock(&ibnl_mutex);
-			kfree(cur);
-			return 0;
-		}
-	}
-	pr_warn("Can't remove callback for client idx %d. Not found\n", index);
-	mutex_unlock(&ibnl_mutex);
-
-	return -EINVAL;
+	mutex_lock(&rdma_nl_mutex);
+	rdma_nl_types[index].cb_table = NULL;
+	mutex_unlock(&rdma_nl_mutex);
 }
-EXPORT_SYMBOL(ibnl_remove_client);
+EXPORT_SYMBOL(rdma_nl_unregister);
 
 void *ibnl_put_msg(struct sk_buff *skb, struct nlmsghdr **nlh, int seq,
 		   int len, int client, int op, int flags)
@@ -149,45 +162,31 @@ EXPORT_SYMBOL(ibnl_put_attr);
 static int ibnl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 			struct netlink_ext_ack *extack)
 {
-	struct ibnl_client *client;
 	int type = nlh->nlmsg_type;
-	int index = RDMA_NL_GET_CLIENT(type);
+	unsigned int index = RDMA_NL_GET_CLIENT(type);
 	unsigned int op = RDMA_NL_GET_OP(type);
+	struct netlink_callback cb = {};
+	struct netlink_dump_control c = {};
 
-	list_for_each_entry(client, &client_list, list) {
-		if (client->index == index) {
-			if (op >= client->nops || !client->cb_table[op].dump)
-				return -EINVAL;
-
-			/*
-			 * For response or local service set_timeout request,
-			 * there is no need to use netlink_dump_start.
-			 */
-			if (!(nlh->nlmsg_flags & NLM_F_REQUEST) ||
-			    (index == RDMA_NL_LS &&
-			     op == RDMA_NL_LS_OP_SET_TIMEOUT)) {
-				struct netlink_callback cb = {
-					.skb = skb,
-					.nlh = nlh,
-					.dump = client->cb_table[op].dump,
-					.module = client->cb_table[op].module,
-				};
-
-				return cb.dump(skb, &cb);
-			}
-
-			{
-				struct netlink_dump_control c = {
-					.dump = client->cb_table[op].dump,
-					.module = client->cb_table[op].module,
-				};
-				return netlink_dump_start(nls, skb, nlh, &c);
-			}
-		}
+	if (!is_nl_valid(index, op))
+		return -EINVAL;
+
+	/*
+	 * For response or local service set_timeout request,
+	 * there is no need to use netlink_dump_start.
+	 */
+	if (!(nlh->nlmsg_flags & NLM_F_REQUEST) ||
+	    (index == RDMA_NL_LS && op == RDMA_NL_LS_OP_SET_TIMEOUT)) {
+		cb.skb = skb;
+		cb.nlh = nlh;
+		cb.dump = rdma_nl_types[index].cb_table[op].dump;
+		cb.module = rdma_nl_types[index].cb_table[op].module;
+		return cb.dump(skb, &cb);
 	}
 
-	pr_info("Index %d wasn't found in client list\n", index);
-	return -EINVAL;
+	c.dump = rdma_nl_types[index].cb_table[op].dump;
+	c.module = rdma_nl_types[index].cb_table[op].module;
+	return netlink_dump_start(nls, skb, nlh, &c);
 }
 
 static void ibnl_rcv_reply_skb(struct sk_buff *skb)
@@ -221,10 +220,10 @@ static void ibnl_rcv_reply_skb(struct sk_buff *skb)
 
 static void ibnl_rcv(struct sk_buff *skb)
 {
-	mutex_lock(&ibnl_mutex);
+	mutex_lock(&rdma_nl_mutex);
 	ibnl_rcv_reply_skb(skb);
 	netlink_rcv_skb(skb, &ibnl_rcv_msg);
-	mutex_unlock(&ibnl_mutex);
+	mutex_unlock(&rdma_nl_mutex);
 }
 
 int ibnl_unicast(struct sk_buff *skb, struct nlmsghdr *nlh,
@@ -241,31 +240,25 @@ int ibnl_multicast(struct sk_buff *skb, struct nlmsghdr *nlh,
 }
 EXPORT_SYMBOL(ibnl_multicast);
 
-int __init ibnl_init(void)
+int __init rdma_nl_init(void)
 {
 	struct netlink_kernel_cfg cfg = {
 		.input	= ibnl_rcv,
 	};
 
 	nls = netlink_kernel_create(&init_net, NETLINK_RDMA, &cfg);
-	if (!nls) {
-		pr_warn("Failed to create netlink socket\n");
+	if (!nls)
 		return -ENOMEM;
-	}
 
 	return 0;
 }
 
-void ibnl_cleanup(void)
+void rdma_nl_exit(void)
 {
-	struct ibnl_client *cur, *next;
+	int idx;
 
-	mutex_lock(&ibnl_mutex);
-	list_for_each_entry_safe(cur, next, &client_list, list) {
-		list_del(&(cur->list));
-		kfree(cur);
-	}
-	mutex_unlock(&ibnl_mutex);
+	for (idx = 0; idx < RDMA_NL_NUM_CLIENTS; idx++)
+		rdma_nl_unregister(idx);
 
 	netlink_kernel_release(nls);
 }
diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index 585266144329..6735dcf5d2a3 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -10,27 +10,22 @@ struct ibnl_client_cbs {
 	struct module *module;
 };
 
-int ibnl_init(void);
-void ibnl_cleanup(void);
+int rdma_nl_init(void);
+void rdma_nl_exit(void);
 
 /**
- * Add a a client to the list of IB netlink exporters.
+ * Register client in RDMA netlink.
  * @index: Index of the added client
- * @nops: Number of supported ops by the added client.
  * @cb_table: A table for op->callback
- *
- * Returns 0 on success or a negative error code.
  */
-int ibnl_add_client(int index, int nops,
-		    const struct ibnl_client_cbs cb_table[]);
+void rdma_nl_register(unsigned int index,
+		      const struct ibnl_client_cbs cb_table[]);
 
 /**
  * Remove a client from IB netlink.
  * @index: Index of the removed IB client.
- *
- * Returns 0 on success or a negative error code.
  */
-int ibnl_remove_client(int index);
+void rdma_nl_unregister(unsigned int index);
 
 /**
  * Put a new message in a supplied skb.
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
