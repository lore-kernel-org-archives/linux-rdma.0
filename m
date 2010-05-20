From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 04/11] RDMA/cxgb4: Optimize CQ overflow detection.
Date: Thu, 20 May 2010 16:57:43 -0500
Message-ID: <20100520215743.32394.67844.stgit@build.ogc.int>
References: <20100520215727.32394.90669.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100520215727.32394.90669.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

1) save the timestamp flit in the cq when we consume a CQE

2) always compare the saved flit with the previous entry flit when reading
the next CQE entry.  If the flits don't compare, then we have overflowed.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cq.c |    1 +
 drivers/infiniband/hw/cxgb4/t4.h |   28 ++++++++++++++++------------
 2 files changed, 17 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cq.c b/drivers/infiniband/hw/cxgb4/cq.c
index 46ac00f..2447f52 100644
--- a/drivers/infiniband/hw/cxgb4/cq.c
+++ b/drivers/infiniband/hw/cxgb4/cq.c
@@ -373,6 +373,7 @@ static void create_read_req_cqe(struct t4_wq *wq, struct t4_cqe *hw_cqe,
 				 V_CQE_SWCQE(SW_CQE(hw_cqe)) |
 				 V_CQE_OPCODE(FW_RI_READ_REQ) |
 				 V_CQE_TYPE(1));
+	read_cqe->bits_type_ts = hw_cqe->bits_type_ts;
 }
 
 /*
diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index d0e8af3..712bc56 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -434,7 +434,7 @@ struct t4_cq {
 	struct c4iw_rdev *rdev;
 	u64 ugts;
 	size_t memsize;
-	u64 timestamp;
+	__be64 bits_type_ts;
 	u32 cqid;
 	u16 size; /* including status page */
 	u16 cidx;
@@ -487,6 +487,7 @@ static inline void t4_swcq_consume(struct t4_cq *cq)
 
 static inline void t4_hwcq_consume(struct t4_cq *cq)
 {
+	cq->bits_type_ts = cq->queue[cq->cidx].bits_type_ts;
 	cq->cidx_inc++;
 	if (++cq->cidx == cq->size) {
 		cq->cidx = 0;
@@ -501,20 +502,23 @@ static inline int t4_valid_cqe(struct t4_cq *cq, struct t4_cqe *cqe)
 
 static inline int t4_next_hw_cqe(struct t4_cq *cq, struct t4_cqe **cqe)
 {
-	int ret = 0;
-	u64 bits_type_ts = be64_to_cpu(cq->queue[cq->cidx].bits_type_ts);
+	int ret;
+	u16 prev_cidx;
 
-	if (G_CQE_GENBIT(bits_type_ts) == cq->gen) {
-		*cqe = &cq->queue[cq->cidx];
-		cq->timestamp = G_CQE_TS(bits_type_ts);
-	} else if (G_CQE_TS(bits_type_ts) > cq->timestamp)
-		ret = -EOVERFLOW;
+	if (cq->cidx == 0)
+		prev_cidx = cq->size - 1;
 	else
-		ret = -ENODATA;
-	if (ret == -EOVERFLOW) {
-		printk(KERN_ERR MOD "cq overflow cqid %u\n", cq->cqid);
+		prev_cidx = cq->cidx - 1;
+
+	if (cq->queue[prev_cidx].bits_type_ts != cq->bits_type_ts) {
+		ret = -EOVERFLOW;
 		cq->error = 1;
-	}
+		printk(KERN_ERR MOD "cq overflow cqid %u\n", cq->cqid);
+	} else if (t4_valid_cqe(cq, &cq->queue[cq->cidx])) {
+		*cqe = &cq->queue[cq->cidx];
+		ret = 0;
+	} else
+		ret = -ENODATA;
 	return ret;
 }
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
