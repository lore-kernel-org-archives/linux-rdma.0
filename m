From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/37] librdmacm: name changes to indicate only IP addresses supported
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <EB6FC47F797745D3B31C33BE8C5D3250@amr.corp.intel.com>
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

Several commands to the kernel RDMA CM only support IP addresses
because of limitations in the structure definition.  Update
the library to match the name changes in the kernel and indicate
that only IP addresses can be used with the current commands.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma_abi.h |   12 ++++++------
 src/cma.c                   |   12 ++++++------
 2 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/include/rdma/rdma_cma_abi.h b/include/rdma/rdma_cma_abi.h
index 1a3a9c2..e51a372 100644
--- a/include/rdma/rdma_cma_abi.h
+++ b/include/rdma/rdma_cma_abi.h
@@ -48,8 +48,8 @@
 enum {
 	UCMA_CMD_CREATE_ID,
 	UCMA_CMD_DESTROY_ID,
-	UCMA_CMD_BIND_ADDR,
-	UCMA_CMD_RESOLVE_ADDR,
+	UCMA_CMD_BIND_IP,
+	UCMA_CMD_RESOLVE_IP,
 	UCMA_CMD_RESOLVE_ROUTE,
 	UCMA_CMD_QUERY_ROUTE,
 	UCMA_CMD_CONNECT,
@@ -62,7 +62,7 @@ enum {
 	UCMA_CMD_GET_OPTION,
 	UCMA_CMD_SET_OPTION,
 	UCMA_CMD_NOTIFY,
- 	UCMA_CMD_JOIN_MCAST,
+ 	UCMA_CMD_JOIN_IP_MCAST,
  	UCMA_CMD_LEAVE_MCAST,
 	UCMA_CMD_MIGRATE_ID
 };
@@ -94,13 +94,13 @@ struct ucma_abi_destroy_id_resp {
 	__u32 events_reported;
 };
 
-struct ucma_abi_bind_addr {
+struct ucma_abi_bind_ip {
 	__u64 response;
 	struct sockaddr_in6 addr;
 	__u32 id;
 };
 
-struct ucma_abi_resolve_addr {
+struct ucma_abi_resolve_ip {
 	struct sockaddr_in6 src_addr;
 	struct sockaddr_in6 dst_addr;
 	__u32 id;
@@ -192,7 +192,7 @@ struct ucma_abi_notify {
 	__u32 event;
 };
 
-struct ucma_abi_join_mcast {
+struct ucma_abi_join_ip_mcast {
 	__u64 response;		/* ucma_abi_create_id_resp */
 	__u64 uid;
 	struct sockaddr_in6 addr;
diff --git a/src/cma.c b/src/cma.c
index 59e89dd..b5f71d0 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -525,7 +525,7 @@ static int ucma_query_route(struct rdma_cm_id *id)
 
 int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 {
-	struct ucma_abi_bind_addr *cmd;
+	struct ucma_abi_bind_ip *cmd;
 	struct cma_id_private *id_priv;
 	void *msg;
 	int ret, size, addrlen;
@@ -534,7 +534,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	if (!addrlen)
 		return ERR(EINVAL);
 
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_BIND_ADDR, size);
+	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_BIND_IP, size);
 	id_priv = container_of(id, struct cma_id_private, id);
 	cmd->id = id_priv->handle;
 	memcpy(&cmd->addr, addr, addrlen);
@@ -549,7 +549,7 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 		      struct sockaddr *dst_addr, int timeout_ms)
 {
-	struct ucma_abi_resolve_addr *cmd;
+	struct ucma_abi_resolve_ip *cmd;
 	struct cma_id_private *id_priv;
 	void *msg;
 	int ret, size, daddrlen;
@@ -558,7 +558,7 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 	if (!daddrlen)
 		return ERR(EINVAL);
 
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_RESOLVE_ADDR, size);
+	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_RESOLVE_IP, size);
 	id_priv = container_of(id, struct cma_id_private, id);
 	cmd->id = id_priv->handle;
 	if (src_addr)
@@ -1037,7 +1037,7 @@ int rdma_disconnect(struct rdma_cm_id *id)
 int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 			void *context)
 {
-	struct ucma_abi_join_mcast *cmd;
+	struct ucma_abi_join_ip_mcast *cmd;
 	struct ucma_abi_create_id_resp *resp;
 	struct cma_id_private *id_priv;
 	struct cma_multicast *mc, **pos;
@@ -1067,7 +1067,7 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	id_priv->mc_list = mc;
 	pthread_mutex_unlock(&id_priv->mut);
 
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_JOIN_MCAST, size);
+	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_JOIN_IP_MCAST, size);
 	cmd->id = id_priv->handle;
 	memcpy(&cmd->addr, addr, addrlen);
 	cmd->uid = (uintptr_t) mc;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
