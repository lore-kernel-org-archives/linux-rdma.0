From: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH 02/11] RDMA/cxgb4: abort connections when moving to ERROR state.
Date: Mon,  7 Jan 2013 18:41:51 +0530
Message-ID: <1357564320-15022-3-git-send-email-vipul@chelsio.com>
References: <1357564320-15022-1-git-send-email-vipul@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1357564320-15022-1-git-send-email-vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org, divy-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, abhishek-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If a FINI operation fails, then we need to ABORT instead
of CLOSE.  Also, if we ABORT due to unexpected STREAMING
data, then wake up anybody blocked in FINI...

Signed-off-by: Vipul Pandya <vipul-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c |    1 +
 drivers/infiniband/hw/cxgb4/qp.c |    1 +
 2 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index 9cab6a6..3dce47a 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -1438,6 +1438,7 @@ static int abort_rpl(struct c4iw_dev *dev, struct sk_buff *skb)
 	mutex_lock(&ep->com.mutex);
 	switch (ep->com.state) {
 	case ABORTING:
+		c4iw_wake_up(&ep->com.wr_wait, -ECONNRESET);
 		__state_set(&ep->com, DEAD);
 		release = 1;
 		break;
diff --git a/drivers/infiniband/hw/cxgb4/qp.c b/drivers/infiniband/hw/cxgb4/qp.c
index 05bfe53..17ba4f8 100644
--- a/drivers/infiniband/hw/cxgb4/qp.c
+++ b/drivers/infiniband/hw/cxgb4/qp.c
@@ -1383,6 +1383,7 @@ err:
 	qhp->ep = NULL;
 	set_state(qhp, C4IW_QP_STATE_ERROR);
 	free = 1;
+	abort = 1;
 	wake_up(&qhp->wait);
 	BUG_ON(!ep);
 	flush_qp(qhp);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
