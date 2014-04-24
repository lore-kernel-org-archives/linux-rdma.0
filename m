From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH RESEND 3.15-rc3 2/3] iw_cxgb4: force T5 connections to use
	TAHOE cong control
Date: Thu, 24 Apr 2014 14:31:59 -0500
Message-ID: <20140424193158.27837.83201.stgit@build.ogc.int>
References: <20140424193153.27837.76419.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20140424193153.27837.76419.stgit-T4OLL4TyM9aNDNWfRnPdfg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This is required to work around a T5 HW issue.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/hw/cxgb4/cm.c          |    8 ++++++++
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h |   14 ++++++++++++++
 2 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index f9b04bc..1f863a9 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -587,6 +587,10 @@ static int send_connect(struct c4iw_ep *ep)
 		opt2 |= SACK_EN(1);
 	if (wscale && enable_tcp_window_scaling)
 		opt2 |= WND_SCALE_EN(1);
+	if (is_t5(ep->com.dev->rdev.lldi.adapter_type)) {
+		opt2 |= T5_OPT_2_VALID;
+		opt2 |= V_CONG_CNTRL(CONG_ALG_TAHOE);
+	}
 	t4_set_arp_err_handler(skb, NULL, act_open_req_arp_failure);
 
 	if (is_t4(ep->com.dev->rdev.lldi.adapter_type)) {
@@ -2018,6 +2022,10 @@ static void accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
 		if (tcph->ece && tcph->cwr)
 			opt2 |= CCTRL_ECN(1);
 	}
+	if (is_t5(ep->com.dev->rdev.lldi.adapter_type)) {
+		opt2 |= T5_OPT_2_VALID;
+		opt2 |= V_CONG_CNTRL(CONG_ALG_TAHOE);
+	}
 
 	rpl = cplhdr(skb);
 	INIT_TP_WR(rpl, ep->hwtid);
diff --git a/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h b/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
index dc193c2..6121ca0 100644
--- a/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
+++ b/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
@@ -836,4 +836,18 @@ struct ulptx_idata {
 #define V_RX_DACK_CHANGE(x) ((x) << S_RX_DACK_CHANGE)
 #define F_RX_DACK_CHANGE    V_RX_DACK_CHANGE(1U)
 
+enum {                     /* TCP congestion control algorithms */
+	CONG_ALG_RENO,
+	CONG_ALG_TAHOE,
+	CONG_ALG_NEWRENO,
+	CONG_ALG_HIGHSPEED
+};
+
+#define S_CONG_CNTRL    14
+#define M_CONG_CNTRL    0x3
+#define V_CONG_CNTRL(x) ((x) << S_CONG_CNTRL)
+#define G_CONG_CNTRL(x) (((x) >> S_CONG_CNTRL) & M_CONG_CNTRL)
+
+#define T5_OPT_2_VALID       (1 << 31)
+
 #endif /* _T4FW_RI_API_H_ */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
