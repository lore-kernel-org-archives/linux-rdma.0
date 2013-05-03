From: sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 2/2] rdma/cm: Allow enabling reuseaddr in any state
Date: Fri,  3 May 2013 15:19:52 -0700
Message-ID: <1367619592-2363-2-git-send-email-sean.hefty@intel.com>
References: <1367619592-2363-1-git-send-email-sean.hefty@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1367619592-2363-1-git-send-email-sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The rdma_cm only allows setting reuseaddr if the corresponding
rdma_cm_id is in the idle state.  Allow setting this value in
other states.  This brings the behavior more inline with
sockets.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 7203a0f..71d7b4c 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -2122,7 +2122,7 @@ int rdma_set_reuseaddr(struct rdma_cm_id *id, int reuse)
 
 	id_priv = container_of(id, struct rdma_id_private, id);
 	spin_lock_irqsave(&id_priv->lock, flags);
-	if (id_priv->state == RDMA_CM_IDLE) {
+	if (reuse || id_priv->state == RDMA_CM_IDLE) {
 		id_priv->reuseaddr = reuse;
 		ret = 0;
 	} else {
-- 
1.7.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
