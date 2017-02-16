From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 03/14] cxgb3: Update to use new udma write barriers
Date: Thu, 16 Feb 2017 12:22:58 -0700
Message-ID: <1487272989-8215-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1487272989-8215-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1487272989-8215-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Steve says the chip reads until a EOP marked WR is found, so the only
write barrier is to make sure DMA is ready before setting the WR in
that way.

Add missing rmb()s in the obvious spot.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 providers/cxgb3/cq.c      | 2 ++
 providers/cxgb3/cxio_wr.h | 2 +-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/providers/cxgb3/cq.c b/providers/cxgb3/cq.c
index a6158ce771f89f..eddcd43dc3bd8e 100644
--- a/providers/cxgb3/cq.c
+++ b/providers/cxgb3/cq.c
@@ -121,6 +121,7 @@ static inline int cxio_poll_cq(struct t3_wq *wq, struct t3_cq *cq,
 
 	*cqe_flushed = 0;
 	hw_cqe = cxio_next_cqe(cq);
+	udma_from_device_barrier();
 
 	/* 
 	 * Skip cqes not affiliated with a QP.
@@ -266,6 +267,7 @@ static int iwch_poll_cq_one(struct iwch_device *rhp, struct iwch_cq *chp,
 	int ret = 1;
 
 	hw_cqe = cxio_next_cqe(&chp->cq);
+	udma_from_device_barrier();
 
 	if (!hw_cqe)
 		return 0;
diff --git a/providers/cxgb3/cxio_wr.h b/providers/cxgb3/cxio_wr.h
index 735b64918a15c8..057f61ac3c7d2f 100644
--- a/providers/cxgb3/cxio_wr.h
+++ b/providers/cxgb3/cxio_wr.h
@@ -347,7 +347,7 @@ static inline void build_fw_riwrh(struct fw_riwrh *wqe, enum t3_wr_opcode op,
 	wqe->op_seop_flags = htonl(V_FW_RIWR_OP(op) |
 				   V_FW_RIWR_SOPEOP(M_FW_RIWR_SOPEOP) |
 				   V_FW_RIWR_FLAGS(flags));
-	mb();
+	udma_to_device_barrier();
 	wqe->gen_tid_len = htonl(V_FW_RIWR_GEN(genbit) | V_FW_RIWR_TID(tid) |
 				 V_FW_RIWR_LEN(len));
 	/* 2nd gen bit... */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
