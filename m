From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 02/10] IB/core: Add flags parameter for ib_create_cq
Date: Sun, 17 May 2015 16:36:18 +0300
Message-ID: <1431869786-6308-3-git-send-email-ogerlitz@mellanox.com>
References: <1431869786-6308-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431869786-6308-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

We add a flags parameter for ib_create_cq in order
to specify creation flags for the CQ.

This commit does not change any functionality.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/mad.c                      |    4 ++--
 drivers/infiniband/core/verbs.c                    |    5 +++--
 drivers/infiniband/hw/ehca/ehca_main.c             |    3 ++-
 drivers/infiniband/hw/mlx4/mad.c                   |    2 +-
 drivers/infiniband/hw/mlx4/main.c                  |    2 +-
 drivers/infiniband/hw/mlx5/main.c                  |    2 +-
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |    5 +++--
 drivers/infiniband/ulp/iser/iser_verbs.c           |    8 +++-----
 drivers/infiniband/ulp/isert/ib_isert.c            |    7 ++++---
 drivers/infiniband/ulp/srp/ib_srp.c                |    4 ++--
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    2 +-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    7 +++----
 include/rdma/ib_verbs.h                            |    6 +++++-
 net/9p/trans_rdma.c                                |    2 +-
 net/rds/ib_cm.c                                    |    4 ++--
 net/rds/iw_cm.c                                    |    8 ++++----
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   15 +++++----------
 net/sunrpc/xprtrdma/verbs.c                        |    8 ++++----
 18 files changed, 47 insertions(+), 47 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 600af26..2abcdcb 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2944,8 +2944,8 @@ static int ib_mad_port_open(struct ib_device *device,
 		cq_size *= 2;
 
 	port_priv->cq = ib_create_cq(port_priv->device,
-				     ib_mad_thread_completion_handler,
-				     NULL, port_priv, cq_size, 0);
+				     ib_mad_thread_completion_handler, NULL,
+				     port_priv, cq_size, 0, 0);
 	if (IS_ERR(port_priv->cq)) {
 		dev_err(&device->dev, "Couldn't create ib_mad CQ\n");
 		ret = PTR_ERR(port_priv->cq);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 0da8163..56c2873 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1010,10 +1010,11 @@ EXPORT_SYMBOL(ib_destroy_qp);
 struct ib_cq *ib_create_cq(struct ib_device *device,
 			   ib_comp_handler comp_handler,
 			   void (*event_handler)(struct ib_event *, void *),
-			   void *cq_context, int cqe, int comp_vector)
+			   void *cq_context, int cqe, int comp_vector, u32 flags)
 {
 	struct ib_cq *cq;
-	struct ib_cq_init_attr attr = {.cqe = cqe, .comp_vector = comp_vector};
+	struct ib_cq_init_attr attr = {.cqe = cqe, .comp_vector = comp_vector,
+				       .flags = flags};
 
 	cq = device->create_cq(device, &attr, NULL, NULL);
 
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 321545b..81869e3 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -542,7 +542,8 @@ static int ehca_create_aqp1(struct ehca_shca *shca, u32 port)
 		return -EPERM;
 	}
 
