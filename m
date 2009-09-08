From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] RDMA/iwcm: Reject the connection when the cm_id is destroyed.
Date: Tue, 08 Sep 2009 15:33:58 -0500
Message-ID: <20090908203358.14739.37133.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: tom-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If the cm_id of a connect request is destroyed prior to the ULP
accepting or rejecting the connection, then the provider never cleans
up the connection.  The iwcm should explicitly reject these connections
if the cm_id is destroyed.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/core/iwcm.c |    1 +
 1 files changed, 1 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 8f9509e..55d093a 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -362,6 +362,7 @@ static void destroy_cm_id(struct iw_cm_id *cm_id)
 		 * In either case, must tell the provider to reject.
 		 */
 		cm_id_priv->state = IW_CM_STATE_DESTROYING;
+		cm_id->device->iwcm->reject(cm_id, NULL, 0);
 		break;
 	case IW_CM_STATE_CONN_SENT:
 	case IW_CM_STATE_DESTROYING:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
