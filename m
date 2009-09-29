From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH v2] IWCM: Don't call provider reject func with irqs disabled
Date: Tue, 29 Sep 2009 13:41:53 -0500
Message-ID: <20090929184152.16572.60582.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Recently a call to the provider's reject handler was added to
destroy_cm_id() to fix a provider endpoint leak.  This call needs to be
done outside of irq disablement.  So unlock and relock around this call.
This is safe because:

1) the provider will do nothing with this endpoint until the iwcm either
accepts or rejects.

2) the lock is only released after the iwcm state is changed, so an errant
iwcm app that is destroying -and- rejecting the connection concurrently
will get a failure on one of the calls.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/core/iwcm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 55d093a..625fec5 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -362,7 +362,9 @@ static void destroy_cm_id(struct iw_cm_id *cm_id)
 		 * In either case, must tell the provider to reject.
 		 */
 		cm_id_priv->state = IW_CM_STATE_DESTROYING;
+		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 		cm_id->device->iwcm->reject(cm_id, NULL, 0);
+		spin_lock_irqsave(&cm_id_priv->lock, flags);
 		break;
 	case IW_CM_STATE_CONN_SENT:
 	case IW_CM_STATE_DESTROYING:

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
