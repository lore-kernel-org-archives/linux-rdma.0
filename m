From: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Subject: [PATCH 37/47] RDMA/qedr: Declare local functions static
Date: Fri,  6 Oct 2017 14:33:23 -0700
Message-ID: <20171006213333.6721-38-bart.vanassche@wdc.com>
References: <20171006213333.6721-1-bart.vanassche@wdc.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171006213333.6721-1-bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>, Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Bart Van Assche <bart.vanassche-Sjgp3cTcYWE@public.gmane.org>
Cc: Michal Kalderon <Michal.Kalderon-YGCgFSpz5w/QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/qedr/main.c         | 22 +++++++++++-----------
 drivers/infiniband/hw/qedr/qedr_iw_cm.c   | 14 +++++++-------
 drivers/infiniband/hw/qedr/qedr_roce_cm.c | 27 +++++++++++++--------------
 drivers/infiniband/hw/qedr/verbs.c        |  2 +-
 4 files changed, 32 insertions(+), 33 deletions(-)

diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
index 1afc26785049..be282e4915d8 100644
--- a/drivers/infiniband/hw/qedr/main.c
+++ b/drivers/infiniband/hw/qedr/main.c
@@ -54,8 +54,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 
 #define QEDR_WQ_MULTIPLIER_DFT	(3)
 
-void qedr_ib_dispatch_event(struct qedr_dev *dev, u8 port_num,
-			    enum ib_event_type type)
+static void qedr_ib_dispatch_event(struct qedr_dev *dev, u8 port_num,
+				   enum ib_event_type type)
 {
 	struct ib_event ibev;
 
@@ -96,8 +96,8 @@ static struct net_device *qedr_get_netdev(struct ib_device *dev, u8 port_num)
 	return qdev->ndev;
 }
 
-int qedr_roce_port_immutable(struct ib_device *ibdev, u8 port_num,
-			     struct ib_port_immutable *immutable)
+static int qedr_roce_port_immutable(struct ib_device *ibdev, u8 port_num,
+				    struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
 	int err;
@@ -115,8 +115,8 @@ int qedr_roce_port_immutable(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }
 
-int qedr_iw_port_immutable(struct ib_device *ibdev, u8 port_num,
-			   struct ib_port_immutable *immutable)
+static int qedr_iw_port_immutable(struct ib_device *ibdev, u8 port_num,
+				  struct ib_port_immutable *immutable)
 {
 	struct ib_port_attr attr;
 	int err;
@@ -133,7 +133,7 @@ int qedr_iw_port_immutable(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }
 
-int qedr_iw_register_device(struct qedr_dev *dev)
+static int qedr_iw_register_device(struct qedr_dev *dev)
 {
 	dev->ibdev.node_type = RDMA_NODE_RNIC;
 	dev->ibdev.query_gid = qedr_iw_query_gid;
@@ -159,7 +159,7 @@ int qedr_iw_register_device(struct qedr_dev *dev)
 	return 0;
 }
 
-void qedr_roce_register_device(struct qedr_dev *dev)
+static void qedr_roce_register_device(struct qedr_dev *dev)
 {
 	dev->ibdev.node_type = RDMA_NODE_IB_CA;
 	dev->ibdev.query_gid = qedr_query_gid;
@@ -689,12 +689,12 @@ static int qedr_set_device_attr(struct qedr_dev *dev)
 	return 0;
 }
 
-void qedr_unaffiliated_event(void *context, u8 event_code)
+static void qedr_unaffiliated_event(void *context, u8 event_code)
 {
 	pr_err("unaffiliated event not implemented yet\n");
 }
 
-void qedr_affiliated_event(void *context, u8 e_code, void *fw_handle)
+static void qedr_affiliated_event(void *context, u8 e_code, void *fw_handle)
 {
 #define EVENT_TYPE_NOT_DEFINED	0
 #define EVENT_TYPE_CQ		1
@@ -833,7 +833,7 @@ static int qedr_init_hw(struct qedr_dev *dev)
 	return rc;
 }
 
-void qedr_stop_hw(struct qedr_dev *dev)
+static void qedr_stop_hw(struct qedr_dev *dev)
 {
 	dev->ops->rdma_remove_user(dev->rdma_ctx, dev->dpi);
 	dev->ops->rdma_stop(dev->rdma_ctx);
diff --git a/drivers/infiniband/hw/qedr/qedr_iw_cm.c b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
index 2950d3f6ecb8..478b7317b80a 100644
--- a/drivers/infiniband/hw/qedr/qedr_iw_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_iw_cm.c
@@ -79,7 +79,7 @@ qedr_fill_sockaddr6(const struct qed_iwarp_cm_info *cm_info,
 	}
 }
 
-void
+static void
 qedr_iw_mpa_request(void *context, struct qed_iwarp_cm_event_params *params)
 {
 	struct qedr_iw_listener *listener = (struct qedr_iw_listener *)context;
@@ -113,7 +113,7 @@ qedr_iw_mpa_request(void *context, struct qed_iwarp_cm_event_params *params)
 	listener->cm_id->event_handler(listener->cm_id, &event);
 }
 
-void
+static void
 qedr_iw_issue_event(void *context,
 		    struct qed_iwarp_cm_event_params *params,
 		    enum iw_cm_event_type event_type)
@@ -136,7 +136,7 @@ qedr_iw_issue_event(void *context,
 		ep->cm_id->event_handler(ep->cm_id, &event);
 }
 
-void
+static void
 qedr_iw_close_event(void *context, struct qed_iwarp_cm_event_params *params)
 {
 	struct qedr_iw_ep *ep = (struct qedr_iw_ep *)context;
@@ -149,7 +149,7 @@ qedr_iw_close_event(void *context, struct qed_iwarp_cm_event_params *params)
 	}
 }
 
-void
+static void
 qedr_iw_qp_event(void *context,
 		 struct qed_iwarp_cm_event_params *params,
 		 enum ib_event_type ib_event, char *str)
@@ -217,7 +217,7 @@ static void qedr_iw_disconnect_worker(struct work_struct *work)
 	qedr_iw_qp_rem_ref(&qp->ibqp);
 }
 
