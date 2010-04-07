From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 30/37] librdmacm: format IB CM private data RDMA CM header
Date: Wed, 7 Apr 2010 10:12:43 -0700
Message-ID: <6AB026B9815D4D63B96BABD21736311E@amr.corp.intel.com>
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

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 src/acm.c |   59 ++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 src/cma.c |   32 +++++++++++++++++++++++++++++---
 2 files changed, 81 insertions(+), 10 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 5dd8899..8975b97 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -51,6 +51,18 @@ static pthread_mutex_t acm_lock = PTHREAD_MUTEX_INITIALIZER;
 static int sock;
 static short server_port = 6125;
 
+struct ib_connect_hdr {
+	uint8_t  cma_version;
+	uint8_t  ip_version; /* IP version: 7:4 */
+	uint16_t port;
+	uint32_t src_addr[4];
+	uint32_t dst_addr[4];
+#define cma_src_ip4 src_addr[3]
+#define cma_src_ip6 src_addr[0]
+#define cma_dst_ip4 dst_addr[3]
+#define cma_dst_ip6 dst_addr[0]
+};
+
 void ucma_ib_init(void)
 {
 	struct sockaddr_in addr;
@@ -100,22 +112,22 @@ static void ucma_set_sid(enum rdma_port_space ps, struct sockaddr *addr,
 		sib->sib_sid_mask = htonll(RDMA_IB_IP_PS_MASK);
 }
 
-static void ucma_ib_convert_addr(struct rdma_addrinfo *rai,
-				 struct ib_path_record *path)
+static int ucma_ib_convert_addr(struct rdma_addrinfo *rai,
+				struct ib_path_record *path)
 {
 	struct sockaddr_ib *src, *dst;
 
 	if (!path)
-		return;
+		return ERR(ENODATA);
 
 	src = zalloc(sizeof *src);
 	if (!src)
-		return;
+		return ERR(ENOMEM);
 
 	dst = zalloc(sizeof *dst);
 	if (!dst) {
 		free(src);
-		return;
+		return ERR(ENOMEM);
 	}
 
 	src->sib_family = AF_IB;
@@ -140,6 +152,33 @@ static void ucma_ib_convert_addr(struct rdma_addrinfo *rai,
 
 	rai->ai_family = AF_IB;
 	rai->ai_port_space = RDMA_PS_IB;
+	return 0;
+}
+				 
+static void ucma_ib_format_connect(struct rdma_addrinfo *rai)
+{
+	struct ib_connect_hdr *hdr;
+
+	hdr = zalloc(sizeof *hdr);
+	if (!hdr)
+		return;
+
+	if (rai->ai_family == AF_INET) {
+		hdr->ip_version = 4 << 4;
+		memcpy(&hdr->cma_src_ip4,
+		       &((struct sockaddr_in *) rai->ai_src_addr)->sin_addr, 4);
+		memcpy(&hdr->cma_dst_ip4,
+		       &((struct sockaddr_in *) rai->ai_dst_addr)->sin_addr, 4);
+	} else {
+		hdr->ip_version = 6 << 4;
+		memcpy(&hdr->cma_src_ip6,
+		       &((struct sockaddr_in6 *) rai->ai_src_addr)->sin6_addr, 16);
+		memcpy(&hdr->cma_dst_ip6,
+		       &((struct sockaddr_in6 *) rai->ai_dst_addr)->sin6_addr, 16);
+	}
+
+	rai->ai_connect = hdr;
+	rai->ai_connect_len = sizeof(*hdr);
 }
 
 static void ucma_ib_save_resp(struct rdma_addrinfo *rai, struct acm_resolve_msg *msg)
@@ -166,8 +205,14 @@ static void ucma_ib_save_resp(struct rdma_addrinfo *rai, struct acm_resolve_msg
 
 	rai->ai_route = path_data;
 	rai->ai_route_len = len;
-	if (af_ib_support)
-		ucma_ib_convert_addr(rai, pri_path);
+	if (af_ib_support) {
+		ucma_ib_format_connect(rai);
+		if (ucma_ib_convert_addr(rai, pri_path) &&
+		    rai->ai_connect) {
+			free(rai->ai_connect);
+			rai->ai_connect_len = 0;
+		}
+	}
 	return;
 err:
 	free(path_data);
diff --git a/src/cma.c b/src/cma.c
index 6ac949a..faf4264 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -106,6 +106,8 @@ struct cma_device {
 struct cma_id_private {
 	struct rdma_cm_id	id;
 	struct cma_device	*cma_dev;
+	void			*connect;
+	size_t			connect_len;
 	int			events_completed;
 	int			connect_error;
 	int			sync;
@@ -363,6 +365,8 @@ static void ucma_free_id(struct cma_id_private *id_priv)
 
 	if (id_priv->sync)
 		rdma_destroy_event_channel(id_priv->id.channel);
+	if (id_priv->connect)
+		free(id_priv->connect);
 	free(id_priv);
 }
 
@@ -1186,15 +1190,20 @@ static void ucma_copy_conn_param_to_kern(struct cma_id_private *id_priv,
 	dst->initiator_depth = id_priv->initiator_depth;
 	dst->valid = 1;
 
+	if (id_priv->connect_len) {
+		memcpy(dst->private_data, id_priv->connect, id_priv->connect_len);
+		dst->private_data_len = id_priv->connect_len;
+	}
+
 	if (src) {
 		dst->flow_control = src->flow_control;
 		dst->retry_count = src->retry_count;
 		dst->rnr_retry_count = src->rnr_retry_count;
 
 		if (src->private_data && src->private_data_len) {
-			memcpy(dst->private_data, src->private_data,
-			       src->private_data_len);
-			dst->private_data_len = src->private_data_len;
+			memcpy(dst->private_data + dst->private_data_len,
+			       src->private_data, src->private_data_len);
+			dst->private_data_len += src->private_data_len;
 		}
 	} else {
 		dst->retry_count = 7;
@@ -1238,6 +1247,11 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	if (ret != size)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
+	if (id_priv->connect) {
+		free(id_priv->connect);
+		id_priv->connect_len = 0;
+	}
+
 	return ucma_complete(id_priv);
 }
 
@@ -2038,6 +2052,7 @@ int rdma_create_ep(struct rdma_cm_id **id, struct rdma_addrinfo *res,
 		   struct ibv_pd *pd, struct ibv_qp_init_attr *qp_init_attr)
 {
 	struct rdma_cm_id *cm_id;
+	struct cma_id_private *id_priv;
 	int ret;
 
 	ret = rdma_create_id2(NULL, &cm_id, NULL, res->ai_port_space, res->ai_qp_type);
@@ -2075,6 +2090,17 @@ int rdma_create_ep(struct rdma_cm_id **id, struct rdma_addrinfo *res,
 	if (ret)
 		goto err;
 
+	if (res->ai_connect_len) {
+		id_priv = container_of(cm_id, struct cma_id_private, id);
+		id_priv->connect = malloc(res->ai_connect_len);
+		if (!id_priv->connect) {
+			ret = ERR(ENOMEM);
+			goto err;
+		}
+		memcpy(id_priv->connect, res->ai_connect, res->ai_connect_len);
+		id_priv->connect_len = res->ai_connect_len;
+	}
+
 out:
 	*id = cm_id;
 	return 0;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
