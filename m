From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: expand hints support to rdma_getaddrinfo
Date: Wed, 8 Sep 2010 11:13:06 -0700
Message-ID: <CF9C39F99A89134C9CF9C4CCB68B8DDF25AB4EA12D@orsmsx501.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: RDMA list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If a user passes in hints into rdma_getaddrinfo, they can
specify resolved source and destination addresses.  In this
case, there's no need for the user to specify the node or
service parameters.  This differs from getaddrinfo, which
indicates that either node or service must be provided, but
is useful if rdma_getaddrinfo is being used to obtain
routing data.

Supporting this option allows the librdmacm to call
rdma_getaddrinfo internally from rdma_resolve_route when IB ACM
is enabled.  IB ACM can return only routing data (i.e. a path
record) based on the source and destination IP addresses.

In addition to specifying the source and destination addresses
as part of the hints, a user could include partial routing data hints,
such as a desired SLID and/or DLID, and rdma_getaddrinfo can resolve the
full route.  This helps to support MPI applications that exchange endpoint
data, such as LIDs, out of band, but require SL data from the
SA to avoid potential deadlock conditions.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/acm.c      |   60 ++++++++++++++++++++------------------
 src/addrinfo.c |   89 ++++++++++++++++++++++++++++++++++++--------------------
 src/cma.c      |   30 ++++++++-----------
 src/cma.h      |    6 ++--
 4 files changed, 106 insertions(+), 79 deletions(-)

diff --git a/src/acm.c b/src/acm.c
index b2a952e..1867362 100644
--- a/src/acm.c
+++ b/src/acm.c
@@ -244,11 +244,22 @@ static void ucma_ib_save_resp(struct rdma_addrinfo *rai, struct acm_resolve_msg
 	}
 }
 
