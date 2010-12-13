From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V3 5/6] RDMA CM: Save Owning PID
Date: Mon, 13 Dec 2010 18:22:49 +0200
Message-ID: <1292257370-24391-6-git-send-email-nirm@voltaire.com>
References: <1292257370-24391-1-git-send-email-nirm@voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1292257370-24391-1-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org, nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Save owning PID to id-priv when creating id's/accepting connections.

Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    8 ++++++++
 1 files changed, 8 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 5821f93..9629a90 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -134,6 +134,7 @@ struct rdma_id_private {
 	u32			qp_num;
 	u8			srq;
 	u8			tos;
+	pid_t			owner;
 };
 
 struct cma_multicast {
@@ -418,6 +419,7 @@ struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
 	if (!id_priv)
 		return ERR_PTR(-ENOMEM);
 
+	id_priv->owner = current->pid;
 	id_priv->state = RDMA_CM_IDLE;
 	id_priv->id.context = context;
 	id_priv->id.event_handler = event_handler;
@@ -2671,8 +2673,14 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 {
 	struct rdma_id_private *id_priv;
 	int ret;
+	unsigned long flags;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
+
+	spin_lock_irqsave(&id_priv->lock, flags);
+	id_priv->owner = current->pid;
+	spin_unlock_irqrestore(&id_priv->lock, flags);
+
 	if (!cma_comp(id_priv, RDMA_CM_CONNECT))
 		return -EINVAL;
 
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
