From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 09/17] RDMA/iw_cxgb4: Handle return value of c4iw_ofld_send() in abort_arp_failure()
Date: Fri,  6 May 2016 22:18:02 +0530
Message-ID: <1462553290-16422-10-git-send-email-hariprasad@chelsio.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In abort_arp_failure(), the return value from c4iw_ofld_send() is
ignored and thus if the CPL isn't sent, the endpoint is stuck and never
gets aborted. Failure of c4iw_ofld_send() is treated as fatal error, and
the ep resources are released in a safer context through process_work().

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 12 +++++++++---
 1 file changed, 9 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 6c22bc95a112..6129dbd0dc9e 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -540,12 +540,18 @@ static void act_open_req_arp_failure(void *handle, struct sk_buff *skb)
  */
 static void abort_arp_failure(void *handle, struct sk_buff *skb)
 {
-	struct c4iw_rdev *rdev = handle;
+	int ret;
+	struct c4iw_ep *ep = handle;
+	struct c4iw_rdev *rdev = &ep->com.dev->rdev;
 	struct cpl_abort_req *req = cplhdr(skb);
 
 	PDBG("%s rdev %p\n", __func__, rdev);
 	req->cmd = CPL_ABORT_NO_RST;
-	c4iw_ofld_send(rdev, skb);
+	ret = c4iw_ofld_send(rdev, skb);
+	if (ret) {
+		__state_set(&ep->com, DEAD);
+		queue_arp_failure_cpl(ep, skb, FAKE_CPL_PUT_EP_SAFE);
+	}
 }
 
 static int send_flowc(struct c4iw_ep *ep, struct sk_buff *skb)
@@ -642,7 +648,7 @@ static int send_abort(struct c4iw_ep *ep, struct sk_buff *skb, gfp_t gfp)
 		return -ENOMEM;
 	}
 	set_wr_txq(skb, CPL_PRIORITY_DATA, ep->txq_idx);
-	t4_set_arp_err_handler(skb, &ep->com.dev->rdev, abort_arp_failure);
+	t4_set_arp_err_handler(skb, ep, abort_arp_failure);
 	req = (struct cpl_abort_req *) skb_put(skb, wrlen);
 	memset(req, 0, wrlen);
 	INIT_TP_WR(req, ep->hwtid);
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
