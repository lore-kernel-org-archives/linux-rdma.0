From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V2 2/9] IB/core: Change ib_create_cq to use struct ib_cq_init_attr
Date: Sun, 31 May 2015 15:14:10 +0300
Message-ID: <1433074457-26437-3-git-send-email-ogerlitz@mellanox.com>
References: <1433074457-26437-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1433074457-26437-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Amir Vadai <amirv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently, ib_create_cq uses cqe and comp_vecotr instead
of the extendible ib_cq_init_attr struct.

Earlier patches already changed the vendors to work with
ib_cq_init_attr. This patch changes the consumers too.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/mad.c                      |    5 ++++-
 drivers/infiniband/core/verbs.c                    |    5 ++---
 drivers/infiniband/hw/ehca/ehca_main.c             |    6 +++++-
 drivers/infiniband/hw/mlx4/mad.c                   |    5 ++++-
 drivers/infiniband/hw/mlx4/main.c                  |    5 ++++-
 drivers/infiniband/hw/mlx5/main.c                  |    7 +++++--
 drivers/infiniband/ulp/ipoib/ipoib_verbs.c         |    9 +++++++--
 drivers/infiniband/ulp/iser/iser_verbs.c           |    6 +++++-
 drivers/infiniband/ulp/isert/ib_isert.c            |    6 +++++-
 drivers/infiniband/ulp/srp/ib_srp.c                |   10 ++++++++--
 drivers/infiniband/ulp/srpt/ib_srpt.c              |    5 ++++-
 .../staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c    |    7 +++++--
 include/rdma/ib_verbs.h                            |    6 ++----
 net/9p/trans_rdma.c                                |    5 ++++-
 net/rds/ib_cm.c                                    |    8 ++++++--
 net/rds/iw_cm.c                                    |    8 ++++++--
 net/sunrpc/xprtrdma/svc_rdma_transport.c           |   10 ++++++----
 net/sunrpc/xprtrdma/verbs.c                        |   10 ++++++----
 18 files changed, 88 insertions(+), 35 deletions(-)

diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 600af26..ad3f729 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -2923,6 +2923,7 @@ static int ib_mad_port_open(struct ib_device *device,
 	unsigned long flags;
 	char name[sizeof "ib_mad123"];
 	int has_smi;
+	struct ib_cq_init_attr cq_attr;
 
 	/* Create new device info */
 	port_priv = kzalloc(sizeof *port_priv, GFP_KERNEL);
@@ -2943,9 +2944,11 @@ static int ib_mad_port_open(struct ib_device *device,
 	if (has_smi)
 		cq_size *= 2;
 
+	memset(&cq_attr, 0, sizeof(cq_attr));
+	cq_attr.cqe = cq_size;
 	port_priv->cq = ib_create_cq(port_priv->device,
 				     ib_mad_thread_completion_handler,
-				     NULL, port_priv, cq_size, 0);
+				     NULL, port_priv, &cq_attr);
 	if (IS_ERR(port_priv->cq)) {
 		dev_err(&device->dev, "Couldn't create ib_mad CQ\n");
 		ret = PTR_ERR(port_priv->cq);
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f7615d4..a716ae2 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -1075,12 +1075,11 @@ EXPORT_SYMBOL(ib_destroy_qp);
 struct ib_cq *ib_create_cq(struct ib_device *device,
 			   ib_comp_handler comp_handler,
 			   void (*event_handler)(struct ib_event *, void *),
-			   void *cq_context, int cqe, int comp_vector)
+			   void *cq_context, struct ib_cq_init_attr *cq_attr)
 {
 	struct ib_cq *cq;
-	struct ib_cq_init_attr attr = {.cqe = cqe, .comp_vector = comp_vector};
 
-	cq = device->create_cq(device, &attr, NULL, NULL);
+	cq = device->create_cq(device, cq_attr, NULL, NULL);
 
 	if (!IS_ERR(cq)) {
 		cq->device        = device;
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 5e30b72..7727556 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -552,6 +552,7 @@ static int ehca_create_aqp1(struct ehca_shca *shca, u32 port)
 	struct ib_cq *ibcq;
 	struct ib_qp *ibqp;
 	struct ib_qp_init_attr qp_init_attr;
+	struct ib_cq_init_attr cq_attr;
 	int ret;
 
 	if (sport->ibcq_aqp1) {
@@ -559,7 +560,10 @@ static int ehca_create_aqp1(struct ehca_shca *shca, u32 port)
 		return -EPERM;
 	}
 
-	ibcq = ib_create_cq(&shca->ib_device, NULL, NULL, (void *)(-1), 10, 0);
+	memset(&cq_attr, 0, sizeof(cq_attr));
+	cq_attr.cqe = 10;
+	ibcq = ib_create_cq(&shca->ib_device, NULL, NULL, (void *)(-1),
+			    &cq_attr);
 	if (IS_ERR(ibcq)) {
 		ehca_err(&shca->ib_device, "Cannot create AQP1 CQ.");
 		return PTR_ERR(ibcq);
diff --git a/drivers/infiniband/hw/mlx4/mad.c b/drivers/infiniband/hw/mlx4/mad.c
index 9cd2b00..462e728 100644
--- a/drivers/infiniband/hw/mlx4/mad.c
+++ b/drivers/infiniband/hw/mlx4/mad.c
@@ -1773,6 +1773,7 @@ static int create_pv_resources(struct ib_device *ibdev, int slave, int port,
 			       int create_tun, struct mlx4_ib_demux_pv_ctx *ctx)
 {
 	int ret, cq_size;
+	struct ib_cq_init_attr cq_attr;
 
 	if (ctx->state != DEMUX_PV_STATE_DOWN)
 		return -EEXIST;
@@ -1801,8 +1802,10 @@ static int create_pv_resources(struct ib_device *ibdev, int slave, int port,
 	if (ctx->has_smi)
 		cq_size *= 2;
 
+	memset(&cq_attr, 0, sizeof(cq_attr));
+	cq_attr.cqe = cq_size;
 	ctx->cq = ib_create_cq(ctx->ib_dev, mlx4_ib_tunnel_comp_handler,
-			       NULL, ctx, cq_size, 0);
+			       NULL, ctx, &cq_attr);
 	if (IS_ERR(ctx->cq)) {
 		ret = PTR_ERR(ctx->cq);
 		pr_err("Couldn't create tunnel CQ (%d)\n", ret);
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index c49dd0b..3b90df0 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -758,6 +758,7 @@ static struct ib_xrcd *mlx4_ib_alloc_xrcd(struct ib_device *ibdev,
 					  struct ib_udata *udata)
 {
 	struct mlx4_ib_xrcd *xrcd;
+	struct ib_cq_init_attr cq_attr;
 	int err;
 
 	if (!(to_mdev(ibdev)->dev->caps.flags & MLX4_DEV_CAP_FLAG_XRC))
@@ -777,7 +778,9 @@ static struct ib_xrcd *mlx4_ib_alloc_xrcd(struct ib_device *ibdev,
 		goto err2;
 	}
 
-	xrcd->cq = ib_create_cq(ibdev, NULL, NULL, xrcd, 1, 0);
+	memset(&cq_attr, 0, sizeof(cq_attr));
+	cq_attr.cqe = 1;
+	xrcd->cq = ib_create_cq(ibdev, NULL, NULL, xrcd, &cq_attr);
 	if (IS_ERR(xrcd->cq)) {
 		err = PTR_ERR(xrcd->cq);
 		goto err3;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 9565c20..b9976a0 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -971,6 +971,7 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
 	struct ib_cq *cq;
 	struct ib_qp *qp;
 	struct ib_mr *mr;
+	struct ib_cq_init_attr cq_attr;
 	int ret;
 
 	attr = kzalloc(sizeof(*attr), GFP_KERNEL);
@@ -994,8 +995,10 @@ static int create_umr_res(struct mlx5_ib_dev *dev)
 		goto error_1;
 	}
 
-	cq = ib_create_cq(&dev->ib_dev, mlx5_umr_cq_handler, NULL, NULL, 128,
-			  0);
+	memset(&cq_attr, 0, sizeof(cq_attr));
+	cq_attr.cqe = 128;
+	cq = ib_create_cq(&dev->ib_dev, mlx5_umr_cq_handler, NULL, NULL,
+			  &cq_attr);
 	if (IS_ERR(cq)) {
 		mlx5_ib_dbg(dev, "Couldn't create CQ for sync UMR QP\n");
 		ret = PTR_ERR(cq);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
index e5cc430..93a0ca4 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_verbs.c
@@ -141,6 +141,7 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 		.sq_sig_type = IB_SIGNAL_ALL_WR,
 		.qp_type     = IB_QPT_UD
 	};
+	struct ib_cq_init_attr cq_attr;
 
 	int ret, size;
 	int i;
@@ -178,14 +179,18 @@ int ipoib_transport_dev_init(struct net_device *dev, struct ib_device *ca)
 	} else
 		goto out_free_wq;
 
-	priv->recv_cq = ib_create_cq(priv->ca, ipoib_ib_completion, NULL, dev, size, 0);
+	memset(&cq_attr, 0, sizeof(cq_attr));
+	cq_attr.cqe = size;
+	priv->recv_cq = ib_create_cq(priv->ca, ipoib_ib_completion, NULL,
+				     dev, &cq_attr);
 	if (IS_ERR(priv->recv_cq)) {
 		printk(KERN_WARNING "%s: failed to create receive CQ\n", ca->name);
 		goto out_cm_dev_cleanup;
 	}
 
+	cq_attr.cqe = ipoib_sendq_size;
 	priv->send_cq = ib_create_cq(priv->ca, ipoib_send_comp_handler, NULL,
-				     dev, ipoib_sendq_size, 0);
+				     dev, &cq_attr);
 	if (IS_ERR(priv->send_cq)) {
 		printk(KERN_WARNING "%s: failed to create send CQ\n", ca->name);
 		goto out_free_recv_cq;
diff --git a/drivers/infiniband/ulp/iser/iser_verbs.c b/drivers/infiniband/ulp/iser/iser_verbs.c
index d33c5c0..e287287 100644
--- a/drivers/infiniband/ulp/iser/iser_verbs.c
+++ b/drivers/infiniband/ulp/iser/iser_verbs.c
@@ -126,14 +126,18 @@ static int iser_create_device_ib_res(struct iser_device *device)
 		goto pd_err;
 
 	for (i = 0; i < device->comps_used; i++) {
+		struct ib_cq_init_attr cq_attr;
 		struct iser_comp *comp = &device->comps[i];
 
 		comp->device = device;
+		memset(&cq_attr, 0, sizeof(cq_attr));
+		cq_attr.cqe = max_cqe;
+		cq_attr.comp_vector = i;
 		comp->cq = ib_create_cq(device->ib_device,
 					iser_cq_callback,
 					iser_cq_event_callback,
 					(void *)comp,
-					max_cqe, i);
+					&cq_attr);
 		if (IS_ERR(comp->cq)) {
 			comp->cq = NULL;
 			goto cq_err;
diff --git a/drivers/infiniband/ulp/isert/ib_isert.c b/drivers/infiniband/ulp/isert/ib_isert.c
index d99a0c8..59ac1fc 100644
--- a/drivers/infiniband/ulp/isert/ib_isert.c
+++ b/drivers/infiniband/ulp/isert/ib_isert.c
@@ -318,15 +318,19 @@ isert_alloc_comps(struct isert_device *device,
 	max_cqe = min(ISER_MAX_CQ_LEN, attr->max_cqe);
 
 	for (i = 0; i < device->comps_used; i++) {
+		struct ib_cq_init_attr cq_attr;
 		struct isert_comp *comp = &device->comps[i];
 
 		comp->device = device;
 		INIT_WORK(&comp->work, isert_cq_work);
+		memset(&cq_attr, 0, sizeof(cq_attr));
+		cq_attr.cqe = max_cqe;
+		cq_attr.comp_vector = i;
 		comp->cq = ib_create_cq(device->ib_device,
 					isert_cq_callback,
 					isert_cq_event_callback,
 					(void *)comp,
-					max_cqe, i);
+					&cq_attr);
 		if (IS_ERR(comp->cq)) {
 			isert_err("Unable to allocate cq\n");
 			ret = PTR_ERR(comp->cq);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index c3f654d..16b29cb 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -500,6 +500,7 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 	struct ib_fmr_pool *fmr_pool = NULL;
 	struct srp_fr_pool *fr_pool = NULL;
 	const int m = 1 + dev->use_fast_reg;
+	struct ib_cq_init_attr cq_attr;
 	int ret;
 
 	init_attr = kzalloc(sizeof *init_attr, GFP_KERNEL);
@@ -507,15 +508,20 @@ static int srp_create_ch_ib(struct srp_rdma_ch *ch)
 		return -ENOMEM;
 
 	/* + 1 for SRP_LAST_WR_ID */
+	memset(&cq_attr, 0, sizeof(cq_attr));
+	cq_attr.cqe = target->queue_size + 1;
+	cq_attr.comp_vector = ch->comp_vector;
 	recv_cq = ib_create_cq(dev->dev, srp_recv_completion, NULL, ch,
-			       target->queue_size + 1, ch->comp_vector);
+			       &cq_attr);
 	if (IS_ERR(recv_cq)) {
 		ret = PTR_ERR(recv_cq);
 		goto err;
 	}
 
+	cq_attr.cqe = m * target->queue_size;
+	cq_attr.comp_vector = ch->comp_vector;
 	send_cq = ib_create_cq(dev->dev, srp_send_completion, NULL, ch,
-			       m * target->queue_size, ch->comp_vector);
+			       &cq_attr);
 	if (IS_ERR(send_cq)) {
 		ret = PTR_ERR(send_cq);
 		goto err_recv_cq;
diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index 9b84b4c..1a65202 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -2080,6 +2080,7 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 	struct srpt_port *sport = ch->sport;
 	struct srpt_device *sdev = sport->sdev;
 	u32 srp_sq_size = sport->port_attrib.srp_sq_size;
+	struct ib_cq_init_attr cq_attr;
 	int ret;
 
 	WARN_ON(ch->rq_size < 1);
@@ -2090,8 +2091,10 @@ static int srpt_create_ch_ib(struct srpt_rdma_ch *ch)
 		goto out;
 
 retry:
+	memset(&cq_attr, 0, sizeof(cq_attr));
+	cq_attr.cqe = ch->rq_size + srp_sq_size;
 	ch->cq = ib_create_cq(sdev->device, srpt_completion, NULL, ch,
-			      ch->rq_size + srp_sq_size, 0);
+			      &cq_attr);
 	if (IS_ERR(ch->cq)) {
 		ret = PTR_ERR(ch->cq);
 		pr_err("failed to create CQ cqe= %d ret= %d\n",
diff --git a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
index 3bad441..a23aa76 100644
--- a/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
+++ b/drivers/staging/lustre/lnet/klnds/o2iblnd/o2iblnd.c
@@ -647,6 +647,7 @@ kib_conn_t *kiblnd_create_conn(kib_peer_t *peer, struct rdma_cm_id *cmid,
 	kib_dev_t	      *dev;
 	struct ib_qp_init_attr *init_qp_attr;
 	struct kib_sched_info	*sched;
+	struct ib_cq_init_attr  cq_attr;
 	kib_conn_t		*conn;
 	struct ib_cq		*cq;
 	unsigned long		flags;
@@ -742,10 +743,12 @@ kib_conn_t *kiblnd_create_conn(kib_peer_t *peer, struct rdma_cm_id *cmid,
 
 	kiblnd_map_rx_descs(conn);
 
+	memset(&cq_attr, 0, sizeof(cq_attr));
+	cq_attr.cqe = IBLND_CQ_ENTRIES(version);
+	cq_attr.comp_vector = kiblnd_get_completion_vector(conn, cpt);
 	cq = ib_create_cq(cmid->device,
 			  kiblnd_cq_completion, kiblnd_cq_event, conn,
-			  IBLND_CQ_ENTRIES(version),
-			  kiblnd_get_completion_vector(conn, cpt));
+			  &cq_attr);
 	if (IS_ERR(cq)) {
 		CERROR("Can't create CQ: %ld, cqe: %d\n",
 		       PTR_ERR(cq), IBLND_CQ_ENTRIES(version));
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 6c715d7..321a0b3 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2314,16 +2314,14 @@ static inline int ib_post_recv(struct ib_qp *qp,
  *   asynchronous event not associated with a completion occurs on the CQ.
  * @cq_context: Context associated with the CQ returned to the user via
  *   the associated completion and event handlers.
- * @cqe: The minimum size of the CQ.
- * @comp_vector - Completion vector used to signal completion events.
- *     Must be >= 0 and < context->num_comp_vectors.
+ * @cq_attr: The attributes the CQ should be created upon.
  *
  * Users can examine the cq structure to determine the actual CQ size.
  */
 struct ib_cq *ib_create_cq(struct ib_device *device,
 			   ib_comp_handler comp_handler,
 			   void (*event_handler)(struct ib_event *, void *),
-			   void *cq_context, int cqe, int comp_vector);
+			   void *cq_context, struct ib_cq_init_attr *cq_attr);
 
 /**
  * ib_resize_cq - Modifies the capacity of the CQ.
diff --git a/net/9p/trans_rdma.c b/net/9p/trans_rdma.c
index 3533d2a..bfbcb45 100644
--- a/net/9p/trans_rdma.c
+++ b/net/9p/trans_rdma.c
@@ -648,6 +648,7 @@ rdma_create_trans(struct p9_client *client, const char *addr, char *args)
 	struct rdma_conn_param conn_param;
 	struct ib_qp_init_attr qp_attr;
 	struct ib_device_attr devattr;
+	struct ib_cq_init_attr cq_attr;
 
 	/* Parse the transport specific mount options */
 	err = parse_opts(args, &opts);
@@ -705,9 +706,11 @@ rdma_create_trans(struct p9_client *client, const char *addr, char *args)
 		goto error;
 
 	/* Create the Completion Queue */
+	memset(&cq_attr, 0, sizeof(cq_attr));
+	cq_attr.cqe = opts.sq_depth + opts.rq_depth + 1;
 	rdma->cq = ib_create_cq(rdma->cm_id->device, cq_comp_handler,
 				cq_event_handler, client,
-				opts.sq_depth + opts.rq_depth + 1, 0);
+				&cq_attr);
 	if (IS_ERR(rdma->cq))
 		goto error;
 	ib_req_notify_cq(rdma->cq, IB_CQ_NEXT_COMP);
diff --git a/net/rds/ib_cm.c b/net/rds/ib_cm.c
index b8d1bda..7aa1488 100644
--- a/net/rds/ib_cm.c
+++ b/net/rds/ib_cm.c
@@ -247,6 +247,7 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	struct rds_ib_connection *ic = conn->c_transport_data;
 	struct ib_device *dev = ic->i_cm_id->device;
 	struct ib_qp_init_attr attr;
+	struct ib_cq_init_attr cq_attr;
 	struct rds_ib_device *rds_ibdev;
 	int ret;
 
@@ -270,9 +271,11 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 	ic->i_pd = rds_ibdev->pd;
 	ic->i_mr = rds_ibdev->mr;
 
+	memset(&cq_attr, 0, sizeof(cq_attr));
+	cq_attr.cqe = ic->i_send_ring.w_nr + 1;
 	ic->i_send_cq = ib_create_cq(dev, rds_ib_send_cq_comp_handler,
 				     rds_ib_cq_event_handler, conn,
-				     ic->i_send_ring.w_nr + 1, 0);
+				     &cq_attr);
 	if (IS_ERR(ic->i_send_cq)) {
 		ret = PTR_ERR(ic->i_send_cq);
 		ic->i_send_cq = NULL;
@@ -280,9 +283,10 @@ static int rds_ib_setup_qp(struct rds_connection *conn)
 		goto out;
 	}
 
+	cq_attr.cqe = ic->i_recv_ring.w_nr;
 	ic->i_recv_cq = ib_create_cq(dev, rds_ib_recv_cq_comp_handler,
 				     rds_ib_cq_event_handler, conn,
-				     ic->i_recv_ring.w_nr, 0);
+				     &cq_attr);
 	if (IS_ERR(ic->i_recv_cq)) {
 		ret = PTR_ERR(ic->i_recv_cq);
 		ic->i_recv_cq = NULL;
diff --git a/net/rds/iw_cm.c b/net/rds/iw_cm.c
index a6c2bea..bc29196 100644
--- a/net/rds/iw_cm.c
+++ b/net/rds/iw_cm.c
@@ -179,6 +179,7 @@ static int rds_iw_init_qp_attrs(struct ib_qp_init_attr *attr,
 		void *context)
 {
 	struct ib_device *dev = rds_iwdev->dev;
+	struct ib_cq_init_attr cq_attr;
 	unsigned int send_size, recv_size;
 	int ret;
 
@@ -198,9 +199,11 @@ static int rds_iw_init_qp_attrs(struct ib_qp_init_attr *attr,
 	attr->sq_sig_type = IB_SIGNAL_REQ_WR;
 	attr->qp_type = IB_QPT_RC;
 
+	memset(&cq_attr, 0, sizeof(cq_attr));
+	cq_attr.cqe = send_size;
 	attr->send_cq = ib_create_cq(dev, send_cq_handler,
 				     rds_iw_cq_event_handler,
-				     context, send_size, 0);
+				     context, &cq_attr);
 	if (IS_ERR(attr->send_cq)) {
 		ret = PTR_ERR(attr->send_cq);
 		attr->send_cq = NULL;
@@ -208,9 +211,10 @@ static int rds_iw_init_qp_attrs(struct ib_qp_init_attr *attr,
 		goto out;
 	}
 
+	cq_attr.cqe = recv_size;
 	attr->recv_cq = ib_create_cq(dev, recv_cq_handler,
 				     rds_iw_cq_event_handler,
-				     context, recv_size, 0);
+				     context, &cq_attr);
 	if (IS_ERR(attr->recv_cq)) {
 		ret = PTR_ERR(attr->recv_cq);
 		attr->recv_cq = NULL;
diff --git a/net/sunrpc/xprtrdma/svc_rdma_transport.c b/net/sunrpc/xprtrdma/svc_rdma_transport.c
index 88eb994..ad96ee5 100644
--- a/net/sunrpc/xprtrdma/svc_rdma_transport.c
+++ b/net/sunrpc/xprtrdma/svc_rdma_transport.c
@@ -855,6 +855,7 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 	struct svcxprt_rdma *listen_rdma;
 	struct svcxprt_rdma *newxprt = NULL;
 	struct rdma_conn_param conn_param;
+	struct ib_cq_init_attr cq_attr;
 	struct ib_qp_init_attr qp_attr;
 	struct ib_device_attr devattr;
 	int uninitialized_var(dma_mr_acc);
@@ -907,22 +908,23 @@ static struct svc_xprt *svc_rdma_accept(struct svc_xprt *xprt)
 		dprintk("svcrdma: error creating PD for connect request\n");
 		goto errout;
 	}
+	memset(&cq_attr, 0, sizeof(cq_attr));
+	cq_attr.cqe = newxprt->sc_sq_depth;
 	newxprt->sc_sq_cq = ib_create_cq(newxprt->sc_cm_id->device,
 					 sq_comp_handler,
 					 cq_event_handler,
 					 newxprt,
-					 newxprt->sc_sq_depth,
-					 0);
+					 &cq_attr);
 	if (IS_ERR(newxprt->sc_sq_cq)) {
 		dprintk("svcrdma: error creating SQ CQ for connect request\n");
 		goto errout;
 	}
+	cq_attr.cqe = newxprt->sc_max_requests;
 	newxprt->sc_rq_cq = ib_create_cq(newxprt->sc_cm_id->device,
 					 rq_comp_handler,
 					 cq_event_handler,
 					 newxprt,
-					 newxprt->sc_max_requests,
-					 0);
+					 &cq_attr);
 	if (IS_ERR(newxprt->sc_rq_cq)) {
 		dprintk("svcrdma: error creating RQ CQ for connect request\n");
 		goto errout;
diff --git a/net/sunrpc/xprtrdma/verbs.c b/net/sunrpc/xprtrdma/verbs.c
index 6f6b8a5..5ac60d4 100644
--- a/net/sunrpc/xprtrdma/verbs.c
+++ b/net/sunrpc/xprtrdma/verbs.c
@@ -644,6 +644,7 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia,
 {
 	struct ib_device_attr *devattr = &ia->ri_devattr;
 	struct ib_cq *sendcq, *recvcq;
+	struct ib_cq_init_attr cq_attr;
 	int rc, err;
 
 	/* check provider's send/recv wr limits */
@@ -691,9 +692,10 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia,
 	init_waitqueue_head(&ep->rep_connect_wait);
 	INIT_DELAYED_WORK(&ep->rep_connect_worker, rpcrdma_connect_worker);
 
+	memset(&cq_attr, 0, sizeof(cq_attr));
+	cq_attr.cqe = ep->rep_attr.cap.max_send_wr + 1;
 	sendcq = ib_create_cq(ia->ri_id->device, rpcrdma_sendcq_upcall,
-				  rpcrdma_cq_async_error_upcall, ep,
-				  ep->rep_attr.cap.max_send_wr + 1, 0);
+				  rpcrdma_cq_async_error_upcall, ep, &cq_attr);
 	if (IS_ERR(sendcq)) {
 		rc = PTR_ERR(sendcq);
 		dprintk("RPC:       %s: failed to create send CQ: %i\n",
@@ -708,9 +710,9 @@ rpcrdma_ep_create(struct rpcrdma_ep *ep, struct rpcrdma_ia *ia,
 		goto out2;
 	}
 
+	cq_attr.cqe = ep->rep_attr.cap.max_recv_wr + 1;
 	recvcq = ib_create_cq(ia->ri_id->device, rpcrdma_recvcq_upcall,
-				  rpcrdma_cq_async_error_upcall, ep,
-				  ep->rep_attr.cap.max_recv_wr + 1, 0);
+				  rpcrdma_cq_async_error_upcall, ep, &cq_attr);
 	if (IS_ERR(recvcq)) {
 		rc = PTR_ERR(recvcq);
 		dprintk("RPC:       %s: failed to create recv CQ: %i\n",
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
