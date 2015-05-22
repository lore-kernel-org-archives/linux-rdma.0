From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/7] dapl mpxyd: use wr opcode instead of wc opcode to support logging on error cases
Date: Fri, 22 May 2015 12:22:42 -0700
Message-ID: <1432322567-9349-2-git-send-email-arlin.r.davis@intel.com>
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
 dapl/svc/mpxy_in.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/dapl/svc/mpxy_in.c b/dapl/svc/mpxy_in.c
index 0ec6a1c..fb57304 100644
--- a/dapl/svc/mpxy_in.c
+++ b/dapl/svc/mpxy_in.c
@@ -720,7 +720,7 @@ void m_pi_req_event(struct mcm_qp *m_qp, struct mcm_wr_rx *wr_rx, struct ibv_wc
 {
 	mlog(4, " WR_rx[%d] %p %s complete po-addr=%p ln=%d, key=%x ctx=%Lx\n",
 		wr_rx->w_idx, wr_rx,
-		wc->opcode == IBV_WC_RDMA_READ ? "RR":"RW_IMM WC",
+		wr_rx->wr.opcode == IBV_WR_RDMA_READ ? "RR":"RW_IMM WC",
 		wr_rx->sg[0].addr, wr_rx->sg[0].length,
 		wr_rx->sg[0].lkey, wr_rx->context);
 
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
