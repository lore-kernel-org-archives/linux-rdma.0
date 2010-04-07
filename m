From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 7/37] librdmacm: add support to bind using AF_IB
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <452D818161DB4FBF80A4062ED61D6188@amr.corp.intel.com>
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

Allow rdma_bind_addr to accept AF_IB addresses.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma_abi.h |   10 +++++++++-
 src/cma.c                   |   25 +++++++++++++++++++++++++
 2 files changed, 34 insertions(+), 1 deletions(-)

diff --git a/include/rdma/rdma_cma_abi.h b/include/rdma/rdma_cma_abi.h
index 0ef9564..8add397 100644
--- a/include/rdma/rdma_cma_abi.h
+++ b/include/rdma/rdma_cma_abi.h
@@ -66,7 +66,8 @@ enum {
  	UCMA_CMD_JOIN_IP_MCAST,
  	UCMA_CMD_LEAVE_MCAST,
 	UCMA_CMD_MIGRATE_ID,
-	UCMA_CMD_QUERY
+	UCMA_CMD_QUERY,
+	UCMA_CMD_BIND
 };
 
 struct ucma_abi_cmd_hdr {
@@ -102,6 +103,13 @@ struct ucma_abi_bind_ip {
 	__u32 id;
 };
 
+struct ucma_abi_bind {
+	__u32 id;
+	__u16 addr_size;
+	__u16 reserved;
+	struct sockaddr_storage addr;
+};
+
 struct ucma_abi_resolve_ip {
 	struct sockaddr_in6 src_addr;
 	struct sockaddr_in6 dst_addr;
diff --git a/src/cma.c b/src/cma.c
index e85ef2d..be61333 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -673,6 +673,28 @@ static int ucma_query_route(struct rdma_cm_id *id)
 	return 0;
 }
 
+static int rdma_bind_addr2(struct rdma_cm_id *id, struct sockaddr *addr,
+			   socklen_t addrlen)
+{
+	struct ucma_abi_bind *cmd;
+	struct cma_id_private *id_priv;
+	void *msg;
+	int ret, size;
+	
+	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_BIND, size);
+	id_priv = container_of(id, struct cma_id_private, id);
+	cmd->id = id_priv->handle;
+	cmd->addr_size = addrlen;
+	cmd->reserved = 0;
+	memcpy(&cmd->addr, addr, addrlen);
+
+	ret = write(id->channel->fd, msg, size);
+	if (ret != size)
+		return (ret >= 0) ? ERR(ENODATA) : -1;
+
+	return ucma_query_addr(id);
+}
+
 int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 {
 	struct ucma_abi_bind_ip *cmd;
@@ -684,6 +706,9 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	if (!addrlen)
 		return ERR(EINVAL);
 
+	if (af_ib_support)
+		return rdma_bind_addr2(id, addr, addrlen);
+
 	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_BIND_IP, size);
 	id_priv = container_of(id, struct cma_id_private, id);
 	cmd->id = id_priv->handle;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
