From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v3 3/6] rdma_cm: add rdma_consumer_reject_data helper function
Date: Mon, 24 Oct 2016 11:59:03 -0700
Message-ID: <7690d653aefbf9ff51dfa6c1ebef57b47616be23.1477336045.git.swise@opengridcomputing.com>
References: <cover.1477336045.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1477336045.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

rdma_consumer_reject_data() will return the private data pointer
and length if any is available.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/core/cma.c | 16 ++++++++++++++++
 include/rdma/rdma_cm.h        | 10 ++++++++++
 2 files changed, 26 insertions(+)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 0d88c9d..2536d42 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -128,6 +128,22 @@ bool rdma_is_consumer_reject(struct rdma_cm_id *id, int reason)
 }
 EXPORT_SYMBOL(rdma_is_consumer_reject);
 
+const void *rdma_consumer_reject_data(struct rdma_cm_id *id,
+				      struct rdma_cm_event *ev, u8 *data_len)
+{
+	void *p;
+
+	if (rdma_is_consumer_reject(id, ev->status)) {
+		*data_len = ev->param.conn.private_data_len;
+		p = ev->param.conn.private_data;
+	} else {
+		*data_len = 0;
+		p = NULL;
+	}
+	return p;
+}
+EXPORT_SYMBOL(rdma_consumer_reject_data);
+
 static void cma_add_one(struct ib_device *device);
 static void cma_remove_one(struct ib_device *device, void *client_data);
 
diff --git a/include/rdma/rdma_cm.h b/include/rdma/rdma_cm.h
index 62039c2..d3968b5 100644
--- a/include/rdma/rdma_cm.h
+++ b/include/rdma/rdma_cm.h
@@ -403,4 +403,14 @@ const char *__attribute_const__ rdma_reject_msg(struct rdma_cm_id *id,
  */
 bool rdma_is_consumer_reject(struct rdma_cm_id *id, int reason);
 
+/**
+ * rdma_consumer_reject_data - return the consumer reject private data and
+ *			       length, if any.
+ * @id: Communication identifier that received the REJECT event.
+ * @ev: RDMA CM reject event.
+ * @data_len: Pointer to the resulting length of the consumer data.
+ */
+const void *rdma_consumer_reject_data(struct rdma_cm_id *id,
+				      struct rdma_cm_event *ev, u8 *data_len);
+
 #endif /* RDMA_CM_H */
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
