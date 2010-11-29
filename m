From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 5/5] RDMA CM: Netlink Client
Date: Mon, 29 Nov 2010 18:16:39 +0200
Message-ID: <1291047399-430-6-git-send-email-nirm@voltaire.com>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291047399-430-1-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org, nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add callbacks and data types for statistics export.
One callback is implemented that exports all of the current devices/ids.
Add/remove the callback to IB Netlink on init/cleanup.

Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |   97 +++++++++++++++++++++++++++++++++++++++++
 include/rdma/rdma_cm.h        |   14 ++++++
 2 files changed, 111 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 5821f93..9c6ce73 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -51,6 +51,7 @@
 #include <rdma/ib_cm.h>
 #include <rdma/ib_sa.h>
 #include <rdma/iw_cm.h>
+#include <rdma/ib_netlink.h>
 
 MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("Generic RDMA CM Agent");
@@ -134,6 +135,7 @@ struct rdma_id_private {
 	u32			qp_num;
 	u8			srq;
 	u8			tos;
+	pid_t			owner;
 };
 
 struct cma_multicast {
@@ -418,6 +420,7 @@ struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
 	if (!id_priv)
 		return ERR_PTR(-ENOMEM);
 
+	id_priv->owner = current->pid;
 	id_priv->state = RDMA_CM_IDLE;
 	id_priv->id.context = context;
 	id_priv->id.event_handler = event_handler;
@@ -2671,8 +2674,14 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 {
 	struct rdma_id_private *id_priv;
 	int ret;
+	unsigned long flags;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
+
+	spin_lock_irqsave(&id_priv->lock, flags);
+	id_priv->owner = current->pid;
+	spin_unlock_irqrestore(&id_priv->lock, flags);
+
 	if (!cma_comp(id_priv, RDMA_CM_CONNECT))
 		return -EINVAL;
 
@@ -3243,6 +3252,91 @@ static void cma_remove_one(struct ib_device *device)
 	kfree(cma_dev);
 }
 
+static int cma_get_stats(struct sk_buff **nl_skb, int pid)
+{
+	struct rdma_cm_id_stats *id_stats;
+	struct rdma_id_private *id_priv;
+	struct rdma_cm_id *id = NULL;
+	struct cma_device *cma_dev;
+	char *dev_name;
+	struct sockaddr_in *src, *dst;
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+	struct sockaddr_in6 *src6, *dst6;
+#endif
+	int seq = 0;
+
+	mutex_lock(&lock);
+	list_for_each_entry(cma_dev, &dev_list, list) {
+		dev_name = ibnl_put(nl_skb, pid, seq++,
+				    strlen(cma_dev->device->name) + 1,
+				    IBNL_RDMA_CM,
+				    IBNL_RDMA_CM_DEVICE_NAME);
+		if (!dev_name)
+			goto errmem;
+		strcpy(dev_name, cma_dev->device->name);
+		list_for_each_entry(id_priv, &cma_dev->id_list, list) {
+			id_stats = ibnl_put(nl_skb, pid, seq++,
+					    sizeof *id_stats, IBNL_RDMA_CM,
+					    IBNL_RDMA_CM_ID_STATS);
+			if (!id_stats)
+				goto errmem;
+			memset(id_stats, 0, sizeof *id_stats);
+			id = &id_priv->id;
+			id_stats->nt = id->route.addr.dev_addr.dev_type;
+			id_stats->port_num = id->port_num;
+			id_stats->bound_dev_if =
+				id->route.addr.dev_addr.bound_dev_if;
+
+			if (id->route.addr.src_addr.ss_family == AF_INET &&
+			    id->route.addr.dst_addr.ss_family == AF_INET) {
+				src = (struct sockaddr_in *)
+					(&id->route.addr.src_addr);
+				dst = (struct sockaddr_in *)
+					(&id->route.addr.dst_addr);
+				id_stats->local_port = src->sin_port;
+				id_stats->remote_port = dst->sin_port;
+				id_stats->local_addr[0] = src->sin_addr.s_addr;
+				id_stats->remote_addr[0] = dst->sin_addr.s_addr;
+			}
+
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+			if (id->route.addr.src_addr.ss_family == AF_INET6 &&
+			    id->route.addr.dst_addr.ss_family == AF_INET6) {
+				src6 = (struct sockaddr_in6 *)
+					(&id->route.addr.src_addr);
+				dst6 = (struct sockaddr_in6 *)
+					(&id->route.addr.dst_addr);
+
+				ipv6_addr_copy((struct in6_addr *)
+					       (id_stats->local_addr),
+					       &src6->sin6_addr);
+				ipv6_addr_copy((struct in6_addr *)
+					       (id_stats->remote_addr),
+					       &dst6->sin6_addr);
+			}
+#endif
+			id_stats->ps = id->ps;
+			id_stats->cm_state = id_priv->state;
+			id_stats->qp_num = id_priv->qp_num;
+			id_stats->pid = id_priv->owner;
+		}
+	}
+	mutex_unlock(&lock);
+	return 0;
+errmem:
+	printk(KERN_INFO "RDMA CM failed to export data.\n");
+	mutex_unlock(&lock);
+	return -ENOMEM;
+}
+
+static int cma_get_data(int op, struct sk_buff **nl_skb, int pid)
+{
+	if (op == IBNL_RDMA_CM_STATS)
+		return cma_get_stats(nl_skb, pid);
+	printk(KERN_NOTICE "RDMA CM Invalid netlink operation (%d)\n", op);
+	return -EINVAL;
+}
+
 static int __init cma_init(void)
 {
 	int ret;
@@ -3258,6 +3352,8 @@ static int __init cma_init(void)
 	ret = ib_register_client(&cma_client);
 	if (ret)
 		goto err;
+	if (ibnl_add_cb(IBNL_RDMA_CM, cma_get_data))
+		printk(KERN_WARNING "RDMA CM failed to add netlink callback\n");
 	return 0;
 
 err:
@@ -3270,6 +3366,7 @@ err:
 
 static void __exit cma_cleanup(void)
 {
+	ibnl_remove_cb(IBNL_RDMA_CM);
 	ib_unregister_client(&cma_client);
 	unregister_netdevice_notifier(&cma_nb);
 	rdma_addr_unregister_client(&addr_client);
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index c766da9..7f341bb 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -147,6 +147,20 @@ struct rdma_cm_id {
 	u8			 port_num;
 };
 
+struct rdma_cm_id_stats {
+	enum rdma_node_type nt;
+	int port_num;
+	int bound_dev_if;
+	__be16	local_port;
+	__be16	remote_port;
+	__be32	local_addr[4];
+	__be32	remote_addr[4];
+	enum rdma_port_space ps;
+	enum rdma_cm_state cm_state;
+	u32 qp_num;
+	pid_t pid;
+};
+
 /**
  * rdma_create_id - Create an RDMA identifier.
  *
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
