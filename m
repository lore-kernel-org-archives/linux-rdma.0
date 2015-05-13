From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v6 1/6] IB/core, cma: Nice log-friendly string helpers
Date: Wed, 13 May 2015 12:35:00 +0300
Message-ID: <1431509705-16337-2-git-send-email-sagig@mellanox.com>
References: <1431509705-16337-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431509705-16337-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sagi Grimberg <sagig-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some of us keep revisiting the code to decode enumerations that
appear in out logs. Let's borrow the nice logging helpers that
exists in xprtrdma and rds for CMA events, IB events and WC statuses.

Reviewed-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Reviewed-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c   |   28 +++++++++++++++++
 drivers/infiniband/core/verbs.c |   65 +++++++++++++++++++++++++++++++++++++++
 include/rdma/ib_verbs.h         |    4 ++
 include/rdma/rdma_cm.h          |    2 +
 4 files changed, 99 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index d570030..36bbe78 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -65,6 +65,34 @@ MODULE_LICENSE("Dual BSD/GPL");
 #define CMA_CM_MRA_SETTING (IB_CM_MRA_FLAG_DELAY | 24)
 #define CMA_IBOE_PACKET_LIFETIME 18
 
+static const char * const cma_events[] = {
+	[RDMA_CM_EVENT_ADDR_RESOLVED]	 = "address resolved",
+	[RDMA_CM_EVENT_ADDR_ERROR]	 = "address error",
+	[RDMA_CM_EVENT_ROUTE_RESOLVED]	 = "route resolved ",
+	[RDMA_CM_EVENT_ROUTE_ERROR]	 = "route error",
+	[RDMA_CM_EVENT_CONNECT_REQUEST]	 = "connect request",
+	[RDMA_CM_EVENT_CONNECT_RESPONSE] = "connect response",
+	[RDMA_CM_EVENT_CONNECT_ERROR]	 = "connect error",
+	[RDMA_CM_EVENT_UNREACHABLE]	 = "unreachable",
+	[RDMA_CM_EVENT_REJECTED]	 = "rejected",
+	[RDMA_CM_EVENT_ESTABLISHED]	 = "established",
+	[RDMA_CM_EVENT_DISCONNECTED]	 = "disconnected",
+	[RDMA_CM_EVENT_DEVICE_REMOVAL]	 = "device removal",
+	[RDMA_CM_EVENT_MULTICAST_JOIN]	 = "multicast join",
+	[RDMA_CM_EVENT_MULTICAST_ERROR]	 = "multicast error",
+	[RDMA_CM_EVENT_ADDR_CHANGE]	 = "address change",
+	[RDMA_CM_EVENT_TIMEWAIT_EXIT]	 = "timewait exit",
+};
+
+const char *rdma_event_msg(enum rdma_cm_event_type event)
+{
+	size_t index = event;
+
+	return (index < ARRAY_SIZE(cma_events) && cma_events[index]) ?
+			cma_events[index] : "UNRECOGNIZED_EVENT";
+}
+EXPORT_SYMBOL(rdma_event_msg);
+
 static void cma_add_one(struct ib_device *device);
 static void cma_remove_one(struct ib_device *device);
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index f93eb8d..d8f70d6 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -48,6 +48,71 @@
 
 #include "core_priv.h"
 
