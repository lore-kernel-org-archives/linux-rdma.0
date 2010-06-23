From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v2 2/3] RDMA/cxgb4: Add module option to tweak delayed ack.
Date: Wed, 23 Jun 2010 10:46:49 -0500
Message-ID: <20100623154649.22600.63839.stgit@build.ogc.int>
References: <20100623154643.22600.20003.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20100623154643.22600.20003.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c          |   10 +++++++++-
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h |   10 ++++++++++
 2 files changed, 19 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 8c9b483..8d1f09b 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -61,6 +61,10 @@ static char *states[] = {
 	NULL,
 };
 
+static int dack_mode;
+module_param(dack_mode, int, 0644);
+MODULE_PARM_DESC(dack_mode, "Delayed ack mode (default=0)");
+
 int c4iw_max_read_depth = 8;
 module_param(c4iw_max_read_depth, int, 0644);
 MODULE_PARM_DESC(c4iw_max_read_depth, "Per-connection max ORD/IRD (default=8)");
@@ -474,6 +478,7 @@ static int send_connect(struct c4iw_ep *ep)
 	cxgb4_best_mtu(ep->com.dev->rdev.lldi.mtus, ep->mtu, &mtu_idx);
 	wscale = compute_wscale(rcv_win);
 	opt0 = KEEP_ALIVE(1) |
+	       DELACK(1) |
 	       WND_SCALE(wscale) |
 	       MSS_IDX(mtu_idx) |
 	       L2T_IDX(ep->l2t->idx) |
@@ -845,7 +850,9 @@ static int update_rx_credits(struct c4iw_ep *ep, u32 credits)
 	INIT_TP_WR(req, ep->hwtid);
 	OPCODE_TID(req) = cpu_to_be32(MK_OPCODE_TID(CPL_RX_DATA_ACK,
 						    ep->hwtid));
-	req->credit_dack = cpu_to_be32(credits);
+	req->credit_dack = cpu_to_be32(credits | RX_FORCE_ACK(1) |
+				       F_RX_DACK_CHANGE |
+				       V_RX_DACK_MODE(dack_mode));
 	set_wr_txq(skb, CPL_PRIORITY_ACK, ep->txq_idx);
 	c4iw_ofld_send(&ep->com.dev->rdev, skb);
 	return credits;
@@ -1264,6 +1271,7 @@ static void accept_cr(struct c4iw_ep *ep, __be32 peer_ip, struct sk_buff *skb,
 	cxgb4_best_mtu(ep->com.dev->rdev.lldi.mtus, ep->mtu, &mtu_idx);
 	wscale = compute_wscale(rcv_win);
 	opt0 = KEEP_ALIVE(1) |
+	       DELACK(1) |
 	       WND_SCALE(wscale) |
 	       MSS_IDX(mtu_idx) |
 	       L2T_IDX(ep->l2t->idx) |
diff --git a/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h b/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
index fc706bd..dc193c2 100644
--- a/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
+++ b/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
@@ -826,4 +826,14 @@ struct ulptx_idata {
 #define S_ULPTX_NSGE    0
 #define M_ULPTX_NSGE    0xFFFF
 #define V_ULPTX_NSGE(x) ((x) << S_ULPTX_NSGE)
+
+#define S_RX_DACK_MODE    29
+#define M_RX_DACK_MODE    0x3
+#define V_RX_DACK_MODE(x) ((x) << S_RX_DACK_MODE)
+#define G_RX_DACK_MODE(x) (((x) >> S_RX_DACK_MODE) & M_RX_DACK_MODE)
+
+#define S_RX_DACK_CHANGE    31
+#define V_RX_DACK_CHANGE(x) ((x) << S_RX_DACK_CHANGE)
+#define F_RX_DACK_CHANGE    V_RX_DACK_CHANGE(1U)
+
 #endif /* _T4FW_RI_API_H_ */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
