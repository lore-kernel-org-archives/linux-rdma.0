From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>
Subject: [PATCH 07/12] Clear status reporting from mthca_qp
Date: Thu, 7 Jul 2011 12:22:02 -0500
Message-ID: <20110707172202.GH10241@baloo.cartoons>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

---
 drivers/infiniband/hw/mthca/mthca_qp.c |   49 ++++++++++----------------------
 1 files changed, 15 insertions(+), 34 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_qp.c b/drivers/infiniband/hw/mthca/mthca_qp.c
index a34c9d3..9601049 100644
--- a/drivers/infiniband/hw/mthca/mthca_qp.c
+++ b/drivers/infiniband/hw/mthca/mthca_qp.c
@@ -308,7 +308,6 @@ static void store_attrs(struct mthca_sqp *sqp, const struct ib_qp_attr *attr,
 static void init_port(struct mthca_dev *dev, int port)
 {
 	int err;
-	u8 status;
 	struct mthca_init_ib_param param;
 
 	memset(&param, 0, sizeof param);
@@ -319,11 +318,9 @@ static void init_port(struct mthca_dev *dev, int port)
 	param.gid_cap    = dev->limits.gid_table_len;
 	param.pkey_cap   = dev->limits.pkey_table_len;
 
-	err = mthca_INIT_IB(dev, &param, port, &status);
+	err = mthca_INIT_IB(dev, &param, port);
 	if (err)
 		mthca_warn(dev, "INIT_IB failed, return code %d.\n", err);
-	if (status)
-		mthca_warn(dev, "INIT_IB returned status %02x.\n", status);
 }
 
 static __be32 get_hw_access_flags(struct mthca_qp *qp, const struct ib_qp_attr *attr,
@@ -433,7 +430,6 @@ int mthca_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr_m
 	struct mthca_qp_param *qp_param;
 	struct mthca_qp_context *context;
 	int mthca_state;
-	u8 status;
 
 	mutex_lock(&qp->mutex);
 
@@ -448,12 +444,9 @@ int mthca_query_qp(struct ib_qp *ibqp, struct ib_qp_attr *qp_attr, int qp_attr_m
 		goto out;
 	}
 
-	err = mthca_QUERY_QP(dev, qp->qpn, 0, mailbox, &status);
-	if (err)
-		goto out_mailbox;
-	if (status) {
-		mthca_warn(dev, "QUERY_QP returned status %02x\n", status);
-		err = -EINVAL;
+	err = mthca_QUERY_QP(dev, qp->qpn, 0, mailbox);
+	if (err) {
+		mthca_warn(dev, "QUERY_QP failed (%d)\n", err);
 		goto out_mailbox;
 	}
 
@@ -555,7 +548,6 @@ static int __mthca_modify_qp(struct ib_qp *ibqp,
 	struct mthca_qp_param *qp_param;
 	struct mthca_qp_context *qp_context;
 	u32 sqd_event = 0;
-	u8 status;
 	int err = -EINVAL;
 
 	mailbox = mthca_alloc_mailbox(dev, GFP_KERNEL);
@@ -781,13 +773,10 @@ static int __mthca_modify_qp(struct ib_qp *ibqp,
 		sqd_event = 1 << 31;
 
 	err = mthca_MODIFY_QP(dev, cur_state, new_state, qp->qpn, 0,
-			      mailbox, sqd_event, &status);
-	if (err)
-		goto out_mailbox;
-	if (status) {
-		mthca_warn(dev, "modify QP %d->%d returned status %02x.\n",
-			   cur_state, new_state, status);
-		err = -EINVAL;
+			      mailbox, sqd_event);
+	if (err) {
+		mthca_warn(dev, "modify QP %d->%d returned %d.\n",
+			   cur_state, new_state, err);
 		goto out_mailbox;
 	}
 
@@ -817,7 +806,7 @@ static int __mthca_modify_qp(struct ib_qp *ibqp,
 		    cur_state != IB_QPS_ERR &&
 		    (new_state == IB_QPS_RESET ||
 		     new_state == IB_QPS_ERR))
-			mthca_CLOSE_IB(dev, qp->port, &status);
+			mthca_CLOSE_IB(dev, qp->port);
 	}
 
 	/*
@@ -1429,7 +1418,6 @@ static inline int get_qp_refcount(struct mthca_dev *dev, struct mthca_qp *qp)
 void mthca_free_qp(struct mthca_dev *dev,
 		   struct mthca_qp *qp)
 {
-	u8 status;
 	struct mthca_cq *send_cq;
 	struct mthca_cq *recv_cq;
 
@@ -1454,7 +1442,7 @@ void mthca_free_qp(struct mthca_dev *dev,
 
 	if (qp->state != IB_QPS_RESET)
 		mthca_MODIFY_QP(dev, qp->state, IB_QPS_RESET, qp->qpn, 0,
-				NULL, 0, &status);
+				NULL, 0);
 
 	/*
 	 * If this is a userspace QP, the buffers, MR, CQs and so on
@@ -2263,7 +2251,6 @@ void mthca_free_err_wqe(struct mthca_dev *dev, struct mthca_qp *qp, int is_send,
 int mthca_init_qp_table(struct mthca_dev *dev)
 {
 	int err;
-	u8 status;
 	int i;
 
 	spin_lock_init(&dev->qp_table.lock);
@@ -2290,15 +2277,10 @@ int mthca_init_qp_table(struct mthca_dev *dev)
 
 	for (i = 0; i < 2; ++i) {
 		err = mthca_CONF_SPECIAL_QP(dev, i ? IB_QPT_GSI : IB_QPT_SMI,
-					    dev->qp_table.sqp_start + i * 2,
-					    &status);
-		if (err)
-			goto err_out;
-		if (status) {
+				    dev->qp_table.sqp_start + i * 2);
+		if (err) {
 			mthca_warn(dev, "CONF_SPECIAL_QP returned "
-				   "status %02x, aborting.\n",
-				   status);
-			err = -EINVAL;
+				   "%d, aborting.\n", err);
 			goto err_out;
 		}
 	}
@@ -2306,7 +2288,7 @@ int mthca_init_qp_table(struct mthca_dev *dev)
 
  err_out:
 	for (i = 0; i < 2; ++i)
-		mthca_CONF_SPECIAL_QP(dev, i, 0, &status);
+		mthca_CONF_SPECIAL_QP(dev, i, 0);
 
 	mthca_array_cleanup(&dev->qp_table.qp, dev->limits.num_qps);
 	mthca_alloc_cleanup(&dev->qp_table.alloc);
@@ -2317,10 +2299,9 @@ int mthca_init_qp_table(struct mthca_dev *dev)
 void mthca_cleanup_qp_table(struct mthca_dev *dev)
 {
 	int i;
-	u8 status;
 
 	for (i = 0; i < 2; ++i)
-		mthca_CONF_SPECIAL_QP(dev, i, 0, &status);
+		mthca_CONF_SPECIAL_QP(dev, i, 0);
 
 	mthca_array_cleanup(&dev->qp_table.qp, dev->limits.num_qps);
 	mthca_alloc_cleanup(&dev->qp_table.alloc);
-- 
1.7.5.3


-- 
Goldwyn
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
