From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v4 1/8] rdma_cm: add rdma_reject_msg() helper function
Date: Tue, 25 Oct 2016 11:33:04 -0700
Message-ID: <f9a1a00b4c074c7dc0204223426f19d4f7663cef.1477426743.git.swise@opengridcomputing.com>
References: <cover.1477426743.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1477426743.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

rdma_reject_msg() returns a pointer to a string message associated with
the transport reject reason codes.

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-egDjqUIXVlxBDLzU/O5InQ@public.gmane.org>
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/cm.c   | 48 ++++++++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/cma.c  | 14 ++++++++++++
 drivers/infiniband/core/iwcm.c | 21 ++++++++++++++++++
 include/rdma/ib_cm.h           |  6 ++++++
 include/rdma/iw_cm.h           |  6 ++++++
 include/rdma/rdma_cm.h         |  8 +++++++
 6 files changed, 103 insertions(+)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index c995255..6c64d0c 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -57,6 +57,54 @@ MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("InfiniBand CM");
 MODULE_LICENSE("Dual BSD/GPL");
 
+static const char * const ibcm_rej_reason_strs[] = {
+	[IB_CM_REJ_NO_QP]			= "no QP",
+	[IB_CM_REJ_NO_EEC]			= "no EEC",
+	[IB_CM_REJ_NO_RESOURCES]		= "no resources",
+	[IB_CM_REJ_TIMEOUT]			= "timeout",
+	[IB_CM_REJ_UNSUPPORTED]			= "unsupported",
+	[IB_CM_REJ_INVALID_COMM_ID]		= "invalid comm ID",
+	[IB_CM_REJ_INVALID_COMM_INSTANCE]	= "invalid comm instance",
+	[IB_CM_REJ_INVALID_SERVICE_ID]		= "invalid service ID",
+	[IB_CM_REJ_INVALID_TRANSPORT_TYPE]	= "invalid transport type",
+	[IB_CM_REJ_STALE_CONN]			= "stale conn",
+	[IB_CM_REJ_RDC_NOT_EXIST]		= "RDC not exist",
+	[IB_CM_REJ_INVALID_GID]			= "invalid GID",
+	[IB_CM_REJ_INVALID_LID]			= "invalid LID",
+	[IB_CM_REJ_INVALID_SL]			= "invalid SL",
+	[IB_CM_REJ_INVALID_TRAFFIC_CLASS]	= "invalid traffic class",
+	[IB_CM_REJ_INVALID_HOP_LIMIT]		= "invalid hop limit",
+	[IB_CM_REJ_INVALID_PACKET_RATE]		= "invalid packet rate",
+	[IB_CM_REJ_INVALID_ALT_GID]		= "invalid alt GID",
+	[IB_CM_REJ_INVALID_ALT_LID]		= "invalid alt LID",
+	[IB_CM_REJ_INVALID_ALT_SL]		= "invalid alt SL",
+	[IB_CM_REJ_INVALID_ALT_TRAFFIC_CLASS]	= "invalid alt traffic class",
+	[IB_CM_REJ_INVALID_ALT_HOP_LIMIT]	= "invalid alt hop limit",
+	[IB_CM_REJ_INVALID_ALT_PACKET_RATE]	= "invalid alt packet rate",
+	[IB_CM_REJ_PORT_CM_REDIRECT]		= "port CM redirect",
+	[IB_CM_REJ_PORT_REDIRECT]		= "port redirect",
+	[IB_CM_REJ_INVALID_MTU]			= "invalid MTU",
+	[IB_CM_REJ_INSUFFICIENT_RESP_RESOURCES]	= "insufficient resp resources",
+	[IB_CM_REJ_CONSUMER_DEFINED]		= "consumer defined",
+	[IB_CM_REJ_INVALID_RNR_RETRY]		= "invalid RNR retry",
+	[IB_CM_REJ_DUPLICATE_LOCAL_COMM_ID]	= "duplicate local comm ID",
+	[IB_CM_REJ_INVALID_CLASS_VERSION]	= "invalid class version",
+	[IB_CM_REJ_INVALID_FLOW_LABEL]		= "invalid flow label",
+	[IB_CM_REJ_INVALID_ALT_FLOW_LABEL]	= "invalid alt flow label",
+};
+
+const char *__attribute_const__ ibcm_reject_msg(int reason)
+{
+	size_t index = reason;
+
+	if (index < ARRAY_SIZE(ibcm_rej_reason_strs) &&
+	    ibcm_rej_reason_strs[index])
+		return ibcm_rej_reason_strs[index];
+	else
+		return "unrecognized reason";
+}
+EXPORT_SYMBOL(ibcm_reject_msg);
+
 static void cm_add_one(struct ib_device *device);
 static void cm_remove_one(struct ib_device *device, void *client_data);
 
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 5f65a78..427f74e 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -101,6 +101,20 @@ const char *__attribute_const__ rdma_event_msg(enum rdma_cm_event_type event)
 }
 EXPORT_SYMBOL(rdma_event_msg);
 
