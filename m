From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH v2 6/6] nvme-rdma: use intelligent affinity based queue mappings
Date: Thu,  6 Apr 2017 13:36:38 +0300
Message-ID: <1491474998-16423-7-git-send-email-sagi@grimberg.me>
References: <1491474998-16423-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <1491474998-16423-1-git-send-email-sagi@grimberg.me>
Sender: linux-block-owner@vger.kernel.org
To: Jens Axboe <axboe@kernel.dk>, linux-nvme@lists.infradead.org, linux-block@vger.kernel.org, linux-rdma@vger.kernel.org
Cc: Christoph Hellwig <hch@lst.de>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

Use the generic block layer affinity mapping helper. Also,
limit nr_hw_queues to the rdma device number of irq vectors
as we don't really need more.

Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 drivers/nvme/host/rdma.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/drivers/nvme/host/rdma.c b/drivers/nvme/host/rdma.c
index 4aae363943e3..22334b6e8fc3 100644
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
@@ -496,14 +497,10 @@ static int nvme_rdma_create_queue_ib(struct nvme_rdma_queue *queue,
 	queue->device = dev;
 
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
 	queue->ib_cq = ib_alloc_cq(dev->dev, queue,
@@ -645,10 +642,20 @@ static int nvme_rdma_connect_io_queues(struct nvme_rdma_ctrl *ctrl)
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
@@ -1523,6 +1530,13 @@ static void nvme_rdma_complete_rq(struct request *rq)
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
@@ -1532,6 +1546,7 @@ static const struct blk_mq_ops nvme_rdma_mq_ops = {
 	.init_hctx	= nvme_rdma_init_hctx,
 	.poll		= nvme_rdma_poll,
 	.timeout	= nvme_rdma_timeout,
+	.map_queues	= nvme_rdma_map_queues,
 };
 
 static const struct blk_mq_ops nvme_rdma_admin_mq_ops = {
-- 
2.7.4
