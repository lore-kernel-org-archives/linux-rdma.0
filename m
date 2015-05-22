From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 4/7] dapl mpxyd: memset ib_wr structure before post_send on WC and WR requests
Date: Fri, 22 May 2015 12:22:44 -0700
Message-ID: <1432322567-9349-4-git-send-email-arlin.r.davis@intel.com>
References: <1432322567-9349-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1432322567-9349-1-git-send-email-arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/svc/mpxy_in.c  |   10 ++++++----
 dapl/svc/mpxy_out.c |   10 ++++++----
 2 files changed, 12 insertions(+), 8 deletions(-)

diff --git a/dapl/svc/mpxy_in.c b/dapl/svc/mpxy_in.c
index fb57304..cdfab35 100644
--- a/dapl/svc/mpxy_in.c
+++ b/dapl/svc/mpxy_in.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2014 Intel Corporation. All rights reserved.
+ * Copyright (c) 2012-2015 Intel Corporation. All rights reserved.
  *
  * This software is available to you under the OpenIB.org BSD license
  * below:
@@ -498,8 +498,7 @@ static int m_pi_send_wc(struct mcm_qp *m_qp, struct mcm_wr_rx *wr_rx, int status
 
 	if (m_qp->smd->md->indata) {
 		wc_rx_ptr = &wc_rx;
-		wr.send_flags = IBV_SEND_INLINE;
-
+		sge.lkey = 0; /* inline doesn't need registered */
 	} else {
 		wc_rx_ptr = (struct mcm_wc_rx *)
 			    (m_qp->wc_buf_rx + (sizeof(struct mcm_wc_rx) * wc_idx));
@@ -515,7 +514,7 @@ static int m_pi_send_wc(struct mcm_qp *m_qp, struct mcm_wr_rx *wr_rx, int status
 		return (m_pi_send_wc_local(m_qp, wr_rx, wc_idx));
 
 	/* send back a WC with error */
-	wr.next = 0;
+	memset(&wr, 0, sizeof(struct ibv_send_wr));
 	wr.opcode = IBV_WR_RDMA_WRITE_WITH_IMM;
 	wr.imm_data = htonl(*(uint32_t *)&wrc);
 	wr.num_sge = 1;
@@ -526,6 +525,9 @@ static int m_pi_send_wc(struct mcm_qp *m_qp, struct mcm_wr_rx *wr_rx, int status
 				 (m_qp->wrc_rem.wc_addr + (m_qp->wrc_rem.wc_sz * wc_idx)));
 	wr.sg_list = &sge;
 
+	if (m_qp->smd->md->indata)
+		wr.send_flags |= IBV_SEND_INLINE;
+
 	mlog(4, " WC: RW_imm post: wr_id[%d] %Lx sglist %p sge %d op %d flgs %x"
 		" idata %x WR_rem = raddr %p rkey %x ln %d op %x\n",
 		wr_rx->w_idx, wr.wr_id, wr.sg_list, wr.num_sge, wr.opcode,
diff --git a/dapl/svc/mpxy_out.c b/dapl/svc/mpxy_out.c
index 01647a7..8df32f7 100644
--- a/dapl/svc/mpxy_out.c
+++ b/dapl/svc/mpxy_out.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2012-2014 Intel Corporation. All rights reserved.
+ * Copyright (c) 2012-2015 Intel Corporation. All rights reserved.
  *
  * This software is available to you under the OpenIB.org BSD license
  * below:
@@ -267,7 +267,6 @@ static int m_po_send_pi(struct mcm_qp *m_qp, struct mcm_wr *m_wr, int wr_idx)
 
 	if (m_qp->smd->md->indata) {
 		wr_rx_ptr = &wr_rx;
-		wr.send_flags = IBV_SEND_INLINE;
 		sge.lkey = 0; /* inline doesn't need registered */
 	} else {
 		wr_rx_ptr = (struct mcm_wr_rx *)
@@ -285,12 +284,15 @@ static int m_po_send_pi(struct mcm_qp *m_qp, struct mcm_wr *m_wr, int wr_idx)
 	wrc.type = M_WR_TYPE;
 	wrc.flags = 0;
 
+	memset(&wr, 0, sizeof(struct ibv_send_wr));
 	wr.wr_id = WRID_SET(m_wr, WRID_TX_RW_IMM);
-	wr.next = 0;
 	wr.sg_list = &sge;
 	wr.num_sge = 1;
 	wr.opcode = IBV_WR_RDMA_WRITE_WITH_IMM;
 
+	if (m_qp->smd->md->indata)
+		wr.send_flags = IBV_SEND_INLINE;
+
 	if (m_wr->flags & M_SEND_MP_SIG) {
 		m_qp->post_sig_cnt++;  /* sig event pending */
 #if MCM_PROFILE /* MCM_QP_PO_PI_RW */
@@ -302,7 +304,7 @@ static int m_po_send_pi(struct mcm_qp *m_qp, struct mcm_wr *m_wr, int wr_idx)
 #endif
 	}
 
-	wr.send_flags |= m_wr->wr.send_flags | IBV_SEND_SIGNALED;
+	wr.send_flags |= IBV_SEND_SIGNALED;
 	wr.imm_data = htonl(*(uint32_t *)&wrc);
 	wr.wr.rdma.rkey = m_qp->wrc_rem.wr_rkey;
 	wr.wr.rdma.remote_addr =
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
