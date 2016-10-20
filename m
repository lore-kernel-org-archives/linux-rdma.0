From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RFC] rdma_cm: add rdma_reject_msg() helper function
Date: Thu, 20 Oct 2016 14:12:52 -0700
Message-ID: <20161020211652.35902E0C53@smtp.ogc.us>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

rdma_reject_msg() returns a pointer to a string message associated with
the transport reject reason codes.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

---

Hey Bart, if folks like this, then perhaps you can make use of it in your
nvme series.

Steve.

---
 drivers/infiniband/core/cma.c | 64 +++++++++++++++++++++++++++++++++++++++++++
 include/rdma/rdma_cm.h        |  8 ++++++
 2 files changed, 72 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 5f65a78..fd11821 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -101,6 +101,70 @@ const char *__attribute_const__ rdma_event_msg(enum rdma_cm_event_type event)
 }
 EXPORT_SYMBOL(rdma_event_msg);
 
+static const char * const ib_rej_reason_strs[] = {
+	[IB_CM_REJ_NO_QP]			= "no qp",
+	[IB_CM_REJ_NO_EEC]			= "no eec",
+	[IB_CM_REJ_NO_RESOURCES]		= "no resources",
+	[IB_CM_REJ_TIMEOUT]			= "timeout",
+	[IB_CM_REJ_UNSUPPORTED]			= "unsupported",
+	[IB_CM_REJ_INVALID_COMM_ID]		= "invalid comm id",
+	[IB_CM_REJ_INVALID_COMM_INSTANCE]	= "invalid comm instance",
+	[IB_CM_REJ_INVALID_SERVICE_ID]		= "invalid service id",
+	[IB_CM_REJ_INVALID_TRANSPORT_TYPE]	= "invalid transport type",
+	[IB_CM_REJ_STALE_CONN]			= "stale conn",
+	[IB_CM_REJ_RDC_NOT_EXIST]		= "rdc not exist",
+	[IB_CM_REJ_INVALID_GID]			= "invalid gid",
+	[IB_CM_REJ_INVALID_LID]			= "invalid lid",
+	[IB_CM_REJ_INVALID_SL]			= "invalid sl",
+	[IB_CM_REJ_INVALID_TRAFFIC_CLASS]	= "invalid traffic class",
+	[IB_CM_REJ_INVALID_HOP_LIMIT]		= "invalid hop limit",
+	[IB_CM_REJ_INVALID_PACKET_RATE]		= "invalid packet rate",
+	[IB_CM_REJ_INVALID_ALT_GID]		= "invalid alt gid",
+	[IB_CM_REJ_INVALID_ALT_LID]		= "invalid alt lid",
+	[IB_CM_REJ_INVALID_ALT_SL]		= "invalid alt sl",
+	[IB_CM_REJ_INVALID_ALT_TRAFFIC_CLASS]	= "invalid alt traffic class",
+	[IB_CM_REJ_INVALID_ALT_HOP_LIMIT]	= "invalid alt hop limit",
+	[IB_CM_REJ_INVALID_ALT_PACKET_RATE]	= "invalid alt packet rate",
+	[IB_CM_REJ_PORT_CM_REDIRECT]		= "port cm redirect",
+	[IB_CM_REJ_PORT_REDIRECT]		= "port redirect",
+	[IB_CM_REJ_INVALID_MTU]			= "invalid mtu",
+	[IB_CM_REJ_INSUFFICIENT_RESP_RESOURCES]	= "insufficient resp resources",
+	[IB_CM_REJ_CONSUMER_DEFINED]		= "consumer defined",
+	[IB_CM_REJ_INVALID_RNR_RETRY]		= "invalid rnr retry",
+	[IB_CM_REJ_DUPLICATE_LOCAL_COMM_ID]	= "duplicate local comm id",
+	[IB_CM_REJ_INVALID_CLASS_VERSION]	= "invalid class version",
+	[IB_CM_REJ_INVALID_FLOW_LABEL]		= "invalid flow label",
+	[IB_CM_REJ_INVALID_ALT_FLOW_LABEL]	= "invalid alt flow label",
+};
+
+static const char * const iw_rej_reason_strs[] = {
+	[ECONNRESET]			= "reset by remote host",
+	[ECONNREFUSED]			= "refused by remote application",
+	[ETIMEDOUT]			= "setup timeout",
+};
+
+const char *__attribute_const__ rdma_reject_msg(struct rdma_cm_id *id,
+						int reason)
+{
+	size_t index = reason;
+
+	if (rdma_ib_or_roce(id->device, id->port_num))
+		return (index < ARRAY_SIZE(ib_rej_reason_strs) &&
+			ib_rej_reason_strs[index]) ?
+			ib_rej_reason_strs[index] : "unrecognized reason";
+
+	if (rdma_protocol_iwarp(id->device, id->port_num)) {
+
+		/* iWARP uses negative errnos */
+		index = -index;
+		return (index < ARRAY_SIZE(iw_rej_reason_strs) &&
+			iw_rej_reason_strs[index]) ?
+			iw_rej_reason_strs[index] : "unrecognized reason";
+	}
+	return "unrecognized reason";
+}
+EXPORT_SYMBOL(rdma_reject_msg);
+
 static void cma_add_one(struct ib_device *device);
 static void cma_remove_one(struct ib_device *device, void *client_data);
 
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 81fb1d1..712a70c 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -388,4 +388,12 @@ int rdma_set_afonly(struct rdma_cm_id *id, int afonly);
  */
 __be64 rdma_get_service_id(struct rdma_cm_id *id, struct sockaddr *addr);
 
+/**
+ * rdma_reject_msg - return a pointer to a reject message string.
+ * @id: Communication identifier that received the REJECT event
+ * @reason: Value returned in the REJECT event status field.
+ */
+const char *__attribute_const__ rdma_reject_msg(struct rdma_cm_id *id,
+						int reason);
+
 #endif /* RDMA_CM_H */
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
