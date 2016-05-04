From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/4] IB/netlink: Allow multiple clients to register under the same family
Date: Wed,  4 May 2016 18:41:56 +0300
Message-ID: <1462376518-6725-3-git-send-email-leon@kernel.org>
References: <1462376518-6725-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462376518-6725-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

This commit adds the ability for multiple clients to register to the same
family. We will allow this only if there isn't an overlap between them.
If there is an overlap, we will fail the latest client registration.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cma.c      |  3 ++-
 drivers/infiniband/core/iwcm.c     |  3 ++-
 drivers/infiniband/core/netlink.c  | 37 ++++++++++++++++++++++++++-----------
 drivers/infiniband/core/sa_query.c |  2 +-
 include/rdma/rdma_netlink.h        |  7 +++++--
 5 files changed, 36 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 09a0243..8d93ab1 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4312,7 +4312,8 @@ err_wq:
 static void __exit cma_cleanup(void)
 {
 	cma_configfs_exit();
-	ibnl_remove_client(RDMA_NL_RDMA_CM);
+	ibnl_remove_client(RDMA_NL_RDMA_CM,
+			   RDMA_NL_RDMA_CM_NUM_OPS, cma_cb_table);
 	ib_unregister_client(&cma_client);
 	unregister_netdevice_notifier(&cma_nb);
 	rdma_addr_unregister_client(&addr_client);
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 5011ecf..0efa1e7 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -1199,7 +1199,8 @@ static void __exit iw_cm_cleanup(void)
 {
 	unregister_net_sysctl_table(iwcm_ctl_table_hdr);
 	destroy_workqueue(iwcm_wq);
-	ibnl_remove_client(RDMA_NL_IWCM);
+	ibnl_remove_client(RDMA_NL_IWCM, RDMA_NL_IWPM_NUM_OPS,
+			   iwcm_nl_cb_table);
 	iwpm_exit(RDMA_NL_IWCM);
 }
 
diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index ff2dcbb..06e9de0 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -66,6 +66,7 @@ int ibnl_add_client(int index, int nops,
 {
 	struct ibnl_client *cur;
 	struct ibnl_client *nl_client;
+	int i;
 
 	nl_client = kmalloc(sizeof *nl_client, GFP_KERNEL);
 	if (!nl_client)
@@ -79,10 +80,15 @@ int ibnl_add_client(int index, int nops,
 
 	list_for_each_entry(cur, &client_list, list) {
 		if (cur->index == index) {
-			pr_warn("Client for %d already exists\n", index);
-			mutex_unlock(&ibnl_mutex);
-			kfree(nl_client);
-			return -EINVAL;
+			for (i = 0; i < min(nops, cur->nops); i++) {
+				if (cur->cb_table[i].dump &&
+				    cb_table[i].dump) {
+					pr_warn("Client for %d already exists\n", index);
+					mutex_unlock(&ibnl_mutex);
+					kfree(nl_client);
+					return -EINVAL;
+				}
+			}
 		}
 	}
 
@@ -94,17 +100,24 @@ int ibnl_add_client(int index, int nops,
 }
 EXPORT_SYMBOL(ibnl_add_client);
 
-int ibnl_remove_client(int index)
+int ibnl_remove_client(int index, int nops,
+		       const struct ibnl_client_cbs cb_table[])
 {
 	struct ibnl_client *cur, *next;
+	int i;
 
 	mutex_lock(&ibnl_mutex);
 	list_for_each_entry_safe(cur, next, &client_list, list) {
-		if (cur->index == index) {
-			list_del(&(cur->list));
-			mutex_unlock(&ibnl_mutex);
-			kfree(cur);
-			return 0;
+		if (cur->index == index && cur->nops == nops) {
+			for (i = 0; i < nops; i++) {
+				if (cb_table[i].dump &&
+				    cur->cb_table[i].dump) {
+					list_del(&cur->list);
+					mutex_unlock(&ibnl_mutex);
+					kfree(cur);
+					return 0;
+				}
+			}
 		}
 	}
 	pr_warn("Can't remove callback for client idx %d. Not found\n", index);
@@ -159,9 +172,11 @@ static int ibnl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh)
 
 	list_for_each_entry(client, &client_list, list) {
 		if (client->index == index) {
-			if (op >= client->nops || !client->cb_table[op].dump)
+			if (op >= client->nops)
 				return -EINVAL;
 
+			if (!client->cb_table[op].dump)
+				continue;
 			/*
 			 * For response or local service set_timeout request,
 			 * there is no need to use netlink_dump_start.
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 5050c61..62dc8dd 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -1841,7 +1841,7 @@ err1:
 
 static void __exit ib_sa_cleanup(void)
 {
-	ibnl_remove_client(RDMA_NL_LS);
+	ibnl_remove_client(RDMA_NL_LS, RDMA_NL_LS_NUM_OPS, ib_sa_cb_table);
 	cancel_delayed_work(&ib_nl_timed_work);
 	flush_workqueue(ib_nl_wq);
 	destroy_workqueue(ib_nl_wq);
diff --git a/include/rdma/rdma_netlink.h b/include/rdma/rdma_netlink.h
index 5852661..c8aef66 100644
--- a/include/rdma/rdma_netlink.h
+++ b/include/rdma/rdma_netlink.h
@@ -16,7 +16,7 @@ void ibnl_cleanup(void);
 /**
  * Add a a client to the list of IB netlink exporters.
  * @index: Index of the added client
- * @nops: Number of supported ops by the added client.
+ * @nops: Number of max supported ops by the added client.
  * @cb_table: A table for op->callback
  *
  * Returns 0 on success or a negative error code.
@@ -27,10 +27,13 @@ int ibnl_add_client(int index, int nops,
 /**
  * Remove a client from IB netlink.
  * @index: Index of the removed IB client.
+ * @nops: Number of max supported ops by the added client.
+ * @cb_table: A table for op->callback
  *
  * Returns 0 on success or a negative error code.
  */
-int ibnl_remove_client(int index);
+int ibnl_remove_client(int index, int nops,
+		       const struct ibnl_client_cbs cb_table[]);
 
 /**
  * Put a new message in a supplied skb.
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
