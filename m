From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH] rds: use local_dma_lkey
Date: Fri, 18 Dec 2015 14:55:53 +0100
Message-ID: <1450446953-18848-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Santosh Shilimkar <santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

We now alwasy have a per-PD local_dma_lkey available.  Make use of that
fact in rds and stop registering our own MR.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/staging/rdma/ehca/ehca_mrmw.c |  1 -
 net/rds/iw.c                          | 19 +------------------
 net/rds/iw.h                          |  9 ---------
 net/rds/iw_cm.c                       |  6 +-----
 net/rds/iw_recv.c                     |  2 +-
 net/rds/iw_send.c                     |  7 ++++---
 6 files changed, 7 insertions(+), 37 deletions(-)

diff --git a/drivers/staging/rdma/ehca/ehca_mrmw.c b/drivers/staging/rdma/ehca/ehca_mrmw.c
index 1814af7..06b832b 100644
--- a/drivers/staging/rdma/ehca/ehca_mrmw.c
+++ b/drivers/staging/rdma/ehca/ehca_mrmw.c
@@ -1339,7 +1339,6 @@ int ehca_reg_internal_maxmr(
 	e_mr->ib.ib_mr.pd = &e_pd->ib_pd;
 	e_mr->ib.ib_mr.uobject = NULL;
 	atomic_inc(&(e_pd->ib_pd.usecnt));
-	atomic_set(&(e_mr->ib.ib_mr.usecnt), 0);
 	*e_maxmr = e_mr;
 	return 0;
 
diff --git a/net/rds/iw.c b/net/rds/iw.c
index c74bc8b74..27e9c5e 100644
--- a/net/rds/iw.c
+++ b/net/rds/iw.c
@@ -71,7 +71,6 @@ static void rds_iw_add_one(struct ib_device *device)
 
 	spin_lock_init(&rds_iwdev->spinlock);
 
-	rds_iwdev->dma_local_lkey = !!(device->device_cap_flags & IB_DEVICE_LOCAL_DMA_LKEY);
 	rds_iwdev->max_wrs = device->max_qp_wr;
 	rds_iwdev->max_sge = min(device->max_sge, RDS_IW_MAX_SGE);
 
@@ -80,20 +79,10 @@ static void rds_iw_add_one(struct ib_device *device)
 	if (IS_ERR(rds_iwdev->pd))
 		goto free_dev;
 
-	if (!rds_iwdev->dma_local_lkey) {
-		rds_iwdev->mr = ib_get_dma_mr(rds_iwdev->pd,
-					IB_ACCESS_REMOTE_READ |
-					IB_ACCESS_REMOTE_WRITE |
-					IB_ACCESS_LOCAL_WRITE);
-		if (IS_ERR(rds_iwdev->mr))
-			goto err_pd;
-	} else
-		rds_iwdev->mr = NULL;
-
 	rds_iwdev->mr_pool = rds_iw_create_mr_pool(rds_iwdev);
 	if (IS_ERR(rds_iwdev->mr_pool)) {
 		rds_iwdev->mr_pool = NULL;
-		goto err_mr;
+		goto err_pd;
 	}
 
 	INIT_LIST_HEAD(&rds_iwdev->cm_id_list);
@@ -103,9 +92,6 @@ static void rds_iw_add_one(struct ib_device *device)
 	ib_set_client_data(device, &rds_iw_client, rds_iwdev);
 	return;
 
-err_mr:
-	if (rds_iwdev->mr)
-		ib_dereg_mr(rds_iwdev->mr);
 err_pd:
 	ib_dealloc_pd(rds_iwdev->pd);
 free_dev:
@@ -132,9 +118,6 @@ static void rds_iw_remove_one(struct ib_device *device, void *client_data)
 	if (rds_iwdev->mr_pool)
 		rds_iw_destroy_mr_pool(rds_iwdev->mr_pool);
 
-	if (rds_iwdev->mr)
-		ib_dereg_mr(rds_iwdev->mr);
-
 	ib_dealloc_pd(rds_iwdev->pd);
 
 	list_del(&rds_iwdev->list);
diff --git a/net/rds/iw.h b/net/rds/iw.h
index 5af01d1..b0f6f46 100644
--- a/net/rds/iw.h
+++ b/net/rds/iw.h
@@ -111,7 +111,6 @@ struct rds_iw_connection {
 	/* alphabet soup, IBTA style */
 	struct rdma_cm_id	*i_cm_id;
 	struct ib_pd		*i_pd;
-	struct ib_mr		*i_mr;
 	struct ib_cq		*i_send_cq;
 	struct ib_cq		*i_recv_cq;
 
@@ -160,7 +159,6 @@ struct rds_iw_connection {
 
 	/* Protocol version specific information */
 	unsigned int		i_flowctl:1;	/* enable/disable flow ctl */
-	unsigned int		i_dma_local_lkey:1;
 	unsigned int		i_fastreg_posted:1; /* fastreg posted on this connection */
 	/* Batched completions */
 	unsigned int		i_unsignaled_wrs;
@@ -184,11 +182,9 @@ struct rds_iw_device {
 	struct list_head	conn_list;
 	struct ib_device	*dev;
 	struct ib_pd		*pd;
-	struct ib_mr		*mr;
 	struct rds_iw_mr_pool	*mr_pool;
 	int			max_sge;
 	unsigned int		max_wrs;
-	unsigned int		dma_local_lkey:1;
 	spinlock_t		spinlock;	/* protect the above */
 };
 
@@ -265,11 +261,6 @@ static inline void rds_iw_dma_sync_sg_for_device(struct ib_device *dev,
 }
 #define ib_dma_sync_sg_for_device	rds_iw_dma_sync_sg_for_device
 
-static inline u32 rds_iw_local_dma_lkey(struct rds_iw_connection *ic)
-{
-	return ic->i_dma_local_lkey ? ic->i_cm_id->device->local_dma_lkey : ic->i_mr->lkey;
-}
-
 /* ib.c */
 extern struct rds_transport rds_iw_transport;
 extern struct ib_client rds_iw_client;
diff --git a/net/rds/iw_cm.c b/net/rds/iw_cm.c
index aea4c91..78d5f52 100644
--- a/net/rds/iw_cm.c
+++ b/net/rds/iw_cm.c
@@ -269,7 +269,6 @@ static int rds_iw_setup_qp(struct rds_connection *conn)
 
 	/* Protection domain and memory range */
 	ic->i_pd = rds_iwdev->pd;
-	ic->i_mr = rds_iwdev->mr;
 
 	ret = rds_iw_init_qp_attrs(&attr, rds_iwdev,
 			&ic->i_send_ring, rds_iw_send_cq_comp_handler,
@@ -341,7 +340,7 @@ static int rds_iw_setup_qp(struct rds_connection *conn)
 	 * the posted credit count. */
 	rds_iw_recv_refill(conn, GFP_KERNEL, GFP_HIGHUSER, 1);
 
-	rdsdebug("conn %p pd %p mr %p cq %p %p\n", conn, ic->i_pd, ic->i_mr,
+	rdsdebug("conn %p pd %p cq %p %p\n", conn, ic->i_pd,
 		 ic->i_send_cq, ic->i_recv_cq);
 
 out:
@@ -446,7 +445,6 @@ int rds_iw_cm_handle_connect(struct rdma_cm_id *cm_id,
 	cm_id->context = conn;
 
 	rds_iwdev = ib_get_client_data(cm_id->device, &rds_iw_client);
-	ic->i_dma_local_lkey = rds_iwdev->dma_local_lkey;
 
 	/* We got halfway through setting up the ib_connection, if we
 	 * fail now, we have to take the long route out of this mess. */
@@ -550,7 +548,6 @@ int rds_iw_conn_connect(struct rds_connection *conn)
 	}
 
 	rds_iwdev = ib_get_client_data(ic->i_cm_id->device, &rds_iw_client);
-	ic->i_dma_local_lkey = rds_iwdev->dma_local_lkey;
 
 	dest.sin_family = AF_INET;
 	dest.sin_addr.s_addr = (__force u32)conn->c_faddr;
@@ -649,7 +646,6 @@ void rds_iw_conn_shutdown(struct rds_connection *conn)
 
 		ic->i_cm_id = NULL;
 		ic->i_pd = NULL;
-		ic->i_mr = NULL;
 		ic->i_send_cq = NULL;
 		ic->i_recv_cq = NULL;
 		ic->i_send_hdrs = NULL;
diff --git a/net/rds/iw_recv.c b/net/rds/iw_recv.c
index a66d179..d45178f 100644
--- a/net/rds/iw_recv.c
+++ b/net/rds/iw_recv.c
@@ -351,7 +351,7 @@ void rds_iw_recv_init_ack(struct rds_iw_connection *ic)
 
 	sge->addr = ic->i_ack_dma;
 	sge->length = sizeof(struct rds_header);
-	sge->lkey = rds_iw_local_dma_lkey(ic);
+	sge->lkey = ic->rds_iwdev->pd->local_dma_lkey;
 
 	wr->sg_list = sge;
 	wr->num_sge = 1;
diff --git a/net/rds/iw_send.c b/net/rds/iw_send.c
index e20bd50..06c3450 100644
--- a/net/rds/iw_send.c
+++ b/net/rds/iw_send.c
@@ -457,7 +457,7 @@ rds_iw_xmit_populate_wr(struct rds_iw_connection *ic,
 		sge = rds_iw_data_sge(ic, send->s_sge);
 		sge->addr = buffer;
 		sge->length = length;
-		sge->lkey = rds_iw_local_dma_lkey(ic);
+		sge->lkey = ic->rds_iwdev->pd->local_dma_lkey;
 
 		sge = rds_iw_header_sge(ic, send->s_sge);
 	} else {
@@ -469,7 +469,7 @@ rds_iw_xmit_populate_wr(struct rds_iw_connection *ic,
 
 	sge->addr = ic->i_send_hdrs_dma + (pos * sizeof(struct rds_header));
 	sge->length = sizeof(struct rds_header);
-	sge->lkey = rds_iw_local_dma_lkey(ic);
+	sge->lkey = ic->rds_iwdev->pd->local_dma_lkey;
 }
 
 /*
@@ -903,7 +903,8 @@ int rds_iw_xmit_rdma(struct rds_connection *conn, struct rm_rdma_op *op)
 			else {
 				send->s_sge[j].addr = ib_sg_dma_address(ic->i_cm_id->device, scat);
 				send->s_sge[j].length = len;
-				send->s_sge[j].lkey = rds_iw_local_dma_lkey(ic);
+				send->s_sge[j].lkey =
+					ic->rds_iwdev->pd->local_dma_lkey;
 			}
 
 			sent += len;
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
