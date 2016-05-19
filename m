From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [rdma-next,V2 5/6] IB/core: Register SA ibnl client during ib_core initialization
Date: Thu, 19 May 2016 17:12:35 +0300
Message-ID: <1463667156-6518-6-git-send-email-leonro@mellanox.com>
References: <1463667156-6518-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463667156-6518-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Move SA ibnl client registration to ib_core module init.
This will allow us to register a single client to handle
all RDMA_NL_LS operations and make it none SA independent.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/core_priv.h |  5 +++++
 drivers/infiniband/core/device.c    | 28 ++++++++++++++++++++++++++++
 drivers/infiniband/core/sa_query.c  | 27 +++++----------------------
 3 files changed, 38 insertions(+), 22 deletions(-)

diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index c78a7fa..1ff3345 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -146,4 +146,9 @@ void ib_mad_cleanup(void);
 int ib_sa_init(void);
 void ib_sa_cleanup(void);
 
+int ib_nl_handle_resolve_resp(struct sk_buff *skb,
+			      struct netlink_callback *cb);
+int ib_nl_handle_set_timeout(struct sk_buff *skb,
+			     struct netlink_callback *cb);
+
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 300b92c..fa38e50 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -955,6 +955,26 @@ struct net_device *ib_get_net_dev_by_params(struct ib_device *dev,
 }
 EXPORT_SYMBOL(ib_get_net_dev_by_params);
 
+static struct ibnl_client_cbs ibnl_ls_cb_table[] = {
+	[RDMA_NL_LS_OP_RESOLVE] = {
+		.dump = ib_nl_handle_resolve_resp,
+		.module = THIS_MODULE },
+	[RDMA_NL_LS_OP_SET_TIMEOUT] = {
+		.dump = ib_nl_handle_set_timeout,
+		.module = THIS_MODULE },
+};
+
+static int ib_add_ibnl_clients(void)
+{
+	return ibnl_add_client(RDMA_NL_LS, ARRAY_SIZE(ibnl_ls_cb_table),
+			       ibnl_ls_cb_table);
+}
+
+static void ib_remove_ibnl_clients(void)
+{
+	ibnl_remove_client(RDMA_NL_LS);
+}
+
 static int __init ib_core_init(void)
 {
 	int ret;
@@ -1001,10 +1021,17 @@ static int __init ib_core_init(void)
 		goto err_mad;
 	}
 
+	if (ib_add_ibnl_clients()) {
+		pr_warn("Couldn't register ibnl clients\n");
+		goto err_sa;
+	}
+
 	ib_cache_setup();
 
 	return 0;
 
+err_sa:
+	ib_sa_cleanup();
 err_mad:
 	ib_mad_cleanup();
 err_addr:
@@ -1023,6 +1050,7 @@ err:
 static void __exit ib_core_cleanup(void)
 {
 	ib_cache_cleanup();
+	ib_remove_ibnl_clients();
 	ib_mad_cleanup();
 	ib_sa_cleanup();
 	addr_cleanup();
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index db3c92d..8bd61a61 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -701,8 +701,8 @@ static void ib_nl_request_timeout(struct work_struct *work)
 	spin_unlock_irqrestore(&ib_nl_request_lock, flags);
 }
 
-static int ib_nl_handle_set_timeout(struct sk_buff *skb,
-				    struct netlink_callback *cb)
+int ib_nl_handle_set_timeout(struct sk_buff *skb,
+			     struct netlink_callback *cb)
 {
 	const struct nlmsghdr *nlh = (struct nlmsghdr *)cb->nlh;
 	int timeout, delta, abs_delta;
@@ -778,8 +778,8 @@ static inline int ib_nl_is_good_resolve_resp(const struct nlmsghdr *nlh)
 	return 1;
 }
 
-static int ib_nl_handle_resolve_resp(struct sk_buff *skb,
-				     struct netlink_callback *cb)
+int ib_nl_handle_resolve_resp(struct sk_buff *skb,
+			      struct netlink_callback *cb)
 {
 	const struct nlmsghdr *nlh = (struct nlmsghdr *)cb->nlh;
 	unsigned long flags;
@@ -834,15 +834,6 @@ resp_out:
 	return skb->len;
 }
 
-static struct ibnl_client_cbs ib_sa_cb_table[] = {
-	[RDMA_NL_LS_OP_RESOLVE] = {
-		.dump = ib_nl_handle_resolve_resp,
-		.module = THIS_MODULE },
-	[RDMA_NL_LS_OP_SET_TIMEOUT] = {
-		.dump = ib_nl_handle_set_timeout,
-		.module = THIS_MODULE },
-};
-
 static void free_sm_ah(struct kref *kref)
 {
 	struct ib_sa_sm_ah *sm_ah = container_of(kref, struct ib_sa_sm_ah, ref);
@@ -1816,17 +1807,10 @@ int ib_sa_init(void)
 		goto err3;
 	}
 
-	if (ibnl_add_client(RDMA_NL_LS, ARRAY_SIZE(ib_sa_cb_table),
-			    ib_sa_cb_table)) {
-		pr_err("Failed to add netlink callback\n");
-		ret = -EINVAL;
-		goto err4;
-	}
 	INIT_DELAYED_WORK(&ib_nl_timed_work, ib_nl_request_timeout);
 
 	return 0;
-err4:
-	destroy_workqueue(ib_nl_wq);
+
 err3:
 	mcast_cleanup();
 err2:
@@ -1837,7 +1821,6 @@ err1:
 
 void ib_sa_cleanup(void)
 {
-	ibnl_remove_client(RDMA_NL_LS);
 	cancel_delayed_work(&ib_nl_timed_work);
 	flush_workqueue(ib_nl_wq);
 	destroy_workqueue(ib_nl_wq);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
