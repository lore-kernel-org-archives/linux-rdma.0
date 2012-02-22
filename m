From: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
Subject: [PATCH] iw_cm: reject connect requests if cmid is not in LISTEN
Date: Wed, 22 Feb 2012 15:43:08 -0600
Message-ID: <20120222214307.23921.83903.stgit@build.ogc.int>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

When destroying a listening cmid, the iwcm first marks the state of
the cmid as DESTROYING, then releases the lock and calls into the
iwarp provider to destroy the endpoint.  Since the cmid is not locked,
its possible for the iwarp provider to pass a connection request event
to the iwcm, which will be silently dropped by the iwcm.  This causes
the iwarp provider to never free up the resources from this connection
because the assumption is the iwcm will accept or reject this connection.

The solution is to reject these connection requests.

Signed-off-by: Steve Wise <swise-7bPotxP6k4+P2YhJcF5u+vpXobYPEAuW@public.gmane.org>
---

 drivers/infiniband/core/iwcm.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/iwcm.c b/drivers/infiniband/core/iwcm.c
index 1a696f7..6847d76 100644
--- a/drivers/infiniband/core/iwcm.c
+++ b/drivers/infiniband/core/iwcm.c
@@ -631,6 +631,8 @@ static void cm_conn_req_handler(struct iwcm_id_private *listen_id_priv,
 	spin_lock_irqsave(&listen_id_priv->lock, flags);
 	if (listen_id_priv->state != IW_CM_STATE_LISTEN) {
 		spin_unlock_irqrestore(&listen_id_priv->lock, flags);
+		iw_cm_reject(cm_id, NULL, 0);
+		iw_destroy_cm_id(cm_id);
 		goto out;
 	}
 	spin_unlock_irqrestore(&listen_id_priv->lock, flags);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
