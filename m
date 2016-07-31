From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH RFC] nvme-rdma: Queue ns scanning after a sucessful reconnection
Date: Sun, 31 Jul 2016 18:55:40 +0300
Message-ID: <1469980540-16103-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Keith Busch <keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

On an ordered target shutdown, the target can send a AEN on a namespace
removal, this will trigger the host to queue ns-list query. The shutdown
will trigger error recovery which will attepmt periodic reconnect.

We can hit a race where the ns rescanning fails (error recovery kicked
in and we're not connected) causing removing all the namespaces and when
we reconnect we won't see any namespaces for this controller.

So, queue a namespace rescan after we successfully reconnected to the target.

Note, that unlike user initiated controller reset, we don't need to trigger
namespace scanning (until the point I noticed the above at least) because we
reconnect to an existing controller. However due to the interaction with
the aen mechanism we queue ns scan here as well.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
I'm open to other suggestions if anyone has any...

 drivers/nvme/host/rdma.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index f8539dd75504..5cb069ab27ed 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -743,8 +743,10 @@ static void nvme_rdma_reconnect_ctrl_work(struct work_struct *work)
 	changed = nvme_change_ctrl_state(&ctrl->ctrl, NVME_CTRL_LIVE);
 	WARN_ON_ONCE(!changed);
 
-	if (ctrl->queue_count > 1)
+	if (ctrl->queue_count > 1) {
 		nvme_start_queues(&ctrl->ctrl);
+		nvme_queue_scan(&ctrl->ctrl);
+	}
 
 	dev_info(ctrl->ctrl.device, "Successfully reconnected\n");
 
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