-void ucma_ib_resolve(struct rdma_addrinfo *rai)
+static void ucma_copy_rai_addr(struct acm_ep_addr_data *data, struct sockaddr *addr)
+{
+	if (addr->sa_family == AF_INET) {
+		data->type = ACM_EP_INFO_ADDRESS_IP;
+		memcpy(data->info.addr, &((struct sockaddr_in *) addr)->sin_addr, 4);
+	} else {
+		data->type = ACM_EP_INFO_ADDRESS_IP6;
+		memcpy(data->info.addr, &((struct sockaddr_in6 *) addr)->sin6_addr, 16);
+	}
+}
+
+void ucma_ib_resolve(struct rdma_addrinfo *rai, struct rdma_addrinfo *hints)
 {
 	struct acm_msg msg;
 	struct acm_resolve_msg *resolve_msg = (struct acm_resolve_msg *) &msg;
-	struct acm_ep_addr_data *src_data, *dst_data;
+	struct acm_ep_addr_data *data;
 	int ret;
 
 	if (sock <= 0)
@@ -257,37 +268,30 @@ void ucma_ib_resolve(struct rdma_addrinfo *rai)
 	memset(&msg, 0, sizeof msg);
 	msg.hdr.version = ACM_VERSION;
 	msg.hdr.opcode = ACM_OP_RESOLVE;
+	msg.hdr.length = ACM_MSG_HDR_LENGTH;
 
+	data = &resolve_msg->data[0];
 	if (rai->ai_src_len) {
-		src_data = &resolve_msg->data[0];
-		src_data->flags = ACM_EP_FLAG_SOURCE;
-		if (rai->ai_family == AF_INET) {
-			src_data->type = ACM_EP_INFO_ADDRESS_IP;
-			memcpy(src_data->info.addr,
-			       &((struct sockaddr_in *) rai->ai_src_addr)->sin_addr, 4);
-		} else {
-			src_data->type = ACM_EP_INFO_ADDRESS_IP6;
-			memcpy(src_data->info.addr,
-			       &((struct sockaddr_in6 *) rai->ai_src_addr)->sin6_addr, 16);
-		}
-		dst_data = &resolve_msg->data[1];
-		msg.hdr.length = ACM_MSG_HDR_LENGTH + (2 * ACM_MSG_EP_LENGTH);
-	} else {
-		dst_data = &resolve_msg->data[0];
-		msg.hdr.length = ACM_MSG_HDR_LENGTH + ACM_MSG_EP_LENGTH;
+		data->flags = ACM_EP_FLAG_SOURCE;
+		ucma_copy_rai_addr(data, rai->ai_src_addr);
+		data++;
+		msg.hdr.length += ACM_MSG_EP_LENGTH;
 	}
 
-	dst_data->flags = ACM_EP_FLAG_DEST;
-	if (rai->ai_family == AF_INET) {
-		dst_data->type = ACM_EP_INFO_ADDRESS_IP;
-		memcpy(dst_data->info.addr,
-		       &((struct sockaddr_in *) rai->ai_dst_addr)->sin_addr, 4);
-	} else {
-		dst_data->type = ACM_EP_INFO_ADDRESS_IP6;
-		memcpy(dst_data->info.addr,
-		       &((struct sockaddr_in6 *) rai->ai_dst_addr)->sin6_addr, 16);
+	if (rai->ai_dst_len) {
+		data->flags = ACM_EP_FLAG_DEST;
+		ucma_copy_rai_addr(data, rai->ai_dst_addr);
+		data++;
+		msg.hdr.length += ACM_MSG_EP_LENGTH;
 	}
-	
+
+	if (hints && hints->ai_route_len) {
+		data->type = ACM_EP_INFO_PATH;
+		memcpy(&data->info.path, hints->ai_route, hints->ai_route_len);
+		data++;
+		msg.hdr.length += ACM_MSG_EP_LENGTH;
+	}
+
 	pthread_mutex_lock(&acm_lock);
 	ret = send(sock, (char *) &msg, msg.hdr.length, 0);
 	if (ret != msg.hdr.length) {
diff --git a/src/addrinfo.c b/src/addrinfo.c
index 7c7056f..a1cb8a5 100755
--- a/src/addrinfo.c
+++ b/src/addrinfo.c
@@ -48,7 +48,7 @@
 static void ucma_convert_to_ai(struct addrinfo *ai, struct rdma_addrinfo *rai)
 {
 	memset(ai, 0, sizeof *ai);
-	ai->ai_flags = rai->ai_flags;
+	ai->ai_flags = (rai->ai_flags & RAI_PASSIVE) ? AI_PASSIVE : 0;
 	ai->ai_family = rai->ai_family;
 
 	switch (rai->ai_qp_type) {
@@ -86,8 +86,6 @@ static int ucma_convert_to_rai(struct rdma_addrinfo *rai, struct addrinfo *ai)
 	struct sockaddr *addr;
 	char *canonname;
 
-	memset(rai, 0, sizeof *rai);
-	rai->ai_flags = ai->ai_flags;
 	rai->ai_family = ai->ai_family;
 
 	switch (ai->ai_socktype) {
@@ -130,21 +128,17 @@ static int ucma_convert_to_rai(struct rdma_addrinfo *rai, struct addrinfo *ai)
 	return 0;
 }
 
-int rdma_getaddrinfo(char *node, char *service,
-		     struct rdma_addrinfo *hints,
-		     struct rdma_addrinfo **res)
+static int ucma_convert_gai(char *node, char *service,
+			    struct rdma_addrinfo *hints,
+			    struct rdma_addrinfo *rai)
 {
-	struct rdma_addrinfo *rai;
 	struct addrinfo ai_hints;
 	struct addrinfo *ai, *aih;
 	int ret;
 
-	ret = ucma_init();
-	if (ret)
-		return ret;
-
 	if (hints) {
 		ucma_convert_to_ai(&ai_hints, hints);
+		rai->ai_flags = hints->ai_flags;
 		aih = &ai_hints;
 	} else {
 		aih = NULL;
@@ -154,38 +148,71 @@ int rdma_getaddrinfo(char *node, char *service,
 	if (ret)
 		return ret;
 
-	rai = malloc(sizeof(*rai));
-	if (!rai) {
-		ret = ERR(ENOMEM);
-		goto err1;
-	}
-
 	ret = ucma_convert_to_rai(rai, ai);
+	freeaddrinfo(ai);
+	return ret;
+}
+
+static int ucma_copy_ai_addr(struct sockaddr **dst, socklen_t *dst_len,
+			     struct sockaddr *src, socklen_t src_len)
+{
+	*dst = calloc(1, src_len);
+	if (!(*dst))
+		return ERR(ENOMEM);
+
+	memcpy(*dst, src, src_len);
+	*dst_len = src_len;
+	return 0;
+}
+
+int rdma_getaddrinfo(char *node, char *service,
+		     struct rdma_addrinfo *hints,
+		     struct rdma_addrinfo **res)
+{
+	struct rdma_addrinfo *rai;
+	int ret;
+
+	if (!service && !node && !hints)
+		return ERR(EINVAL);
+
+	ret = ucma_init();
+	if (ret)
+		return ret;
+
+	rai = calloc(1, sizeof(*rai));
+	if (!rai)
+		return ERR(ENOMEM);
+
+	if (node || service) {
+		ret = ucma_convert_gai(node, service, hints, rai);
+	} else {
+		rai->ai_flags = hints->ai_flags;
+		rai->ai_family = hints->ai_family;
+		rai->ai_qp_type = hints->ai_qp_type;
+		rai->ai_port_space = hints->ai_port_space;
+		if (hints->ai_dst_len) {
+			ret = ucma_copy_ai_addr(&rai->ai_dst_addr, &rai->ai_dst_len,
+						hints->ai_dst_addr, hints->ai_dst_len);
+		}
+	}
 	if (ret)
-		goto err2;
+		goto err;
 
 	if (!rai->ai_src_len && hints && hints->ai_src_len) {
-		rai->ai_src_addr = calloc(1, hints->ai_src_len);
-		if (!rai->ai_src_addr) {
-			ret = ERR(ENOMEM);
-			goto err2;
-		}
-		memcpy(rai->ai_src_addr, hints->ai_src_addr,
-		       hints->ai_src_len);
-		rai->ai_src_len = hints->ai_src_len;
+		ret = ucma_copy_ai_addr(&rai->ai_src_addr, &rai->ai_src_len,
+					hints->ai_src_addr, hints->ai_src_len);
+		if (ret)
+			goto err;
 	}
 
 	if (!(rai->ai_flags & RAI_PASSIVE))
-		ucma_ib_resolve(rai);
+		ucma_ib_resolve(rai, hints);
 
-	freeaddrinfo(ai);
 	*res = rai;
 	return 0;
 
-err2:
+err:
 	rdma_freeaddrinfo(rai);
-err1:
-	freeaddrinfo(ai);
 	return ret;
 }
 
diff --git a/src/cma.c b/src/cma.c
index a4fd574..f7568cf 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -867,28 +867,24 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 
 static int ucma_set_ib_route(struct rdma_cm_id *id)
 {
-	struct rdma_addrinfo rai;
-	struct sockaddr_in6 src, dst;
+	struct rdma_addrinfo hint, *rai;
 	int ret;
 
-	memset(&rai, 0, sizeof rai);
-	rai.ai_flags = RAI_ROUTEONLY;
-	rai.ai_family = id->route.addr.src_addr.sa_family;
-	rai.ai_src_len = ucma_addrlen((struct sockaddr *) &id->route.addr.src_addr);
-	rai.ai_dst_len = ucma_addrlen((struct sockaddr *) &id->route.addr.dst_addr);
+	memset(&hint, 0, sizeof hint);
+	hint.ai_flags = RAI_ROUTEONLY;
+	hint.ai_family = id->route.addr.src_addr.sa_family;
+	hint.ai_src_len = ucma_addrlen((struct sockaddr *) &id->route.addr.src_addr);
+	hint.ai_src_addr = &id->route.addr.src_addr;
+	hint.ai_dst_len = ucma_addrlen((struct sockaddr *) &id->route.addr.dst_addr);
+	hint.ai_dst_addr = &id->route.addr.dst_addr;
 
-	memcpy(&src, &id->route.addr.src_addr, rai.ai_src_len);
-	memcpy(&dst, &id->route.addr.dst_addr, rai.ai_dst_len);
-	rai.ai_src_addr = (struct sockaddr *) &src;
-	rai.ai_dst_addr = (struct sockaddr *) &dst;
-
-	ucma_ib_resolve(&rai);
-	if (!rai.ai_route_len)
-		return ERR(ENODATA);
+	ret = rdma_getaddrinfo(NULL, NULL, &hint, &rai);
+	if (ret)
+		return ret;
 
 	ret = rdma_set_option(id, RDMA_OPTION_IB, RDMA_OPTION_IB_PATH,
-			      rai.ai_route, rai.ai_route_len);
-	free(rai.ai_route);
+			      rai->ai_route, rai->ai_route_len);
+	rdma_freeaddrinfo(rai);
 	return ret;
 }
 
diff --git a/src/cma.h b/src/cma.h
index d88c6b1..c6639b0 100644
--- a/src/cma.h
+++ b/src/cma.h
@@ -77,16 +77,16 @@ static inline int ERR(int err)
 int ucma_init();
 extern int af_ib_support;
 
-#define RAI_ROUTEONLY 0x01000000
+#define RAI_ROUTEONLY		0x01000000
 
 #ifdef USE_IB_ACM
 void ucma_ib_init();
 void ucma_ib_cleanup();
-void ucma_ib_resolve(struct rdma_addrinfo *rai);
+void ucma_ib_resolve(struct rdma_addrinfo *rai, struct rdma_addrinfo *hints);
 #else
 #define ucma_ib_init()
 #define ucma_ib_cleanup()
-#define ucma_ib_resolve(x)
+#define ucma_ib_resolve(x, y)
 #endif
 
 /* Define path record definition if using older version of libibverbs */


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