-void
+static void
 qedr_iw_disconnect_event(void *context,
 			 struct qed_iwarp_cm_event_params *params)
 {
@@ -262,7 +262,7 @@ qedr_iw_passive_complete(void *context,
 		qedr_iw_close_event(context, params);
 }
 
-int
+static int
 qedr_iw_mpa_reply(void *context, struct qed_iwarp_cm_event_params *params)
 {
 	struct qedr_iw_ep *ep = (struct qedr_iw_ep *)context;
@@ -274,7 +274,7 @@ qedr_iw_mpa_reply(void *context, struct qed_iwarp_cm_event_params *params)
 	return dev->ops->iwarp_send_rtr(dev->rdma_ctx, &rtr_in);
 }
 
-int
+static int
 qedr_iw_event_handler(void *context, struct qed_iwarp_cm_event_params *params)
 {
 	struct qedr_iw_ep *ep = (struct qedr_iw_ep *)context;
diff --git a/drivers/infiniband/hw/qedr/qedr_roce_cm.c b/drivers/infiniband/hw/qedr/qedr_roce_cm.c
index 2a0346678ddd..9dbf0cc985f3 100644
--- a/drivers/infiniband/hw/qedr/qedr_roce_cm.c
+++ b/drivers/infiniband/hw/qedr/qedr_roce_cm.c
@@ -64,11 +64,11 @@ void qedr_store_gsi_qp_cq(struct qedr_dev *dev, struct qedr_qp *qp,
 	dev->gsi_qp = qp;
 }
 
-void qedr_ll2_complete_tx_packet(void *cxt,
-				 u8 connection_handle,
-				 void *cookie,
-				 dma_addr_t first_frag_addr,
-				 bool b_last_fragment, bool b_last_packet)
+static void qedr_ll2_complete_tx_packet(void *cxt, u8 connection_handle,
+					void *cookie,
+					dma_addr_t first_frag_addr,
+					bool b_last_fragment,
+					bool b_last_packet)
 {
 	struct qedr_dev *dev = (struct qedr_dev *)cxt;
 	struct qed_roce_ll2_packet *pkt = cookie;
@@ -93,8 +93,8 @@ void qedr_ll2_complete_tx_packet(void *cxt,
 		(*cq->ibcq.comp_handler) (&cq->ibcq, cq->ibcq.cq_context);
 }
 
-void qedr_ll2_complete_rx_packet(void *cxt,
-				 struct qed_ll2_comp_rx_data *data)
+static void qedr_ll2_complete_rx_packet(void *cxt,
+					struct qed_ll2_comp_rx_data *data)
 {
 	struct qedr_dev *dev = (struct qedr_dev *)cxt;
 	struct qedr_cq *cq = dev->gsi_rqcq;
@@ -122,10 +122,9 @@ void qedr_ll2_complete_rx_packet(void *cxt,
 		(*cq->ibcq.comp_handler) (&cq->ibcq, cq->ibcq.cq_context);
 }
 
-void qedr_ll2_release_rx_packet(void *cxt,
-				u8 connection_handle,
-				void *cookie,
-				dma_addr_t rx_buf_addr, bool b_last_packet)
+static void qedr_ll2_release_rx_packet(void *cxt, u8 connection_handle,
+				       void *cookie, dma_addr_t rx_buf_addr,
+				       bool b_last_packet)
 {
 	/* Do nothing... */
 }
@@ -237,7 +236,7 @@ static int qedr_ll2_post_tx(struct qedr_dev *dev,
 	return 0;
 }
 
-int qedr_ll2_stop(struct qedr_dev *dev)
+static int qedr_ll2_stop(struct qedr_dev *dev)
 {
 	int rc;
 
@@ -260,8 +259,8 @@ int qedr_ll2_stop(struct qedr_dev *dev)
 	return rc;
 }
 
-int qedr_ll2_start(struct qedr_dev *dev,
-		   struct ib_qp_init_attr *attrs, struct qedr_qp *qp)
+static int qedr_ll2_start(struct qedr_dev *dev,
+			  struct ib_qp_init_attr *attrs, struct qedr_qp *qp)
 {
 	struct qed_ll2_acquire_data data;
 	struct qed_ll2_cbs cbs;
diff --git a/drivers/infiniband/hw/qedr/verbs.c b/drivers/infiniband/hw/qedr/verbs.c
index a8a6e66767d5..5acb9eab64ed 100644
--- a/drivers/infiniband/hw/qedr/verbs.c
+++ b/drivers/infiniband/hw/qedr/verbs.c
@@ -2268,7 +2268,7 @@ int qedr_query_qp(struct ib_qp *ibqp,
 	return rc;
 }
 
-int qedr_free_qp_resources(struct qedr_dev *dev, struct qedr_qp *qp)
+static int qedr_free_qp_resources(struct qedr_dev *dev, struct qedr_qp *qp)
 {
 	int rc = 0;
 
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
