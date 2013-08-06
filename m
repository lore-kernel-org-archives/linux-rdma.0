From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 1/8] RDMA/cxgb4: Use correct bit shift macros for vlan filter tuples
Date: Tue,  6 Aug 2013 21:04:33 +0530
Message-ID: <1375803280-7916-2-git-send-email-vipul@chelsio.com>
References: <1375803280-7916-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1375803280-7916-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 9423441..31dee27 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -542,7 +542,7 @@ static unsigned int select_ntuple(struct c4iw_dev *dev, struct dst_entry *dst,
 			ntuple |= FILTER_SEL_VLAN_NONE << FILTER_SEL_WIDTH_P_FC;
 		else {
 			ntuple |= l2t->vlan << FILTER_SEL_WIDTH_P_FC;
-			ntuple |= 1 << FILTER_SEL_WIDTH_VLD_TAG_P_FC;
+			ntuple |= 1 << FILTER_SEL_WIDTH_TAG_P_FC;
 		}
 		ntuple |= l2t->lport << S_PORT | IPPROTO_TCP <<
 			  FILTER_SEL_WIDTH_VLD_TAG_P_FC;
-- 
1.8.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
