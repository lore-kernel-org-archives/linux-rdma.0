From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 24/37] librdmacm: add support for passive side in rdma_create_ep
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <46E2BE50F33B455F90FC5A141AF1A590@amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
References: 
In-Reply-To: 
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Allow calling rdma_create_ep for a listening rdma_cm_id.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 src/cma.c |   69 ++++++++++++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 57 insertions(+), 12 deletions(-)

diff --git a/src/cma.c b/src/cma.c
index 3b80542..c59f47b 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -104,17 +104,19 @@ struct cma_device {
 };
 
 struct cma_id_private {
-	struct rdma_cm_id id;
-	struct cma_device *cma_dev;
-	int		  events_completed;
-	int		  connect_error;
-	int		  sync;
-	pthread_cond_t	  cond;
-	pthread_mutex_t	  mut;
-	uint32_t	  handle;
-	struct cma_multicast *mc_list;
-	uint8_t		  initiator_depth;
-	uint8_t		  responder_resources;
+	struct rdma_cm_id	id;
+	struct cma_device	*cma_dev;
+	int			events_completed;
+	int			connect_error;
+	int			sync;
+	pthread_cond_t		cond;
+	pthread_mutex_t		mut;
+	uint32_t		handle;
+	struct cma_multicast	*mc_list;
+	struct ibv_pd		*pd;
+	struct ibv_qp_init_attr	*qp_init_attr;
+	uint8_t			initiator_depth;
+	uint8_t			responder_resources;
 };
 
 struct cma_multicast {
@@ -1993,6 +1995,34 @@ int rdma_migrate_id(struct rdma_cm_id *id, struct rdma_event_channel *channel)
 	return 0;
 }
 
+static int ucma_passive_ep(struct rdma_cm_id *id, struct rdma_addrinfo *res,
+			   struct ibv_pd *pd, struct ibv_qp_init_attr *qp_init_attr)
+{
+	struct cma_id_private *id_priv;
+	int ret;
+
+	if (af_ib_support)
+		ret = rdma_bind_addr2(id, res->ai_src_addr, res->ai_src_len);
+	else
+		ret = rdma_bind_addr(id, res->ai_src_addr);
+	if (ret)
+		return ret;
+
+	id_priv = container_of(id, struct cma_id_private, id);
+	id_priv->pd = pd;
+
+	if (qp_init_attr) {
+		id_priv->qp_init_attr = malloc(sizeof *qp_init_attr);
+		if (!id_priv->qp_init_attr)
+			return ERR(ENOMEM);
+
+		*id_priv->qp_init_attr = *qp_init_attr;
+		id_priv->qp_init_attr->qp_type = res->ai_qp_type;
+	}
+
+	return 0;
+}
+
 int rdma_create_ep(struct rdma_cm_id **id, struct rdma_addrinfo *res,
 		   struct ibv_pd *pd, struct ibv_qp_init_attr *qp_init_attr)
 {
@@ -2003,6 +2033,13 @@ int rdma_create_ep(struct rdma_cm_id **id, struct rdma_addrinfo *res,
 	if (ret)
 		return ret;
 
+	if (res->ai_flags & RAI_PASSIVE) {
+		ret = ucma_passive_ep(cm_id, res, pd, qp_init_attr);
+		if (ret)
+			goto err;
+		goto out;
+	}
+
 	if (af_ib_support)
 		ret = rdma_resolve_addr2(cm_id, res->ai_src_addr, res->ai_src_len,
 					 res->ai_dst_addr, res->ai_dst_len, 2000);
@@ -2027,17 +2064,25 @@ int rdma_create_ep(struct rdma_cm_id **id, struct rdma_addrinfo *res,
 	if (ret)
 		goto err;
 
+out:
 	*id = cm_id;
 	return 0;
 
 err:
-	rdma_destroy_id(cm_id);
+	rdma_destroy_ep(cm_id);
 	return ret;
 }
 
 void rdma_destroy_ep(struct rdma_cm_id *id)
 {
+	struct cma_id_private *id_priv;
+
 	if (id->qp)
 		rdma_destroy_qp(id);
+
+	id_priv = container_of(id, struct cma_id_private, id);
+	if (id_priv->qp_init_attr)
+		free(id_priv->qp_init_attr);
+
 	rdma_destroy_id(id);
 }



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
