From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH] iw_cxgb4: handle NET_XMIT return codes
Date: Mon,  8 Dec 2014 15:02:47 +0530
Message-ID: <1418031167-15967-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

cxgb4_create_server() and cxgb4_create_server6() return NET_XMIT_*
values or a negative errno. iw_cxgb4 need to handle this correctly.

Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |    4 ++++
 1 files changed, 4 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index ce87fd3..b50e5ef 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3127,6 +3127,8 @@ static int create_server6(struct c4iw_dev *dev, struct c4iw_listen_ep *ep)
 		err = c4iw_wait_for_reply(&ep->com.dev->rdev,
 					  &ep->com.wr_wait,
 					  0, 0, __func__);
+	else if (err > 0)
+		err = net_xmit_errno(err);
 	if (err)
 		pr_err("cxgb4_create_server6/filter failed err %d stid %d laddr %pI6 lport %d\n",
 		       err, ep->stid,
@@ -3160,6 +3162,8 @@ static int create_server4(struct c4iw_dev *dev, struct c4iw_listen_ep *ep)
 			err = c4iw_wait_for_reply(&ep->com.dev->rdev,
 						  &ep->com.wr_wait,
 						  0, 0, __func__);
+		else if (err > 0)
+			err = net_xmit_errno(err);
 	}
 	if (err)
 		pr_err("cxgb4_create_server/filter failed err %d stid %d laddr %pI4 lport %d\n"
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
