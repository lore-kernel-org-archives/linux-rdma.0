From: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v1 rdma-next 9/9] i40iw: Fix the connection ORD value for loopback
Date: Fri, 22 Dec 2017 14:29:32 -0600
Message-ID: <20171222202932.9324-10-shiraz.saleem@intel.com>
References: <20171222202932.9324-1-shiraz.saleem@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171222202932.9324-1-shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, jgg-uk2M96/98Pc@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, e1000-rdma-5NWGOfrQmneRv+LV9MX5uipxlwaOVQ5f@public.gmane.org, Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The accepting QP ORD value should be adjusted not to
exceed the peer QP IRD value (RFC 6581). This is
skipped for loopback. After the ORD is validated
by i40iw_record_ird_ord(), adjust the ORD value of
the loopback accepting QP to prevent overrunning the
IRD space of the peer QP. Also move the ORD accounting
for 0-byte RDMA read to i40iw_record_ird_ord().

Fixes: f27b4746f378 ("i40iw: add connection management code")
Signed-off-by: Tatyana Nikolova <tatyana.e.nikolova-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/i40iw/i40iw_cm.c | 25 +++++++++++++------------
 1 file changed, 13 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_cm.c b/drivers/infiniband/hw/i40iw/i40iw_cm.c
index 34cc335..6acae2a 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_cm.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_cm.c
@@ -127,6 +127,8 @@ static void i40iw_record_ird_ord(struct i40iw_cm_node *cm_node, u32 conn_ird, u3
 
 	if (conn_ord > I40IW_MAX_ORD_SIZE)
 		conn_ord = I40IW_MAX_ORD_SIZE;
+	else if (!conn_ord && cm_node->send_rdma0_op == SEND_RDMA_READ_ZERO)
+		conn_ord = 1;
 
 	cm_node->ird_size = conn_ird;
 	cm_node->ord_size = conn_ord;
@@ -2873,15 +2875,13 @@ static struct i40iw_cm_listener *i40iw_make_listen_node(
  * i40iw_create_cm_node - make a connection node with params
  * @cm_core: cm's core
  * @iwdev: iwarp device structure
- * @private_data_len: len to provate data for mpa request
- * @private_data: pointer to private data for connection
+ * @conn_param: upper layer connection parameters
  * @cm_info: quad info for connection
  */
 static struct i40iw_cm_node *i40iw_create_cm_node(
 					struct i40iw_cm_core *cm_core,
 					struct i40iw_device *iwdev,
-					u16 private_data_len,
-					void *private_data,
+					struct iw_cm_conn_param *conn_param,
 					struct i40iw_cm_info *cm_info)
 {
 	struct i40iw_cm_node *cm_node;
@@ -2889,6 +2889,9 @@ static struct i40iw_cm_node *i40iw_create_cm_node(
 	struct i40iw_cm_node *loopback_remotenode;
 	struct i40iw_cm_info loopback_cm_info;
 
+	u16 private_data_len = conn_param->private_data_len;
+	const void *private_data = conn_param->private_data;
+
 	/* create a CM connection node */
 	cm_node = i40iw_make_cm_node(cm_core, iwdev, cm_info, NULL);
 	if (!cm_node)
@@ -2897,6 +2900,8 @@ static struct i40iw_cm_node *i40iw_create_cm_node(
 	cm_node->tcp_cntxt.client = 1;
 	cm_node->tcp_cntxt.rcv_wscale = I40IW_CM_DEFAULT_RCV_WND_SCALE;
 
+	i40iw_record_ird_ord(cm_node, conn_param->ird, conn_param->ord);
+
 	if (!memcmp(cm_info->loc_addr, cm_info->rem_addr, sizeof(cm_info->loc_addr))) {
 		loopback_remotelistener = i40iw_find_listener(
 						cm_core,
@@ -2930,6 +2935,9 @@ static struct i40iw_cm_node *i40iw_create_cm_node(
 			       private_data_len);
 			loopback_remotenode->pdata.size = private_data_len;
 
+			if (loopback_remotenode->ord_size > cm_node->ird_size)
+				loopback_remotenode->ord_size = cm_node->ird_size;
+
 			cm_node->state = I40IW_CM_STATE_OFFLOADED;
 			cm_node->tcp_cntxt.rcv_nxt =
 				loopback_remotenode->tcp_cntxt.loc_seq_num;
@@ -3808,9 +3816,7 @@ int i40iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 		    __func__, cm_id->tos, cm_info.user_pri);
 	cm_id->add_ref(cm_id);
 	cm_node = i40iw_create_cm_node(&iwdev->cm_core, iwdev,
-				       conn_param->private_data_len,
-				       (void *)conn_param->private_data,
-				       &cm_info);
+				       conn_param, &cm_info);
 
 	if (IS_ERR(cm_node)) {
 		ret = PTR_ERR(cm_node);
@@ -3842,11 +3848,6 @@ int i40iw_connect(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	}
 
 	cm_node->apbvt_set = true;
-	i40iw_record_ird_ord(cm_node, conn_param->ird, conn_param->ord);
-	if (cm_node->send_rdma0_op == SEND_RDMA_READ_ZERO &&
-	    !cm_node->ord_size)
-		cm_node->ord_size = 1;
-
 	iwqp->cm_node = cm_node;
 	cm_node->iwqp = iwqp;
 	iwqp->cm_id = cm_id;
-- 
2.8.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
