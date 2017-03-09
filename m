From: Sagi Grimberg <sagi@grimberg.me>
Subject: [PATCH rfc 04/10] block: Add a non-selective polling interface
Date: Thu,  9 Mar 2017 15:16:36 +0200
Message-ID: <1489065402-14757-5-git-send-email-sagi@grimberg.me>
References: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1489065402-14757-1-git-send-email-sagi@grimberg.me>
Sender: target-devel-owner@vger.kernel.org
To: linux-block@vger.kernel.org, linux-nvme@lists.infradead.org, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

For a server/target appliance mode where we don't
necessarily care about specific IOs but rather want
to poll opportunisticly, it is useful to have a
non-selective polling interface.

Expose a blk_poll_batch for a batched blkdev polling
interface so our nvme target (and others) can use.

Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
---
 block/blk-mq.c         | 14 ++++++++++++++
 include/linux/blk-mq.h |  2 ++
 include/linux/blkdev.h |  1 +
 3 files changed, 17 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index b2fd175e84d7..1962785b571a 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -2911,6 +2911,20 @@ bool blk_mq_poll(struct request_queue *q, blk_qc_t cookie)
 }
 EXPORT_SYMBOL_GPL(blk_mq_poll);
 
+int blk_mq_poll_batch(struct request_queue *q, unsigned int batch)
+{
+	struct blk_mq_hw_ctx *hctx;
+
+	if (!q->mq_ops || !q->mq_ops->poll_batch)
+		return 0;
+
+	hctx = blk_mq_map_queue(q, smp_processor_id());
+	return q->mq_ops->poll_batch(hctx, batch);
+}
+EXPORT_SYMBOL_GPL(blk_mq_poll_batch);
+
+
+
 void blk_mq_disable_hotplug(void)
 {
 	mutex_lock(&all_q_mutex);
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index b296a9006117..e1f33cad3067 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -100,6 +100,7 @@ typedef void (busy_iter_fn)(struct blk_mq_hw_ctx *, struct request *, void *,
 typedef void (busy_tag_iter_fn)(struct request *, void *, bool);
 typedef int (poll_fn)(struct blk_mq_hw_ctx *, unsigned int);
 typedef int (map_queues_fn)(struct blk_mq_tag_set *set);
+typedef int (poll_batch_fn)(struct blk_mq_hw_ctx *, unsigned int);
 
 
 struct blk_mq_ops {
@@ -117,6 +118,7 @@ struct blk_mq_ops {
 	 * Called to poll for completion of a specific tag.
 	 */
 	poll_fn			*poll;
+	poll_batch_fn		*poll_batch;
 
 	softirq_done_fn		*complete;
 
diff --git a/include/linux/blkdev.h b/include/linux/blkdev.h
index 796016e63c1d..a93507e61a57 100644
--- a/include/linux/blkdev.h
+++ b/include/linux/blkdev.h
@@ -971,6 +971,7 @@ extern void blk_execute_rq_nowait(struct request_queue *, struct gendisk *,
 				  struct request *, int, rq_end_io_fn *);
 
 bool blk_mq_poll(struct request_queue *q, blk_qc_t cookie);
+int blk_mq_poll_batch(struct request_queue *q, unsigned int batch);
 
 static inline struct request_queue *bdev_get_queue(struct block_device *bdev)
 {
-- 
2.7.4
