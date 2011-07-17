From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] rdma_cm: avoid assigning an IS_ERR value to cm id pointer in CMA id object
Date: Sun, 17 Jul 2011 13:46:47 +0300
Message-ID: <201107171346.48065.jackm@dev.mellanox.co.il>
References: <201107141058.29879.jackm@dev.mellanox.co.il> <1828884A29C6694DAF28B7E6B8A8237302E14C@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1828884A29C6694DAF28B7E6B8A8237302E14C-P5GAC/sN6hmkrb+BlOpmy7fspsVTdybXVpNB7YpNyf8@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, "dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org" <dotanb-VPRAkNaXOzVS1MOuV/RT9w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Avoid assigning an IS_ERR value to the cm id pointer in the cma_id object.
This fixes a few anomalies in the error flow, and eliminates the need to
test for the IS_ERR value every time we wish to determine if the cma_id object
has a cm device associated with it.

Also, eliminate the now-unnecessary procedure cma_has_cm_dev (we can check directly
for the existence of the device pointer -- for a non-NULL check, makes no difference
if it is the iwarp or the ib pointer).

Finally, I suggest a few code changes here to improve coding consistency.

Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

---
Sean,
Here is the patch I said I would submit to you.
I got rid of the cma_has_cm_dev() procedure, but if you think that it should be kept,
but simply do the ib-pointer check only (to keep ib out of the rdma level), that is OK with me.

Jack

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index b6a33b3..85ce489 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -406,11 +406,6 @@ static int cma_disable_callback(struct rdma_id_private *id_priv,
 	return 0;
 }
 
-static int cma_has_cm_dev(struct rdma_id_private *id_priv)
-{
-	return (id_priv->id.device && id_priv->cm_id.ib);
-}
-
 struct rdma_cm_id *rdma_create_id(rdma_cm_event_handler event_handler,
 				  void *context, enum rdma_port_space ps,
 				  enum ib_qp_type qp_type)
