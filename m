From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH 5/5] nvme-loop: Remove duplicate call to nvme_remove_namespaces
Date: Fri, 29 Jul 2016 22:57:22 +0300
Message-ID: <1469822242-3477-6-git-send-email-sagi@grimberg.me>
References: <1469822242-3477-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469822242-3477-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

nvme_uninit_ctrl already does that for us.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/target/loop.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/nvme/target/loop.c b/drivers/nvme/target/loop.c
index 94e782987cc9..7affd40a6b33 100644
--- a/drivers/nvme/target/loop.c
+++ b/drivers/nvme/target/loop.c
@@ -414,9 +414,8 @@ static void nvme_loop_del_ctrl_work(struct work_struct *work)
 	struct nvme_loop_ctrl *ctrl = container_of(work,
 				struct nvme_loop_ctrl, delete_work);
 
-	nvme_remove_namespaces(&ctrl->ctrl);
-	nvme_loop_shutdown_ctrl(ctrl);
 	nvme_uninit_ctrl(&ctrl->ctrl);
+	nvme_loop_shutdown_ctrl(ctrl);
 	nvme_put_ctrl(&ctrl->ctrl);
 }
 
@@ -501,7 +500,6 @@ out_free_queues:
 	nvme_loop_destroy_admin_queue(ctrl);
 out_disable:
 	dev_warn(ctrl->ctrl.device, "Removing after reset failure\n");
-	nvme_remove_namespaces(&ctrl->ctrl);
 	nvme_uninit_ctrl(&ctrl->ctrl);
 	nvme_put_ctrl(&ctrl->ctrl);
 }
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
