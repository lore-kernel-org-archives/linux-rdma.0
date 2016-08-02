From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v2 5/5] nvme-rdma: Make sure to shutdown the controller if we can
Date: Tue,  2 Aug 2016 10:53:39 +0300
Message-ID: <1470124419-30405-6-git-send-email-sagi@grimberg.me>
References: <1470124419-30405-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1470124419-30405-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Relying on ctrl state in nvme_rdma_shutdown_ctrl is wrong because
it will never be NVME_CTRL_LIVE (delete_ctrl or reset_ctrl invoked it).

Instead, check that the admin queue is connected. Note that it is safe
because we can never see a copmeting thread trying to destroy the admin
queue (reset or delete controller).

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index f31915696421..ef821592b791 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -1644,7 +1644,7 @@ static void nvme_rdma_shutdown_ctrl(struct nvme_rdma_ctrl *ctrl)
 		nvme_rdma_free_io_queues(ctrl);
 	}
 
-	if (ctrl->ctrl.state == NVME_CTRL_LIVE)
+	if (test_bit(NVME_RDMA_Q_CONNECTED, &ctrl->queues[0].flags))
 		nvme_shutdown_ctrl(&ctrl->ctrl);
 
 	blk_mq_stop_hw_queues(ctrl->ctrl.admin_q);
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
