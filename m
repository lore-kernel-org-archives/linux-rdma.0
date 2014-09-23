From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 3/3] RDMA/cxgb4: Fix ntuple calculation for ipv6 and remove duplicate line
Date: Wed, 24 Sep 2014 03:53:43 +0530
Message-ID: <1411511023-14101-4-git-send-email-hariprasad@chelsio.com>
References: <1411511023-14101-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1411511023-14101-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, pramod-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This fixes ntuple calculation for IPv6 active open request for T5 adapter.
And also removes an duplicate line which got added in commit
92e7ae71726c ("iw_cxgb4: Choose appropriate hw mtu index and ISS for iWARP
connections")

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 2ee9892..fb61f66 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -675,6 +675,7 @@ static int send_connect(struct c4iw_ep *ep)
 	if (is_t5(ep->com.dev->rdev.lldi.adapter_type)) {
 		opt2 |= T5_OPT_2_VALID;
 		opt2 |= V_CONG_CNTRL(CONG_ALG_TAHOE);
+		opt2 |= CONG_CNTRL_VALID; /* OPT_2_ISS for T5 */
 	}
 	t4_set_arp_err_handler(skb, ep, act_open_req_arp_failure);
 
@@ -720,8 +721,6 @@ static int send_connect(struct c4iw_ep *ep)
 	} else {
 		u32 isn = (prandom_u32() & ~7UL) - 1;
 
-		opt2 |= T5_OPT_2_VALID;
-		opt2 |= CONG_CNTRL_VALID; /* OPT_2_ISS for T5 */
 		if (peer2peer)
 			isn += 4;
 
@@ -763,10 +762,10 @@ static int send_connect(struct c4iw_ep *ep)
 			t5_req6->peer_ip_lo = *((__be64 *)
 						(ra6->sin6_addr.s6_addr + 8));
 			t5_req6->opt0 = cpu_to_be64(opt0);
-			t5_req6->params = (__force __be64)cpu_to_be32(
+			t5_req6->params = cpu_to_be64(V_FILTER_TUPLE(
 							cxgb4_select_ntuple(
 						ep->com.dev->rdev.lldi.ports[0],
-						ep->l2t));
+						ep->l2t)));
 			t5_req6->rsvd = cpu_to_be32(isn);
 			PDBG("%s snd_isn %u\n", __func__,
 			     be32_to_cpu(t5_req6->rsvd));
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
