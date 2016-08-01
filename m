From: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Subject: [PATCH] nvmet-rdma: Don't use the inline buffer in order to avoid allocation for small reads
Date: Mon,  1 Aug 2016 11:36:39 +0300
Message-ID: <1470040599-7294-1-git-send-email-sagi@grimberg.me>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, Jay Freyensee <james_p_freyensee-VuQAYsv1563Yd54FQh9/CA@public.gmane.org>, Ming Lin <mlin-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Under extreme conditions this might cause data corruptions. By doing that
we we repost the buffer and then post this buffer for the device to send.
If we happen to use shared receive queues the device might write to the
buffer before it sends it (there is no ordering between send and recv
queues). Without SRQs we probably won't get that if the host doesn't
mis-behave and send more than we allowed it, but relying on that is not
really a good idea.

Signed-off-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
---
 drivers/nvme/target/rdma.c | 13 ++++---------
 1 file changed, 4 insertions(+), 9 deletions(-)

diff --git a/drivers/nvme/target/rdma.c b/drivers/nvme/target/rdma.c
index e06d504bdf0c..4e83d92d6bdd 100644
--- a/drivers/nvme/target/rdma.c
+++ b/drivers/nvme/target/rdma.c
@@ -615,15 +615,10 @@ static u16 nvmet_rdma_map_sgl_keyed(struct nvmet_rdma_rsp *rsp,
 	if (!len)
 		return 0;
 
-	/* use the already allocated data buffer if possible */
-	if (len <= NVMET_RDMA_INLINE_DATA_SIZE && rsp->queue->host_qid) {
-		nvmet_rdma_use_inline_sg(rsp, len, 0);
-	} else {
-		status = nvmet_rdma_alloc_sgl(&rsp->req.sg, &rsp->req.sg_cnt,
-				len);
-		if (status)
-			return status;
-	}
+	status = nvmet_rdma_alloc_sgl(&rsp->req.sg, &rsp->req.sg_cnt,
+			len);
+	if (status)
+		return status;
 
 	ret = rdma_rw_ctx_init(&rsp->rw, cm_id->qp, cm_id->port_num,
 			rsp->req.sg, rsp->req.sg_cnt, 0, addr, key,
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
