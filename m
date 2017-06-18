From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH v6 for-4.13 7/7] nvme-rdma: use intelligent affinity based queue mappings
Date: Sun, 18 Jun 2017 17:37:57 +0300
Message-ID: <1497796677-15794-8-git-send-email-sagi@grimberg.me>
References: <1497796677-15794-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497796677-15794-1-git-send-email-sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Saeed Mahameed <saeedm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Use the generic block layer affinity mapping helper. Also,
limit nr_hw_queues to the rdma device number of irq vectors
as we don't really need more.

Reviewed-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/host/rdma.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 01dc723e6acf..066123a452c3 100644
--- a/drivers/nvme/host/rdma.c
+++ b/drivers/nvme/host/rdma.c
@@ -19,6 +19,7 @@
 #include <linux/string.h>
 #include <linux/atomic.h>
 #include <linux/blk-mq.h>
+#include <linux/blk-mq-rdma.h>
 #include <linux/types.h>
 #include <linux/list.h>
 #include <linux/mutex.h>
@@ -468,14 +469,10 @@ static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue)
 	ibdev = queue->device->dev;
 
 	/*
-	 * The admin queue is barely used once the controller is live, so don't
-	 * bother to spread it out.
+	 * Spread I/O queues completion vectors according their queue index.
+	 * Admin queues can always go on completion vector 0.
 	 */
-	if (idx == 0)
-		comp_vector = 0;
-	else
-		comp_vector = idx % ibdev->num_comp_vectors;
-
+	comp_vector = idx == 0 ? idx : idx - 1;
 
 	/* +1 for ib_stop_cq */
 	queue->ib_cq = ib_alloc_cq(ibdev, queue,
@@ -615,10 +612,20 @@ static int nvme_rdma_connect_io_queues(struct nvme_rdma_ctrl *ctrl)
 static int nvme_rdma_init_io_queues(struct nvme_rdma_ctrl *ctrl)
 {
 	struct nvmf_ctrl_options *opts = ctrl->ctrl.opts;
+	struct ib_device *ibdev = ctrl->device->dev;
 	unsigned int nr_io_queues;
 	int i, ret;
 
 	nr_io_queues = min(opts->nr_io_queues, num_online_cpus());
+
+	/*
+	 * we map queues according to the device irq vectors for
+	 * optimal locality so we don't need more queues than
+	 * completion vectors.
+	 */
+	nr_io_queues = min_t(unsigned int, nr_io_queues,
+				ibdev->num_comp_vectors);
+
 	ret = nvme_set_queue_count(&ctrl->ctrl, &nr_io_queues);
 	if (ret)
 		return ret;
@@ -1505,6 +1512,13 @@ static void nvme_rdma_complete_rq(struct request *rq)
 	nvme_complete_rq(rq);
 }
 
+static int nvme_rdma_map_queues(struct blk_mq_tag_set *set)
+{
+	struct nvme_rdma_ctrl *ctrl = set->driver_data;
+
+	return blk_mq_rdma_map_queues(set, ctrl->device->dev, 0);
+}
+
 static const struct blk_mq_ops nvme_rdma_mq_ops = {
 	.queue_rq	= nvme_rdma_queue_rq,
 	.complete	= nvme_rdma_complete_rq,
@@ -1514,6 +1528,7 @@ static const struct blk_mq_ops nvme_rdma_mq_ops = {
 	.init_hctx	= nvme_rdma_init_hctx,
 	.poll		= nvme_rdma_poll,
 	.timeout	= nvme_rdma_timeout,
+	.map_queues	= nvme_rdma_map_queues,
 };
 
 static const struct blk_mq_ops nvme_rdma_admin_mq_ops = {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
