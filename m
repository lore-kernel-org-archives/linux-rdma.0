From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 5/8] librdmacm: Specify QP type separately from port space
Date: Wed, 15 Jun 2011 17:44:13 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A82373021300@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

We need to know the QP type separately from the port space.  In
order to support XRC, UC, and other QP types, we use RDMA_PS_IB,
which no longer provides a 1:1 mapping between the port space
and QP type.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
The general framework for this is already in the code.  We just
need to clean up a couple of areas.

 include/rdma/rdma_cma.h |    1 +
 src/cma.c               |   23 +++++++++++++----------
 2 files changed, 14 insertions(+), 10 deletions(-)

diff --git a/include/rdma/rdma_cma.h b/include/rdma/rdma_cma.h
index 799a295..3b40060 100755
--- a/include/rdma/rdma_cma.h
+++ b/include/rdma/rdma_cma.h
@@ -127,6 +127,7 @@ struct rdma_cm_id {
 	struct ibv_cq		*recv_cq;
 	struct ibv_srq		*srq;
 	struct ibv_pd		*pd;
+	enum ibv_qp_type	qp_type;
 };
 
 enum {
diff --git a/src/cma.c b/src/cma.c
index e068125..eb339c9 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -410,7 +410,8 @@ static void ucma_free_id(struct cma_id_private *id_priv)
 
 static struct cma_id_private *ucma_alloc_id(struct rdma_event_channel *channel,
 					    void *context,
-					    enum rdma_port_space ps)
+					    enum rdma_port_space ps,
+					    enum ibv_qp_type qp_type)
 {
 	struct cma_id_private *id_priv;
 
@@ -420,6 +421,7 @@ static struct cma_id_private *ucma_alloc_id(struct rdma_event_channel *channel,
 
 	id_priv->id.context = context;
 	id_priv->id.ps = ps;
+	id_priv->id.qp_type = qp_type;
 
 	if (!channel) {
 		id_priv->id.channel = rdma_create_event_channel();
@@ -454,7 +456,7 @@ static int rdma_create_id2(struct rdma_event_channel *channel,
 	if (ret)
 		return ret;
 
-	id_priv = ucma_alloc_id(channel, context, ps);
+	id_priv = ucma_alloc_id(channel, context, ps, qp_type);
 	if (!id_priv)
 		return ERR(ENOMEM);
 
@@ -920,9 +922,9 @@ out:
 	return ucma_complete(id_priv);
 }
 
-static int ucma_is_ud_ps(enum rdma_port_space ps)
+static int ucma_is_ud_qp(enum ibv_qp_type qp_type)
 {
-	return (ps == RDMA_PS_UDP || ps == RDMA_PS_IPOIB);
+	return (qp_type == IBV_QPT_UD);
 }
 
 static int rdma_init_qp_attr(struct rdma_cm_id *id, struct ibv_qp_attr *qp_attr,
@@ -1249,7 +1251,7 @@ int rdma_create_qp(struct rdma_cm_id *id, struct ibv_pd *pd,
 		goto err1;
 	}
 
-	if (ucma_is_ud_ps(id->ps))
+	if (ucma_is_ud_qp(id->qp_type))
 		ret = ucma_init_ud_qp(id_priv, qp);
 	else
 		ret = ucma_init_conn_qp(id_priv, qp);
@@ -1472,7 +1474,7 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 		id_priv->responder_resources = conn_param->responder_resources;
 	}
 
-	if (!ucma_is_ud_ps(id->ps)) {
+	if (!ucma_is_ud_qp(id->qp_type)) {
 		ret = ucma_modify_qp_rtr(id, id_priv->responder_resources);
 		if (ret)
 			return ret;
@@ -1801,7 +1803,8 @@ static int ucma_process_conn_req(struct cma_event *evt,
 	int ret;
 
 	id_priv = ucma_alloc_id(evt->id_priv->id.channel,
-				evt->id_priv->id.context, evt->id_priv->id.ps);
+				evt->id_priv->id.context, evt->id_priv->id.ps,
+				evt->id_priv->id.qp_type);
 	if (!id_priv) {
 		ucma_destroy_kern_id(evt->id_priv->id.channel->fd, handle);
 		ret = ERR(ENOMEM);
@@ -1957,7 +1960,7 @@ retry:
 		break;
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
 		evt->id_priv = (void *) (uintptr_t) resp->uid;
-		if (ucma_is_ud_ps(evt->id_priv->id.ps))
+		if (ucma_is_ud_qp(evt->id_priv->id.qp_type))
 			ucma_copy_ud_event(evt, &resp->param.ud);
 		else
 			ucma_copy_conn_event(evt, &resp->param.conn);
@@ -1977,7 +1980,7 @@ retry:
 		}
 		break;
 	case RDMA_CM_EVENT_ESTABLISHED:
-		if (ucma_is_ud_ps(evt->id_priv->id.ps)) {
+		if (ucma_is_ud_qp(evt->id_priv->id.qp_type)) {
 			ucma_copy_ud_event(evt, &resp->param.ud);
 			break;
 		}
@@ -2019,7 +2022,7 @@ retry:
 		evt->id_priv = (void *) (uintptr_t) resp->uid;
 		evt->event.id = &evt->id_priv->id;
 		evt->event.status = resp->status;
-		if (ucma_is_ud_ps(evt->id_priv->id.ps))
+		if (ucma_is_ud_qp(evt->id_priv->id.qp_type))
 			ucma_copy_ud_event(evt, &resp->param.ud);
 		else
 			ucma_copy_conn_event(evt, &resp->param.conn);


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
