From: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH] IB: new module params. cm_response_timeout, max_cm_retries
Date: Wed,  5 Sep 2012 18:07:34 +0200
Message-ID: <1346861254-8614-1-git-send-email-dongsu.park@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Create two kernel parameters, in order to make variables configurable.
i.e. cma_cm_response_timeout for CM response timeout,
     and cma_max_cm_retries for the number of retries.

They can now be configured via command line for the kernel modules.
For example:
    # modprobe ib_srp cma_cm_response_timeout=30 cma_max_cm_retries=60

Signed-off-by: Dongsu Park <dongsu.park-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Reviewed-by: Sebastian Riemer <sebastian.riemer-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/infiniband/core/cma.c           | 21 ++++++++++++++-------
 drivers/infiniband/ulp/ipoib/ipoib_cm.c | 15 ++++++++++++---
 drivers/infiniband/ulp/srp/ib_srp.c     | 14 +++++++++++---
 include/rdma/ib_cm.h                    |  3 +++
 4 files changed, 40 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 7172559..1d7771f 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -59,11 +59,18 @@ MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("Generic RDMA CM Agent");
 MODULE_LICENSE("Dual BSD/GPL");
 
-#define CMA_CM_RESPONSE_TIMEOUT 20
-#define CMA_MAX_CM_RETRIES 15
 #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
 #define CMA_IBOE_PACKET_LIFETIME 18
 
+static unsigned int cma_cm_response_timeout = CMA_CM_RESPONSE_TIMEOUT;
+static unsigned int cma_max_cm_retries = CMA_MAX_CM_RETRIES;
+
+module_param(cma_cm_response_timeout, uint, 0444);
+MODULE_PARM_DESC(cma_cm_response_timeout, "Response timeout for the RDMA Connection Manager. (default is 20)");
+
+module_param(cma_max_cm_retries, uint, 0444);
+MODULE_PARM_DESC(cma_max_cm_retries, "Max number of retries for the RDMA Connection Manager. (default is 15)");
+
 static void cma_add_one(struct ib_device *device);
 static void cma_remove_one(struct ib_device *device);
 
@@ -2587,8 +2594,8 @@ static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
 	req.path = route->path_rec;
 	req.service_id = cma_get_service_id(id_priv->id.ps,
 					    (struct sockaddr *) &route->addr.dst_addr);
