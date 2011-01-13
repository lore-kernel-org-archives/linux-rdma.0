From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V5 6/6] RDMA CM: Save Owning PID
Date: Thu, 13 Jan 2011 15:56:04 +0200
Message-ID: <1294926964-17715-1-git-send-email-nirm@voltaire.com>
References: <ada39ox4ts7.fsf@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <ada39ox4ts7.fsf-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

It seemed necessary some time ago, but you're right. It's got no use...
Below is a revised patch.

Thanks,
Nir

Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c |    6 ++++++
 1 files changed, 6 insertions(+), 0 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 6436995..0ccb3ed 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -135,6 +135,7 @@ struct rdma_id_private {
 	u32			qp_num;
 	u8			srq;
 	u8			tos;
+	pid_t			owner;
 };
 
 struct cma_multicast {
@@ -419,6 +420,7 @@ struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
 	if (!id_priv)
 		return ERR_PTR(-ENOMEM);
 
+	id_priv->owner = current->pid;
 	id_priv->state = RDMA_CM_IDLE;
 	id_priv->id.context = context;
 	id_priv->id.event_handler = event_handler;
@@ -2674,6 +2676,9 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
+
+	id_priv->owner = current->pid;
+
 	if (!cma_comp(id_priv, RDMA_CM_CONNECT))
 		return -EINVAL;
 
@@ -3313,6 +3318,7 @@ static int cma_get_id_stats(struct sk_buff *skb, struct netlink_callback *cb)
 			id_stats->port_space = id->ps;
 			id_stats->cm_state = id_priv->state;
 			id_stats->qp_num = id_priv->qp_num;
+			id_stats->pid = id_priv->owner;
 
 			i_id++;
 		}
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
