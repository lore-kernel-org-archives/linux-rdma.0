From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 1/8] blk-mq: add blk_mq_alloc_request_hctx
Date: Mon, 13 Jun 2016 16:45:21 +0200
Message-ID: <1465829128-22993-2-git-send-email-hch@lst.de>
References: <1465829128-22993-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465829128-22993-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>

For some protocols like NVMe over Fabrics we need to be able to send
initialization commands to a specific queue.

Based on an earlier patch from Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>.

Signed-off-by: Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>
[hch: disallow sleeping allocation, req_op fixes]
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 block/blk-mq.c         | 39 +++++++++++++++++++++++++++++++++++++++
 include/linux/blk-mq.h |  2 ++
 2 files changed, 41 insertions(+)

diff --git a/block/blk-mq.c b/block/blk-mq.c
index bc7166d..5e0fe60 100644
--- a/block/blk-mq.c
+++ b/block/blk-mq.c
@@ -267,6 +267,45 @@ struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 }
 EXPORT_SYMBOL(blk_mq_alloc_request);
 
+struct request *blk_mq_alloc_request_hctx(struct request_queue *q, int rw,
+		unsigned int flags, unsigned int hctx_idx)
+{
+	struct blk_mq_hw_ctx *hctx;
+	struct blk_mq_ctx *ctx;
+	struct request *rq;
+	struct blk_mq_alloc_data alloc_data;
+	int ret;
+
+	/*
+	 * If the tag allocator sleeps we could get an allocation for a
+	 * different hardware context.  No need to complicate the low level
+	 * allocator for this for the rare use case of a command tied to
+	 * a specific queue.
+	 */
+	if (WARN_ON_ONCE(!(flags & BLK_MQ_REQ_NOWAIT)))
+		return ERR_PTR(-EINVAL);
+
+	if (hctx_idx >= q->nr_hw_queues)
+		return ERR_PTR(-EIO);
+
+	ret = blk_queue_enter(q, true);
+	if (ret)
+		return ERR_PTR(ret);
+
+	hctx = q->queue_hw_ctx[hctx_idx];
+	ctx = __blk_mq_get_ctx(q, cpumask_first(hctx->cpumask));
+
+	blk_mq_set_alloc_data(&alloc_data, q, flags, ctx, hctx);
+	rq = __blk_mq_alloc_request(&alloc_data, rw, 0);
+	if (!rq) {
+		blk_queue_exit(q);
+		return ERR_PTR(-EWOULDBLOCK);
+	}
+
+	return rq;
+}
+EXPORT_SYMBOL_GPL(blk_mq_alloc_request_hctx);
+
 static void __blk_mq_free_request(struct blk_mq_hw_ctx *hctx,
 				  struct blk_mq_ctx *ctx, struct request *rq)
 {
diff --git a/include/linux/blk-mq.h b/include/linux/blk-mq.h
index 2498fdf..cbfd8ca 100644
--- a/include/linux/blk-mq.h
+++ b/include/linux/blk-mq.h
@@ -196,6 +196,8 @@ enum {
 
 struct request *blk_mq_alloc_request(struct request_queue *q, int rw,
 		unsigned int flags);
+struct request *blk_mq_alloc_request_hctx(struct request_queue *q, int op,
+		unsigned int flags, unsigned int hctx_idx);
 struct request *blk_mq_tag_to_rq(struct blk_mq_tags *tags, unsigned int tag);
 struct cpumask *blk_mq_tags_cpumask(struct blk_mq_tags *tags);
 
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
