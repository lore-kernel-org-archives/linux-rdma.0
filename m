From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 8/37] librdmacm: add support for PF_IB to resolve_addr
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <F38E0E86C37C4653A24549B411B368E6@amr.corp.intel.com>
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

Allow user to specify PF_IB addresses to rdma_resolve_addr.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma_abi.h |   13 ++++++++++++-
 src/cma.c                   |   44 +++++++++++++++++++++++++++++++++++++------
 2 files changed, 50 insertions(+), 7 deletions(-)

diff --git a/include/rdma/rdma_cma_abi.h b/include/rdma/rdma_cma_abi.h
index 8add397..4a7a55d 100644
--- a/include/rdma/rdma_cma_abi.h
+++ b/include/rdma/rdma_cma_abi.h
@@ -67,7 +67,8 @@ enum {
  	UCMA_CMD_LEAVE_MCAST,
 	UCMA_CMD_MIGRATE_ID,
 	UCMA_CMD_QUERY,
-	UCMA_CMD_BIND
+	UCMA_CMD_BIND,
+	UCMA_CMD_RESOLVE_ADDR
 };
 
 struct ucma_abi_cmd_hdr {
@@ -117,6 +118,16 @@ struct ucma_abi_resolve_ip {
 	__u32 timeout_ms;
 };
 
+struct ucma_abi_resolve_addr {
+	__u32 id;
+	__u32 timeout_ms;
+	__u16 src_size;
+	__u16 dst_size;
+	__u32 reserved;
+	struct sockaddr_storage src_addr;
+	struct sockaddr_storage dst_addr;
+};
+
 struct ucma_abi_resolve_route {
 	__u32 id;
 	__u32 timeout_ms;
diff --git a/src/cma.c b/src/cma.c
index be61333..e22e1b4 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -721,31 +721,63 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	return ucma_query_route(id);
 }
 
+static int rdma_resolve_addr2(struct rdma_cm_id *id, struct sockaddr *src_addr,
+			      socklen_t src_len, struct sockaddr *dst_addr,
+			      socklen_t dst_len, int timeout_ms)
+{
+	struct ucma_abi_resolve_addr *cmd;
+	struct cma_id_private *id_priv;
+	void *msg;
+	int ret, size;
+	
+	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_RESOLVE_ADDR, size);
+	id_priv = container_of(id, struct cma_id_private, id);
+	cmd->id = id_priv->handle;
+	if ((cmd->src_size = src_len))
+		memcpy(&cmd->src_addr, src_addr, src_len);
+	memcpy(&cmd->dst_addr, dst_addr, dst_len);
+	cmd->dst_size = dst_len;
+	cmd->timeout_ms = timeout_ms;
+	cmd->reserved = 0;
+
+	ret = write(id->channel->fd, msg, size);
+	if (ret != size)
+		return (ret >= 0) ? ERR(ENODATA) : -1;
+
+	memcpy(&id->route.addr.dst_addr, dst_addr, dst_len);
+	return 0;
+}
+
 int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 		      struct sockaddr *dst_addr, int timeout_ms)
 {
 	struct ucma_abi_resolve_ip *cmd;
 	struct cma_id_private *id_priv;
 	void *msg;
-	int ret, size, daddrlen;
+	int ret, size, dst_len, src_len;
 	
-	daddrlen = ucma_addrlen(dst_addr);
-	if (!daddrlen)
+	dst_len = ucma_addrlen(dst_addr);
+	if (!dst_len)
 		return ERR(EINVAL);
 
+	src_len = ucma_addrlen(src_addr);
+	if (af_ib_support)
+		return rdma_resolve_addr2(id, src_addr, src_len, dst_addr,
+					  dst_len, timeout_ms);
+
 	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_RESOLVE_IP, size);
 	id_priv = container_of(id, struct cma_id_private, id);
 	cmd->id = id_priv->handle;
 	if (src_addr)
-		memcpy(&cmd->src_addr, src_addr, ucma_addrlen(src_addr));
-	memcpy(&cmd->dst_addr, dst_addr, daddrlen);
+		memcpy(&cmd->src_addr, src_addr, src_len);
+	memcpy(&cmd->dst_addr, dst_addr, dst_len);
 	cmd->timeout_ms = timeout_ms;
 
 	ret = write(id->channel->fd, msg, size);
 	if (ret != size)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
-	memcpy(&id->route.addr.dst_addr, dst_addr, daddrlen);
+	memcpy(&id->route.addr.dst_addr, dst_addr, dst_len);
 	return 0;
 }
 



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