@@ -920,11 +915,11 @@ void rdma_destroy_id(struct rdma_cm_id *id)
 	if (id_priv->cma_dev) {
 		switch (rdma_node_get_transport(id_priv->id.device->node_type)) {
 		case RDMA_TRANSPORT_IB:
-			if (id_priv->cm_id.ib && !IS_ERR(id_priv->cm_id.ib))
+			if (id_priv->cm_id.ib)
 				ib_destroy_cm_id(id_priv->cm_id.ib);
 			break;
 		case RDMA_TRANSPORT_IWARP:
-			if (id_priv->cm_id.iw && !IS_ERR(id_priv->cm_id.iw))
+			if (id_priv->cm_id.iw)
 				iw_destroy_cm_id(id_priv->cm_id.iw);
 			break;
 		default:
@@ -1085,12 +1080,12 @@ static struct rdma_id_private *cma_new_conn_id(struct rdma_cm_id *listen_id,
 
 	if (cma_get_net_info(ib_event->private_data, listen_id->ps,
 			     &ip_ver, &port, &src, &dst))
-		goto err;
+		return NULL;
 
 	id = rdma_create_id(listen_id->event_handler, listen_id->context,
 			    listen_id->ps, ib_event->param.req_rcvd.qp_type);
 	if (IS_ERR(id))
-		goto err;
+		return NULL;
 
 	cma_save_net_info(&id->route.addr, &listen_id->route.addr,
 			  ip_ver, port, src, dst);
@@ -1100,7 +1095,7 @@ static struct rdma_id_private *cma_new_conn_id(struct rdma_cm_id *listen_id,
 	rt->path_rec = kmalloc(sizeof *rt->path_rec * rt->num_paths,
 			       GFP_KERNEL);
 	if (!rt->path_rec)
-		goto destroy_id;
+		goto err;
 
 	rt->path_rec[0] = *ib_event->param.req_rcvd.primary_path;
 	if (rt->num_paths == 2)
@@ -1114,7 +1109,7 @@ static struct rdma_id_private *cma_new_conn_id(struct rdma_cm_id *listen_id,
 		ret = rdma_translate_ip((struct sockaddr *) &rt->addr.src_addr,
 					&rt->addr.dev_addr);
 		if (ret)
-			goto destroy_id;
+			goto err;
 	}
 	rdma_addr_set_dgid(&rt->addr.dev_addr, &rt->path_rec[0].dgid);
 
@@ -1122,9 +1117,8 @@ static struct rdma_id_private *cma_new_conn_id(struct rdma_cm_id *listen_id,
 	id_priv->state = RDMA_CM_CONNECT;
 	return id_priv;
 
-destroy_id:
-	rdma_destroy_id(id);
 err:
+	rdma_destroy_id(id);
 	return NULL;
 }
 
@@ -1468,13 +1462,15 @@ static int cma_ib_listen(struct rdma_id_private *id_priv)
 {
 	struct ib_cm_compare_data compare_data;
 	struct sockaddr *addr;
+	struct ib_cm_id	*id;
 	__be64 svc_id;
 	int ret;
 
-	id_priv->cm_id.ib = ib_create_cm_id(id_priv->id.device, cma_req_handler,
-					    id_priv);
-	if (IS_ERR(id_priv->cm_id.ib))
-		return PTR_ERR(id_priv->cm_id.ib);
+	id = ib_create_cm_id(id_priv->id.device, cma_req_handler, id_priv);
+	if (IS_ERR(id))
+		return PTR_ERR(id);
+
+	id_priv->cm_id.ib = id;
 
 	addr = (struct sockaddr *) &id_priv->id.route.addr.src_addr;
 	svc_id = cma_get_service_id(id_priv->id.ps, addr);
@@ -1497,12 +1493,15 @@ static int cma_iw_listen(struct rdma_id_private *id_priv, int backlog)
 {
 	int ret;
 	struct sockaddr_in *sin;
+	struct iw_cm_id	*id;
 
-	id_priv->cm_id.iw = iw_create_cm_id(id_priv->id.device,
-					    iw_conn_req_handler,
-					    id_priv);
-	if (IS_ERR(id_priv->cm_id.iw))
-		return PTR_ERR(id_priv->cm_id.iw);
+	id = iw_create_cm_id(id_priv->id.device,
+			     iw_conn_req_handler,
+			     id_priv);
+	if (IS_ERR(id))
+		return PTR_ERR(id);
+
+	id_priv->cm_id.iw = id;
 
 	sin = (struct sockaddr_in *) &id_priv->id.route.addr.src_addr;
 	id_priv->cm_id.iw->local_addr = *sin;
@@ -2484,6 +2483,7 @@ static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
 {
 	struct ib_cm_sidr_req_param req;
 	struct rdma_route *route;
+	struct ib_cm_id	*id;
 	int ret;
 
 	req.private_data_len = sizeof(struct cma_hdr) +
@@ -2501,12 +2501,13 @@ static int cma_resolve_ib_udp(struct rdma_id_private *id_priv,
 	if (ret)
 		goto out;
 
-	id_priv->cm_id.ib = ib_create_cm_id(id_priv->id.device,
-					    cma_sidr_rep_handler, id_priv);
-	if (IS_ERR(id_priv->cm_id.ib)) {
-		ret = PTR_ERR(id_priv->cm_id.ib);
+	id = ib_create_cm_id(id_priv->id.device, cma_sidr_rep_handler,
+			     id_priv);
+	if (IS_ERR(id)) {
+		ret = PTR_ERR(id);
 		goto out;
 	}
+	id_priv->cm_id.ib = id;
 
 	req.path = route->path_rec;
 	req.service_id = cma_get_service_id(id_priv->id.ps,
@@ -2530,6 +2531,7 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 	struct ib_cm_req_param req;
 	struct rdma_route *route;
 	void *private_data;
+	struct ib_cm_id	*id;
 	int offset, ret;
 
 	memset(&req, 0, sizeof req);
@@ -2543,12 +2545,12 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 		memcpy(private_data + offset, conn_param->private_data,
 		       conn_param->private_data_len);
 
-	id_priv->cm_id.ib = ib_create_cm_id(id_priv->id.device, cma_ib_handler,
-					    id_priv);
-	if (IS_ERR(id_priv->cm_id.ib)) {
-		ret = PTR_ERR(id_priv->cm_id.ib);
+	id = ib_create_cm_id(id_priv->id.device, cma_ib_handler, id_priv);
+	if (IS_ERR(id)) {
+		ret = PTR_ERR(id);
 		goto out;
 	}
+	id_priv->cm_id.ib = id;
 
 	route = &id_priv->id.route;
 	ret = cma_format_hdr(private_data, id_priv->id.ps, route);
@@ -2577,7 +2579,7 @@ static int cma_connect_ib(struct rdma_id_private *id_priv,
 
 	ret = ib_send_cm_req(id_priv->cm_id.ib, &req);
 out:
-	if (ret && !IS_ERR(id_priv->cm_id.ib)) {
+	if (ret && !IS_ERR(id)) {
 		ib_destroy_cm_id(id_priv->cm_id.ib);
 		id_priv->cm_id.ib = NULL;
 	}
@@ -2595,10 +2597,8 @@ static int cma_connect_iw(struct rdma_id_private *id_priv,
 	struct iw_cm_conn_param iw_param;
 
 	cm_id = iw_create_cm_id(id_priv->id.device, cma_iw_handler, id_priv);
-	if (IS_ERR(cm_id)) {
-		ret = PTR_ERR(cm_id);
-		goto out;
-	}
+	if (IS_ERR(cm_id))
+		return PTR_ERR(cm_id);
 
 	id_priv->cm_id.iw = cm_id;
 
@@ -2622,7 +2622,7 @@ static int cma_connect_iw(struct rdma_id_private *id_priv,
 		iw_param.qpn = conn_param->qp_num;
 	ret = iw_cm_connect(cm_id, &iw_param);
 out:
-	if (ret && !IS_ERR(cm_id)) {
+	if (ret) {
 		iw_destroy_cm_id(cm_id);
 		id_priv->cm_id.iw = NULL;
 	}
@@ -2795,7 +2795,7 @@ int rdma_notify(struct rdma_cm_id *id, enum ib_event_type event)
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	if (!cma_has_cm_dev(id_priv))
+	if (!id_priv->cm_id.ib)
 		return -EINVAL;
 
 	switch (id->device->node_type) {
@@ -2817,7 +2817,7 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	if (!cma_has_cm_dev(id_priv))
+	if (!id_priv->cm_id.ib)
 		return -EINVAL;
 
 	switch (rdma_node_get_transport(id->device->node_type)) {
@@ -2848,7 +2848,7 @@ int rdma_disconnect(struct rdma_cm_id *id)
 	int ret;
 
 	id_priv = container_of(id, struct rdma_id_private, id);
-	if (!cma_has_cm_dev(id_priv))
+	if (!id_priv->cm_id.ib)
 		return -EINVAL;
 
 	switch (rdma_node_get_transport(id->device->node_type)) {
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
