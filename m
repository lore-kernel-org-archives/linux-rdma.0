From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 37/37] librdmacm: use IB ACM to resolve IB path
Date: Wed, 7 Apr 2010 10:12:43 -0700
Message-ID: <49283041F55F4D2C9A89060D59AB4107@amr.corp.intel.com>
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

Starting with 2.6.33, the kernel supports the ability to
manually specify the path record that a connection should
use.  Allow the librdmacm to contact the IB ACM to acquire
path record data, even if rdma_getaddrinfo is not used and
the kernel does not support AF_IB.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 src/acm.c |    2 +-
 src/cma.c |   37 +++++++++++++++++++++++++++++++++++--
 src/cma.h |    2 ++
 3 files changed, 38 insertions(+), 3 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index 8975b97..ca338bc 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -205,7 +205,7 @@ static void ucma_ib_save_resp(struct rdma_addrinfo *rai, struct acm_resolve_msg
 
 	rai->ai_route = path_data;
 	rai->ai_route_len = len;
-	if (af_ib_support) {
+	if (af_ib_support && !(rai->ai_flags & RAI_ROUTEONLY)) {
 		ucma_ib_format_connect(rai);
 		if (ucma_ib_convert_addr(rai, pri_path) &&
 		    rai->ai_connect) {
diff --git a/src/cma.c b/src/cma.c
index 66a7643..258a324 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -858,15 +858,47 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 	return ucma_complete(id_priv);
 }
 
+static int ucma_set_ib_route(struct rdma_cm_id *id)
+{
+	struct rdma_addrinfo rai;
+	struct sockaddr_in6 src, dst;
+	int size, ret;
+
+	memset(&rai, 0, sizeof rai);
+	rai.ai_flags = RAI_ROUTEONLY;
+	rai.ai_family = id->route.addr.src_addr.sa_family;
+	size = ucma_addrlen((struct sockaddr *) &id->route.addr.src_addr);
+
+	memcpy(&src, &id->route.addr.src_addr, size);
+	memcpy(&dst, &id->route.addr.dst_addr, size);
+	rai.ai_src_addr = (struct sockaddr *) &src;
+	rai.ai_dst_addr = (struct sockaddr *) &dst;
+
+	ucma_ib_resolve(&rai);
+	if (!rai.ai_route_len)
+		return ERR(ENODATA);
+
+	ret = rdma_set_option(id, RDMA_OPTION_IB, RDMA_OPTION_IB_PATH,
+			      rai.ai_route, rai.ai_route_len);
+	free(rai.ai_route);
+	return ret;
+}
+
 int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 {
 	struct ucma_abi_resolve_route *cmd;
 	struct cma_id_private *id_priv;
 	void *msg;
 	int ret, size;
-	
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_RESOLVE_ROUTE, size);
+
 	id_priv = container_of(id, struct cma_id_private, id);
+	if (id->verbs->device->transport_type == IBV_TRANSPORT_IB) {
+		ret = ucma_set_ib_route(id);
+		if (!ret)
+			goto out;
+	}
+
+	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_RESOLVE_ROUTE, size);
 	cmd->id = id_priv->handle;
 	cmd->timeout_ms = timeout_ms;
 
@@ -874,6 +906,7 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 	if (ret != size)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
+out:
 	return ucma_complete(id_priv);
 }
 
diff --git a/src/cma.h b/src/cma.h
index 1e0c571..d25cdea 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -87,6 +87,8 @@ static inline void *zalloc(size_t size)
 int ucma_init();
 extern int af_ib_support;
 
+#define RAI_ROUTEONLY 0x01000000
+
 #ifdef USE_IB_ACM
 void ucma_ib_init();
 void ucma_ib_cleanup();



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
