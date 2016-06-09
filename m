From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH net-next 3/7] RDMA/iw_cxgb4: clean up c4iw_reject_cr()
Date: Fri, 10 Jun 2016 01:05:13 +0530
Message-ID: <1465500917-18491-4-git-send-email-hariprasad@chelsio.com>
References: <1465500917-18491-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465500917-18491-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>, Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Get rid of unneeded code, and refactor things a bit.

For MPA version 0 we abort the connection.  For > 0, we attempt to send
an MPA_START/REJECT Reply, and then disconnect gracefully.  If the send
of the MPA message fails, then we abort the connection.  We can ignore
c4iw_ep_disconnect() errors here because it will clean up the endpoint
if there are failures.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 19 ++++++++-----------
 1 file changed, 8 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 2ba3403d8101..25236fc7dc92 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3037,9 +3037,9 @@ out:
 
 int c4iw_reject_cr(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 {
-	int err = 0;
-	int disconnect = 0;
+	int abort;
 	struct c4iw_ep *ep = to_ep(cm_id);
+
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 
 	mutex_lock(&ep->com.mutex);
@@ -3050,16 +3050,13 @@ int c4iw_reject_cr(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 	}
 	set_bit(ULP_REJECT, &ep->com.history);
 	if (mpa_rev == 0)
-		disconnect = 2;
-	else {
-		err = send_mpa_reject(ep, pdata, pdata_len);
-		disconnect = 1;
-	}
+		abort = 1;
+	else
+		abort = send_mpa_reject(ep, pdata, pdata_len);
 	mutex_unlock(&ep->com.mutex);
-	if (disconnect) {
-		stop_ep_timer(ep);
-		err = c4iw_ep_disconnect(ep, disconnect == 2, GFP_KERNEL);
-	}
+
+	stop_ep_timer(ep);
+	c4iw_ep_disconnect(ep, abort != 0, GFP_KERNEL);
 	c4iw_put_ep(&ep->com);
 	return 0;
 }
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
