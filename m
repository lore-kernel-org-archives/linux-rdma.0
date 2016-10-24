From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v3 2/6] rdma_cm: add rdma_is_consumer_reject() helper function
Date: Mon, 24 Oct 2016 11:59:03 -0700
Message-ID: <66890f3b3abede2fe9fa658b91450c24ab516ed1.1477336045.git.swise@opengridcomputing.com>
References: <cover.1477336045.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1477336045.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Return true if the peer consumer application rejected the
connection attempt.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 13 +++++++++++++
 include/rdma/rdma_cm.h        |  7 +++++++
 2 files changed, 20 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 831e94b..0d88c9d 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -115,6 +115,19 @@ const char *__attribute_const__ rdma_reject_msg(struct rdma_cm_id *id,
 }
 EXPORT_SYMBOL(rdma_reject_msg);
 
+bool rdma_is_consumer_reject(struct rdma_cm_id *id, int reason)
+{
+	if (rdma_ib_or_roce(id->device, id->port_num))
+		return reason == IB_CM_REJ_CONSUMER_DEFINED;
+
+	if (rdma_protocol_iwarp(id->device, id->port_num))
+		return reason == -ECONNREFUSED;
+
+	WARN_ON_ONCE(1);
+	return false;
+}
+EXPORT_SYMBOL(rdma_is_consumer_reject);
+
 static void cma_add_one(struct ib_device *device);
 static void cma_remove_one(struct ib_device *device, void *client_data);
 
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index f11a768..62039c2 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -395,5 +395,12 @@ __be64 rdma_get_service_id(struct rdma_cm_id *id, struct sockaddr *addr);
  */
 const char *__attribute_const__ rdma_reject_msg(struct rdma_cm_id *id,
 						int reason);
+/**
+ * rdma_is_consumer_reject - return true if the consumer rejected the connect
+ *                           request.
+ * @id: Communication identifier that received the REJECT event.
+ * @reason: Value returned in the REJECT event status field.
+ */
+bool rdma_is_consumer_reject(struct rdma_cm_id *id, int reason);
 
 #endif /* RDMA_CM_H */
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
