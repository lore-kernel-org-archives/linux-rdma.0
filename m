From: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Subject: [PATCH for-next 13/17] RDMA/iw_cxgb4: Handle ULP accept/reject during ABORTING
Date: Fri,  6 May 2016 22:18:06 +0530
Message-ID: <1462553290-16422-14-git-send-email-hariprasad@chelsio.com>
References: <1462553290-16422-1-git-send-email-hariprasad@chelsio.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462553290-16422-1-git-send-email-hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, nirranjan-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

c4iw_reject() and c4iw_accept() need to handle the case where the
endpoint has timed out and is in the middle of ABORTING the connection.

Here is the flow that causes the BUG_ON() to fire on the server side:

1) offload connection setup and endpoint timer started

2) MPA_START request received from peer, CONNECT_REQUEST passed to ULP

3) endpoint timer fires, and process_timeout() aborts the connection,
this moves the endpoint state to ABORTING until HW sends up the
ABORT_RPL_RSS.

4) application exits closing the CONNECT_REQUEST cm_id.  The IWCM calls
c4iw_reject_cr() to destroy this connection request.

5) WHAMO: BUG_ON() because the state is ABORTING.

The fix is to change c4iw_reject_cr() and c4iw_accept_cr() to fail the
operation if the state is not in MPA_REQ_RCVD vs in DEAD.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Signed-off-by: Hariprasad Shenai <hariprasad-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/cm.c | 6 ++----
 1 file changed, 2 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/cm.c b/drivers/infiniband/hw/cxgb4/cm.c
index a972067d94cb..e8edfeea84f9 100644
--- a/drivers/infiniband/hw/cxgb4/cm.c
+++ b/drivers/infiniband/hw/cxgb4/cm.c
@@ -3005,13 +3005,12 @@ int c4iw_reject_cr(struct iw_cm_id *cm_id, const void *pdata, u8 pdata_len)
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 
 	mutex_lock(&ep->com.mutex);
-	if (ep->com.state == DEAD) {
+	if (ep->com.state != MPA_REQ_RCVD) {
 		mutex_unlock(&ep->com.mutex);
 		c4iw_put_ep(&ep->com);
 		return -ECONNRESET;
 	}
 	set_bit(ULP_REJECT, &ep->com.history);
-	BUG_ON(ep->com.state != MPA_REQ_RCVD);
 	if (mpa_rev == 0)
 		disconnect = 2;
 	else {
@@ -3040,12 +3039,11 @@ int c4iw_accept_cr(struct iw_cm_id *cm_id, struct iw_cm_conn_param *conn_param)
 	PDBG("%s ep %p tid %u\n", __func__, ep, ep->hwtid);
 
 	mutex_lock(&ep->com.mutex);
-	if (ep->com.state == DEAD) {
+	if (ep->com.state != MPA_REQ_RCVD) {
 		err = -ECONNRESET;
 		goto err_out;
 	}
 
-	BUG_ON(ep->com.state != MPA_REQ_RCVD);
 	BUG_ON(!qp);
 
 	set_bit(ULP_ACCEPT, &ep->com.history);
-- 
2.3.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
