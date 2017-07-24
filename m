From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 2/3] rdma: Autoload netlink client modules
Date: Mon, 24 Jul 2017 16:26:43 -0600
Message-ID: <1500935204-6505-3-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1500935204-6505-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1500935204-6505-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <notifications-9UaJU3cA/F/QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If a message comes in and we do not have the client in the table, then
try to load the module supplying that client using MODULE_ALIAS to find
it.

This duplicates the scheme seen in other netlink muxes (eg nfnetlink).

Factor out ibnl_find_client since this creates a 3rd copy of the pattern.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 drivers/infiniband/core/cma.c     |  2 +
 drivers/infiniband/core/device.c  |  2 +
 drivers/infiniband/core/iwcm.c    |  2 +
 drivers/infiniband/core/netlink.c | 96 ++++++++++++++++++++++-----------------
 include/rdma/rdma_netlink.h       | 12 +++++
 5 files changed, 73 insertions(+), 41 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 0eb393237ba2fc..f63a11e31ec988 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4534,5 +4534,7 @@ static void __exit cma_cleanup(void)
 	destroy_workqueue(cma_wq);
 }
 
+MODULE_ALIAS_RDMA_NETLINK(RDMA_NL_RDMA_CM, 1);
+
 module_init(cma_init);
 module_exit(cma_cleanup);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index a5dfab6adf495b..6630b334ae7526 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1204,5 +1204,7 @@ static void __exit ib_core_cleanup(void)
 	destroy_workqueue(ib_wq);
 }
 
+MODULE_ALIAS_RDMA_NETLINK(RDMA_NL_LS, 4);
+
 module_init(ib_core_init);
 module_exit(ib_core_cleanup);
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 31661b5c174364..51585a8e467a56 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -1204,5 +1204,7 @@ static void __exit iw_cm_cleanup(void)
 	iwpm_exit(RDMA_NL_IWCM);
 }
 
+MODULE_ALIAS_RDMA_NETLINK(RDMA_NL_IWCM, 2);
+
 module_init(iw_cm_init);
 module_exit(iw_cm_cleanup);
diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index 1165fe81d104a3..36141b9457f0e6 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -51,6 +51,18 @@ static DEFINE_MUTEX(ibnl_mutex);
 static struct sock *nls;
 static LIST_HEAD(client_list);
 
+static struct ibnl_client *ibnl_find_client(int index)
+{
+	struct ibnl_client *client;
+
+	list_for_each_entry_rcu(client, &client_list, list) {
+		if (client->index == index)
+			return client;
+	}
+
+	return NULL;
+}
+
 int ibnl_chk_listeners(unsigned int group)
 {
 	if (netlink_has_listeners(nls, group) == 0)
@@ -61,7 +73,6 @@ int ibnl_chk_listeners(unsigned int group)
 int ibnl_add_client(int index, int nops,
 		    const struct ibnl_client_cbs cb_table[])
 {
-	struct ibnl_client *cur;
 	struct ibnl_client *nl_client;
 
 	nl_client = kmalloc(sizeof *nl_client, GFP_KERNEL);
@@ -73,14 +84,11 @@ int ibnl_add_client(int index, int nops,
 	nl_client->cb_table	= cb_table;
 
 	mutex_lock(&ibnl_mutex);
-
-	list_for_each_entry(cur, &client_list, list) {
-		if (cur->index == index) {
-			pr_warn("Client for %d already exists\n", index);
-			mutex_unlock(&ibnl_mutex);
-			kfree(nl_client);
-			return -EINVAL;
-		}
+	if (ibnl_find_client(index)) {
+		pr_warn("Client for %d already exists\n", index);
+		mutex_unlock(&ibnl_mutex);
+		kfree(nl_client);
+		return -EINVAL;
 	}
 
 	list_add_tail(&nl_client->list, &client_list);
@@ -155,40 +163,46 @@ static int ibnl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 	int index = RDMA_NL_GET_CLIENT(type);
 	unsigned int op = RDMA_NL_GET_OP(type);
 
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
+	client = ibnl_find_client(index);
+#ifdef CONFIG_MODULES
+	if (!client) {
+		mutex_unlock(&ibnl_mutex);
+		request_module("rdma_netlink_subsys-%d", index);
+		mutex_lock(&ibnl_mutex);
+		client = ibnl_find_client(index);
+	}
+#endif
+	if (!client) {
+		pr_info("Index %d wasn't found in client list\n", index);
+		return -EINVAL;
 	}
 
-	pr_info("Index %d wasn't found in client list\n", index);
-	return -EINVAL;
+	if (op >= client->nops || !client->cb_table[op].dump)
+		return -EINVAL;
+
+	/*
+	 * For response or local service set_timeout request,
+	 * there is no need to use netlink_dump_start.
+	 */
+	if (!(nlh->nlmsg_flags & NLM_F_REQUEST) ||
+	    (index == RDMA_NL_LS && op == RDMA_NL_LS_OP_SET_TIMEOUT)) {
+		struct netlink_callback cb = {
+		    .skb = skb,
+		    .nlh = nlh,
+		    .dump = client->cb_table[op].dump,
+		    .module = client->cb_table[op].module,
+		};
+
+		return cb.dump(skb, &cb);
+	}
+
+	{
+		struct netlink_dump_control c = {
+		    .dump = client->cb_table[op].dump,
+		    .module = client->cb_table[op].module,
+		};
+		return netlink_dump_start(nls, skb, nlh, &c);
+	}
 }
 
 static void ibnl_rcv_reply_skb(struct sk_buff *skb)
diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index 348c102cb5f6af..5b2e813592199a 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -10,6 +10,18 @@ struct ibnl_client_cbs {
 	struct module *module;
 };
 
+/* Define this module as providing netlinkg services for NETLINK_RDMA, client
+ * index _index.  Since the client indexes were setup in a uapi header as an
+ * enum and we do no want to change that, the user must supply the expanded
+ * constant as well and the compiler checks they are the same.
+ */
+#define MODULE_ALIAS_RDMA_NETLINK(_index, _val)                                \
+	static inline void __chk_##_index(void)                                \
+	{                                                                      \
+		BUILD_BUG_ON(_index != _val);                                  \
+	}                                                                      \
+	MODULE_ALIAS("rdma_netlink_subsys-" __stringify(_val))
+
 /**
  * Add a a client to the list of IB netlink exporters.
  * @index: Index of the added client
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
