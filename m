From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V4 5/6] RDMA CM: Netlink Client
Date: Mon, 3 Jan 2011 17:33:53 +0200
Message-ID: <1294068834-17778-6-git-send-email-nirm@voltaire.com>
References: <1294068834-17778-1-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1294068834-17778-1-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add callbacks and data types for statistics export.
One callback is implemented that exports all of the current devices/ids.
Add/remove the callback to IB Netlink on init/cleanup.

Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |   91 +++++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_netlink.h     |   15 +++++++
 include/rdma/rdma_cm.h        |   11 +++++
 3 files changed, 117 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 5821f93..6436995 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -51,6 +51,7 @@
 #include <rdma/ib_cm.h>
 #include <rdma/ib_sa.h>
 #include <rdma/iw_cm.h>
+#include <rdma/ib_netlink.h>
 
 MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("Generic RDMA CM Agent");
@@ -3243,6 +3244,93 @@ static void cma_remove_one(struct ib_device *device)
 	kfree(cma_dev);
 }
 
+static int cma_get_id_stats(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct nlmsghdr *nlh;
+	struct rdma_cm_id_stats *id_stats;
+	struct rdma_id_private *id_priv;
+	struct rdma_cm_id *id = NULL;
+	struct cma_device *cma_dev;
+	int i_dev = 0, i_id = 0;
+
+	/* We export all of the id's as a sequence of messages.
+	   Each id gets its own netlink message */
+	mutex_lock(&lock);
+	list_for_each_entry(cma_dev, &dev_list, list) {
+		if (i_dev < cb->args[0]) {
+			i_dev++;
+			continue;
+		}
+		i_id = 0;
+		list_for_each_entry(id_priv, &cma_dev->id_list, list) {
+			if (i_id < cb->args[1]) {
+				i_id++;
+				continue;
+			}
+			id_stats = ibnl_put_msg(skb, &nlh, cb->nlh->nlmsg_seq,
+						sizeof *id_stats, IBNL_RDMA_CM,
+						IBNL_RDMA_CM_ID_STATS);
+			if (!id_stats)
+				goto out;
+			memset(id_stats, 0, sizeof *id_stats);
+			id = &id_priv->id;
+			id_stats->node_type = id->route.addr.dev_addr.dev_type;
+			id_stats->port_num = id->port_num;
+			id_stats->bound_dev_if =
+				id->route.addr.dev_addr.bound_dev_if;
+
+			if (id->route.addr.src_addr.ss_family == AF_INET) {
+				if (ibnl_put_attr(skb, nlh,
+						  sizeof(struct sockaddr_in),
+						  &id->route.addr.src_addr,
+						  IBNL_RDMA_CM_ATTR_SRC_ADDR)) {
+					goto out;
+				}
+				if (ibnl_put_attr(skb, nlh,
+						  sizeof(struct sockaddr_in),
+						  &id->route.addr.dst_addr,
+						  IBNL_RDMA_CM_ATTR_DST_ADDR)) {
+					goto out;
+				}
+			}
+#if defined(CONFIG_IPV6) || defined(CONFIG_IPV6_MODULE)
+			else if (id->route.addr.src_addr.ss_family ==
+				 AF_INET6) {
+				if (ibnl_put_attr(skb, nlh,
+						  sizeof(struct sockaddr_in6),
+						  &id->route.addr.src_addr,
+						  IBNL_RDMA_CM_ATTR_SRC_ADDR)) {
+					goto out;
+				}
+				if (ibnl_put_attr(skb, nlh,
+						  sizeof(struct sockaddr_in6),
+						  &id->route.addr.dst_addr,
+						  IBNL_RDMA_CM_ATTR_DST_ADDR)) {
+					goto out;
+				}
+			}
+#endif
+			id_stats->port_space = id->ps;
+			id_stats->cm_state = id_priv->state;
+			id_stats->qp_num = id_priv->qp_num;
+
+			i_id++;
+		}
+		cb->args[1] = 0;
+		i_dev++;
+	}
+out:
+	mutex_unlock(&lock);
+	cb->args[0] = i_dev;
+	cb->args[1] = i_id;
+
+	return skb->len;
+}
+
+static const struct ibnl_client_cbs cma_cb_table[] = {
+	[IBNL_RDMA_CM_ID_STATS] = {.dump = cma_get_id_stats},
+};
+
 static int __init cma_init(void)
 {
 	int ret;
@@ -3258,6 +3346,8 @@ static int __init cma_init(void)
 	ret = ib_register_client(&cma_client);
 	if (ret)
 		goto err;
+	if (ibnl_add_client(IBNL_RDMA_CM, IBNL_RDMA_CM_NUM_OPS, cma_cb_table))
+		printk(KERN_WARNING "RDMA CM failed to add netlink callback\n");
 	return 0;
 
 err:
@@ -3270,6 +3360,7 @@ err:
 
 static void __exit cma_cleanup(void)
 {
+	ibnl_remove_client(IBNL_RDMA_CM);
 	ib_unregister_client(&cma_client);
 	unregister_netdevice_notifier(&cma_nb);
 	rdma_addr_unregister_client(&addr_client);
diff --git a/include/rdma/ib_netlink.h b/include/rdma/ib_netlink.h
index 1ef76d0..1ce6ed8 100644
--- a/include/rdma/ib_netlink.h
+++ b/include/rdma/ib_netlink.h
@@ -1,6 +1,21 @@
 #ifndef _IBNETLINK_H
 #define _IBNETLINK_H
 
+enum {
+	IBNL_RDMA_CM = 1
+};
+
+enum {
+	IBNL_RDMA_CM_ID_STATS = 0,
+	IBNL_RDMA_CM_NUM_OPS
+};
+
+enum {
+	IBNL_RDMA_CM_ATTR_SRC_ADDR = 1,
+	IBNL_RDMA_CM_ATTR_DST_ADDR,
+	IBNL_RDMA_CM_NUM_ATTR,
+};
+
 #define IBNL_GET_CLIENT(type) ((type & (((1 << 6) - 1) << 10)) >> 10)
 #define IBNL_GET_OP(type) (type & ((1 << 10) - 1))
 #define IBNL_GET_TYPE(client, op) ((client << 10) + op)
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index c766da9..66b776e 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -147,6 +147,17 @@ struct rdma_cm_id {
 	u8			 port_num;
 };
 
+struct rdma_cm_id_stats {
+	__u32 qp_num;
+	__u32 bound_dev_if;
+	__u32 port_space;
+	__s32 pid;
+	__u8 cm_state;
+	__u8 node_type;
+	__u8 port_num;
+	__u8 reserved;
+};
+
 /**
  * rdma_create_id - Create an RDMA identifier.
  *
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
