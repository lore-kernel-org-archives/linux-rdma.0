From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v6 3/4] IB/cma: Add support for network namespaces
Date: Thu, 27 Aug 2015 17:29:31 +0300
Message-ID: <1440685772-14076-4-git-send-email-haggaie@mellanox.com>
References: <1440685772-14076-1-git-send-email-haggaie@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440685772-14076-1-git-send-email-haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Add support for network namespaces in the ib_cma module. This is
accomplished by:

1. Adding network namespace parameter for rdma_create_id. This parameter is
   used to populate the network namespace field in rdma_id_private.
   rdma_create_id keeps a reference on the network namespace.
2. Using the network namespace from the rdma_id instead of init_net inside
   of ib_cma, when listening on an ID and when looking for an ID for an
   incoming request.
3. Decrementing the reference count for the appropriate network namespace
   when calling rdma_destroy_id.

In order to preserve the current behavior init_net is passed when calling
from other modules.

Signed-off-by: Guy Shapiro <guysh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yotam Kenneth <yotamke-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c                      | 46 +++++++++++++---------
 drivers/infiniband/core/ucma.c                     |  3 +-
 drivers/infiniband/ulp/iser/iser_verbs.c           |  2 +-
 drivers/infiniband/ulp/isert/ib_isert.c            |  2 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h    |  4 +-
 include/rdma/rdma_cm.h                             |  6 ++-
 net/9p/trans_rdma.c                                |  4 +-
 net/rds/ib.c                                       |  2 +-
 net/rds/ib_cm.c                                    |  2 +-
 net/rds/iw.c                                       |  2 +-
 net/rds/iw_cm.c                                    |  2 +-
 net/rds/rdma_transport.c                           |  4 +-
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |  4 +-
 net/sunrpc/xprtrdma/verbs.c                        |  3 +-
 14 files changed, 52 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index f40ca053fa3e..debf25ccf930 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -591,7 +591,8 @@ static int cma_disable_callback(struct rdma_id_private *id_priv,
 	return 0;
 }
 
-struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
+struct rdma_cm_id *rdma_create_id(struct net *net,
+				  rdma_cm_event_handler event_handler,
 				  void *context, enum rdma_port_space ps,
 				  enum ib_qp_type qp_type)
 {
@@ -615,7 +616,7 @@ struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
 	INIT_LIST_HEAD(&id_priv->listen_list);
 	INIT_LIST_HEAD(&id_priv->mc_list);
 	get_random_bytes(&id_priv->seq_num, sizeof id_priv->seq_num);
-	id_priv->id.route.addr.dev_addr.net = &init_net;
+	id_priv->id.route.addr.dev_addr.net = get_net(net);
 
 	return &id_priv->id;
 }
@@ -1257,7 +1258,7 @@ static bool cma_match_net_dev(const struct rdma_id_private *id_priv,
 		return addr->src_addr.ss_family == AF_IB;
 
 	return !addr->dev_addr.bound_dev_if ||
-	       (net_eq(dev_net(net_dev), &init_net) &&
+	       (net_eq(dev_net(net_dev), addr->dev_addr.net) &&
 		addr->dev_addr.bound_dev_if == net_dev->ifindex);
 }
 
@@ -1314,7 +1315,7 @@ static struct rdma_id_private *cma_id_from_event(struct ib_cm_id *cm_id,
 		}
 	}
 
