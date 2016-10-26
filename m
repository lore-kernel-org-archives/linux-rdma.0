From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v5 4/8] nvme-rdma: use rdma connection reject helper functions
Date: Wed, 26 Oct 2016 12:36:47 -0700
Message-ID: <b61e9a20572b3afb4ebf62a0a1613097311e7c92.1477510827.git.swise@opengridcomputing.com>
References: <cover.1477510827.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1477510827.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org, santosh.shilimkar-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Also add nvme cm status strings and use them.

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 42 ++++++++++++++++++++++++++++++++++++------
 1 file changed, 36 insertions(+), 6 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index fbdb226..fcf2079 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -43,6 +43,28 @@
 
 #define NVME_RDMA_MAX_INLINE_SEGMENTS	1
 
+static const char *const nvme_rdma_cm_status_strs[] = {
+	[NVME_RDMA_CM_INVALID_LEN]	= "invalid length",
+	[NVME_RDMA_CM_INVALID_RECFMT]	= "invalid record format",
+	[NVME_RDMA_CM_INVALID_QID]	= "invalid queue ID",
+	[NVME_RDMA_CM_INVALID_HSQSIZE]	= "invalid host SQ size",
+	[NVME_RDMA_CM_INVALID_HRQSIZE]	= "invalid host RQ size",
+	[NVME_RDMA_CM_NO_RSC]		= "resource not found",
+	[NVME_RDMA_CM_INVALID_IRD]	= "invalid IRD",
+	[NVME_RDMA_CM_INVALID_ORD]	= "Invalid ORD",
+};
+
+static const char *nvme_rdma_cm_msg(enum nvme_rdma_cm_status status)
+{
+	size_t index = status;
+
+	if (index < ARRAY_SIZE(nvme_rdma_cm_status_strs) &&
+	    nvme_rdma_cm_status_strs[index])
+		return nvme_rdma_cm_status_strs[index];
+	else
+		return "unrecognized reason";
+};
+
 /*
  * We handle AEN commands ourselves and don't even let the
  * block layer know about them.
@@ -1222,16 +1244,24 @@ out_destroy_queue_ib:
 static int nvme_rdma_conn_rejected(struct nvme_rdma_queue *queue,
 		struct rdma_cm_event *ev)
 {
-	if (ev->param.conn.private_data_len) {
-		struct nvme_rdma_cm_rej *rej =
-			(struct nvme_rdma_cm_rej *)ev->param.conn.private_data;
+	struct rdma_cm_id *cm_id = queue->cm_id;
+	int status = ev->status;
+	const char *rej_msg;
+	const struct nvme_rdma_cm_rej *rej_data;
+	u8 rej_data_len;
+
+	rej_msg = rdma_reject_msg(cm_id, status);
+	rej_data = rdma_consumer_reject_data(cm_id, ev, &rej_data_len);
+
+	if (rej_data && rej_data_len >= sizeof(u16)) {
+		u16 sts = le16_to_cpu(rej_data->sts);
 
 		dev_err(queue->ctrl->ctrl.device,
-			"Connect rejected, status %d.", le16_to_cpu(rej->sts));
-		/* XXX: Think of something clever to do here... */
+		      "Connect rejected: status %d (%s) nvme status %d (%s).\n",
+		      status, rej_msg, sts, nvme_rdma_cm_msg(sts));
 	} else {
 		dev_err(queue->ctrl->ctrl.device,
-			"Connect rejected, no private data.\n");
+			"Connect rejected: status %d (%s).\n", status, rej_msg);
 	}
 
 	return -ECONNRESET;
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
