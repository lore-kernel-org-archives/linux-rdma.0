From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 2/8] iw_cxgb4: fix possible memory leak in RX_PKT processing
Date: Fri, 21 Mar 2014 20:40:31 +0530
Message-ID: <1395414637-8298-3-git-send-email-hariprasad@chelsio.com>
References: <1395414637-8298-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1395414637-8298-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, kumaras-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>

If cxgb4_ofld_send() returns < 0, then send_fw_pass_open_req() must
free the request skb and the saved skb with the tcp header.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index e1fc5c5..773d010 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3204,6 +3204,7 @@ static void send_fw_pass_open_req(struct c4iw_dev *dev, struct sk_buff *skb,
 	struct sk_buff *req_skb;
 	struct fw_ofld_connection_wr *req;
 	struct cpl_pass_accept_req *cpl = cplhdr(skb);
+	int ret;
 
 	req_skb = alloc_skb(sizeof(struct fw_ofld_connection_wr), GFP_KERNEL);
 	req = (struct fw_ofld_connection_wr *)__skb_put(req_skb, sizeof(*req));
@@ -3240,7 +3241,13 @@ static void send_fw_pass_open_req(struct c4iw_dev *dev, struct sk_buff *skb,
 	req->cookie = (unsigned long)skb;
 
 	set_wr_txq(req_skb, CPL_PRIORITY_CONTROL, port_id);
-	cxgb4_ofld_send(dev->rdev.lldi.ports[0], req_skb);
+	ret = cxgb4_ofld_send(dev->rdev.lldi.ports[0], req_skb);
+	if (ret < 0) {
+		pr_err("%s - cxgb4_ofld_send error %d - dropping\n", __func__,
+		       ret);
+		kfree_skb(skb);
+		kfree_skb(req_skb);
+	}
 }
 
 /*
-- 
1.8.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
