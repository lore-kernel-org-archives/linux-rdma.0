From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 2/37] librdmacm: support querying AF_IB addresses
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <26DB836F8DEA4127BC17E7C72C4800DE@amr.corp.intel.com>
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

The current query route command returns path record data and address
information.  The latter is restricted to sizeof(sockaddr_in6).  In
order to support AF_IB, modify the library to use the new query addr
command, which supports larger address sizes and avoids querying for
path records data when none are available.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma_abi.h |   22 +++++++++++++++++++---
 src/cma.c                   |   35 ++++++++++++++++++++++++++++++++++-
 2 files changed, 53 insertions(+), 4 deletions(-)

diff --git a/include/rdma/rdma_cma_abi.h b/include/rdma/rdma_cma_abi.h
index e51a372..5c736fb 100644
--- a/include/rdma/rdma_cma_abi.h
+++ b/include/rdma/rdma_cma_abi.h
@@ -64,7 +64,8 @@ enum {
 	UCMA_CMD_NOTIFY,
  	UCMA_CMD_JOIN_IP_MCAST,
  	UCMA_CMD_LEAVE_MCAST,
-	UCMA_CMD_MIGRATE_ID
+	UCMA_CMD_MIGRATE_ID,
+	UCMA_CMD_QUERY
 };
 
 struct ucma_abi_cmd_hdr {
@@ -112,10 +113,14 @@ struct ucma_abi_resolve_route {
 	__u32 timeout_ms;
 };
 
-struct ucma_abi_query_route {
+enum {
+	UCMA_QUERY_ADDR
+};
+
+struct ucma_abi_query {
 	__u64 response;
 	__u32 id;
-	__u32 reserved;
+	__u32 option;
 };
 
 struct ucma_abi_query_route_resp {
@@ -128,6 +133,17 @@ struct ucma_abi_query_route_resp {
 	__u8 reserved[3];
 };
 
+struct ucma_abi_query_addr_resp {
+	__u64 node_guid;
+	__u8  port_num;
+	__u8  reserved;
+	__u16 pkey;
+	__u16 src_size;
+	__u16 dst_size;
+	struct sockaddr_storage src_addr;
+	struct sockaddr_storage dst_addr;
+};
+
 struct ucma_abi_conn_param {
 	__u32 qp_num;
 	__u32 reserved;
diff --git a/src/cma.c b/src/cma.c
index b5f71d0..2aef594 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -473,10 +473,43 @@ static int ucma_addrlen(struct sockaddr *addr)
 	}
 }
 
+static int ucma_query_addr(struct rdma_cm_id *id)
+{
+	struct ucma_abi_query_addr_resp *resp;
+	struct ucma_abi_query *cmd;
+	struct cma_id_private *id_priv;
+	void *msg;
+	int ret, size;
+	
+	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_QUERY, size);
+	id_priv = container_of(id, struct cma_id_private, id);
+	cmd->id = id_priv->handle;
+	cmd->option = UCMA_QUERY_ADDR;
+
+	ret = write(id->channel->fd, msg, size);
+	if (ret != size)
+		return (ret >= 0) ? ERR(ENODATA) : -1;
+
+	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
+
+	memcpy(&id->route.addr.src_addr, &resp->src_addr, resp->src_size);
+	memcpy(&id->route.addr.dst_addr, &resp->dst_addr, resp->dst_size);
+
+	if (!id_priv->cma_dev && resp->node_guid) {
+		ret = ucma_get_device(id_priv, resp->node_guid);
+		if (ret)
+			return ret;
+		id->port_num = resp->port_num;
+		id->route.addr.addr.ibaddr.pkey = resp->pkey;
+	}
+
+	return 0;
+}
+
 static int ucma_query_route(struct rdma_cm_id *id)
 {
 	struct ucma_abi_query_route_resp *resp;
-	struct ucma_abi_query_route *cmd;
+	struct ucma_abi_query *cmd;
 	struct cma_id_private *id_priv;
 	void *msg;
 	int ret, size, i;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
