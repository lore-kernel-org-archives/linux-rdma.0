From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RFC v2 3/3] nvme-rdma: use rdma_reject_msg() to log connection
 rejects
Date: Thu, 20 Oct 2016 15:40:29 -0700
Message-ID: <60243a2ce17e08cdc93600b9998698dbd7f83306.1477003235.git.swise@opengridcomputing.com>
References: <cover.1477003235.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1477003235.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, sagig-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, axboe-b10kYP2dOMg@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 601aecf..6319c26 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1237,18 +1237,22 @@ out_destroy_queue_ib:
 static int nvme_rdma_conn_rejected(struct nvme_rdma_queue *queue,
 		struct rdma_cm_event *ev)
 {
-	if (ev->param.conn.private_data_len) {
+	struct rdma_cm_id *cm_id = queue->cm_id;
+	int rdma_status = ev->status;
+	short nvme_status = -1;
+
+	if (rdma_consumer_reject(cm_id, rdma_status) &&
+	    ev->param.conn.private_data_len) {
 		struct nvme_rdma_cm_rej *rej =
 			(struct nvme_rdma_cm_rej *)ev->param.conn.private_data;
 
-		dev_err(queue->ctrl->ctrl.device,
-			"Connect rejected, status %d.", le16_to_cpu(rej->sts));
-		/* XXX: Think of something clever to do here... */
-	} else {
-		dev_err(queue->ctrl->ctrl.device,
-			"Connect rejected, no private data.\n");
+		nvme_status = le16_to_cpu(rej->sts);
 	}
 
+	dev_err(queue->ctrl->ctrl.device, "Connect rejected: status %d (%s) "
+		"nvme status %d.\n", rdma_status,
+		rdma_reject_msg(cm_id, rdma_status), nvme_status);
+
 	return -ECONNRESET;
 }
 
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
