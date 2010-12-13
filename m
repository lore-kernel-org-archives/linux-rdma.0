From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 6/6] RDMA CM: Netlink Client
Date: Mon, 13 Dec 2010 18:22:50 +0200
Message-ID: <1292257370-24391-7-git-send-email-nirm@voltaire.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292257370-24391-1-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org, nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Add callbacks and data types for statistics export.
One callback is implemented that exports all of the current devices/ids.
Add/remove the callback to IB Netlink on init/cleanup.

Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |   77 +++++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_netlink.h     |   15 ++++++++
 include/rdma/rdma_cm.h        |   10 +++++
 3 files changed, 102 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 9629a90..e3280d3 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -51,6 +51,7 @@
 #include <rdma/ib_cm.h>
 #include <rdma/ib_sa.h>
 #include <rdma/iw_cm.h>
+#include <rdma/ib_netlink.h>
 
 MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("Generic RDMA CM Agent");
@@ -3251,6 +3252,79 @@ static void cma_remove_one(struct ib_device *device)
 	kfree(cma_dev);
 }
 
+static int cma_get_id_stats(struct sk_buff *skb, struct netlink_callback *cb)
+{
+	struct nlmsghdr *nlh;
+	struct rdma_cm_id_stats *id_stats;
+	struct rdma_id_private *id_priv;
+	struct rdma_cm_id *id = NULL;
+	struct cma_device *cma_dev;
+	int i_dev, i_id;
+
+	/* We export all of the id's as a sequence of messages.
+	   Each id gets its own netlink message */	
+	mutex_lock(&lock);
+	i_dev = 0;
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
+			id_stats->nt = id->route.addr.dev_addr.dev_type;
+			id_stats->port_num = id->port_num;
+			id_stats->bound_dev_if =
+				id->route.addr.dev_addr.bound_dev_if;
+
+			if (ibnl_put_attr(skb, nlh,
+					  sizeof id->route.addr.src_addr,
+					  &id->route.addr.src_addr,
+					  IBNL_RDMA_CM_ATTR_SRC_ADDR)) {
+				goto out;
+			}
+
+			if (ibnl_put_attr(skb, nlh,
+					  sizeof id->route.addr.dst_addr,
+					  &id->route.addr.dst_addr,
+					  IBNL_RDMA_CM_ATTR_DST_ADDR)) {
+				goto out;
+			}
+
+			id_stats->ps = id->ps;
+			id_stats->cm_state = id_priv->state;
+			id_stats->qp_num = id_priv->qp_num;
+			id_stats->pid = id_priv->owner;
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
+static int (*cma_cb_table[])(struct sk_buff *skb,
+			     struct netlink_callback *cb) = {
+	[IBNL_RDMA_CM_ID_STATS] = cma_get_id_stats,
+};
+
 static int __init cma_init(void)
 {
 	int ret;
@@ -3266,6 +3340,8 @@ static int __init cma_init(void)
 	ret = ib_register_client(&cma_client);
 	if (ret)
 		goto err;
+	if (ibnl_add_client(IBNL_RDMA_CM, IBNL_RDMA_CM_NUM_OPS, cma_cb_table))
+		printk(KERN_WARNING "RDMA CM failed to add netlink callback\n");
 	return 0;
 
 err:
@@ -3278,6 +3354,7 @@ err:
 
 static void __exit cma_cleanup(void)
 {
+	ibnl_remove_client(IBNL_RDMA_CM);
 	ib_unregister_client(&cma_client);
 	unregister_netdevice_notifier(&cma_nb);
 	rdma_addr_unregister_client(&addr_client);
diff --git a/include/rdma/ib_netlink.h b/include/rdma/ib_netlink.h
index 0db338c..470318f 100644
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
index c766da9..ec47f11 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -147,6 +147,16 @@ struct rdma_cm_id {
 	u8			 port_num;
 };
 
+struct rdma_cm_id_stats {
+	u8 nt;
+	u8 port_num;
+	u32 bound_dev_if;
+	u32 ps;
+	u8 cm_state;
+	u32 qp_num;
+	pid_t pid;
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
