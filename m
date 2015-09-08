From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 3/5] iw_cxgb4: fix misuse of ep->ord for minimum ird calculation
Date: Tue,  8 Sep 2015 09:56:59 +0530
Message-ID: <1441686421-5899-4-git-send-email-hariprasad@chelsio.com>
References: <1441686421-5899-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1441686421-5899-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

When calculating the minimum ird in c4iw_accept_cr(), we need to always
have a value of at least 1 if the RTR message is a 0B read.  The code
was
incorrectly using ep->ord for this logic which was incorrectly adjusting
the ird and causing incorrect ord/ird negotiation when using MPAv2 to
negotiate these values.

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index a26d293..06d208c 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -2878,7 +2878,7 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	} else {
 		if (peer2peer &&
 		    (ep->mpa_attr.p2p_type != FW_RI_INIT_P2PTYPE_DISABLED) &&
-		    (p2p_type == FW_RI_INIT_P2PTYPE_READ_REQ) && ep->ord == 0)
+		    (p2p_type == FW_RI_INIT_P2PTYPE_READ_REQ) && ep->ird == 0)
 			ep->ird = 1;
 	}
 
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
