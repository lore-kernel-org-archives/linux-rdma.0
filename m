From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH 2/2] iw_cxgb4: use the MPA initiator's IRD if < our ORD
Date: Wed, 17 Aug 2016 10:02:43 -0700
Message-ID: <794dd2690e629d9842c2d48ed0614bdf543cc166.1471453661.git.swise@opengridcomputing.com>
References: <cover.1471453661.git.swise@opengridcomputing.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1471453661.git.swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Problem Description: The i40iw initiator sends an MPA-request with ird=16
and ord=16. The cxgb4 responder sends an MPA-reply with ord = 32 causing
i40iw to terminate due to insufficient resources.

The logic to reduce the ORD to <= peer's IRD was wrong.

Reported-by: Shiraz Saleem <shiraz.saleem-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index a698efc..b6a953a 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3140,7 +3140,7 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	if (ep->mpa_attr.version == 2 && ep->mpa_attr.enhanced_rdma_conn) {
 		if (conn_param->ord > ep->ird) {
 			if (RELAXED_IRD_NEGOTIATION) {
-				ep->ord = ep->ird;
+				conn_param->ord = ep->ird;
 			} else {
 				ep->ird = conn_param->ird;
 				ep->ord = conn_param->ord;
-- 
2.7.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
