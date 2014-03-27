From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 for-next] IB/core: Don't resolve passive side RoCE L2 address in cma req handler
Date: Thu, 27 Mar 2014 10:52:58 +0200
Message-ID: <1395910378-28519-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The code that resolves the passive side source mac within the rdma_cm 
connection request handler was both redundant and buggy, remove it.

It was redundant since later, when an RC QP is modified to RTR state 
the resolution will take place in the ib_core module. It was buggy b/c
this callback also deals with UD SIDR exchange under which we wrongly
looked on the REQ member of the CM event and dereferenced a random value.

Fixes: dd5f03beb4f7 'IB/core: Ethernet L2 attributes in verbs/cm structures'
Signed-off-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Hi Roland, we're post 3.14-rc8 and hence I assume will go to 3.15-rc1 
and once there we will post it to -stable to it gets into 3.14.y

That nasty random deref wasn't causing instant crashes, but rather only 
when running on lengthy QA loops, so we missed it through the submission.


V1 changes: removed unused variables from cma_req_handler 

V2 changes: added pointer to the commit this fixes in the change-log


 drivers/infiniband/core/cm.c  |   17 -----------------
 drivers/infiniband/core/cma.c |   26 --------------------------
 include/rdma/ib_cm.h          |    1 -
 3 files changed, 0 insertions(+), 44 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 0601b9d..c323917 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -349,23 +349,6 @@ static void cm_init_av_for_response(struct cm_port *port, struct ib_wc *wc,
 			   grh, &av->ah_attr);
 }
 
-int ib_update_cm_av(struct ib_cm_id *id, const u8 *smac, const u8 *alt_smac)
-{
-	struct cm_id_private *cm_id_priv;
-
-	cm_id_priv = container_of(id, struct cm_id_private, id);
-
-	if (smac != NULL)
-		memcpy(cm_id_priv->av.smac, smac, sizeof(cm_id_priv->av.smac));
-
-	if (alt_smac != NULL)
-		memcpy(cm_id_priv->alt_av.smac, alt_smac,
-		       sizeof(cm_id_priv->alt_av.smac));
-
-	return 0;
-}
-EXPORT_SYMBOL(ib_update_cm_av);
-
 static int cm_init_av_by_path(struct ib_sa_path_rec *path, struct cm_av *av)
 {
 	struct cm_device *cm_dev;
diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 199958d..42c3058 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -1284,15 +1284,6 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	struct rdma_id_private *listen_id, *conn_id;
 	struct rdma_cm_event event;
 	int offset, ret;
-	u8 smac[ETH_ALEN];
-	u8 alt_smac[ETH_ALEN];
-	u8 *psmac = smac;
-	u8 *palt_smac = alt_smac;
-	int is_iboe = ((rdma_node_get_transport(cm_id->device->node_type) ==
-			RDMA_TRANSPORT_IB) &&
-		       (rdma_port_get_link_layer(cm_id->device,
-			ib_event->param.req_rcvd.port) ==
-			IB_LINK_LAYER_ETHERNET));
 
 	listen_id = cm_id->context;
 	if (!cma_check_req_qp_type(&listen_id->id, ib_event))
@@ -1336,28 +1327,11 @@ static int cma_req_handler(struct ib_cm_id *cm_id, struct ib_cm_event *ib_event)
 	ret = conn_id->id.event_handler(&conn_id->id, &event);
 	if (ret)
 		goto err3;
-
-	if (is_iboe) {
-		if (ib_event->param.req_rcvd.primary_path != NULL)
-			rdma_addr_find_smac_by_sgid(
-				&ib_event->param.req_rcvd.primary_path->sgid,
-				psmac, NULL);
-		else
-			psmac = NULL;
-		if (ib_event->param.req_rcvd.alternate_path != NULL)
-			rdma_addr_find_smac_by_sgid(
-				&ib_event->param.req_rcvd.alternate_path->sgid,
-				palt_smac, NULL);
-		else
-			palt_smac = NULL;
-	}
 	/*
 	 * Acquire mutex to prevent user executing rdma_destroy_id()
 	 * while we're accessing the cm_id.
 	 */
 	mutex_lock(&lock);
-	if (is_iboe)
-		ib_update_cm_av(cm_id, psmac, palt_smac);
 	if (cma_comp(conn_id, RDMA_CM_CONNECT) &&
 	    (conn_id->id.qp_type != IB_QPT_UD))
 		ib_send_cm_mra(cm_id, CMA_CM_MRA_SETTING, NULL, 0);
diff --git a/include/rdma/ib_cm.h b/include/rdma/ib_cm.h
index f29e3a2..0e3ff30 100644
--- a/include/rdma/ib_cm.h
+++ b/include/rdma/ib_cm.h
@@ -601,5 +601,4 @@ struct ib_cm_sidr_rep_param {
 int ib_send_cm_sidr_rep(struct ib_cm_id *cm_id,
 			struct ib_cm_sidr_rep_param *param);
 
-int ib_update_cm_av(struct ib_cm_id *id, const u8 *smac, const u8 *alt_smac);
 #endif /* IB_CM_H */
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
