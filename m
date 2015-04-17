From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-4.1 1/4] iw_cxgb4: Cleanup register defines/MACROS
Date: Fri, 17 Apr 2015 20:35:02 +0530
Message-ID: <1429283105-13243-2-git-send-email-hariprasad@chelsio.com>
References: <1429283105-13243-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429283105-13243-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, leedom-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Cleanup macros and register defines for consistency

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c          | 4 ++--
 drivers/infiniband/hw/cxgb4/t4fw_ri_api.h | 4 +++-
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 57176dd..6ed5025 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -675,7 +675,7 @@ static int send_connect(struct c4iw_ep *ep)
 	if (is_t5(ep->com.dev->rdev.lldi.adapter_type)) {
 		opt2 |= T5_OPT_2_VALID_F;
 		opt2 |= CONG_CNTRL_V(CONG_ALG_TAHOE);
-		opt2 |= CONG_CNTRL_VALID; /* OPT_2_ISS for T5 */
+		opt2 |= T5_ISS_F;
 	}
 	t4_set_arp_err_handler(skb, ep, act_open_req_arp_failure);
 
@@ -2214,7 +2214,7 @@ static void accept_cr(struct c4iw_ep *ep, struct sk_buff *skb,
 		u32 isn = (prandom_u32() & ~7UL) - 1;
 		opt2 |= T5_OPT_2_VALID_F;
 		opt2 |= CONG_CNTRL_V(CONG_ALG_TAHOE);
-		opt2 |= CONG_CNTRL_VALID; /* OPT_2_ISS for T5 */
+		opt2 |= T5_ISS_F;
 		rpl5 = (void *)rpl;
 		memset(&rpl5->iss, 0, roundup(sizeof(*rpl5)-sizeof(*rpl), 16));
 		if (peer2peer)
diff --git a/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h b/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
index 5e53327..343e8daf 100644
--- a/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
+++ b/drivers/infiniband/hw/cxgb4/t4fw_ri_api.h
@@ -848,6 +848,8 @@ enum {                     /* TCP congestion control algorithms */
 #define CONG_CNTRL_V(x) ((x) << CONG_CNTRL_S)
 #define CONG_CNTRL_G(x) (((x) >> CONG_CNTRL_S) & CONG_CNTRL_M)
 
-#define CONG_CNTRL_VALID   (1 << 18)
+#define T5_ISS_S    18
+#define T5_ISS_V(x) ((x) << T5_ISS_S)
+#define T5_ISS_F    T5_ISS_V(1U)
 
 #endif /* _T4FW_RI_API_H_ */
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
