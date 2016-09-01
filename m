From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v4 3/6] nvme_rdma: keep a ref on the ctrl during delete/flush
Date: Thu, 1 Sep 2016 09:12:25 -0700
Message-ID: <70928a8d66b3a78e6f463b27dd0a6945c1a84f6f.1472746379.git.swise@opengridcomputing.com>
References: <cover.1472746379.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1472746379.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-Eyp3ogxVSr5BDLzU/O5InQ@public.gmane.org>
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 26 ++++++++++++++++++--------
 1 file changed, 18 insertions(+), 8 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index ab545fb..15b0c1d 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1351,9 +1351,15 @@ static int nvme_rdma_device_unplug(struct nvme_rdma_queue *queue)
 		ret = 1;
 	}
 
-	/* Queue controller deletion */
+	/*
+	 * Queue controller deletion. Keep a reference until all
+	 * work is flushed since delete_work will free the ctrl mem
+	 */
+	kref_get(&ctrl->ctrl.kref);
 	queue_work(nvme_rdma_wq, &ctrl->delete_work);
 	flush_work(&ctrl->delete_work);
+	nvme_put_ctrl(&ctrl->ctrl);
+
 	return ret;
 }
 
@@ -1700,15 +1706,19 @@ static int __nvme_rdma_del_ctrl(struct nvme_rdma_ctrl *ctrl)
 static int nvme_rdma_del_ctrl(struct nvme_ctrl *nctrl)
 {
 	struct nvme_rdma_ctrl *ctrl = to_rdma_ctrl(nctrl);
-	int ret;
+	int ret = 0;
 
+	/*
+	 * Keep a reference until all work is flushed since
+	 * __nvme_rdma_del_ctrl can free the ctrl mem
+	 */
+	if (!kref_get_unless_zero(&ctrl->ctrl.kref))
+		return -EBUSY;
 	ret = __nvme_rdma_del_ctrl(ctrl);
-	if (ret)
-		return ret;
-
-	flush_work(&ctrl->delete_work);
-
-	return 0;
+	if (!ret)
+		flush_work(&ctrl->delete_work);
+	nvme_put_ctrl(&ctrl->ctrl);
+	return ret;
 }
 
 static void nvme_rdma_remove_ctrl_work(struct work_struct *work)
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
