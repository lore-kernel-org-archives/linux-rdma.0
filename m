From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 1/2] iw_cxgb4: limit IRD/ORD advertised to ULP by device max.
Date: Tue, 16 Aug 2016 11:33:38 -0700
Message-ID: <4fa2875df1a471eb8c6a1509f2e7d4d0e698a88d.1471453661.git.swise@opengridcomputing.com>
References: <cover.1471453661.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1471453661.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Problem Description: i40iw initiator sends MPA-request with ird =
63, ord = 63. The cxgb4 responder sends a RST.  Since the inbound ord=63
and it exceeds the max_ird/c4iw_max_read_depth (=32 default), chelsio
decides to abort.

Instead, cxgb4 should adjust the ord/ird down before presenting it to
the ULP.

Reported-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 3aca7f6..a698efc 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1827,8 +1827,12 @@ static int process_mpa_request(struct c4iw_ep *ep, struct sk_buff *skb)
 				(ep->mpa_pkt + sizeof(*mpa));
 			ep->ird = ntohs(mpa_v2_params->ird) &
 				MPA_V2_IRD_ORD_MASK;
+			ep->ird = min_t(u32, ep->ird,
+					cur_max_read_depth(ep->com.dev));
 			ep->ord = ntohs(mpa_v2_params->ord) &
 				MPA_V2_IRD_ORD_MASK;
+			ep->ord = min_t(u32, ep->ord,
+					cur_max_read_depth(ep->com.dev));
 			PDBG("%s initiator ird %u ord %u\n", __func__, ep->ird,
 			     ep->ord);
 			if (ntohs(mpa_v2_params->ird) & MPA_V2_PEER2PEER_MODEL)
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
