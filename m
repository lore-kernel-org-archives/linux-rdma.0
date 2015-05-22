From: arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 1/7] dapl mcm: HST->MXS mode, using RDMA_WRITE_WITH_IMM, fails with dtest -w
Date: Fri, 22 May 2015 12:22:41 -0700
Message-ID: <1432322567-9349-1-git-send-email-arlin.r.davis@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Host side incorrectly sets opcode to IBV_WR_RDMA_WRITE_WITH_IMM on every segment
instead of just the last segment.

Signed-off-by: Arlin Davis <arlin.r.davis-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 dapl/openib_mcm/proxy.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/dapl/openib_mcm/proxy.c b/dapl/openib_mcm/proxy.c
index f4ec1f2..5163bca 100644
--- a/dapl/openib_mcm/proxy.c
+++ b/dapl/openib_mcm/proxy.c
@@ -111,6 +111,12 @@ int mcm_send_pi(struct dcm_ib_qp *m_qp,
 			m_wr_rx.w_idx = htonl(m_qp->wc_tl); /* snd back wc tail */
 			m_wr_rx.wr.num_sge = htonl(wr->num_sge);
 			m_wr_rx.wr.opcode = htonl(wr->opcode);
+
+			/* RW_IMM: reset opcode on all segments except last */
+			if (!(wr_flags & M_SEND_LS) &&
+			     (wr->opcode == IBV_WR_RDMA_WRITE_WITH_IMM))
+				m_wr_rx.wr.opcode = htonl(IBV_WR_RDMA_WRITE);
+
 			m_wr_rx.wr.send_flags = htonl(wr->send_flags);
 			m_wr_rx.wr.imm_data = htonl(wr->imm_data);
 			m_wr_rx.sg[0].addr = htonll(l_addr + l_off);
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