-	bind_list = cma_ps_find(&init_net,
+	bind_list = cma_ps_find(dev_net(*net_dev),
 				rdma_ps_from_service_id(req.service_id),
 				cma_port_from_service_id(req.service_id));
 	id_priv = cma_find_listener(bind_list, cm_id, ib_event, &req, *net_dev);
@@ -1386,6 +1387,7 @@ static void cma_cancel_operation(struct rdma_id_private *id_priv,
 static void cma_release_port(struct rdma_id_private *id_priv)
 {
 	struct rdma_bind_list *bind_list = id_priv->bind_list;
+	struct net *net = id_priv->id.route.addr.dev_addr.net;
 
 	if (!bind_list)
 		return;
@@ -1393,7 +1395,7 @@ static void cma_release_port(struct rdma_id_private *id_priv)
 	mutex_lock(&lock);
 	hlist_del(&id_priv->node);
 	if (hlist_empty(&bind_list->owners)) {
-		cma_ps_remove(&init_net, bind_list->ps, bind_list->port);
+		cma_ps_remove(net, bind_list->ps, bind_list->port);
 		kfree(bind_list);
 	}
 	mutex_unlock(&lock);
@@ -1452,6 +1454,7 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 		cma_deref_id(id_priv->id.context);
 
 	kfree(id_priv->id.route.path_rec);
+	put_net(id_priv->id.route.addr.dev_addr.net);
 	kfree(id_priv);
 }
 EXPORT_SYMBOL(rdma_destroy_id);
@@ -1582,7 +1585,8 @@ static struct rdma_id_private *cma_new_conn_id(struct rdma_cm_id *listen_id,
 		      ib_event->param.req_rcvd.primary_path->service_id;
 	int ret;
 
-	id = rdma_create_id(listen_id->event_handler, listen_id->context,
+	id = rdma_create_id(listen_id->route.addr.dev_addr.net,
+			    listen_id->event_handler, listen_id->context,
 			    listen_id->ps, ib_event->param.req_rcvd.qp_type);
 	if (IS_ERR(id))
 		return NULL;
@@ -1632,9 +1636,10 @@ static struct rdma_id_private *cma_new_udp_id(struct rdma_cm_id *listen_id,
 	struct rdma_id_private *id_priv;
 	struct rdma_cm_id *id;
 	const sa_family_t ss_family = listen_id->route.addr.src_addr.ss_family;
+	struct net *net = listen_id->route.addr.dev_addr.net;
 	int ret;
 
-	id = rdma_create_id(listen_id->event_handler, listen_id->context,
+	id = rdma_create_id(net, listen_id->event_handler, listen_id->context,
 			    listen_id->ps, IB_QPT_UD);
 	if (IS_ERR(id))
 		return NULL;
@@ -1872,7 +1877,8 @@ static int iw_conn_req_handler(struct iw_cm_id *cm_id,
 		return -ECONNABORTED;
 
 	/* Create a new RDMA id for the new IW CM ID */
-	new_cm_id = rdma_create_id(listen_id->id.event_handler,
+	new_cm_id = rdma_create_id(listen_id->id.route.addr.dev_addr.net,
+				   listen_id->id.event_handler,
 				   listen_id->id.context,
 				   RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(new_cm_id)) {
@@ -2000,12 +2006,13 @@ static void cma_listen_on_dev(struct rdma_id_private *id_priv,
 {
 	struct rdma_id_private *dev_id_priv;
 	struct rdma_cm_id *id;
+	struct net *net = id_priv->id.route.addr.dev_addr.net;
 	int ret;
 
 	if (cma_family(id_priv) == AF_IB && !rdma_cap_ib_cm(cma_dev->device, 1))
 		return;
 
-	id = rdma_create_id(cma_listen_handler, id_priv, id_priv->id.ps,
+	id = rdma_create_id(net, cma_listen_handler, id_priv, id_priv->id.ps,
 			    id_priv->id.qp_type);
 	if (IS_ERR(id))
 		return;
@@ -2678,7 +2685,8 @@ static int cma_alloc_port(enum rdma_port_space ps,
 	if (!bind_list)
 		return -ENOMEM;
 
-	ret = cma_ps_alloc(&init_net, ps, bind_list, snum);
+	ret = cma_ps_alloc(id_priv->id.route.addr.dev_addr.net, ps, bind_list,
+			   snum);
 	if (ret < 0)
 		goto err;
 
@@ -2697,13 +2705,14 @@ static int cma_alloc_any_port(enum rdma_port_space ps,
 	static unsigned int last_used_port;
 	int low, high, remaining;
 	unsigned int rover;
+	struct net *net = id_priv->id.route.addr.dev_addr.net;
 
-	inet_get_local_port_range(&init_net, &low, &high);
+	inet_get_local_port_range(net, &low, &high);
 	remaining = (high - low) + 1;
 	rover = prandom_u32() % remaining + low;
 retry:
 	if (last_used_port != rover &&
-	    !cma_ps_find(&init_net, ps, (unsigned short)rover)) {
+	    !cma_ps_find(net, ps, (unsigned short)rover)) {
 		int ret = cma_alloc_port(ps, id_priv, rover);
 		/*
 		 * Remember previously used port number in order to avoid
@@ -2769,7 +2778,7 @@ static int cma_use_port(enum rdma_port_space ps,
 	if (snum < PROT_SOCK && !capable(CAP_NET_BIND_SERVICE))
 		return -EACCES;
 
-	bind_list = cma_ps_find(&init_net, ps, snum);
+	bind_list = cma_ps_find(id_priv->id.route.addr.dev_addr.net, ps, snum);
 	if (!bind_list) {
 		ret = cma_alloc_port(ps, id_priv, snum);
 	} else {
@@ -2961,8 +2970,11 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 		if (addr->sa_family == AF_INET)
 			id_priv->afonly = 1;
 #if IS_ENABLED(CONFIG_IPV6)
-		else if (addr->sa_family == AF_INET6)
-			id_priv->afonly = init_net.ipv6.sysctl.bindv6only;
+		else if (addr->sa_family == AF_INET6) {
+			struct net *net = id_priv->id.route.addr.dev_addr.net;
+
+			id_priv->afonly = net->ipv6.sysctl.bindv6only;
+		}
 #endif
 	}
 	ret = cma_get_port(id_priv);
@@ -3767,6 +3779,7 @@ static int cma_netdev_change(struct net_device *ndev, struct rdma_id_private *id
 	dev_addr = &id_priv->id.route.addr.dev_addr;
 
 	if ((dev_addr->bound_dev_if == ndev->ifindex) &&
+	    (net_eq(dev_net(ndev), dev_addr->net)) &&
 	    memcmp(dev_addr->src_dev_addr, ndev->dev_addr, ndev->addr_len)) {
 		printk(KERN_INFO "RDMA CM addr change for ndev %s used by id %p\n",
 		       ndev->name, &id_priv->id);
@@ -3792,9 +3805,6 @@ static int cma_netdev_callback(struct notifier_block *self, unsigned long event,
 	struct rdma_id_private *id_priv;
 	int ret = NOTIFY_DONE;
 
-	if (dev_net(ndev) != &init_net)
-		return NOTIFY_DONE;
-
 	if (event != NETDEV_BONDING_FAILOVER)
 		return NOTIFY_DONE;
 
diff --git a/drivers/infiniband/core/ucma.c b/drivers/infiniband/core/ucma.c
index a53fc9b01c69..82a17a7b7e6d 100644
--- a/drivers/infiniband/core/ucma.c
+++ b/drivers/infiniband/core/ucma.c
@@ -472,7 +472,8 @@ static ssize_t ucma_create_id(struct ucma_file *file, const char __user *inbuf,
 		return -ENOMEM;
 
 	ctx->uid = cmd.uid;
-	ctx->cm_id = rdma_create_id(ucma_event_handler, ctx, cmd.ps, qp_type);
+	ctx->cm_id = rdma_create_id(&init_net, ucma_event_handler, ctx, cmd.ps,
+				    qp_type);
 	if (IS_ERR(ctx->cm_id)) {
 		ret = PTR_ERR(ctx->cm_id);
 		goto err1;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index ae70cc1463ac..2896ed64da73 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -1012,7 +1012,7 @@ int iser_connect(struct iser_conn   *iser_conn,
 	ib_conn->beacon.wr_id = ISER_BEACON_WRID;
 	ib_conn->beacon.opcode = IB_WR_SEND;
 
-	ib_conn->cma_id = rdma_create_id(iser_cma_handler,
+	ib_conn->cma_id = rdma_create_id(&init_net, iser_cma_handler,
 					 (void *)iser_conn,
 					 RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(ib_conn->cma_id)) {
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index dc439a40da3f..797fc398c266 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -3065,7 +3065,7 @@ isert_setup_id(struct isert_np *isert_np)
 	sa = (struct sockaddr *)&np->np_sockaddr;
 	isert_dbg("ksockaddr: %p, sa: %p\n", &np->np_sockaddr, sa);
 
-	id = rdma_create_id(isert_cma_handler, isert_np,
+	id = rdma_create_id(&init_net, isert_cma_handler, isert_np,
 			    RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(id)) {
 		isert_err("rdma_create_id() failed: %ld\n", PTR_ERR(id));
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
index f5d1d9f8f1ed..eb1a3abdb153 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.h
@@ -129,7 +129,9 @@ extern kib_tunables_t  kiblnd_tunables;
 				     IBLND_CREDIT_HIGHWATER_V1 : \
 				     *kiblnd_tunables.kib_peercredits_hiw) /* when eagerly to return credits */
 
-#define kiblnd_rdma_create_id(cb, dev, ps, qpt) rdma_create_id(cb, dev, ps, qpt)
+#define kiblnd_rdma_create_id(cb, dev, ps, qpt) rdma_create_id(&init_net, \
+							       cb, dev, \
+							       ps, qpt)
 
 static inline int
 kiblnd_concurrent_sends_v1(void)
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index c92522c192d2..463ec0ccbe51 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -160,13 +160,17 @@ struct rdma_cm_id {
 /**
  * rdma_create_id - Create an RDMA identifier.
  *
+ * @net: The network namespace in which to create the new id.
  * @event_handler: User callback invoked to report events associated with the
  *   returned rdma_id.
  * @context: User specified context associated with the id.
  * @ps: RDMA port space.
  * @qp_type: type of queue pair associated with the id.
+ *
+ * The id holds a reference on the network namespace until it is destroyed.
  */
-struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
+struct rdma_cm_id *rdma_create_id(struct net *net,
+				  rdma_cm_event_handler event_handler,
 				  void *context, enum rdma_port_space ps,
 				  enum ib_qp_type qp_type);
 
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index ba1210253f5e..52b4a2f993f2 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -655,8 +655,8 @@ rdma_create_trans(struct p9_client *client, const char *addr, char *args)
 		return -ENOMEM;
 
 	/* Create the RDMA CM ID */
-	rdma->cm_id = rdma_create_id(p9_cm_event_handler, client, RDMA_PS_TCP,
-				     IB_QPT_RC);
+	rdma->cm_id = rdma_create_id(&init_net, p9_cm_event_handler, client,
+				     RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(rdma->cm_id))
 		goto error;
 
diff --git a/net/rds/ib.c b/net/rds/ib.c
index c6f95b9494ae..3f87a93e38bb 100644
--- a/net/rds/ib.c
+++ b/net/rds/ib.c
@@ -317,7 +317,7 @@ static int rds_ib_laddr_check(__be32 addr)
 	/* Create a CMA ID and try to bind it. This catches both
 	 * IB and iWARP capable NICs.
 	 */
-	cm_id = rdma_create_id(NULL, NULL, RDMA_PS_TCP, IB_QPT_RC);
+	cm_id = rdma_create_id(&init_net, NULL, NULL, RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(cm_id))
 		return PTR_ERR(cm_id);
 
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index a75e8832bc23..79126a190842 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -564,7 +564,7 @@ int rds_ib_conn_connect(struct rds_connection *conn)
 
 	/* XXX I wonder what affect the port space has */
 	/* delegate cm event handler to rdma_transport */
-	ic->i_cm_id = rdma_create_id(rds_rdma_cm_event_handler, conn,
+	ic->i_cm_id = rdma_create_id(&init_net, rds_rdma_cm_event_handler, conn,
 				     RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(ic->i_cm_id)) {
 		ret = PTR_ERR(ic->i_cm_id);
diff --git a/net/rds/iw.c b/net/rds/iw.c
index c7dcddbf17cb..e32221eb1a6c 100644
--- a/net/rds/iw.c
+++ b/net/rds/iw.c
@@ -223,7 +223,7 @@ static int rds_iw_laddr_check(__be32 addr)
 	/* Create a CMA ID and try to bind it. This catches both
 	 * IB and iWARP capable NICs.
 	 */
-	cm_id = rdma_create_id(NULL, NULL, RDMA_PS_TCP, IB_QPT_RC);
+	cm_id = rdma_create_id(&init_net, NULL, NULL, RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(cm_id))
 		return PTR_ERR(cm_id);
 
diff --git a/net/rds/iw_cm.c b/net/rds/iw_cm.c
index 8f486fa32079..6068da58701f 100644
--- a/net/rds/iw_cm.c
+++ b/net/rds/iw_cm.c
@@ -523,7 +523,7 @@ int rds_iw_conn_connect(struct rds_connection *conn)
 
 	/* XXX I wonder what affect the port space has */
 	/* delegate cm event handler to rdma_transport */
-	ic->i_cm_id = rdma_create_id(rds_rdma_cm_event_handler, conn,
+	ic->i_cm_id = rdma_create_id(&init_net, rds_rdma_cm_event_handler, conn,
 				     RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(ic->i_cm_id)) {
 		ret = PTR_ERR(ic->i_cm_id);
diff --git a/net/rds/rdma_transport.c b/net/rds/rdma_transport.c
index 208240836043..7deaa617e821 100644
--- a/net/rds/rdma_transport.c
+++ b/net/rds/rdma_transport.c
@@ -131,8 +131,8 @@ static int rds_rdma_listen_init(void)
 	struct rdma_cm_id *cm_id;
 	int ret;
 
-	cm_id = rdma_create_id(rds_rdma_cm_event_handler, NULL, RDMA_PS_TCP,
-			       IB_QPT_RC);
+	cm_id = rdma_create_id(&init_net, rds_rdma_cm_event_handler, NULL,
+			       RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(cm_id)) {
 		ret = PTR_ERR(cm_id);
 		printk(KERN_ERR "RDS/RDMA: failed to setup listener, "
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 11d5133c3f38..4e220e6716d4 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -691,8 +691,8 @@ static struct svc_xprt *svc_rdma_create(struct svc_serv *serv,
 	if (!cma_xprt)
 		return ERR_PTR(-ENOMEM);
 
-	listen_id = rdma_create_id(rdma_listen_handler, cma_xprt, RDMA_PS_TCP,
-				   IB_QPT_RC);
+	listen_id = rdma_create_id(&init_net, rdma_listen_handler, cma_xprt,
+				   RDMA_PS_TCP, IB_QPT_RC);
 	if (IS_ERR(listen_id)) {
 		ret = PTR_ERR(listen_id);
 		dprintk("svcrdma: rdma_create_id failed = %d\n", ret);
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index afd504375a9a..2c605d22a3f6 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -423,7 +423,8 @@ rpcrdma_create_id(struct rpcrdma_xprt *xprt,
 
 	init_completion(&ia->ri_done);
 
-	id = rdma_create_id(rpcrdma_conn_upcall, xprt, RDMA_PS_TCP, IB_QPT_RC);
+	id = rdma_create_id(&init_net, rpcrdma_conn_upcall, xprt, RDMA_PS_TCP,
+			    IB_QPT_RC);
 	if (IS_ERR(id)) {
 		rc = PTR_ERR(id);
 		dprintk("RPC:       %s: rdma_create_id() failed %i\n",
-- 
1.7.11.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
