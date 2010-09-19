From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2.6.36] RDMA/cxgb3: Turn off rx coalescing for iwarp
	connections.
Date: Sat, 18 Sep 2010 19:38:21 -0500
Message-ID: <20100919003821.11904.91366.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, stable-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The HW by default has RX coalescing on.  For iwarp connections, this was
causing a 100ms delay in connection establishement due to the ingress
MPA Start message being stalled in HW.  So explicitly turn rx coalescing
off when setting up iwarp connections.

This was causing very bad performance for NP64 gather operations using
OpenMPI due to the way it sets up connections on larger jobs.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb3/iwch_cm.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_cm.c b/drivers/infiniband/hw/cxgb3/iwch_cm.c
index d88077a..13c8887 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_cm.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_cm.c
@@ -463,7 +463,8 @@ static int send_connect(struct iwch_ep *ep)
 	    V_MSS_IDX(mtu_idx) |
 	    V_L2T_IDX(ep->l2t->idx) | V_TX_CHANNEL(ep->l2t->smt_idx);
 	opt0l = V_TOS((ep->tos >> 2) & M_TOS) | V_RCV_BUFSIZ(rcv_win>>10);
-	opt2 = V_FLAVORS_VALID(1) | V_CONG_CONTROL_FLAVOR(cong_flavor);
+	opt2 = F_RX_COALESCE_VALID | V_RX_COALESCE(0) | V_FLAVORS_VALID(1) |
+	       V_CONG_CONTROL_FLAVOR(cong_flavor);
 	skb->priority = CPL_PRIORITY_SETUP;
 	set_arp_failure_handler(skb, act_open_req_arp_failure);
 
@@ -1280,7 +1281,8 @@ static void accept_cr(struct iwch_ep *ep, __be32 peer_ip, struct sk_buff *skb)
 	    V_MSS_IDX(mtu_idx) |
 	    V_L2T_IDX(ep->l2t->idx) | V_TX_CHANNEL(ep->l2t->smt_idx);
 	opt0l = V_TOS((ep->tos >> 2) & M_TOS) | V_RCV_BUFSIZ(rcv_win>>10);
-	opt2 = V_FLAVORS_VALID(1) | V_CONG_CONTROL_FLAVOR(cong_flavor);
+	opt2 = F_RX_COALESCE_VALID | V_RX_COALESCE(0) | V_FLAVORS_VALID(1) |
+	       V_CONG_CONTROL_FLAVOR(cong_flavor);
 
 	rpl = cplhdr(skb);
 	rpl->wr.wr_hi = htonl(V_WR_OP(FW_WROPCODE_FORWARD));

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
