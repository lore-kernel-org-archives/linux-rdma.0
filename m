From: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH v2 1/5] IB/core: Make rdma_rw_ctx_init() initialize all used
 fields
Date: Thu, 30 Jun 2016 15:49:04 +0200
Message-ID: <5917eaad-10e5-31c3-2b97-78cfcd8065de@sandisk.com>
References: <c9a58bf1-b230-5990-a2b3-4e6aa729cd8f@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <c9a58bf1-b230-5990-a2b3-4e6aa729cd8f-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, "Nicholas A. Bellinger" <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>, Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>, "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Some but not all callers of rdma_rw_ctx_init() zero-initialize
struct rdma_rw_ctx. Hence make rdma_rw_ctx_init() initialize all
work request fields that will be read by ib_post_send().

Fixes: a060b5629ab0 ("IB/core: generic RDMA READ/WRITE API")
Signed-off-by: Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> #v4.7+
Cc: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Nicholas Bellinger <nab-IzHhD5pYlfBP7FQvKIMDCQ@public.gmane.org>
Cc: Parav Pandit <pandit.parav-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Laurence Oberman <loberman-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/core/rw.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/rw.c b/drivers/infiniband/core/rw.c
index 1eb9b12..1ad2baa 100644
--- a/drivers/infiniband/core/rw.c
+++ b/drivers/infiniband/core/rw.c
@@ -71,6 +71,7 @@ static inline u32 rdma_rw_fr_page_list_len(struct ib_device *dev)
 	return min_t(u32, dev->attrs.max_fast_reg_page_list_len, 256);
 }
 
+/* Caller must have zero-initialized *reg. */
 static int rdma_rw_init_one_mr(struct ib_qp *qp, u8 port_num,
 		struct rdma_rw_reg_ctx *reg, struct scatterlist *sg,
 		u32 sg_cnt, u32 offset)
@@ -114,6 +115,7 @@ static int rdma_rw_init_mr_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		u8 port_num, struct scatterlist *sg, u32 sg_cnt, u32 offset,
 		u64 remote_addr, u32 rkey, enum dma_data_direction dir)
 {
+	struct rdma_rw_reg_ctx *prev = NULL;
 	u32 pages_per_mr = rdma_rw_fr_page_list_len(qp->pd->device);
 	int i, j, ret = 0, count = 0;
 
@@ -125,7 +127,6 @@ static int rdma_rw_init_mr_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 	}
 
 	for (i = 0; i < ctx->nr_ops; i++) {
-		struct rdma_rw_reg_ctx *prev = i ? &ctx->reg[i - 1] : NULL;
 		struct rdma_rw_reg_ctx *reg = &ctx->reg[i];
 		u32 nents = min(sg_cnt, pages_per_mr);
 
@@ -162,9 +163,13 @@ static int rdma_rw_init_mr_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 		sg_cnt -= nents;
 		for (j = 0; j < nents; j++)
 			sg = sg_next(sg);
+		prev = reg;
 		offset = 0;
 	}
 
+	if (prev)
+		prev->wr.wr.next = NULL;
+
 	ctx->type = RDMA_RW_MR;
 	return count;
 
@@ -205,11 +210,10 @@ static int rdma_rw_init_map_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 			rdma_wr->wr.opcode = IB_WR_RDMA_READ;
 		rdma_wr->remote_addr = remote_addr + total_len;
 		rdma_wr->rkey = rkey;
+		rdma_wr->wr.num_sge = nr_sge;
 		rdma_wr->wr.sg_list = sge;
 
 		for (j = 0; j < nr_sge; j++, sg = sg_next(sg)) {
-			rdma_wr->wr.num_sge++;
-
 			sge->addr = ib_sg_dma_address(dev, sg) + offset;
 			sge->length = ib_sg_dma_len(dev, sg) - offset;
 			sge->lkey = qp->pd->local_dma_lkey;
@@ -220,8 +224,8 @@ static int rdma_rw_init_map_wrs(struct rdma_rw_ctx *ctx, struct ib_qp *qp,
 			offset = 0;
 		}
 
-		if (i + 1 < ctx->nr_ops)
-			rdma_wr->wr.next = &ctx->map.wrs[i + 1].wr;
+		rdma_wr->wr.next = i + 1 < ctx->nr_ops ?
+			&ctx->map.wrs[i + 1].wr : NULL;
 	}
 
 	ctx->type = RDMA_RW_MULTI_WR;
-- 
2.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
