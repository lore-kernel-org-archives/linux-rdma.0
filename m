From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 for-next 08/10] IB/core: Extend create QP to get RX HASH configuration
Date: Sun, 17 Apr 2016 17:27:15 +0300
Message-ID: <1460903237-16870-9-git-send-email-yishaih@mellanox.com>
References: <1460903237-16870-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1460903237-16870-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, alexv-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, tzahio-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Extend create QP to get RX HASH configuration. This configuration
includes:
 * Receive Work Queue (WQ) indirection table.
 * The hashing function used to choose the WQ from this table.
 * The packet's properties the hashing function should use.

If a QP contains external WQs (without any internal queues), it is
created stateless and ready to receive immediately.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/verbs.c | 24 ++++++++++++++++++++++--
 include/rdma/ib_verbs.h         | 35 +++++++++++++++++++++++++++++++++++
 2 files changed, 57 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f06b6ca..ad0a26e 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -729,6 +729,15 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 	struct ib_qp *qp, *real_qp;
 	struct ib_device *device;
 
+	if (qp_init_attr->rx_hash_conf) {
+		if (qp_init_attr->send_cq || qp_init_attr->recv_cq)
+			return ERR_PTR(-EINVAL);
+		if ((qp_init_attr->qp_type != IB_QPT_UD) ||
+		    (qp_init_attr->qp_type != IB_QPT_RAW_ETHERTYPE) ||
+		    (qp_init_attr->qp_type != IB_QPT_RAW_PACKET))
+			return ERR_PTR(-EINVAL);
+	}
+
 	device = pd ? pd->device : qp_init_attr->xrcd->device;
 	qp = device->create_qp(pd, qp_init_attr, NULL);
 
@@ -737,6 +746,7 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 		qp->real_qp    = qp;
 		qp->uobject    = NULL;
 		qp->qp_type    = qp_init_attr->qp_type;
+		qp->rwq_ind_tbl = NULL;
 
 		atomic_set(&qp->usecnt, 0);
 		if (qp_init_attr->qp_type == IB_QPT_XRC_TGT) {
@@ -764,7 +774,8 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 				qp->srq = NULL;
 			} else {
 				qp->recv_cq = qp_init_attr->recv_cq;
-				atomic_inc(&qp_init_attr->recv_cq->usecnt);
+				if (!qp_init_attr->rx_hash_conf)
+					atomic_inc(&qp_init_attr->recv_cq->usecnt);
 				qp->srq = qp_init_attr->srq;
 				if (qp->srq)
 					atomic_inc(&qp_init_attr->srq->usecnt);
@@ -775,7 +786,12 @@ struct ib_qp *ib_create_qp(struct ib_pd *pd,
 			qp->xrcd    = NULL;
 
 			atomic_inc(&pd->usecnt);
-			atomic_inc(&qp_init_attr->send_cq->usecnt);
+			if (qp_init_attr->rx_hash_conf) {
+				qp->rwq_ind_tbl = qp_init_attr->rx_hash_conf->rwq_ind_tbl;
+				atomic_inc(&qp->rwq_ind_tbl->usecnt);
+			} else {
+				atomic_inc(&qp_init_attr->send_cq->usecnt);
+			}
 		}
 	}
 
@@ -1248,6 +1264,7 @@ int ib_destroy_qp(struct ib_qp *qp)
 	struct ib_pd *pd;
 	struct ib_cq *scq, *rcq;
 	struct ib_srq *srq;
+	struct ib_rwq_ind_table *ind_tbl;
 	int ret;
 
 	if (atomic_read(&qp->usecnt))
@@ -1260,6 +1277,7 @@ int ib_destroy_qp(struct ib_qp *qp)
 	scq  = qp->send_cq;
 	rcq  = qp->recv_cq;
 	srq  = qp->srq;
+	ind_tbl = qp->rwq_ind_tbl;
 
 	ret = qp->device->destroy_qp(qp);
 	if (!ret) {
@@ -1271,6 +1289,8 @@ int ib_destroy_qp(struct ib_qp *qp)
 			atomic_dec(&rcq->usecnt);
 		if (srq)
 			atomic_dec(&srq->usecnt);
+		if (ind_tbl)
+			atomic_dec(&ind_tbl->usecnt);
 	}
 
 	return ret;
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index ee3952c..31018e6 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1005,6 +1005,7 @@ struct ib_qp_init_attr {
 	enum ib_qp_type		qp_type;
 	enum ib_qp_create_flags	create_flags;
 	u8			port_num; /* special QP types only */
+	struct ib_rx_hash_conf	*rx_hash_conf;
 };
 
 struct ib_qp_open_attr {
@@ -1494,6 +1495,40 @@ struct ib_qp {
 	void		       *qp_context;
 	u32			qp_num;
 	enum ib_qp_type		qp_type;
+	struct ib_rwq_ind_table *rwq_ind_tbl;
+};
+
+/* RX Hash function flags */
+enum ib_rx_hash_function_flags {
+	IB_RX_HASH_FUNC_TOEPLITZ	= 1 << 0,
+	IB_RX_HASH_FUNC_XOR		= 1 << 1
+};
+
+/*
+ * RX Hash flags, these flags allows to set which incoming packet's field should
+ * participates in RX Hash. Each flag represent certain packet's field,
+ * when the flag is set the field that is represented by the flag will
+ * participate in RX Hash calculation.
+ * Note: *IPV4 and *IPV6 flags can't be enabled together on the same QP
+ * and *TCP and *UDP flags can't be enabled together on the same QP.
+*/
+enum ib_rx_hash_fields {
+	IB_RX_HASH_SRC_IPV4	= 1 << 0,
+	IB_RX_HASH_DST_IPV4	= 1 << 1,
+	IB_RX_HASH_SRC_IPV6	= 1 << 2,
+	IB_RX_HASH_DST_IPV6	= 1 << 3,
+	IB_RX_HASH_SRC_PORT_TCP	= 1 << 4,
+	IB_RX_HASH_DST_PORT_TCP	= 1 << 5,
+	IB_RX_HASH_SRC_PORT_UDP	= 1 << 6,
+	IB_RX_HASH_DST_PORT_UDP	= 1 << 7
+};
+
+struct ib_rx_hash_conf {
+	enum ib_rx_hash_function_flags rx_hash_function;
+	u8			rx_key_len; /* valid only for Toeplitz */
+	u8			*rx_hash_key;
+	u64			rx_hash_fields_mask; /* enum ib_rx_hash_fields */
+	struct ib_rwq_ind_table *rwq_ind_tbl;
 };
 
 struct ib_mr {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
