From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RFC 2/2] RDMA/nldev: provide detailed CM_ID information
Date: Tue, 30 Jan 2018 08:59:11 -0800
Message-ID: <531889e6a24f7919dec71734c91298d266aa9721.1517418595.git.swise@opengridcomputing.com>
References: <cover.1517418595.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1517418595.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Implement RDMA nldev netlink interface to get detailed CM_ID information.

Because cm_id's are attached to rdma devices in various work queue contexts,
the pid and task information at device-attach time is sometimes not useful.
For example, an nvme/f host connection ends up being bound to a device
in a work queue context and the resulting pid at attach time no longer exists
after connection setup.  So instead we mark all cm_id's created via the
rdma_ucm as "user", and all others as "kernel".  This required tweaking
the restrack code a little.  It also required wrapping some rdma_cm
functions to allow passing the module name string.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/cma.c      |  55 ++++++---
 drivers/infiniband/core/nldev.c    | 245 +++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/restrack.c |  29 ++++-
 drivers/infiniband/core/ucma.c     |   8 +-
 include/rdma/rdma_cm.h             |  24 +++-
 include/rdma/restrack.h            |   4 +
 include/uapi/rdma/rdma_netlink.h   |  30 +++++
 7 files changed, 365 insertions(+), 30 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 72ad52b..51fbfa1 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -465,6 +465,9 @@ static void _cma_attach_to_dev(struct rdma_id_private *id_priv,
 	id_priv->id.route.addr.dev_addr.transport =
 		rdma_node_get_transport(cma_dev->device->node_type);
 	list_add_tail(&id_priv->list, &cma_dev->id_list);
+	id_priv->id.res.type = RDMA_RESTRACK_CM_ID;
+	id_priv->id.res.kern_name = id_priv->id.caller;
+	rdma_restrack_add(&id_priv->id.res);
 }
 
 static void cma_attach_to_dev(struct rdma_id_private *id_priv,
@@ -737,10 +740,10 @@ static void cma_deref_id(struct rdma_id_private *id_priv)
 		complete(&id_priv->comp);
 }
 