+static const char * const ib_events[] = {
+	[IB_EVENT_CQ_ERR]		= "CQ error",
+	[IB_EVENT_QP_FATAL]		= "QP fatal error",
+	[IB_EVENT_QP_REQ_ERR]		= "QP request error",
+	[IB_EVENT_QP_ACCESS_ERR]	= "QP access error",
+	[IB_EVENT_COMM_EST]		= "communication established",
+	[IB_EVENT_SQ_DRAINED]		= "send queue drained",
+	[IB_EVENT_PATH_MIG]		= "path migration successful",
+	[IB_EVENT_PATH_MIG_ERR]		= "path migration error",
+	[IB_EVENT_DEVICE_FATAL]		= "device fatal error",
+	[IB_EVENT_PORT_ACTIVE]		= "port active",
+	[IB_EVENT_PORT_ERR]		= "port error",
+	[IB_EVENT_LID_CHANGE]		= "LID change",
+	[IB_EVENT_PKEY_CHANGE]		= "P_key change",
+	[IB_EVENT_SM_CHANGE]		= "SM change",
+	[IB_EVENT_SRQ_ERR]		= "SRQ error",
+	[IB_EVENT_SRQ_LIMIT_REACHED]	= "SRQ limit reached",
+	[IB_EVENT_QP_LAST_WQE_REACHED]	= "last WQE reached",
+	[IB_EVENT_CLIENT_REREGISTER]	= "client reregister",
+	[IB_EVENT_GID_CHANGE]		= "GID changed",
+};
+
+const char *ib_event_msg(enum ib_event_type event)
+{
+	size_t index = event;
+
+	return (index < ARRAY_SIZE(ib_events) && ib_events[index]) ?
+			ib_events[index] : "UNRECOGNIZED_EVENT";
+}
+EXPORT_SYMBOL(ib_event_msg);
+
+static const char * const wc_statuses[] = {
+	[IB_WC_SUCCESS]			= "success",
+	[IB_WC_LOC_LEN_ERR]		= "local length error",
+	[IB_WC_LOC_QP_OP_ERR]		= "local QP operation error",
+	[IB_WC_LOC_EEC_OP_ERR]		= "local EE context operation error",
+	[IB_WC_LOC_PROT_ERR]		= "local protection error",
+	[IB_WC_WR_FLUSH_ERR]		= "WR flushed",
+	[IB_WC_MW_BIND_ERR]		= "memory management operation error",
+	[IB_WC_BAD_RESP_ERR]		= "bad response error",
+	[IB_WC_LOC_ACCESS_ERR]		= "local access error",
+	[IB_WC_REM_INV_REQ_ERR]		= "envalid request error",
+	[IB_WC_REM_ACCESS_ERR]		= "remote access error",
+	[IB_WC_REM_OP_ERR]		= "remote operation error",
+	[IB_WC_RETRY_EXC_ERR]		= "transport retry counter exceeded",
+	[IB_WC_RNR_RETRY_EXC_ERR]	= "RNR retry counter exceeded",
+	[IB_WC_LOC_RDD_VIOL_ERR]	= "local RDD violation error",
+	[IB_WC_REM_INV_RD_REQ_ERR]	= "remove invalid RD request",
+	[IB_WC_REM_ABORT_ERR]		= "operation aborted",
+	[IB_WC_INV_EECN_ERR]		= "invalid EE context number",
+	[IB_WC_INV_EEC_STATE_ERR]	= "invalid EE context state",
+	[IB_WC_FATAL_ERR]		= "fatal error",
+	[IB_WC_RESP_TIMEOUT_ERR]	= "response timeout error",
+	[IB_WC_GENERAL_ERR]		= "general error",
+};
+
+const char *ib_wc_status_msg(enum ib_wc_status status)
+{
+	size_t index = status;
+
+	return (index < ARRAY_SIZE(wc_statuses) && wc_statuses[index]) ?
+			wc_statuses[index] : "UNRECOGNIZED_STATUS";
+}
+EXPORT_SYMBOL(ib_wc_status_msg);
+
 __attribute_const__ int ib_rate_to_mult(enum ib_rate rate)
 {
 	switch (rate) {
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 65994a1..672fc8f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -412,6 +412,8 @@ enum ib_event_type {
 	IB_EVENT_GID_CHANGE,
 };
 
+__attribute_const__ const char *ib_event_msg(enum ib_event_type event);
+
 struct ib_event {
 	struct ib_device	*device;
 	union {
@@ -663,6 +665,8 @@ enum ib_wc_status {
 	IB_WC_GENERAL_ERR
 };
 
+__attribute_const__ const char *ib_wc_status_msg(enum ib_wc_status status);
+
 enum ib_wc_opcode {
 	IB_WC_SEND,
 	IB_WC_RDMA_WRITE,
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 1ed2088..c92522c 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -62,6 +62,8 @@ enum rdma_cm_event_type {
 	RDMA_CM_EVENT_TIMEWAIT_EXIT
 };
 
+__attribute_const__ const char *rdma_event_msg(enum rdma_cm_event_type event);
+
 enum rdma_port_space {
 	RDMA_PS_SDP   = 0x0001,
 	RDMA_PS_IPOIB = 0x0002,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
