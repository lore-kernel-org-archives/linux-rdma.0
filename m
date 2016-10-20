From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RFC v2 2/3] rdma_cm: add rdma_consumer_reject() helper
 function
Date: Thu, 20 Oct 2016 15:40:26 -0700
Message-ID: <cb135696be86c21c144ef35a4d6f7f71394a3627.1477003235.git.swise@opengridcomputing.com>
References: <cover.1477003235.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1477003235.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Return true if the peer consumer application rejected the
connection attempt.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 13 +++++++++++++
 include/rdma/ib_cm.h          |  9 +++++++++
 include/rdma/iw_cm.h          |  9 +++++++++
 include/rdma/rdma_cm.h        |  6 ++++++
 4 files changed, 37 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 7cc7346..4ec16a3 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -114,6 +114,19 @@ const char *__attribute_const__ rdma_reject_msg(struct rdma_cm_id *id,
 }
 EXPORT_SYMBOL(rdma_reject_msg);
 
+bool rdma_consumer_reject(struct rdma_cm_id *id, int reason)
+{
+	if (rdma_ib_or_roce(id->device, id->port_num))
+		return ib_consumer_reject(reason);
+
+	if (rdma_protocol_iwarp(id->device, id->port_num))
+		return iw_consumer_reject(reason);
+
+	/* FIXME should we WARN_ONCE() here? */
+	return false;
+}
+EXPORT_SYMBOL(rdma_consumer_reject);
+
 static void cma_add_one(struct ib_device *device);
 static void cma_remove_one(struct ib_device *device, void *client_data);
 
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index af193b7..5595529 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -609,4 +609,13 @@ int ib_send_cm_sidr_rep(struct ib_cm_id *cm_id,
  */
 const char *__attribute_const__ ib_reject_msg(int reason);
 
+/**
+ * ib_consumer_reject - return true if the user rejected the connection.
+ * @reason: Value returned in the REJECT event status field.
+ */
+static inline bool ib_consumer_reject(int reason)
+{
+	return reason == IB_CM_REJ_CONSUMER_DEFINED;
+};
+
 #endif /* IB_CM_H */
diff --git a/include/rdma/iw_cm.h b/include/rdma/iw_cm.h
index 15b437e..1e5bd33 100644
--- a/include/rdma/iw_cm.h
+++ b/include/rdma/iw_cm.h
@@ -259,4 +259,13 @@ int iw_cm_init_qp_attr(struct iw_cm_id *cm_id, struct ib_qp_attr *qp_attr,
  */
 const char *__attribute_const__ iw_reject_msg(int reason);
 
+/**
+ * iw_consumer_reject - return true if the consumer rejected the connection.
+ * @reason: Value returned in the REJECT event status field.
+ */
+static inline bool iw_consumer_reject(int reason)
+{
+	return reason == -ECONNREFUSED;
+}
+
 #endif /* IW_CM_H */
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 712a70c..058dfbb 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -395,5 +395,11 @@ __be64 rdma_get_service_id(struct rdma_cm_id *id, struct sockaddr *addr);
  */
 const char *__attribute_const__ rdma_reject_msg(struct rdma_cm_id *id,
 						int reason);
+/**
+ * rdma_consumer_reject - return true if the consumer rejected the connection.
+ * @id: Communication identifier that received the REJECT event
+ * @reason: Value returned in the REJECT event status field.
+ */
+bool rdma_consumer_reject(struct rdma_cm_id *id, int reason);
 
 #endif /* RDMA_CM_H */
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