-	req.timeout_ms = 1 << (CMA_CM_RESPONSE_TIMEOUT - 8);
-	req.max_cm_retries = CMA_MAX_CM_RETRIES;
+	req.timeout_ms = 1 << (cma_cm_response_timeout - 8);
+	req.max_cm_retries = cma_max_cm_retries;
 
 	ret = ib_send_cm_sidr_req(id_priv->cm_id.ib, &req);
 	if (ret) {
@@ -2650,9 +2657,9 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 	req.flow_control = conn_param->flow_control;
 	req.retry_count = conn_param->retry_count;
 	req.rnr_retry_count = conn_param->rnr_retry_count;
-	req.remote_cm_response_timeout = CMA_CM_RESPONSE_TIMEOUT;
-	req.local_cm_response_timeout = CMA_CM_RESPONSE_TIMEOUT;
-	req.max_cm_retries = CMA_MAX_CM_RETRIES;
+	req.remote_cm_response_timeout = cma_cm_response_timeout;
+	req.local_cm_response_timeout = cma_cm_response_timeout;
+	req.max_cm_retries = cma_max_cm_retries;
 	req.srq = id_priv->srq ? 1 : 0;
 
 	ret = ib_send_cm_req(id_priv->cm_id.ib, &req);
diff --git a/drivers/infiniband/ulp/ipoib/ipoib_cm.c b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
index 24683fd..3b41ab0 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_cm.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_cm.c
@@ -56,6 +56,15 @@ MODULE_PARM_DESC(cm_data_debug_level,
 		 "Enable data path debug tracing for connected mode if > 0");
 #endif
 
+static unsigned int cma_cm_response_timeout = CMA_CM_RESPONSE_TIMEOUT;
+static unsigned int cma_max_cm_retries = CMA_MAX_CM_RETRIES;
+
+module_param(cma_cm_response_timeout, uint, 0444);
+MODULE_PARM_DESC(cma_cm_response_timeout, "Response timeout for the RDMA Connection Manager. (default is 20)");
+
+module_param(cma_max_cm_retries, uint, 0444);
+MODULE_PARM_DESC(cma_max_cm_retries, "Max number of retries for the RDMA Connection Manager. (default is 15)");
+
 #define IPOIB_CM_IETF_ID 0x1000000000000000ULL
 
 #define IPOIB_CM_RX_UPDATE_TIME (256 * HZ)
@@ -1055,11 +1064,11 @@ static int ipoib_cm_send_req(struct net_device *dev,
 	 * module parameters if anyone cared about setting them.
 	 */
 	req.responder_resources		= 4;
-	req.remote_cm_response_timeout	= 20;
-	req.local_cm_response_timeout	= 20;
+	req.remote_cm_response_timeout	= cma_cm_response_timeout;
+	req.local_cm_response_timeout	= cma_cm_response_timeout;
 	req.retry_count			= 0; /* RFC draft warns against retries */
 	req.rnr_retry_count		= 0; /* RFC draft warns against retries */
-	req.max_cm_retries		= 15;
+	req.max_cm_retries		= cma_max_cm_retries;
 	req.srq				= ipoib_cm_has_srq(dev);
 	return ib_send_cm_req(id, &req);
 }
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index ba7bbfd..13536da 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -66,6 +66,8 @@ static unsigned int cmd_sg_entries;
 static unsigned int indirect_sg_entries;
 static bool allow_ext_sg;
 static int topspin_workarounds = 1;
+static unsigned int cma_cm_response_timeout = CMA_CM_RESPONSE_TIMEOUT;
+static unsigned int cma_max_cm_retries = CMA_MAX_CM_RETRIES;
 
 module_param(srp_sg_tablesize, uint, 0444);
 MODULE_PARM_DESC(srp_sg_tablesize, "Deprecated name for cmd_sg_entries");
@@ -86,6 +88,12 @@ module_param(topspin_workarounds, int, 0444);
 MODULE_PARM_DESC(topspin_workarounds,
 		 "Enable workarounds for Topspin/Cisco SRP target bugs if != 0");
 
+module_param(cma_cm_response_timeout, uint, 0444);
+MODULE_PARM_DESC(cma_cm_response_timeout, "Response timeout for the RDMA Connection Manager. (default is 20)");
+
+module_param(cma_max_cm_retries, uint, 0444);
+MODULE_PARM_DESC(cma_max_cm_retries, "Max number of retries for the RDMA Connection Manager. (default is 15)");
+
 static void srp_add_one(struct ib_device *device);
 static void srp_remove_one(struct ib_device *device);
 static void srp_recv_completion(struct ib_cq *cq, void *target_ptr);
@@ -378,11 +386,11 @@ static int srp_send_req(struct srp_target_port *target)
 	 * module parameters if anyone cared about setting them.
 	 */
 	req->param.responder_resources	      = 4;
-	req->param.remote_cm_response_timeout = 20;
-	req->param.local_cm_response_timeout  = 20;
+	req->param.remote_cm_response_timeout = cma_cm_response_timeout;
+	req->param.local_cm_response_timeout  = cma_cm_response_timeout;
 	req->param.retry_count 		      = 7;
 	req->param.rnr_retry_count 	      = 7;
-	req->param.max_cm_retries 	      = 15;
+	req->param.max_cm_retries 	      = cma_max_cm_retries;
 
 	req->priv.opcode     	= SRP_LOGIN_REQ;
 	req->priv.tag        	= 0;
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index 0e3ff30..1cb502e 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -274,6 +274,9 @@ struct ib_cm_event {
 #define CM_LAP_ATTR_ID		cpu_to_be16(0x0019)
 #define CM_APR_ATTR_ID		cpu_to_be16(0x001A)
 
+#define CMA_CM_RESPONSE_TIMEOUT	20
+#define CMA_MAX_CM_RETRIES	15
+
 /**
  * ib_cm_handler - User-defined callback to process communication events.
  * @cm_id: Communication identifier associated with the reported event.
-- 
1.7.11.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
