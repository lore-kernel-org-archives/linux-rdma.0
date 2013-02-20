From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH perftest] Support iwarp transports.
Date: Tue, 19 Feb 2013 22:09:41 -0600
Message-ID: <20130220040941.31762.66644.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: idos-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

- add transport type for making transport-specific decisions
- rdma read sink mrs need REMOTE_WRITE access for iwarp transports
- set initiator_depth and responder_resources based on device max values
- add chelsio devices

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 src/perftest_communication.c |    8 +++--
 src/perftest_parameters.c    |   63 ++++++++++++++++++++++++++++++++----------
 src/perftest_parameters.h    |    4 ++-
 src/perftest_resources.c     |    2 +
 4 files changed, 57 insertions(+), 20 deletions(-)

diff --git a/src/perftest_communication.c b/src/perftest_communication.c
index 781d796..b88be1d 100644
--- a/src/perftest_communication.c
+++ b/src/perftest_communication.c
@@ -745,8 +745,8 @@ int rdma_client_connect(struct pingpong_context *ctx,struct perftest_parameters
 
 	memset(&conn_param, 0, sizeof conn_param);
 	if (user_param->verb == READ) {
-		conn_param.responder_resources = RDMA_MAX_RESP_RES;
-		conn_param.initiator_depth = RDMA_MAX_INIT_DEPTH;
+		conn_param.responder_resources = user_param->out_reads;
+		conn_param.initiator_depth = user_param->out_reads;
 	}
 	user_param->work_rdma_cm = temp;
 
@@ -862,8 +862,8 @@ int rdma_server_connect(struct pingpong_context *ctx,
 
 	memset(&conn_param, 0, sizeof conn_param);
 	if (user_param->verb == READ) {
-		conn_param.responder_resources = RDMA_MAX_RESP_RES;
-		conn_param.initiator_depth = RDMA_MAX_INIT_DEPTH;
+		conn_param.responder_resources = user_param->out_reads;
+		conn_param.initiator_depth = user_param->out_reads;
 	}
 	if (user_param->connection_type == UD)
 		conn_param.qp_num = ctx->qp[0]->qp_num;
diff --git a/src/perftest_parameters.c b/src/perftest_parameters.c
index e32303a..a6b75d2 100644
--- a/src/perftest_parameters.c
+++ b/src/perftest_parameters.c
@@ -564,6 +564,21 @@ static void force_dependecies(struct perftest_parameters *user_param) {
 /****************************************************************************** 
  *
  ******************************************************************************/
+const char *transport_str(enum ibv_transport_type type) {
+
+	switch (type) {
+        case IBV_TRANSPORT_IB:	
+		return "IB";
+        case IBV_TRANSPORT_IWARP:
+		return "IW";
+        default:
+		return "Unknown";
+	}
+}
+
+/****************************************************************************** 
+ *
+ ******************************************************************************/
 const char *link_layer_str(uint8_t link_layer) {
 
 	switch (link_layer) {
@@ -592,21 +607,37 @@ static Device ib_dev_name(struct ibv_context *context) {
 
 	else { 
 
-		switch (attr.vendor_part_id) { 
-			case 4113  : dev_fname = CONNECTIB; break;
-			case 4099  : dev_fname = CONNECTX3; break;
-			case 26418 : dev_fname = CONNECTX2; break;
-			case 26428 : dev_fname = CONNECTX2; break;
-			case 26438 : dev_fname = CONNECTX2; break;
-			case 26448 : dev_fname = CONNECTX2; break;
-			case 26458 : dev_fname = CONNECTX2; break;
-			case 26468 : dev_fname = CONNECTX2; break;
-			case 26478 : dev_fname = CONNECTX2; break;
-			case 25408 : dev_fname = CONNECTX;  break;
-			case 25418 : dev_fname = CONNECTX;  break;
-			case 25428 : dev_fname = CONNECTX;  break;
-			case 25448 : dev_fname = CONNECTX;  break;
-			default	   : dev_fname = UNKNOWN;
+		switch (attr.vendor_id) {
+			case 5555:
+				switch (attr.vendor_part_id) { 
+					case 4113  : dev_fname = CONNECTIB; break;
+					case 4099  : dev_fname = CONNECTX3; break;
+					case 26418 : dev_fname = CONNECTX2; break;
+					case 26428 : dev_fname = CONNECTX2; break;
+					case 26438 : dev_fname = CONNECTX2; break;
+					case 26448 : dev_fname = CONNECTX2; break;
+					case 26458 : dev_fname = CONNECTX2; break;
+					case 26468 : dev_fname = CONNECTX2; break;
+					case 26478 : dev_fname = CONNECTX2; break;
+					case 25408 : dev_fname = CONNECTX;  break;
+					case 25418 : dev_fname = CONNECTX;  break;
+					case 25428 : dev_fname = CONNECTX;  break;
+					case 25448 : dev_fname = CONNECTX;  break;
+					default	   : dev_fname = UNKNOWN;
+				}
+				break;
+			case 5157: {
+				switch (attr.vendor_part_id >> 12) {
+					case 10 :
+					case 4  : dev_fname = CHELSIO_T4; break;
+					case 11 :
+					case 5  : dev_fname = CHELSIO_T5; break;
+					default : dev_fname = UNKNOWN; break;
+				}
+				break;
+			}
+			default:
+				dev_fname = UNKNOWN;
 		}
 	}
 
@@ -1189,6 +1220,7 @@ int parser(struct perftest_parameters *user_param,char *argv[], int argc) {
  ******************************************************************************/
 int check_link_and_mtu(struct ibv_context *context,struct perftest_parameters *user_param) {
 
+	user_param->transport_type = context->device->transport_type;
 	user_param->link_type = set_link_layer(context,user_param->ib_port);
 	if (user_param->link_type == LINK_FAILURE) {
 		fprintf(stderr, " Couldn't set the link layer\n");
@@ -1323,6 +1355,7 @@ void ctx_print_test_info(struct perftest_parameters *user_param) {
 	} 
 
 	printf(" Mtu             : %luB\n",user_param->connection_type == RawEth ? user_param->curr_mtu : MTU_SIZE(user_param->curr_mtu));
+	printf(" Transport type  : %s\n" ,transport_str(user_param->transport_type));
 	printf(" Link type       : %s\n" ,link_layer_str(user_param->link_type));
 
 	if (user_param->gid_index != DEF_GID_INDEX)
diff --git a/src/perftest_parameters.h b/src/perftest_parameters.h
index 463630c..09f3e47 100644
--- a/src/perftest_parameters.h
+++ b/src/perftest_parameters.h
@@ -180,7 +180,8 @@ typedef enum { LOCAL , REMOTE } PrintDataSide;
 typedef enum {CMP_AND_SWAP, FETCH_AND_ADD} AtomicType;
 
 // The type of the device (Hermon B0/A0 or no)
-typedef enum { DEVICE_ERROR = -1 ,UNKNOWN = 0 ,CONNECTX = 1,CONNECTX2 = 2, CONNECTX3 = 3, CONNECTIB = 4, LEGACY = 5} Device;
+typedef enum { DEVICE_ERROR = -1 ,UNKNOWN = 0 ,CONNECTX = 1,CONNECTX2 = 2, CONNECTX3 = 3, CONNECTIB = 4, LEGACY = 5,
+	       CHELSIO_T4 = 6, CHELSIO_T5 = 7} Device;
 
 // Type of test method.
 typedef enum { ITERATIONS , DURATION } TestMethod;
@@ -236,6 +237,7 @@ struct perftest_parameters {
 	int				margin;
 	uint32_t		rem_ud_qpn;
 	uint32_t		rem_ud_qkey;
+	enum ibv_transport_type transport_type;
 	uint8_t			link_type;
 	uint8_t			link_type2;
 	MachineType		machine;
diff --git a/src/perftest_resources.c b/src/perftest_resources.c
index fd9809f..01726ba 100644
--- a/src/perftest_resources.c
+++ b/src/perftest_resources.c
@@ -376,6 +376,8 @@ int ctx_init(struct pingpong_context *ctx,struct perftest_parameters *user_param
 		
 	} else if (user_param->verb == READ) {
 		flags |= IBV_ACCESS_REMOTE_READ;
+		if (user_param->transport_type == IBV_TRANSPORT_IWARP)
+			flags |= IBV_ACCESS_REMOTE_WRITE;
 
 	} else if (user_param->verb == ATOMIC) {
 		flags |= IBV_ACCESS_REMOTE_ATOMIC;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