-struct rdma_cm_id *rdma_create_id(struct net *net,
-				  rdma_cm_event_handler event_handler,
-				  void *context, enum rdma_port_space ps,
-				  enum ib_qp_type qp_type)
+struct rdma_cm_id *__rdma_create_id(struct net *net,
+				    rdma_cm_event_handler event_handler,
+				    void *context, enum rdma_port_space ps,
+				    enum ib_qp_type qp_type, const char *caller)
 {
 	struct rdma_id_private *id_priv;
 
@@ -748,7 +751,10 @@ struct rdma_cm_id *rdma_create_id(struct net *net,
 	if (!id_priv)
 		return ERR_PTR(-ENOMEM);
 
-	id_priv->owner = task_pid_nr(current);
+	if (caller)
+		id_priv->id.caller = caller;
+	else
+		id_priv->owner = task_pid_nr(current);
 	id_priv->state = RDMA_CM_IDLE;
 	id_priv->id.context = context;
 	id_priv->id.event_handler = event_handler;
@@ -768,7 +774,7 @@ struct rdma_cm_id *rdma_create_id(struct net *net,
 
 	return &id_priv->id;
 }
-EXPORT_SYMBOL(rdma_create_id);
+EXPORT_SYMBOL(__rdma_create_id);
 
 static int cma_init_ud_qp(struct rdma_id_private *id_priv, struct ib_qp *qp)
 {
@@ -1628,6 +1634,7 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 	mutex_unlock(&id_priv->handler_mutex);
 
 	if (id_priv->cma_dev) {
+		rdma_restrack_del(&id_priv->id.res);
 		if (rdma_cap_ib_cm(id_priv->id.device, 1)) {
 			if (id_priv->cm_id.ib)
 				ib_destroy_cm_id(id_priv->cm_id.ib);
@@ -1786,9 +1793,10 @@ static struct rdma_id_private *cma_new_conn_id(struct rdma_cm_id *listen_id,
 		ib_event->param.req_rcvd.primary_path->service_id;
 	int ret;
 
-	id = rdma_create_id(listen_id->route.addr.dev_addr.net,
+	id = __rdma_create_id(listen_id->route.addr.dev_addr.net,
 			    listen_id->event_handler, listen_id->context,
-			    listen_id->ps, ib_event->param.req_rcvd.qp_type);
+			    listen_id->ps, ib_event->param.req_rcvd.qp_type,
+			    listen_id->caller);
 	if (IS_ERR(id))
 		return NULL;
 
@@ -1843,8 +1851,8 @@ static struct rdma_id_private *cma_new_udp_id(struct rdma_cm_id *listen_id,
 	struct net *net = listen_id->route.addr.dev_addr.net;
 	int ret;
 
-	id = rdma_create_id(net, listen_id->event_handler, listen_id->context,
-			    listen_id->ps, IB_QPT_UD);
+	id = __rdma_create_id(net, listen_id->event_handler, listen_id->context,
+			      listen_id->ps, IB_QPT_UD, listen_id->caller);
 	if (IS_ERR(id))
 		return NULL;
 
@@ -2110,10 +2118,11 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 		goto out;
 
 	/* Create a new RDMA id for the new IW CM ID */
-	new_cm_id = rdma_create_id(listen_id->id.route.addr.dev_addr.net,
-				   listen_id->id.event_handler,
-				   listen_id->id.context,
-				   RDMA_PS_TCP, IB_QPT_RC);
+	new_cm_id = __rdma_create_id(listen_id->id.route.addr.dev_addr.net,
+				     listen_id->id.event_handler,
+				     listen_id->id.context,
+				     RDMA_PS_TCP, IB_QPT_RC,
+				     listen_id->id.caller);
 	if (IS_ERR(new_cm_id)) {
 		ret = -ENOMEM;
 		goto out;
@@ -2238,8 +2247,8 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 	if (cma_family(id_priv) == AF_IB && !rdma_cap_ib_cm(cma_dev->device, 1))
 		return;
 
-	id = rdma_create_id(net, cma_listen_handler, id_priv, id_priv->id.ps,
-			    id_priv->id.qp_type);
+	id = __rdma_create_id(net, cma_listen_handler, id_priv, id_priv->id.ps,
+			      id_priv->id.qp_type, id_priv->id.caller);
 	if (IS_ERR(id))
 		return;
 
@@ -3347,8 +3356,10 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 
 	return 0;
 err2:
-	if (id_priv->cma_dev)
+	if (id_priv->cma_dev) {
+		rdma_restrack_del(&id_priv->id.res);
 		cma_release_dev(id_priv);
+	}
 err1:
 	cma_comp_exch(id_priv, RDMA_CM_ADDR_BOUND, RDMA_CM_IDLE);
 	return ret;
@@ -3731,14 +3742,18 @@ static int cma_send_sidr_rep(struct rdma_id_private *id_priv,
 	return ib_send_cm_sidr_rep(id_priv->cm_id.ib, &rep);
 }
 
-int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
+int __rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param,
+		  const char *caller)
 {
 	struct rdma_id_private *id_priv;
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
 
-	id_priv->owner = task_pid_nr(current);
+	if (caller)
+		id_priv->id.caller = caller;
+	else
+		id_priv->owner = task_pid_nr(current);
 
 	if (!cma_comp(id_priv, RDMA_CM_CONNECT))
 		return -EINVAL;
@@ -3778,7 +3793,7 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	rdma_reject(id, NULL, 0);
 	return ret;
 }
-EXPORT_SYMBOL(rdma_accept);
+EXPORT_SYMBOL(__rdma_accept);
 
 int rdma_notify(struct rdma_cm_id *id, enum ib_event_type event)
 {
diff --git a/drivers/infiniband/core/nldev.c b/drivers/infiniband/core/nldev.c
index fa8655e..a4091b5 100644
--- a/drivers/infiniband/core/nldev.c
+++ b/drivers/infiniband/core/nldev.c
@@ -34,6 +34,7 @@
 #include <linux/pid.h>
 #include <linux/pid_namespace.h>
 #include <net/netlink.h>
+#include <rdma/rdma_cm.h>
 #include <rdma/rdma_netlink.h>
 
 #include "core_priv.h"
@@ -71,6 +72,22 @@
 	[RDMA_NLDEV_ATTR_RES_PID]		= { .type = NLA_U32 },
 	[RDMA_NLDEV_ATTR_RES_KERN_NAME]		= { .type = NLA_NUL_STRING,
 						    .len = TASK_COMM_LEN },
+	[RDMA_NLDEV_ATTR_RES_CM_ID]		= { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_RES_CM_ID_ENTRY]	= { .type = NLA_NESTED },
+	[RDMA_NLDEV_ATTR_RES_PS]		= { .type = NLA_U32 },
+	[RDMA_NLDEV_ATTR_RES_IPV4_SADDR]	= {
+				.len = FIELD_SIZEOF(struct iphdr, saddr) },
+	[RDMA_NLDEV_ATTR_RES_IPV4_DADDR]	= {
+				.len = FIELD_SIZEOF(struct iphdr, saddr) },
+	[RDMA_NLDEV_ATTR_RES_IPV6_SADDR]	= {
+				.len = FIELD_SIZEOF(struct ipv6hdr, saddr) },
+	[RDMA_NLDEV_ATTR_RES_IPV6_DADDR]	= {
+				.len = FIELD_SIZEOF(struct ipv6hdr, saddr) },
+	[RDMA_NLDEV_ATTR_RES_IP_SPORT]		= { .type = NLA_U16 },
+	[RDMA_NLDEV_ATTR_RES_IP_DPORT]		= { .type = NLA_U16 },
+	[RDMA_NLDEV_ATTR_RES_DEV_TYPE]		= { .type = NLA_U8 },
+	[RDMA_NLDEV_ATTR_RES_TRANSPORT_TYPE]	= { .type = NLA_U8 },
+	[RDMA_NLDEV_ATTR_RES_NETWORK_TYPE]	= { .type = NLA_U8 },
 };
 
 static int fill_nldev_handle(struct sk_buff *msg, struct ib_device *device)
@@ -182,6 +199,7 @@ static int fill_res_info(struct sk_buff *msg, struct ib_device *device)
 		[RDMA_RESTRACK_PD] = "pd",
 		[RDMA_RESTRACK_CQ] = "cq",
 		[RDMA_RESTRACK_QP] = "qp",
+		[RDMA_RESTRACK_CM_ID] = "cm_id",
 	};
 
 	struct rdma_restrack_root *res = &device->res;
@@ -284,6 +302,99 @@ static int fill_res_qp_entry(struct sk_buff *msg,
 	return -EMSGSIZE;
 }
 
+static int fill_res_cm_id_entry(struct sk_buff *msg,
+				struct rdma_cm_id *cm_id, uint32_t port)
+{
+	struct rdma_id_private *id_priv;
+	struct nlattr *entry_attr;
+
+	if (port && port != cm_id->port_num)
+		return 0;
+
+	id_priv = container_of(cm_id, struct rdma_id_private, id);
+	entry_attr = nla_nest_start(msg, RDMA_NLDEV_ATTR_RES_CM_ID_ENTRY);
+	if (!entry_attr)
+		goto out;
+
+	if (cm_id->port_num &&
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_PORT_INDEX, cm_id->port_num))
+		goto err;
+
+	if (id_priv->qp_num &&
+	    nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_LQPN, id_priv->qp_num))
+		goto err;
+
+	if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_PS, cm_id->ps))
+		goto err;
+
+	if (nla_put_u8(msg, RDMA_NLDEV_ATTR_RES_TYPE, cm_id->qp_type))
+		goto err;
+	if (nla_put_u8(msg, RDMA_NLDEV_ATTR_RES_STATE, id_priv->state))
+		goto err;
+	if (nla_put_u8(msg, RDMA_NLDEV_ATTR_RES_DEV_TYPE,
+		       id_priv->id.route.addr.dev_addr.dev_type))
+		goto err;
+	if (nla_put_u8(msg, RDMA_NLDEV_ATTR_RES_TRANSPORT_TYPE,
+		       id_priv->id.route.addr.dev_addr.transport))
+		goto err;
+
+	if (cm_id->route.addr.src_addr.ss_family == AF_INET) {
+		struct sockaddr_in *sin;
+
+		sin = (struct sockaddr_in *)&cm_id->route.addr.src_addr;
+		if (nla_put_in_addr(msg, RDMA_NLDEV_ATTR_RES_IPV4_SADDR,
+				    sin->sin_addr.s_addr))
+			goto err;
+		if (nla_put_net16(msg, RDMA_NLDEV_ATTR_RES_IP_SPORT,
+				  sin->sin_port))
+			goto err;
+
+		sin = (struct sockaddr_in *)&cm_id->route.addr.dst_addr;
+		if (nla_put_in_addr(msg, RDMA_NLDEV_ATTR_RES_IPV4_DADDR,
+				    sin->sin_addr.s_addr))
+			goto err;
+		if (nla_put_net16(msg, RDMA_NLDEV_ATTR_RES_IP_DPORT,
+				  sin->sin_port))
+			goto err;
+	} else {
+		struct sockaddr_in6 *sin6;
+
+		sin6 = (struct sockaddr_in6 *)&cm_id->route.addr.src_addr;
+		if (nla_put_in6_addr(msg, RDMA_NLDEV_ATTR_RES_IPV6_SADDR,
+				     &sin6->sin6_addr))
+			goto err;
+		if (nla_put_net16(msg, RDMA_NLDEV_ATTR_RES_IP_SPORT,
+				  sin6->sin6_port))
+			goto err;
+
+		sin6 = (struct sockaddr_in6 *)&cm_id->route.addr.dst_addr;
+		if (nla_put_in6_addr(msg, RDMA_NLDEV_ATTR_RES_IPV6_DADDR,
+				     &sin6->sin6_addr))
+			goto err;
+		if (nla_put_net16(msg, RDMA_NLDEV_ATTR_RES_IP_DPORT,
+				  sin6->sin6_port))
+			goto err;
+	}
+
+	if (id_priv->id.caller) {
+		if (nla_put_string(msg, RDMA_NLDEV_ATTR_RES_KERN_NAME,
+				   id_priv->id.caller))
+			goto err;
+	} else {
+		/* CMA keeps the owning pid. */
+		if (nla_put_u32(msg, RDMA_NLDEV_ATTR_RES_PID, id_priv->owner))
+			goto err;
+	}
+
+	nla_nest_end(msg, entry_attr);
+	return 0;
+
+err:
+	nla_nest_cancel(msg, entry_attr);
+out:
+	return -EMSGSIZE;
+}
+
 static int nldev_get_doit(struct sk_buff *skb, struct nlmsghdr *nlh,
 			  struct netlink_ext_ack *extack)
 {
@@ -686,6 +797,137 @@ static int nldev_res_get_qp_dumpit(struct sk_buff *skb,
 	return ret;
 }
 
+static int nldev_res_get_cm_id_dumpit(struct sk_buff *skb,
+				      struct netlink_callback *cb)
+{
+	struct nlattr *tb[RDMA_NLDEV_ATTR_MAX];
+	struct rdma_restrack_entry *res;
+	int err, ret = 0, idx = 0;
+	struct nlattr *table_attr;
+	struct ib_device *device;
+	int start = cb->args[0];
+	struct rdma_cm_id *cm_id = NULL;
+	struct nlmsghdr *nlh;
+	u32 index, port = 0;
+
+	err = nlmsg_parse(cb->nlh, 0, tb, RDMA_NLDEV_ATTR_MAX - 1,
+			  nldev_policy, NULL);
+	/*
+	 * Right now, we are expecting the device index to get QP information,
+	 * but it is possible to extend this code to return all devices in
+	 * one shot by checking the existence of RDMA_NLDEV_ATTR_DEV_INDEX.
+	 * if it doesn't exist, we will iterate over all devices.
+	 *
+	 * But it is not needed for now.
+	 */
+	if (err || !tb[RDMA_NLDEV_ATTR_DEV_INDEX])
+		return -EINVAL;
+
+	index = nla_get_u32(tb[RDMA_NLDEV_ATTR_DEV_INDEX]);
+	device = ib_device_get_by_index(index);
+	if (!device)
+		return -EINVAL;
+
+	/*
+	 * If no PORT_INDEX is supplied, we will return all QPs from that device
+	 */
+	if (tb[RDMA_NLDEV_ATTR_PORT_INDEX]) {
+		port = nla_get_u32(tb[RDMA_NLDEV_ATTR_PORT_INDEX]);
+		if (!rdma_is_port_valid(device, port)) {
+			ret = -EINVAL;
+			goto err_index;
+		}
+	}
+
+	nlh = nlmsg_put(skb, NETLINK_CB(cb->skb).portid, cb->nlh->nlmsg_seq,
+		RDMA_NL_GET_TYPE(RDMA_NL_NLDEV, RDMA_NLDEV_CMD_RES_QP_GET),
+		0, NLM_F_MULTI);
+
+	if (fill_nldev_handle(skb, device)) {
+		ret = -EMSGSIZE;
+		goto err;
+	}
+
+	table_attr = nla_nest_start(skb, RDMA_NLDEV_ATTR_RES_CM_ID);
+	if (!table_attr) {
+		ret = -EMSGSIZE;
+		goto err;
+	}
+
+	down_read(&device->res.rwsem);
+	hash_for_each_possible(device->res.hash, res, node,
+			       RDMA_RESTRACK_CM_ID) {
+		if (idx < start)
+			goto next;
+
+		if ((rdma_is_kernel_res(res) &&
+		     task_active_pid_ns(current) != &init_pid_ns) ||
+		    (!rdma_is_kernel_res(res) &&
+		     task_active_pid_ns(current) !=
+		     task_active_pid_ns(res->task)))
+			/*
+			 * 1. Kernel QPs should be visible in init namsapce only
+			 * 2. Preent only QPs visible in the current namespace
+			 */
+			goto next;
+
+		if (!rdma_restrack_get(res))
+			/*
+			 * Resource is under release now, but we are not
+			 * relesing lock now, so it will be released in
+			 * our next pass, once we will get ->next pointer.
+			 */
+			goto next;
+
+		cm_id = container_of(res, struct rdma_cm_id, res);
+
+		up_read(&device->res.rwsem);
+		ret = fill_res_cm_id_entry(skb, cm_id, port);
+		down_read(&device->res.rwsem);
+		/*
+		 * Return resource back, but it won't be released till
+		 * the &device->res.rwsem will be released for write.
+		 */
+		rdma_restrack_put(res);
+
+		if (ret == -EMSGSIZE)
+			/*
+			 * There is a chance to optimize here.
+			 * It can be done by using list_prepare_entry
+			 * and list_for_each_entry_continue afterwards.
+			 */
+			break;
+		if (ret)
+			goto res_err;
+next:		idx++;
+	}
+	up_read(&device->res.rwsem);
+
+	nla_nest_end(skb, table_attr);
+	nlmsg_end(skb, nlh);
+	cb->args[0] = idx;
+
+	/*
+	 * No more CM_IDs to fill, cancel the message and
+	 * return 0 to mark end of dumpit.
+	 */
+	if (!cm_id)
+		goto err;
+
+	put_device(&device->dev);
+	return skb->len;
+
+res_err:
+	nla_nest_cancel(skb, table_attr);
+	up_read(&device->res.rwsem);
+
+err:
+	nlmsg_cancel(skb, nlh);
+
+err_index:
+	put_device(&device->dev);
+	return ret;
+}
 static const struct rdma_nl_cbs nldev_cb_table[RDMA_NLDEV_NUM_OPS] = {
 	[RDMA_NLDEV_CMD_GET] = {
 		.doit = nldev_get_doit,
@@ -712,6 +954,9 @@ static int nldev_res_get_qp_dumpit(struct sk_buff *skb,
 		 * too.
 		 */
 	},
+	[RDMA_NLDEV_CMD_RES_CM_ID_GET] = {
+		.dump = nldev_res_get_cm_id_dumpit,
+	},
 };
 
 void __init nldev_init(void)
diff --git a/drivers/infiniband/core/restrack.c b/drivers/infiniband/core/restrack.c
index 857637b..bb13169 100644
--- a/drivers/infiniband/core/restrack.c
+++ b/drivers/infiniband/core/restrack.c
@@ -3,6 +3,7 @@
  * Copyright (c) 2017-2018 Mellanox Technologies. All rights reserved.
  */
 
+#include <rdma/rdma_cm.h>
 #include <rdma/ib_verbs.h>
 #include <rdma/restrack.h>
 #include <linux/mutex.h>
@@ -67,6 +68,7 @@ static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
 	struct ib_pd *pd;
 	struct ib_cq *cq;
 	struct ib_qp *qp;
+	struct rdma_cm_id *cm_id;
 
 	switch (type) {
 	case RDMA_RESTRACK_PD:
@@ -85,6 +87,10 @@ static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
 		xrcd = container_of(res, struct ib_xrcd, res);
 		dev = xrcd->device;
 		break;
+	case RDMA_RESTRACK_CM_ID:
+		cm_id = container_of(res, struct rdma_cm_id, res);
+		dev = cm_id->device;
+		break;
 	default:
 		WARN_ONCE(true, "Wrong resource tracking type %u\n", type);
 		return NULL;
@@ -93,6 +99,27 @@ static struct ib_device *res_to_dev(struct rdma_restrack_entry *res)
 	return dev;
 }
 
+static bool res_is_user(struct rdma_restrack_entry *res)
+{
+	enum rdma_restrack_type type = res->type;
+	bool is_user;
+
+	switch (type) {
+	case RDMA_RESTRACK_CM_ID: {
+		struct rdma_cm_id *cm_id;
+
+		cm_id = container_of(res, struct rdma_cm_id, res);
+		is_user = !cm_id->caller;
+		break;
+	}
+	default:
+		is_user = !uaccess_kernel();
+		break;
+	}
+
+	return is_user;
+}
+
 void rdma_restrack_add(struct rdma_restrack_entry *res)
 {
 	struct ib_device *dev = res_to_dev(res);
@@ -100,7 +127,7 @@ void rdma_restrack_add(struct rdma_restrack_entry *res)
 	if (!dev)
 		return;
 
-	if (!uaccess_kernel()) {
+	if (res_is_user(res)) {
 		get_task_struct(current);
 		res->task = current;
 		res->kern_name = NULL;
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index d67219d..f7f0282 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -476,8 +476,8 @@ static ssize_t ucma_create_id(struct ucma_file *file, const char __user *inbuf,
 		return -ENOMEM;
 
 	ctx->uid = cmd.uid;
-	ctx->cm_id = rdma_create_id(current->nsproxy->net_ns,
-				    ucma_event_handler, ctx, cmd.ps, qp_type);
+	ctx->cm_id = __rdma_create_id(current->nsproxy->net_ns,
+			      ucma_event_handler, ctx, cmd.ps, qp_type, NULL);
 	if (IS_ERR(ctx->cm_id)) {
 		ret = PTR_ERR(ctx->cm_id);
 		goto err1;
@@ -1084,12 +1084,12 @@ static ssize_t ucma_accept(struct ucma_file *file, const char __user *inbuf,
 	if (cmd.conn_param.valid) {
 		ucma_copy_conn_param(ctx->cm_id, &conn_param, &cmd.conn_param);
 		mutex_lock(&file->mut);
-		ret = rdma_accept(ctx->cm_id, &conn_param);
+		ret = __rdma_accept(ctx->cm_id, &conn_param, NULL);
 		if (!ret)
 			ctx->uid = cmd.uid;
 		mutex_unlock(&file->mut);
 	} else
-		ret = rdma_accept(ctx->cm_id, NULL);
+		ret = __rdma_accept(ctx->cm_id, NULL, NULL);
 
 	ucma_put_ctx(ctx);
 	return ret;
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 5984225..73dac9b 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -155,6 +155,12 @@ struct rdma_cm_id {
 	enum rdma_port_space	 ps;
 	enum ib_qp_type		 qp_type;
 	u8			 port_num;
+	const char *caller;
+
+	/*
+	 * Internal to RDMA/core, don't use in the drivers
+	 */
+	struct rdma_restrack_entry     res;
 };
 
 struct rdma_id_private {
@@ -198,6 +204,11 @@ struct rdma_id_private {
 	enum ib_gid_type	gid_type;
 };
 
+struct rdma_cm_id *__rdma_create_id(struct net *net,
+				  rdma_cm_event_handler event_handler,
+				  void *context, enum rdma_port_space ps,
+				  enum ib_qp_type qp_type, const char *caller);
+
 /**
  * rdma_create_id - Create an RDMA identifier.
  *
@@ -210,10 +221,9 @@ struct rdma_id_private {
  *
  * The id holds a reference on the network namespace until it is destroyed.
  */
-struct rdma_cm_id *rdma_create_id(struct net *net,
-				  rdma_cm_event_handler event_handler,
-				  void *context, enum rdma_port_space ps,
-				  enum ib_qp_type qp_type);
+#define rdma_create_id(net, event_handler, context, ps, qp_type) \
+	__rdma_create_id((net), (event_handler), (context), (ps), (qp_type), \
+			 KBUILD_MODNAME)
 
 /**
   * rdma_destroy_id - Destroys an RDMA identifier.
@@ -325,6 +335,9 @@ int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
  */
 int rdma_listen(struct rdma_cm_id *id, int backlog);
 
+int __rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param,
+		  const char *caller);
+
 /**
  * rdma_accept - Called to accept a connection request or response.
  * @id: Connection identifier associated with the request.
@@ -340,7 +353,8 @@ int rdma_init_qp_attr(struct rdma_cm_id *id, struct ib_qp_attr *qp_attr,
  * state of the qp associated with the id is modified to error, such that any
  * previously posted receive buffers would be flushed.
  */
-int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param);
+#define rdma_accept(id, conn_param) \
+	__rdma_accept((id), (conn_param),  KBUILD_MODNAME)
 
 /**
  * rdma_notify - Notifies the RDMA CM of an asynchronous event that has
diff --git a/include/rdma/restrack.h b/include/rdma/restrack.h
index c2d8116..a794e0e 100644
--- a/include/rdma/restrack.h
+++ b/include/rdma/restrack.h
@@ -33,6 +33,10 @@ enum rdma_restrack_type {
 	 */
 	RDMA_RESTRACK_XRCD,
 	/**
+	 * @RDMA_RESTRACK_CM_ID: Connection Manager ID (CM_ID)
+	 */
+	RDMA_RESTRACK_CM_ID,
+	/**
 	 * @RDMA_RESTRACK_MAX: Last entry, used for array dclarations
 	 */
 	RDMA_RESTRACK_MAX
diff --git a/include/uapi/rdma/rdma_netlink.h b/include/uapi/rdma/rdma_netlink.h
index 17e59be..4ed21ee 100644
--- a/include/uapi/rdma/rdma_netlink.h
+++ b/include/uapi/rdma/rdma_netlink.h
@@ -240,6 +240,8 @@ enum rdma_nldev_command {
 
 	RDMA_NLDEV_CMD_RES_QP_GET, /* can dump */
 
+	RDMA_NLDEV_CMD_RES_CM_ID_GET, /* can dump */
+
 	RDMA_NLDEV_NUM_OPS
 };
 
@@ -352,6 +354,34 @@ enum rdma_nldev_attr {
 	 */
 	RDMA_NLDEV_ATTR_RES_KERN_NAME,		/* string */
 
+	RDMA_NLDEV_ATTR_RES_CM_ID,		/* nested table */
+	RDMA_NLDEV_ATTR_RES_CM_ID_ENTRY,	/* nested table */
+	/*
+	 * rdma_cm_id port space.
+	 */
+	RDMA_NLDEV_ATTR_RES_PS,			/* u32 */
+	/*
+	 * IP Addresses/port attributes.
+	 */
+	RDMA_NLDEV_ATTR_RES_IPV4_SADDR,		/* u8[4] */
+	RDMA_NLDEV_ATTR_RES_IPV4_DADDR,		/* u8[4] */
+	RDMA_NLDEV_ATTR_RES_IPV6_SADDR,		/* u8[16] */
+	RDMA_NLDEV_ATTR_RES_IPV6_DADDR,		/* u8[16] */
+	RDMA_NLDEV_ATTR_RES_IP_SPORT,		/* BE u16 */
+	RDMA_NLDEV_ATTR_RES_IP_DPORT,		/* BE u16 */
+	/*
+	 * ARPHRD_INFINIBAND, ARPHRD_ETHER, ...
+	 */
+	RDMA_NLDEV_ATTR_RES_DEV_TYPE,		/* u8 */
+	/*
+	 * enum enum rdma_transport_type (IB, IWARP, ...)
+	 */
+	RDMA_NLDEV_ATTR_RES_TRANSPORT_TYPE,	/* u8 */
+	/*
+	 * enum rdma_network_type (IB, IPv4, IPv6,...)
+	 */
+	RDMA_NLDEV_ATTR_RES_NETWORK_TYPE,	/* u8 */
+
 	RDMA_NLDEV_ATTR_MAX
 };
 #endif /* _UAPI_RDMA_NETLINK_H */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
