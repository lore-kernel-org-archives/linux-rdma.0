From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 7/7] CQ overflow detection giving false positives
Date: Thu, 06 May 2010 18:06:52 -0500
Message-ID: <20100506230652.25362.18848.stgit@build.ogc.int>
References: <20100506230619.25362.97591.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100506230619.25362.97591.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

CQ overflow detection needs to read the gen bit and the timestamp in
one read operation.  Otherwise false overflows can result.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/t4.h |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/t4.h b/drivers/infiniband/hw/cxgb4/t4.h
index 7f04dc5..d0e8af3 100644
--- a/drivers/infiniband/hw/cxgb4/t4.h
+++ b/drivers/infiniband/hw/cxgb4/t4.h
@@ -502,11 +502,12 @@ static inline int t4_valid_cqe(struct t4_cq *cq, struct t4_cqe *cqe)
 static inline int t4_next_hw_cqe(struct t4_cq *cq, struct t4_cqe **cqe)
 {
 	int ret = 0;
+	u64 bits_type_ts = be64_to_cpu(cq->queue[cq->cidx].bits_type_ts);
 
-	if (t4_valid_cqe(cq, &cq->queue[cq->cidx])) {
+	if (G_CQE_GENBIT(bits_type_ts) == cq->gen) {
 		*cqe = &cq->queue[cq->cidx];
-		cq->timestamp = CQE_TS(*cqe);
-	} else if (CQE_TS(&cq->queue[cq->cidx]) > cq->timestamp)
+		cq->timestamp = G_CQE_TS(bits_type_ts);
+	} else if (G_CQE_TS(bits_type_ts) > cq->timestamp)
 		ret = -EOVERFLOW;
 	else
 		ret = -ENODATA;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
