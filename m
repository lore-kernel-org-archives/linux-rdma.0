From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 9/37] librdmacm: add support for PF_IB multicast addresses
Date: Wed, 7 Apr 2010 11:13:22 -0700
Message-ID: <B6A2B96D34FB4D6B8E8495487E11E2BA@amr.corp.intel.com>
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

Allow the user to specify PF_IB addresses when joining
multicast groups.  PF_IB addresses contain MGIDs directly.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma_abi.h |   12 +++++++++++-
 src/cma.c                   |   44 +++++++++++++++++++++++++++++++------------
 2 files changed, 43 insertions(+), 13 deletions(-)

diff --git a/include/rdma/rdma_cma_abi.h b/include/rdma/rdma_cma_abi.h
index 4a7a55d..c3981e6 100644
--- a/include/rdma/rdma_cma_abi.h
+++ b/include/rdma/rdma_cma_abi.h
@@ -68,7 +68,8 @@ enum {
 	UCMA_CMD_MIGRATE_ID,
 	UCMA_CMD_QUERY,
 	UCMA_CMD_BIND,
-	UCMA_CMD_RESOLVE_ADDR
+	UCMA_CMD_RESOLVE_ADDR,
+	UCMA_CMD_JOIN_MCAST
 };
 
 struct ucma_abi_cmd_hdr {
@@ -243,6 +244,15 @@ struct ucma_abi_join_ip_mcast {
 	__u32 id;
 };
 
+struct ucma_abi_join_mcast {
+	__u64 response;		/* rdma_ucma_create_id_resp */
+	__u64 uid;
+	__u32 id;
+	__u16 addr_size;
+	__u16 reserved;
+	struct sockaddr_storage addr;
+};
+
 struct ucma_abi_get_event {
 	__u64 response;
 };
diff --git a/src/cma.c b/src/cma.c
index e22e1b4..c83d9d2 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -1244,21 +1244,16 @@ int rdma_disconnect(struct rdma_cm_id *id)
 	return 0;
 }
 
-int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
-			void *context)
+static int rdma_join_multicast2(struct rdma_cm_id *id, struct sockaddr *addr,
+				socklen_t addrlen, void *context)
 {
-	struct ucma_abi_join_ip_mcast *cmd;
 	struct ucma_abi_create_id_resp *resp;
 	struct cma_id_private *id_priv;
 	struct cma_multicast *mc, **pos;
 	void *msg;
-	int ret, size, addrlen;
+	int ret, size;
 	
 	id_priv = container_of(id, struct cma_id_private, id);
-	addrlen = ucma_addrlen(addr);
-	if (!addrlen)
-		return ERR(EINVAL);
-
 	mc = malloc(sizeof *mc);
 	if (!mc)
 		return ERR(ENOMEM);
@@ -1277,10 +1272,23 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 	id_priv->mc_list = mc;
 	pthread_mutex_unlock(&id_priv->mut);
 
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_JOIN_IP_MCAST, size);
-	cmd->id = id_priv->handle;
-	memcpy(&cmd->addr, addr, addrlen);
-	cmd->uid = (uintptr_t) mc;
+	if (af_ib_support) {
+		struct ucma_abi_join_mcast *cmd;
+
+		CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_JOIN_MCAST, size);
+		cmd->id = id_priv->handle;
+		memcpy(&cmd->addr, addr, addrlen);
+		cmd->addr_size = addrlen;
+		cmd->uid = (uintptr_t) mc;
+		cmd->reserved = 0;
+	} else {
+		struct ucma_abi_join_ip_mcast *cmd;
+
+		CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_JOIN_IP_MCAST, size);
+		cmd->id = id_priv->handle;
+		memcpy(&cmd->addr, addr, addrlen);
+		cmd->uid = (uintptr_t) mc;
+	}
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size) {
@@ -1303,6 +1311,18 @@ err1:
 	return ret;
 }
 
+int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
+			void *context)
+{
+	int addrlen;
+	
+	addrlen = ucma_addrlen(addr);
+	if (!addrlen)
+		return ERR(EINVAL);
+
+	return rdma_join_multicast2(id, addr, addrlen, context);
+}
+
 int rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 {
 	struct ucma_abi_destroy_id *cmd;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
