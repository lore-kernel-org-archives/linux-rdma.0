From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 1/4] iw_cxgb4: Cleanup register defines/MACROS
Date: Thu, 19 Mar 2015 22:13:27 +0530
Message-ID: <1426783410-5128-2-git-send-email-hariprasad@chelsio.com>
References: <1426783410-5128-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1426783410-5128-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Cleanup macros and register defines for consistency

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c          |    4 ++--
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h |    4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 743b805..85167dc 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -675,7 +675,7 @@ static int send_connect(struct c4iw_ep *ep)
 	if (is_t5(ep->com.dev->rdev.lldi.adapter_type)) {
 		opt2 |= T5_OPT_2_VALID_F;
 		opt2 |= V_CONG_CNTRL(CONG_ALG_TAHOE);
-		opt2 |= CONG_CNTRL_VALID; /* OPT_2_ISS for T5 */
+		opt2 |= T5_ISS_F;
 	}
 	t4_set_arp_err_handler(skb, ep, act_open_req_arp_failure);
 
@@ -2217,7 +2217,7 @@ static void accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
 		u32 isn = (prandom_u32() & ~7UL) - 1;
 		opt2 |= T5_OPT_2_VALID_F;
 		opt2 |= V_CONG_CNTRL(CONG_ALG_TAHOE);
-		opt2 |= CONG_CNTRL_VALID; /* OPT_2_ISS for T5 */
+		opt2 |= T5_ISS_F;
 		rpl5 = (void *)rpl;
 		memset(&rpl5->iss, 0, roundup(sizeof(*rpl5)-sizeof(*rpl), 16));
 		if (peer2peer)
diff --git a/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h b/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
index 5709e77..fe29e87 100644
--- a/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
+++ b/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
@@ -848,6 +848,8 @@ enum {                     /* TCP congestion control algorithms */
 #define V_CONG_CNTRL(x) ((x) << S_CONG_CNTRL)
 #define G_CONG_CNTRL(x) (((x) >> S_CONG_CNTRL) & M_CONG_CNTRL)
 
-#define CONG_CNTRL_VALID   (1 << 18)
+#define T5_ISS_S    18
+#define T5_ISS_V(x) ((x) << T5_ISS_S)
+#define T5_ISS_F    T5_ISS_V(1U)
 
 #endif /* _T4FW_RI_API_H_ */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