-	ibcq = ib_create_cq(&shca->ib_device, NULL, NULL, (void *)(-1), 10, 0);
+	ibcq = ib_create_cq(&shca->ib_device, NULL, NULL, (void *)(-1), 10,
+			    0, 0);
 	if (IS_ERR(ibcq)) {
 		ehca_err(&shca->ib_device, "Cannot create AQP1 CQ.");
 		return PTR_ERR(ibcq);
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 9cd2b00..96bf34e 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1802,7 +1802,7 @@ static int create_pv_resources(struct ib_device *ibdev, int slave, int port,
 		cq_size *= 2;
 
 	ctx->cq = ib_create_cq(ctx->ib_dev, mlx4_ib_tunnel_comp_handler,
-			       NULL, ctx, cq_size, 0);
+			       NULL, ctx, cq_size, 0, 0);
 	if (IS_ERR(ctx->cq)) {
 		ret = PTR_ERR(ctx->cq);
 		pr_err("Couldn't create tunnel CQ (%d)\n", ret);
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 26678d2..fea61fd 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -786,7 +786,7 @@ static struct ib_xrcd *mlx4_ib_alloc_xrcd(struct ib_device *ibdev,
 		goto err2;
 	}
 
-	xrcd->cq = ib_create_cq(ibdev, NULL, NULL, xrcd, 1, 0);
+	xrcd->cq = ib_create_cq(ibdev, NULL, NULL, xrcd, 1, 0, 0);
 	if (IS_ERR(xrcd->cq)) {
 		err = PTR_ERR(xrcd->cq);
 		goto err3;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5a86c45..720ebe3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1001,7 +1001,7 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
 	}
 
 	cq = ib_create_cq(&dev->ib_dev, mlx5_umr_cq_handler, NULL, NULL, 128,
-			  0);
+			  0, 0);
 	if (IS_ERR(cq)) {
 		mlx5_ib_dbg(dev, "Couldn't create CQ for sync UMR QP\n");
 		ret = PTR_ERR(cq);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index e5cc430..2bf241b 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -178,14 +178,15 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	} else
 		goto out_free_wq;
 
-	priv->recv_cq = ib_create_cq(priv->ca, ipoib_ib_completion, NULL, dev, size, 0);
+	priv->recv_cq = ib_create_cq(priv->ca, ipoib_ib_completion, NULL,
+				     dev, size, 0, 0);
 	if (IS_ERR(priv->recv_cq)) {
 		printk(KERN_WARNING "%s: failed to create receive CQ\n", ca->name);
 		goto out_cm_dev_cleanup;
 	}
 
 	priv->send_cq = ib_create_cq(priv->ca, ipoib_send_comp_handler, NULL,
-				     dev, ipoib_sendq_size, 0);
+				     dev, ipoib_sendq_size, 0, 0);
 	if (IS_ERR(priv->send_cq)) {
 		printk(KERN_WARNING "%s: failed to create send CQ\n", ca->name);
 		goto out_free_recv_cq;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index cc2dd35..922d322 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -126,11 +126,9 @@ static int iser_create_device_ib_res(struct iser_device *device)
 		struct iser_comp *comp = &device->comps[i];
 
 		comp->device = device;
-		comp->cq = ib_create_cq(device->ib_device,
-					iser_cq_callback,
-					iser_cq_event_callback,
-					(void *)comp,
-					max_cqe, i);
+		comp->cq = ib_create_cq(device->ib_device, iser_cq_callback,
+					iser_cq_event_callback, (void *)comp,
+					max_cqe, i, 0);
 		if (IS_ERR(comp->cq)) {
 			comp->cq = NULL;
 			goto cq_err;
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index 327529e..f7d9ae0 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -320,11 +320,12 @@ isert_alloc_comps(struct isert_device *device,
 
 		comp->device = device;
 		INIT_WORK(&comp->work, isert_cq_work);
-		comp->cq = ib_create_cq(device->ib_device,
-					isert_cq_callback,
+		comp->cq = ib_create_cq(device->ib_device, isert_cq_callback,
 					isert_cq_event_callback,
 					(void *)comp,
-					max_cqe, i);
+					max_cqe,
+					i,
+					0);
 		if (IS_ERR(comp->cq)) {
 			isert_err("Unable to allocate cq\n");
 			ret = PTR_ERR(comp->cq);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index 918814c..1a2214a 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -507,14 +507,14 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 
 	/* + 1 for SRP_LAST_WR_ID */
 	recv_cq = ib_create_cq(dev->dev, srp_recv_completion, NULL, ch,
-			       target->queue_size + 1, ch->comp_vector);
+			       target->queue_size + 1, ch->comp_vector, 0);
 	if (IS_ERR(recv_cq)) {
 		ret = PTR_ERR(recv_cq);
 		goto err;
 	}
 
 	send_cq = ib_create_cq(dev->dev, srp_send_completion, NULL, ch,
-			       m * target->queue_size, ch->comp_vector);
+			       m * target->queue_size, ch->comp_vector, 0);
 	if (IS_ERR(send_cq)) {
 		ret = PTR_ERR(send_cq);
 		goto err_recv_cq;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9b84b4c..7923683 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2091,7 +2091,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 
 retry:
 	ch->cq = ib_create_cq(sdev->device, srpt_completion, NULL, ch,
-			      ch->rq_size + srp_sq_size, 0);
+			      ch->rq_size + srp_sq_size, 0, 0);
 	if (IS_ERR(ch->cq)) {
 		ret = PTR_ERR(ch->cq);
 		pr_err("failed to create CQ cqe= %d ret= %d\n",
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index 3bad441..f7b9e4b 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -742,10 +742,9 @@ kib_conn_t *kiblnd_create_conn(kib_peer_t *peer, struct rdma_cm_id *cmid,
 
 	kiblnd_map_rx_descs(conn);
 
-	cq = ib_create_cq(cmid->device,
-			  kiblnd_cq_completion, kiblnd_cq_event, conn,
-			  IBLND_CQ_ENTRIES(version),
-			  kiblnd_get_completion_vector(conn, cpt));
+	cq = ib_create_cq(cmid->device, kiblnd_cq_completion,
+			  kiblnd_cq_event, conn, IBLND_CQ_ENTRIES(version),
+			  kiblnd_get_completion_vector(conn, cpt), 0);
 	if (IS_ERR(cq)) {
 		CERROR("Can't create CQ: %ld, cqe: %d\n",
 		       PTR_ERR(cq), IBLND_CQ_ENTRIES(version));
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ad0e2ea..1bbe4a4 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -173,6 +173,10 @@ struct ib_odp_caps {
 	} per_transport_caps;
 };
 
+enum ib_cq_creation_flags {
+	IB_CQ_FLAGS_TIMESTAMP	= 1 << 0,
+};
+
 struct ib_cq_init_attr {
 	int cqe;
 	int comp_vector;
@@ -2193,7 +2197,7 @@ static inline int ib_post_recv(struct ib_qp *qp,
 struct ib_cq *ib_create_cq(struct ib_device *device,
 			   ib_comp_handler comp_handler,
 			   void (*event_handler)(struct ib_event *, void *),
-			   void *cq_context, int cqe, int comp_vector);
+			   void *cq_context, int cqe, int comp_vector, u32 flags);
 
 /**
  * ib_resize_cq - Modifies the capacity of the CQ.
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 3533d2a..9b75f8c 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -707,7 +707,7 @@ rdma_create_trans(struct p9_client *client, const char *addr, char *args)
 	/* Create the Completion Queue */
 	rdma->cq = ib_create_cq(rdma->cm_id->device, cq_comp_handler,
 				cq_event_handler, client,
-				opts.sq_depth + opts.rq_depth + 1, 0);
+				opts.sq_depth + opts.rq_depth + 1, 0, 0);
 	if (IS_ERR(rdma->cq))
 		goto error;
 	ib_req_notify_cq(rdma->cq, IB_CQ_NEXT_COMP);
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index 31b74f5..a7c28ac 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -293,7 +293,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 
 	ic->i_send_cq = ib_create_cq(dev, rds_ib_send_cq_comp_handler,
 				     rds_ib_cq_event_handler, conn,
-				     ic->i_send_ring.w_nr + 1, 0);
+				     ic->i_send_ring.w_nr + 1, 0, 0);
 	if (IS_ERR(ic->i_send_cq)) {
 		ret = PTR_ERR(ic->i_send_cq);
 		ic->i_send_cq = NULL;
@@ -303,7 +303,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 
 	ic->i_recv_cq = ib_create_cq(dev, rds_ib_recv_cq_comp_handler,
 				     rds_ib_cq_event_handler, conn,
-				     ic->i_recv_ring.w_nr, 0);
+				     ic->i_recv_ring.w_nr, 0, 0);
 	if (IS_ERR(ic->i_recv_cq)) {
 		ret = PTR_ERR(ic->i_recv_cq);
 		ic->i_recv_cq = NULL;
diff --git a/net/rds/iw_cm.c b/net/rds/iw_cm.c
index a6c2bea..aec9189 100644
--- a/net/rds/iw_cm.c
+++ b/net/rds/iw_cm.c
@@ -199,8 +199,8 @@ static int rds_iw_init_qp_attrs(struct ib_qp_init_attr *attr,
 	attr->qp_type = IB_QPT_RC;
 
 	attr->send_cq = ib_create_cq(dev, send_cq_handler,
-				     rds_iw_cq_event_handler,
-				     context, send_size, 0);
+				     rds_iw_cq_event_handler, context,
+				     send_size, 0, 0);
 	if (IS_ERR(attr->send_cq)) {
 		ret = PTR_ERR(attr->send_cq);
 		attr->send_cq = NULL;
@@ -209,8 +209,8 @@ static int rds_iw_init_qp_attrs(struct ib_qp_init_attr *attr,
 	}
 
 	attr->recv_cq = ib_create_cq(dev, recv_cq_handler,
-				     rds_iw_cq_event_handler,
-				     context, recv_size, 0);
+				     rds_iw_cq_event_handler, context,
+				     recv_size, 0, 0);
 	if (IS_ERR(attr->recv_cq)) {
 		ret = PTR_ERR(attr->recv_cq);
 		attr->recv_cq = NULL;
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 3df8320..cfb5915 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -901,21 +901,16 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		goto errout;
 	}
 	newxprt->sc_sq_cq = ib_create_cq(newxprt->sc_cm_id->device,
-					 sq_comp_handler,
-					 cq_event_handler,
-					 newxprt,
-					 newxprt->sc_sq_depth,
-					 0);
+					 sq_comp_handler, cq_event_handler,
+					 newxprt, newxprt->sc_sq_depth, 0, 0);
 	if (IS_ERR(newxprt->sc_sq_cq)) {
 		dprintk("svcrdma: error creating SQ CQ for connect request\n");
 		goto errout;
 	}
 	newxprt->sc_rq_cq = ib_create_cq(newxprt->sc_cm_id->device,
-					 rq_comp_handler,
-					 cq_event_handler,
-					 newxprt,
-					 newxprt->sc_max_requests,
-					 0);
+					 rq_comp_handler, cq_event_handler,
+					 newxprt, newxprt->sc_max_requests,
+					 0, 0);
 	if (IS_ERR(newxprt->sc_rq_cq)) {
 		dprintk("svcrdma: error creating RQ CQ for connect request\n");
 		goto errout;
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 4870d27..77a65c6 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -772,8 +772,8 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia,
 	INIT_DELAYED_WORK(&ep->rep_connect_worker, rpcrdma_connect_worker);
 
 	sendcq = ib_create_cq(ia->ri_id->device, rpcrdma_sendcq_upcall,
-				  rpcrdma_cq_async_error_upcall, ep,
-				  ep->rep_attr.cap.max_send_wr + 1, 0);
+			      rpcrdma_cq_async_error_upcall, ep,
+			      ep->rep_attr.cap.max_send_wr + 1, 0, 0);
 	if (IS_ERR(sendcq)) {
 		rc = PTR_ERR(sendcq);
 		dprintk("RPC:       %s: failed to create send CQ: %i\n",
@@ -789,8 +789,8 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia,
 	}
 
 	recvcq = ib_create_cq(ia->ri_id->device, rpcrdma_recvcq_upcall,
-				  rpcrdma_cq_async_error_upcall, ep,
-				  ep->rep_attr.cap.max_recv_wr + 1, 0);
+			      rpcrdma_cq_async_error_upcall, ep,
+			      ep->rep_attr.cap.max_recv_wr + 1, 0, 0);
 	if (IS_ERR(recvcq)) {
 		rc = PTR_ERR(recvcq);
 		dprintk("RPC:       %s: failed to create recv CQ: %i\n",
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
