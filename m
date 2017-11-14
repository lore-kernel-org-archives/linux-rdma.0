From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 30/31] IB/{core, umad, cm}: Rename ib_init_ah_from_wc to ib_init_ah_attr_from_wc
Date: Tue, 14 Nov 2017 14:52:17 +0200
Message-ID: <20171114125218.20477-31-leon@kernel.org>
References: <20171114125218.20477-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171114125218.20477-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Currently ib_init_ah_from_wc initializes address handle attributes and
not the address handle object itself.
To avoid confusion between ah_attr vs ah, ib_init_ah_from_wc is
renamed to ib_init_ah_attr_from_wc to reflect that its initialzes
ah_attr.

Signed-off-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cm.c       |  5 +++--
 drivers/infiniband/core/user_mad.c |  8 ++++----
 drivers/infiniband/core/verbs.c    | 12 ++++++------
 include/rdma/ib_verbs.h            |  8 ++++----
 4 files changed, 17 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 3bb82c6ec88d..e5d96bd3c377 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -457,8 +457,9 @@ static int cm_init_av_for_response(struct cm_port *port, struct ib_wc *wc,
 {
 	av->port = port;
 	av->pkey_index = wc->pkey_index;
-	return ib_init_ah_from_wc(port->cm_dev->ib_device, port->port_num, wc,
-				  grh, &av->ah_attr);
+	return ib_init_ah_attr_from_wc(port->cm_dev->ib_device,
+				       port->port_num, wc,
+				       grh, &av->ah_attr);
 }
 
 static int cm_init_av_by_path(struct sa_path_rec *path, struct cm_av *av,
diff --git a/drivers/infiniband/core/user_mad.c b/drivers/infiniband/core/user_mad.c
index 3179fed4b408..3ef8ee5d4aa2 100644
--- a/drivers/infiniband/core/user_mad.c
+++ b/drivers/infiniband/core/user_mad.c
@@ -248,10 +248,10 @@ static void recv_handler(struct ib_mad_agent *agent,
 		const struct ib_global_route *grh;
 		int ret;
 
-		ret = ib_init_ah_from_wc(agent->device, agent->port_num,
-					 mad_recv_wc->wc,
-					 mad_recv_wc->recv_buf.grh,
-					 &ah_attr);
+		ret = ib_init_ah_attr_from_wc(agent->device, agent->port_num,
+					      mad_recv_wc->wc,
+					      mad_recv_wc->recv_buf.grh,
+					      &ah_attr);
 		if (ret)
 			goto err2;
 
diff --git a/drivers/infiniband/core/verbs.c b/drivers/infiniband/core/verbs.c
index 0cac32736189..b53fb0e98751 100644
--- a/drivers/infiniband/core/verbs.c
+++ b/drivers/infiniband/core/verbs.c
@@ -526,7 +526,7 @@ static int ib_resolve_unicast_gid_dmac(struct ib_device *device,
 }
 
 /*
- * This function creates ah from the incoming packet.
+ * This function initializes address handle attributes from the incoming packet.
  * Incoming packet has dgid of the receiver node on which this code is
  * getting executed and, sgid contains the GID of the sender.
  *
@@ -535,9 +535,9 @@ static int ib_resolve_unicast_gid_dmac(struct ib_device *device,
  * GID whom to respond to.
  *
  */
-int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
-		       const struct ib_wc *wc, const struct ib_grh *grh,
-		       struct rdma_ah_attr *ah_attr)
+int ib_init_ah_attr_from_wc(struct ib_device *device, u8 port_num,
+			    const struct ib_wc *wc, const struct ib_grh *grh,
+			    struct rdma_ah_attr *ah_attr)
 {
 	u32 flow_class;
 	u16 gid_index;
@@ -611,7 +611,7 @@ int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
 		return 0;
 	}
 }
-EXPORT_SYMBOL(ib_init_ah_from_wc);
+EXPORT_SYMBOL(ib_init_ah_attr_from_wc);
 
 struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
 				   const struct ib_grh *grh, u8 port_num)
@@ -619,7 +619,7 @@ struct ib_ah *ib_create_ah_from_wc(struct ib_pd *pd, const struct ib_wc *wc,
 	struct rdma_ah_attr ah_attr;
 	int ret;
 
-	ret = ib_init_ah_from_wc(pd->device, port_num, wc, grh, &ah_attr);
+	ret = ib_init_ah_attr_from_wc(pd->device, port_num, wc, grh, &ah_attr);
 	if (ret)
 		return ERR_PTR(ret);
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index cfd837049a32..60c3268c8c04 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -2904,7 +2904,7 @@ int ib_get_gids_from_rdma_hdr(const union rdma_network_hdr *hdr,
 int ib_get_rdma_header_version(const union rdma_network_hdr *hdr);
 
 /**
- * ib_init_ah_from_wc - Initializes address handle attributes from a
+ * ib_init_ah_attr_from_wc - Initializes address handle attributes from a
  *   work completion.
  * @device: Device on which the received message arrived.
  * @port_num: Port on which the received message arrived.
@@ -2914,9 +2914,9 @@ int ib_get_rdma_header_version(const union rdma_network_hdr *hdr);
  * @ah_attr: Returned attributes that can be used when creating an address
  *   handle for replying to the message.
  */
-int ib_init_ah_from_wc(struct ib_device *device, u8 port_num,
-		       const struct ib_wc *wc, const struct ib_grh *grh,
-		       struct rdma_ah_attr *ah_attr);
+int ib_init_ah_attr_from_wc(struct ib_device *device, u8 port_num,
+			    const struct ib_wc *wc, const struct ib_grh *grh,
+			    struct rdma_ah_attr *ah_attr);
 
 /**
  * ib_create_ah_from_wc - Creates an address handle associated with the
-- 
2.15.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
