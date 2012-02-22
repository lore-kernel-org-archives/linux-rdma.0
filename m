From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cm: Call provider listen_destroy function before changing
	state.
Date: Wed, 22 Feb 2012 13:43:38 -0600
Message-ID: <20120222194337.21025.30754.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When destroying a listening cmid, the iwcm first sets the cmid state to
DESTROYING, then releases the lock and calls into the iwarp provider
to destroy the listening endpoint.  Since the cmid is not locked, its
possible for the iwarp provider to pass a connection request event to
the iwcm before the provider has destroyed the listening endpoint. This
connect request will be silently dropped by the iwcm because the state
of the cmid is DESTROYING.  The iwarp provider, however, doesn't know the
connect request was dropped.  This causes the iwarp provider to never free
up the resources from this connection because the assumption is the iwcm
will _always_ either accept or reject this connection.  The solution is
to only change the cmid state  after the iwarp provider has destroyed its
listening endpoint, and thus no more connection requests will be posted.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/core/iwcm.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 1a696f7..3b43bba 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -340,11 +340,11 @@ static void destroy_cm_id(struct iw_cm_id *cm_id)
 	spin_lock_irqsave(&cm_id_priv->lock, flags);
 	switch (cm_id_priv->state) {
 	case IW_CM_STATE_LISTEN:
-		cm_id_priv->state = IW_CM_STATE_DESTROYING;
 		spin_unlock_irqrestore(&cm_id_priv->lock, flags);
 		/* destroy the listening endpoint */
 		ret = cm_id->device->iwcm->destroy_listen(cm_id);
 		spin_lock_irqsave(&cm_id_priv->lock, flags);
+		cm_id_priv->state = IW_CM_STATE_DESTROYING;
 		break;
 	case IW_CM_STATE_ESTABLISHED:
 		cm_id_priv->state = IW_CM_STATE_DESTROYING;

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
