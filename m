From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH 2/5] nvme-rdma: Free the I/O tags when we delete the controller
Date: Fri, 29 Jul 2016 22:57:19 +0300
Message-ID: <1469822242-3477-3-git-send-email-sagi@grimberg.me>
References: <1469822242-3477-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469822242-3477-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If we wait until we free the controller (free_ctrl) we might
lose our rdma device without any notification while we still
have open resources (tags mrs and dma mappings).

Instead, destroy the tags with their rdma resources once we
delete the device and not when freeing it.

Note that we don't do that in nvme_rdma_shutdown_ctrl because
controller reset uses it as well and we want to give active I/O
a chance to complete successfully.

Reported-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index f391d67e4ee0..a70eb3cbf656 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -686,11 +686,6 @@ static void nvme_rdma_free_ctrl(struct nvme_ctrl *nctrl)
 	list_del(&ctrl->list);
 	mutex_unlock(&nvme_rdma_ctrl_mutex);
 
-	if (ctrl->ctrl.tagset) {
-		blk_cleanup_queue(ctrl->ctrl.connect_q);
-		blk_mq_free_tag_set(&ctrl->tag_set);
-		nvme_rdma_dev_put(ctrl->device);
-	}
 	kfree(ctrl->queues);
 	nvmf_free_options(nctrl->opts);
 free_ctrl:
@@ -1666,6 +1661,11 @@ static void nvme_rdma_del_ctrl_work(struct work_struct *work)
 	nvme_remove_namespaces(&ctrl->ctrl);
 	nvme_rdma_shutdown_ctrl(ctrl);
 	nvme_uninit_ctrl(&ctrl->ctrl);
+	if (ctrl->ctrl.tagset) {
+		blk_cleanup_queue(ctrl->ctrl.connect_q);
+		blk_mq_free_tag_set(&ctrl->tag_set);
+		nvme_rdma_dev_put(ctrl->device);
+	}
 	nvme_put_ctrl(&ctrl->ctrl);
 }
 
@@ -1701,6 +1701,11 @@ static void nvme_rdma_remove_ctrl_work(struct work_struct *work)
 
 	nvme_remove_namespaces(&ctrl->ctrl);
 	nvme_uninit_ctrl(&ctrl->ctrl);
+	if (ctrl->ctrl.tagset) {
+		blk_cleanup_queue(ctrl->ctrl.connect_q);
+		blk_mq_free_tag_set(&ctrl->tag_set);
+		nvme_rdma_dev_put(ctrl->device);
+	}
 	nvme_put_ctrl(&ctrl->ctrl);
 }
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