+const char *__attribute_const__ rdma_reject_msg(struct rdma_cm_id *id,
+						int reason)
+{
+	if (rdma_ib_or_roce(id->device, id->port_num))
+		return ibcm_reject_msg(reason);
+
+	if (rdma_protocol_iwarp(id->device, id->port_num))
+		return iwcm_reject_msg(reason);
+
+	WARN_ON_ONCE(1);
+	return "unrecognized transport";
+}
+EXPORT_SYMBOL(rdma_reject_msg);
+
 static void cma_add_one(struct ib_device *device);
 static void cma_remove_one(struct ib_device *device, void *client_data);
 
diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 357624f..c8721c54 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -59,6 +59,27 @@ MODULE_AUTHOR("Tom Tucker");
 MODULE_DESCRIPTION("iWARP CM");
 MODULE_LICENSE("Dual BSD/GPL");
 
+static const char * const iwcm_rej_reason_strs[] = {
+	[ECONNRESET]			= "reset by remote host",
+	[ECONNREFUSED]			= "refused by remote application",
+	[ETIMEDOUT]			= "setup timeout",
+};
+
+const char *__attribute_const__ iwcm_reject_msg(int reason)
+{
+	size_t index;
+
+	/* iWARP uses negative errnos */
+	index = -reason;
+
+	if (index < ARRAY_SIZE(iwcm_rej_reason_strs) &&
+	    iwcm_rej_reason_strs[index])
+		return iwcm_rej_reason_strs[index];
+	else
+		return "unrecognized reason";
+}
+EXPORT_SYMBOL(iwcm_reject_msg);
+
 static struct ibnl_client_cbs iwcm_nl_cb_table[] = {
 	[RDMA_NL_IWPM_REG_PID] = {.dump = iwpm_register_pid_cb},
 	[RDMA_NL_IWPM_ADD_MAPPING] = {.dump = iwpm_add_mapping_cb},
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index 92a7d85..b49258b 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -603,4 +603,10 @@ struct ib_cm_sidr_rep_param {
 int ib_send_cm_sidr_rep(struct ib_cm_id *cm_id,
 			struct ib_cm_sidr_rep_param *param);
 
+/**
+ * ibcm_reject_msg - return a pointer to a reject message string.
+ * @reason: Value returned in the REJECT event status field.
+ */
+const char *__attribute_const__ ibcm_reject_msg(int reason);
+
 #endif /* IB_CM_H */
diff --git a/include/rdma/iw_cm.h b/include/rdma/iw_cm.h
index 6d0065c..5cd7701 100644
--- a/include/rdma/iw_cm.h
+++ b/include/rdma/iw_cm.h
@@ -253,4 +253,10 @@ int iw_cm_disconnect(struct iw_cm_id *cm_id, int abrupt);
 int iw_cm_init_qp_attr(struct iw_cm_id *cm_id, struct ib_qp_attr *qp_attr,
 		       int *qp_attr_mask);
 
+/**
+ * iwcm_reject_msg - return a pointer to a reject message string.
+ * @reason: Value returned in the REJECT event status field.
+ */
+const char *__attribute_const__ iwcm_reject_msg(int reason);
+
 #endif /* IW_CM_H */
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 81fb1d1..f11a768 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -388,4 +388,12 @@ int rdma_set_afonly(struct rdma_cm_id *id, int afonly);
  */
 __be64 rdma_get_service_id(struct rdma_cm_id *id, struct sockaddr *addr);
 
+/**
+ * rdma_reject_msg - return a pointer to a reject message string.
+ * @id: Communication identifier that received the REJECT event.
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
