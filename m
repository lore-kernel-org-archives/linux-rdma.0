From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: IB/cma: Make timeout dependent on the subnet timeout
Date: Tue, 22 Apr 2014 15:16:37 +0200
Message-ID: <53566BB5.5030203@acm.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The default RDMA/CM timeout and retry values are too large for small IB
networks and make the SRP initiator reconnect mechanism unnecessary slow.
Hence make the CM timeout dependent on the subnet timeout in IB networks.

Signed-off-by: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 199958d..95528e1 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -60,7 +60,6 @@ MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("Generic RDMA CM Agent");
 MODULE_LICENSE("Dual BSD/GPL");
 
-#define CMA_CM_RESPONSE_TIMEOUT 20
 #define CMA_MAX_CM_RETRIES 15
 #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
 #define CMA_IBOE_PACKET_LIFETIME 18
@@ -2728,6 +2727,15 @@ out:
 	return ret;
 }
 
+static u8 cma_get_ib_subnet_timeout(struct rdma_cm_id *id)
+{
+	struct ib_port_attr attr;
+	int ret;
+
+	ret = ib_query_port(id->device, id->port_num, &attr);
+	return ret == 0 ? attr.subnet_timeout : 18;
+}
+
 static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
 			      struct rdma_conn_param *conn_param)
 {
@@ -2735,6 +2743,7 @@ static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
 	struct ib_cm_id	*id;
 	void *private_data;
 	int offset, ret;
+	u8 cm_response_timeout = cma_get_ib_subnet_timeout(&id_priv->id) + 2;
 
 	memset(&req, 0, sizeof req);
 	offset = cma_user_data_offset(id_priv);
@@ -2771,7 +2780,7 @@ static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
 
 	req.path = id_priv->id.route.path_rec;
 	req.service_id = rdma_get_service_id(&id_priv->id, cma_dst_addr(id_priv));
-	req.timeout_ms = 1 << (CMA_CM_RESPONSE_TIMEOUT - 8);
+	req.timeout_ms = 1 << max(cm_response_timeout - 8, 0);
 	req.max_cm_retries = CMA_MAX_CM_RETRIES;
 
 	ret = ib_send_cm_sidr_req(id_priv->cm_id.ib, &req);
@@ -2792,6 +2801,7 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 	void *private_data;
 	struct ib_cm_id	*id;
 	int offset, ret;
+	u8 cm_response_timeout = cma_get_ib_subnet_timeout(&id_priv->id) + 2;
 
 	memset(&req, 0, sizeof req);
 	offset = cma_user_data_offset(id_priv);
@@ -2839,8 +2849,8 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 	req.flow_control = conn_param->flow_control;
 	req.retry_count = min_t(u8, 7, conn_param->retry_count);
 	req.rnr_retry_count = min_t(u8, 7, conn_param->rnr_retry_count);
-	req.remote_cm_response_timeout = CMA_CM_RESPONSE_TIMEOUT;
-	req.local_cm_response_timeout = CMA_CM_RESPONSE_TIMEOUT;
+	req.remote_cm_response_timeout = cm_response_timeout;
+	req.local_cm_response_timeout = cm_response_timeout;
 	req.max_cm_retries = CMA_MAX_CM_RETRIES;
 	req.srq = id_priv->srq ? 1 : 0;
 
-- 
1.8.4.5

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
