From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [RFC PATCH] RDMA/cma: Remove netlink interface of CMA statistics
Date: Mon, 13 Nov 2017 16:40:24 +0200
Message-ID: <20171113144024.26655-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

CMA statistics were exposed to users through netlink interface long time
ago, but it wasn't exposed using netlink extensibility approach. The
current implementation was based on struct and not attributes.

Let's remove it, before anyone is actually start to use it and prevents us
to write it properly.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c     | 82 ---------------------------------------
 drivers/infiniband/core/netlink.c |  4 +-
 include/uapi/rdma/rdma_netlink.h  | 28 +------------
 3 files changed, 3 insertions(+), 111 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index e79c807e2a4d..e14e1d5024d0 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -4387,84 +4387,6 @@ static void cma_remove_one(struct ib_device *device, void *client_data)
 	kfree(cma_dev);
 }

-static int cma_get_id_stats(struct sk_buff *skb, struct netlink_callback *cb)
-{
-	struct nlmsghdr *nlh;
-	struct rdma_cm_id_stats *id_stats;
-	struct rdma_id_private *id_priv;
-	struct rdma_cm_id *id = NULL;
-	struct cma_device *cma_dev;
-	int i_dev = 0, i_id = 0;
-
-	/*
-	 * We export all of the IDs as a sequence of messages.  Each
-	 * ID gets its own netlink message.
-	 */
-	mutex_lock(&lock);
-
-	list_for_each_entry(cma_dev, &dev_list, list) {
-		if (i_dev < cb->args[0]) {
-			i_dev++;
-			continue;
-		}
-
-		i_id = 0;
-		list_for_each_entry(id_priv, &cma_dev->id_list, list) {
-			if (i_id < cb->args[1]) {
-				i_id++;
-				continue;
-			}
-
-			id_stats = ibnl_put_msg(skb, &nlh, cb->nlh->nlmsg_seq,
-						sizeof *id_stats, RDMA_NL_RDMA_CM,
-						RDMA_NL_RDMA_CM_ID_STATS,
-						NLM_F_MULTI);
-			if (!id_stats)
-				goto out;
-
-			memset(id_stats, 0, sizeof *id_stats);
-			id = &id_priv->id;
-			id_stats->node_type = id->route.addr.dev_addr.dev_type;
-			id_stats->port_num = id->port_num;
-			id_stats->bound_dev_if =
-				id->route.addr.dev_addr.bound_dev_if;
-
-			if (ibnl_put_attr(skb, nlh,
-					  rdma_addr_size(cma_src_addr(id_priv)),
-					  cma_src_addr(id_priv),
-					  RDMA_NL_RDMA_CM_ATTR_SRC_ADDR))
-				goto out;
-			if (ibnl_put_attr(skb, nlh,
-					  rdma_addr_size(cma_dst_addr(id_priv)),
-					  cma_dst_addr(id_priv),
-					  RDMA_NL_RDMA_CM_ATTR_DST_ADDR))
-				goto out;
-
-			id_stats->pid		= id_priv->owner;
-			id_stats->port_space	= id->ps;
-			id_stats->cm_state	= id_priv->state;
-			id_stats->qp_num	= id_priv->qp_num;
-			id_stats->qp_type	= id->qp_type;
-
-			i_id++;
-		}
-
-		cb->args[1] = 0;
-		i_dev++;
-	}
-
-out:
-	mutex_unlock(&lock);
-	cb->args[0] = i_dev;
-	cb->args[1] = i_id;
-
-	return skb->len;
-}
-
-static const struct rdma_nl_cbs cma_cb_table[] = {
-	[RDMA_NL_RDMA_CM_ID_STATS] = { .dump = cma_get_id_stats},
-};
-
 static int cma_init_net(struct net *net)
 {
 	struct cma_pernet *pernet = cma_pernet(net);
@@ -4514,7 +4436,6 @@ static int __init cma_init(void)
 	if (ret)
 		goto err;

-	rdma_nl_register(RDMA_NL_RDMA_CM, cma_cb_table);
 	cma_configfs_init();

 	return 0;
@@ -4531,7 +4452,6 @@ static int __init cma_init(void)
 static void __exit cma_cleanup(void)
 {
 	cma_configfs_exit();
-	rdma_nl_unregister(RDMA_NL_RDMA_CM);
 	ib_unregister_client(&cma_client);
 	unregister_netdevice_notifier(&cma_nb);
 	rdma_addr_unregister_client(&addr_client);
@@ -4540,7 +4460,5 @@ static void __exit cma_cleanup(void)
 	destroy_workqueue(cma_wq);
 }

-MODULE_ALIAS_RDMA_NETLINK(RDMA_NL_RDMA_CM, 1);
-
 module_init(cma_init);
 module_exit(cma_cleanup);
diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index b12e58787c3d..675e31ce8f94 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -58,7 +58,6 @@ EXPORT_SYMBOL(rdma_nl_chk_listeners);
 static bool is_nl_msg_valid(unsigned int type, unsigned int op)
 {
 	static const unsigned int max_num_ops[RDMA_NL_NUM_CLIENTS] = {
-		[RDMA_NL_RDMA_CM] = RDMA_NL_RDMA_CM_NUM_OPS,
 		[RDMA_NL_IWCM] = RDMA_NL_IWPM_NUM_OPS,
 		[RDMA_NL_LS] = RDMA_NL_LS_NUM_OPS,
 		[RDMA_NL_NLDEV] = RDMA_NLDEV_NUM_OPS,
@@ -176,8 +175,7 @@ static int rdma_nl_rcv_msg(struct sk_buff *skb, struct nlmsghdr *nlh,
 		return -EPERM;

 	/* FIXME: Convert IWCM to properly handle doit callbacks */
-	if ((nlh->nlmsg_flags & NLM_F_DUMP) || index == RDMA_NL_RDMA_CM ||
-	    index == RDMA_NL_IWCM) {
+	if ((nlh->nlmsg_flags & NLM_F_DUMP) || index == RDMA_NL_IWCM) {
 		struct netlink_dump_control c = {
 			.dump = cb_table[op].dump,
 		};
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 861440a87e7c..feefc94b7502 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -4,8 +4,7 @@
 #include <linux/types.h>

 enum {
-	RDMA_NL_RDMA_CM = 1,
-	RDMA_NL_IWCM,
+	RDMA_NL_IWCM = 2,
 	RDMA_NL_RSVD,
 	RDMA_NL_LS,	/* RDMA Local Services */
 	RDMA_NL_NLDEV,	/* RDMA device interface */
@@ -13,8 +12,7 @@ enum {
 };

 enum {
-	RDMA_NL_GROUP_CM = 1,
-	RDMA_NL_GROUP_IWPM,
+	RDMA_NL_GROUP_IWPM = 2,
 	RDMA_NL_GROUP_LS,
 	RDMA_NL_NUM_GROUPS
 };
@@ -23,17 +21,6 @@ enum {
 #define RDMA_NL_GET_OP(type) (type & ((1 << 10) - 1))
 #define RDMA_NL_GET_TYPE(client, op) ((client << 10) + op)

-enum {
-	RDMA_NL_RDMA_CM_ID_STATS = 0,
-	RDMA_NL_RDMA_CM_NUM_OPS
-};
-
-enum {
-	RDMA_NL_RDMA_CM_ATTR_SRC_ADDR = 1,
-	RDMA_NL_RDMA_CM_ATTR_DST_ADDR,
-	RDMA_NL_RDMA_CM_NUM_ATTR,
-};
-
 /* iwarp port mapper op-codes */
 enum {
 	RDMA_NL_IWPM_REG_PID = 0,
@@ -47,17 +34,6 @@ enum {
 	RDMA_NL_IWPM_NUM_OPS
 };

-struct rdma_cm_id_stats {
-	__u32	qp_num;
-	__u32	bound_dev_if;
-	__u32	port_space;
-	__s32	pid;
-	__u8	cm_state;
-	__u8	node_type;
-	__u8	port_num;
-	__u8	qp_type;
-};
-
 enum {
 	IWPM_NLA_REG_PID_UNSPEC = 0,
 	IWPM_NLA_REG_PID_SEQ,
--
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
