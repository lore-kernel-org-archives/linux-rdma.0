From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 3/7] IB: Correct MR length field to be 64-bit
Date: Sun, 24 Sep 2017 21:46:31 +0300
Message-ID: <20170924184635.31948-4-leon@kernel.org>
References: <20170924184635.31948-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170924184635.31948-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The ib_mr->length represents the length of the MR in bytes as per
the IBTA spec 1.3 section 11.2.10.3 (REGISTER PHYSICAL MEMORY REGION).

Currently ib_mr->length field is defined as only 32-bits field.
This might result into truncation and failed WRs of consumers who
registers more than 4GB bytes memory regions and whose WRs accessing
such MRs.

This patch makes the length 64-bit to avoid such truncation.

Cc: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Cc: Chuck Lever <chuck.lever-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Cc: Faisal Latif <faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Fixes: 4c67e2bfc8b7 ("IB/core: Introduce new fast registration API")
Signed-off-by: Ilya Lesokhin <ilyal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c     | 4 ++--
 drivers/infiniband/ulp/iser/iser_memory.c | 2 +-
 include/rdma/ib_verbs.h                   | 2 +-
 net/sunrpc/xprtrdma/frwr_ops.c            | 2 +-
 4 files changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index f0dc5f4aa177..442b9bdc0f03 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -3232,7 +3232,7 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 					    mr->ibmr.iova);
 			set_wqe_32bit_value(wqe->wqe_words,
 					    NES_IWARP_SQ_FMR_WQE_LENGTH_LOW_IDX,
-					    mr->ibmr.length);
+					    lower_32_bits(mr->ibmr.length));
 			set_wqe_32bit_value(wqe->wqe_words,
 					    NES_IWARP_SQ_FMR_WQE_LENGTH_HIGH_IDX, 0);
 			set_wqe_32bit_value(wqe->wqe_words,
@@ -3274,7 +3274,7 @@ static int nes_post_send(struct ib_qp *ibqp, struct ib_send_wr *ib_wr,
 					    mr->npages * 8);
 
 			nes_debug(NES_DBG_IW_TX, "SQ_REG_MR: iova_start: %llx, "
-				  "length: %d, rkey: %0x, pgl_paddr: %llx, "
+				  "length: %lld, rkey: %0x, pgl_paddr: %llx, "
 				  "page_list_len: %u, wqe_misc: %x\n",
 				  (unsigned long long) mr->ibmr.iova,
 				  mr->ibmr.length,
diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 9c3e9ab53a41..322209d5ff58 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -154,7 +154,7 @@ static void iser_dump_page_vec(struct iser_page_vec *page_vec)
 {
 	int i;
 
-	iser_err("page vec npages %d data length %d\n",
+	iser_err("page vec npages %d data length %lld\n",
 		 page_vec->npages, page_vec->fake_mr.length);
 	for (i = 0; i < page_vec->npages; i++)
 		iser_err("vec[%d]: %llx\n", i, page_vec->pages[i]);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index bbb5f54db882..e8608b2dc844 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1739,7 +1739,7 @@ struct ib_mr {
 	u32		   lkey;
 	u32		   rkey;
 	u64		   iova;
-	u32		   length;
+	u64		   length;
 	unsigned int	   page_size;
 	bool		   need_inval;
 	union {
diff --git a/net/sunrpc/xprtrdma/frwr_ops.c b/net/sunrpc/xprtrdma/frwr_ops.c
index 5a936a6a31a3..df062e086bdb 100644
--- a/net/sunrpc/xprtrdma/frwr_ops.c
+++ b/net/sunrpc/xprtrdma/frwr_ops.c
@@ -401,7 +401,7 @@ frwr_op_map(struct rpcrdma_xprt *r_xprt, struct rpcrdma_mr_seg *seg,
 	if (unlikely(n != mw->mw_nents))
 		goto out_mapmr_err;
 
-	dprintk("RPC:       %s: Using frmr %p to map %u segments (%u bytes)\n",
+	dprintk("RPC:       %s: Using frmr %p to map %u segments (%llu bytes)\n",
 		__func__, frmr, mw->mw_nents, mr->length);
 
 	key = (u8)(mr->rkey & 0x000000FF);
-- 
2.14.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
