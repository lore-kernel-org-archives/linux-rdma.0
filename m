From: "Hefty, Sean" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] librdmacm: Fix resource leak when CMA_CREATE_MSG_CMD_RESP
 fails
Date: Tue, 23 Aug 2011 22:57:37 +0000
Message-ID: <1828884A29C6694DAF28B7E6B8A8237316E475AF@ORSMSX101.amr.corp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Language: en-US
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If resources are allocated before CMA_CREATE_MSG_CMD_RESP or
CMA_CREATE_MSG_CMD are called, and those calls fail, we need
to cleanup the resources before returning.

Fix this by changing the CMA_CREATE_MSG macros to remove the
alloca and calling return.  The request and response structures
are now declared directly on the stack.  To accomplish this,
we merge the abi header definition into each command structure.

Problem reported by: Dotan Barak <dotanb-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 include/rdma/rdma_cma_abi.h |   62 ++++
 src/cma.c                   |  625 +++++++++++++++++++------------------------
 2 files changed, 344 insertions(+), 343 deletions(-)

diff --git a/include/rdma/rdma_cma_abi.h b/include/rdma/rdma_cma_abi.h
index ddd0d90..b72f330 100644
--- a/include/rdma/rdma_cma_abi.h
+++ b/include/rdma/rdma_cma_abi.h
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2006 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2005-2011 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -79,6 +79,9 @@ struct ucma_abi_cmd_hdr {
 };
 
 struct ucma_abi_create_id {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u64 uid;
 	__u64 response;
 	__u16 ps;
@@ -91,6 +94,9 @@ struct ucma_abi_create_id_resp {
 };
 
 struct ucma_abi_destroy_id {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u64 response;
 	__u32 id;
 	__u32 reserved;
@@ -101,12 +107,18 @@ struct ucma_abi_destroy_id_resp {
 };
 
 struct ucma_abi_bind_ip {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u64 response;
 	struct sockaddr_in6 addr;
 	__u32 id;
 };
 
 struct ucma_abi_bind {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u32 id;
 	__u16 addr_size;
 	__u16 reserved;
@@ -114,6 +126,9 @@ struct ucma_abi_bind {
 };
 
 struct ucma_abi_resolve_ip {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	struct sockaddr_in6 src_addr;
 	struct sockaddr_in6 dst_addr;
 	__u32 id;
@@ -121,6 +136,9 @@ struct ucma_abi_resolve_ip {
 };
 
 struct ucma_abi_resolve_addr {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u32 id;
 	__u32 timeout_ms;
 	__u16 src_size;
@@ -131,6 +149,9 @@ struct ucma_abi_resolve_addr {
 };
 
 struct ucma_abi_resolve_route {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u32 id;
 	__u32 timeout_ms;
 };
@@ -142,6 +163,9 @@ enum {
 };
 
 struct ucma_abi_query {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u64 response;
 	__u32 id;
 	__u32 option;
@@ -199,17 +223,26 @@ struct ucma_abi_ud_param {
 };
 
 struct ucma_abi_connect {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	struct ucma_abi_conn_param conn_param;
 	__u32 id;
 	__u32 reserved;
 };
 
 struct ucma_abi_listen {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u32 id;
 	__u32 backlog;
 };
 
 struct ucma_abi_accept {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u64 uid;
 	struct ucma_abi_conn_param conn_param;
 	__u32 id;
@@ -217,6 +250,9 @@ struct ucma_abi_accept {
 };
 
 struct ucma_abi_reject {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u32 id;
 	__u8  private_data_len;
 	__u8  reserved[3];
@@ -224,21 +260,33 @@ struct ucma_abi_reject {
 };
 
 struct ucma_abi_disconnect {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u32 id;
 };
 
 struct ucma_abi_init_qp_attr {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u64 response;
 	__u32 id;
 	__u32 qp_state;
 };
 
 struct ucma_abi_notify {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u32 id;
 	__u32 event;
 };
 
 struct ucma_abi_join_ip_mcast {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u64 response;		/* ucma_abi_create_id_resp */
 	__u64 uid;
 	struct sockaddr_in6 addr;
@@ -246,6 +294,9 @@ struct ucma_abi_join_ip_mcast {
 };
 
 struct ucma_abi_join_mcast {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u64 response;		/* rdma_ucma_create_id_resp */
 	__u64 uid;
 	__u32 id;
@@ -255,6 +306,9 @@ struct ucma_abi_join_mcast {
 };
 
 struct ucma_abi_get_event {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u64 response;
 };
 
@@ -270,6 +324,9 @@ struct ucma_abi_event_resp {
 };
 
 struct ucma_abi_set_option {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u64 optval;
 	__u32 id;
 	__u32 level;
@@ -278,6 +335,9 @@ struct ucma_abi_set_option {
 };
 
 struct ucma_abi_migrate_id {
+	__u32 cmd;
+	__u16 in;
+	__u16 out;
 	__u64 response;
 	__u32 id;
 	__u32 fd;
diff --git a/src/cma.c b/src/cma.c
index bad1ba3..7efed6f 100755
--- a/src/cma.c
+++ b/src/cma.c
@@ -1,5 +1,5 @@
 /*
- * Copyright (c) 2005-2006 Intel Corporation.  All rights reserved.
+ * Copyright (c) 2005-2011 Intel Corporation.  All rights reserved.
  *
  * This software is available to you under a choice of one of two
  * licenses.  You may choose to be licensed under the terms of the GNU
@@ -28,8 +28,6 @@
  * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
  * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
  * SOFTWARE.
- *
- * $Id: cm.c 3453 2005-09-15 21:43:21Z sean.hefty $
  */
 
 #if HAVE_CONFIG_H
@@ -59,40 +57,18 @@
 #include <rdma/rdma_verbs.h>
 #include <infiniband/ib.h>
 
-#define CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, type, size) \
-do {                                        \
-	struct ucma_abi_cmd_hdr *hdr;         \
-                                            \
-	size = sizeof(*hdr) + sizeof(*cmd); \
-	msg = alloca(size);                 \
-	if (!msg)                           \
-		return ERR(ENOMEM);         \
-	hdr = msg;                          \
-	cmd = msg + sizeof(*hdr);           \
-	hdr->cmd = type;                    \
-	hdr->in  = sizeof(*cmd);            \
-	hdr->out = sizeof(*resp);           \
-	memset(cmd, 0, sizeof(*cmd));       \
-	resp = alloca(sizeof(*resp));       \
-	if (!resp)                          \
-		return ERR(ENOMEM);         \
-	cmd->response = (uintptr_t)resp;\
+#define CMA_INIT_CMD(req, req_size, op)		\
+do {						\
+	memset(req, 0, req_size);		\
+	(req)->cmd = UCMA_CMD_##op;		\
+	(req)->in  = req_size - sizeof(struct ucma_abi_cmd_hdr); \
 } while (0)
 
-#define CMA_CREATE_MSG_CMD(msg, cmd, type, size) \
-do {                                        \
-	struct ucma_abi_cmd_hdr *hdr;       \
-                                            \
-	size = sizeof(*hdr) + sizeof(*cmd); \
-	msg = alloca(size);                 \
-	if (!msg)                           \
-		return ERR(ENOMEM);         \
-	hdr = msg;                          \
-	cmd = msg + sizeof(*hdr);           \
-	hdr->cmd = type;                    \
-	hdr->in  = sizeof(*cmd);            \
-	hdr->out = 0;                       \
-	memset(cmd, 0, sizeof(*cmd));       \
+#define CMA_INIT_CMD_RESP(req, req_size, op, resp, resp_size) \
+do {						\
+	CMA_INIT_CMD(req, req_size, op);	\
+	(req)->out = resp_size;			\
+	(req)->response = (uintptr_t) (resp);	\
 } while (0)
 
 struct cma_device {
@@ -446,11 +422,10 @@ static int rdma_create_id2(struct rdma_event_channel *channel,
 			   struct rdma_cm_id **id, void *context,
 			   enum rdma_port_space ps, enum ibv_qp_type qp_type)
 {
-	struct ucma_abi_create_id_resp *resp;
-	struct ucma_abi_create_id *cmd;
+	struct ucma_abi_create_id_resp resp;
+	struct ucma_abi_create_id cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size;
+	int ret;
 
 	ret = ucma_init();
 	if (ret)
@@ -460,18 +435,18 @@ static int rdma_create_id2(struct rdma_event_channel *channel,
 	if (!id_priv)
 		return ERR(ENOMEM);
 
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_CREATE_ID, size);
-	cmd->uid = (uintptr_t) id_priv;
-	cmd->ps = ps;
-	cmd->qp_type = qp_type;
+	CMA_INIT_CMD_RESP(&cmd, sizeof cmd, CREATE_ID, &resp, sizeof resp);
+	cmd.uid = (uintptr_t) id_priv;
+	cmd.ps = ps;
+	cmd.qp_type = qp_type;
 
-	ret = write(id_priv->id.channel->fd, msg, size);
-	if (ret != size)
+	ret = write(id_priv->id.channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		goto err;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
+	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
-	id_priv->handle = resp->id;
+	id_priv->handle = resp.id;
 	*id = &id_priv->id;
 	return 0;
 
@@ -492,21 +467,20 @@ int rdma_create_id(struct rdma_event_channel *channel,
 
 static int ucma_destroy_kern_id(int fd, uint32_t handle)
 {
-	struct ucma_abi_destroy_id_resp *resp;
-	struct ucma_abi_destroy_id *cmd;
-	void *msg;
-	int ret, size;
+	struct ucma_abi_destroy_id_resp resp;
+	struct ucma_abi_destroy_id cmd;
+	int ret;
 	
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_DESTROY_ID, size);
-	cmd->id = handle;
+	CMA_INIT_CMD_RESP(&cmd, sizeof cmd, DESTROY_ID, &resp, sizeof resp);
+	cmd.id = handle;
 
-	ret = write(fd, msg, size);
-	if (ret != size)
+	ret = write(fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
+	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
-	return resp->events_reported;
+	return resp.events_reported;
 }
 
 int rdma_destroy_id(struct rdma_cm_id *id)
@@ -550,32 +524,31 @@ static int ucma_addrlen(struct sockaddr *addr)
 
 static int ucma_query_addr(struct rdma_cm_id *id)
 {
-	struct ucma_abi_query_addr_resp *resp;
-	struct ucma_abi_query *cmd;
+	struct ucma_abi_query_addr_resp resp;
+	struct ucma_abi_query cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size;
+	int ret;
 	
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_QUERY, size);
+	CMA_INIT_CMD_RESP(&cmd, sizeof cmd, QUERY, &resp, sizeof resp);
 	id_priv = container_of(id, struct cma_id_private, id);
-	cmd->id = id_priv->handle;
-	cmd->option = UCMA_QUERY_ADDR;
+	cmd.id = id_priv->handle;
+	cmd.option = UCMA_QUERY_ADDR;
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
+	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
-	memcpy(&id->route.addr.src_addr, &resp->src_addr, resp->src_size);
-	memcpy(&id->route.addr.dst_addr, &resp->dst_addr, resp->dst_size);
+	memcpy(&id->route.addr.src_addr, &resp.src_addr, resp.src_size);
+	memcpy(&id->route.addr.dst_addr, &resp.dst_addr, resp.dst_size);
 
-	if (!id_priv->cma_dev && resp->node_guid) {
-		ret = ucma_get_device(id_priv, resp->node_guid);
+	if (!id_priv->cma_dev && resp.node_guid) {
+		ret = ucma_get_device(id_priv, resp.node_guid);
 		if (ret)
 			return ret;
-		id->port_num = resp->port_num;
-		id->route.addr.addr.ibaddr.pkey = resp->pkey;
+		id->port_num = resp.port_num;
+		id->route.addr.addr.ibaddr.pkey = resp.pkey;
 	}
 
 	return 0;
@@ -583,29 +556,28 @@ static int ucma_query_addr(struct rdma_cm_id *id)
 
 static int ucma_query_gid(struct rdma_cm_id *id)
 {
-	struct ucma_abi_query_addr_resp *resp;
-	struct ucma_abi_query *cmd;
+	struct ucma_abi_query_addr_resp resp;
+	struct ucma_abi_query cmd;
 	struct cma_id_private *id_priv;
 	struct sockaddr_ib *sib;
-	void *msg;
-	int ret, size;
+	int ret;
 	
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_QUERY, size);
+	CMA_INIT_CMD_RESP(&cmd, sizeof cmd, QUERY, &resp, sizeof resp);
 	id_priv = container_of(id, struct cma_id_private, id);
-	cmd->id = id_priv->handle;
-	cmd->option = UCMA_QUERY_GID;
+	cmd.id = id_priv->handle;
+	cmd.option = UCMA_QUERY_GID;
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
+	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
-	sib = (struct sockaddr_ib *) &resp->src_addr;
+	sib = (struct sockaddr_ib *) &resp.src_addr;
 	memcpy(id->route.addr.addr.ibaddr.sgid.raw, sib->sib_addr.sib_raw,
 	       sizeof id->route.addr.addr.ibaddr.sgid);
 
-	sib = (struct sockaddr_ib *) &resp->dst_addr;
+	sib = (struct sockaddr_ib *) &resp.dst_addr;
 	memcpy(id->route.addr.addr.ibaddr.dgid.raw, sib->sib_addr.sib_raw,
 	       sizeof id->route.addr.addr.ibaddr.dgid);
 
@@ -645,40 +617,25 @@ static void ucma_convert_path(struct ibv_path_data *path_data,
 static int ucma_query_path(struct rdma_cm_id *id)
 {
 	struct ucma_abi_query_path_resp *resp;
-	struct ucma_abi_query *cmd;
-	struct ucma_abi_cmd_hdr *hdr;
+	struct ucma_abi_query cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size, i;
-
-	size = sizeof(*hdr) + sizeof(*cmd);
-	msg = alloca(size);
-	if (!msg)
-		return ERR(ENOMEM);
-
-	hdr = msg;
-	cmd = msg + sizeof(*hdr);
-
-	hdr->cmd = UCMA_CMD_QUERY;
-	hdr->in  = sizeof(*cmd);
-	hdr->out = sizeof(*resp) + sizeof(struct ibv_path_data) * 6;
-
-	memset(cmd, 0, sizeof(*cmd));
+	int ret, i, size;
 
-	resp = alloca(hdr->out);
+	size = sizeof(*resp) + sizeof(struct ibv_path_data) * 6;
+	resp = alloca(size);
 	if (!resp)
 		return ERR(ENOMEM);
 
+	CMA_INIT_CMD_RESP(&cmd, sizeof cmd, QUERY, resp, size);
 	id_priv = container_of(id, struct cma_id_private, id);
-	cmd->response = (uintptr_t) resp;
-	cmd->id = id_priv->handle;
-	cmd->option = UCMA_QUERY_PATH;
+	cmd.id = id_priv->handle;
+	cmd.option = UCMA_QUERY_PATH;
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, hdr->out);
+	VALGRIND_MAKE_MEM_DEFINED(resp, size);
 
 	if (resp->num_paths) {
 		id->route.path_rec = malloc(sizeof(*id->route.path_rec) *
@@ -696,49 +653,48 @@ static int ucma_query_path(struct rdma_cm_id *id)
 
 static int ucma_query_route(struct rdma_cm_id *id)
 {
-	struct ucma_abi_query_route_resp *resp;
-	struct ucma_abi_query *cmd;
+	struct ucma_abi_query_route_resp resp;
+	struct ucma_abi_query cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size, i;
+	int ret, i;
 
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_QUERY_ROUTE, size);
+	CMA_INIT_CMD_RESP(&cmd, sizeof cmd, QUERY_ROUTE, &resp, sizeof resp);
 	id_priv = container_of(id, struct cma_id_private, id);
-	cmd->id = id_priv->handle;
+	cmd.id = id_priv->handle;
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
+	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
-	if (resp->num_paths) {
+	if (resp.num_paths) {
 		id->route.path_rec = malloc(sizeof *id->route.path_rec *
-					    resp->num_paths);
+					    resp.num_paths);
 		if (!id->route.path_rec)
 			return ERR(ENOMEM);
 
-		id->route.num_paths = resp->num_paths;
-		for (i = 0; i < resp->num_paths; i++)
+		id->route.num_paths = resp.num_paths;
+		for (i = 0; i < resp.num_paths; i++)
 			ibv_copy_path_rec_from_kern(&id->route.path_rec[i],
-						    &resp->ib_route[i]);
+						    &resp.ib_route[i]);
 	}
 
-	memcpy(id->route.addr.addr.ibaddr.sgid.raw, resp->ib_route[0].sgid,
+	memcpy(id->route.addr.addr.ibaddr.sgid.raw, resp.ib_route[0].sgid,
 	       sizeof id->route.addr.addr.ibaddr.sgid);
-	memcpy(id->route.addr.addr.ibaddr.dgid.raw, resp->ib_route[0].dgid,
+	memcpy(id->route.addr.addr.ibaddr.dgid.raw, resp.ib_route[0].dgid,
 	       sizeof id->route.addr.addr.ibaddr.dgid);
-	id->route.addr.addr.ibaddr.pkey = resp->ib_route[0].pkey;
-	memcpy(&id->route.addr.src_addr, &resp->src_addr,
-	       sizeof resp->src_addr);
-	memcpy(&id->route.addr.dst_addr, &resp->dst_addr,
-	       sizeof resp->dst_addr);
-
-	if (!id_priv->cma_dev && resp->node_guid) {
-		ret = ucma_get_device(id_priv, resp->node_guid);
+	id->route.addr.addr.ibaddr.pkey = resp.ib_route[0].pkey;
+	memcpy(&id->route.addr.src_addr, &resp.src_addr,
+	       sizeof resp.src_addr);
+	memcpy(&id->route.addr.dst_addr, &resp.dst_addr,
+	       sizeof resp.dst_addr);
+
+	if (!id_priv->cma_dev && resp.node_guid) {
+		ret = ucma_get_device(id_priv, resp.node_guid);
 		if (ret)
 			return ret;
-		id_priv->id.port_num = resp->port_num;
+		id_priv->id.port_num = resp.port_num;
 	}
 
 	return 0;
@@ -747,20 +703,18 @@ static int ucma_query_route(struct rdma_cm_id *id)
 static int rdma_bind_addr2(struct rdma_cm_id *id, struct sockaddr *addr,
 			   socklen_t addrlen)
 {
-	struct ucma_abi_bind *cmd;
+	struct ucma_abi_bind cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size;
+	int ret;
 	
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_BIND, size);
+	CMA_INIT_CMD(&cmd, sizeof cmd, BIND);
 	id_priv = container_of(id, struct cma_id_private, id);
-	cmd->id = id_priv->handle;
-	cmd->addr_size = addrlen;
-	cmd->reserved = 0;
-	memcpy(&cmd->addr, addr, addrlen);
+	cmd.id = id_priv->handle;
+	cmd.addr_size = addrlen;
+	memcpy(&cmd.addr, addr, addrlen);
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	return ucma_query_addr(id);
@@ -768,10 +722,9 @@ static int rdma_bind_addr2(struct rdma_cm_id *id, struct sockaddr *addr,
 
 int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 {
-	struct ucma_abi_bind_ip *cmd;
+	struct ucma_abi_bind_ip cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size, addrlen;
+	int ret, addrlen;
 	
 	addrlen = ucma_addrlen(addr);
 	if (!addrlen)
@@ -780,13 +733,13 @@ int rdma_bind_addr(struct rdma_cm_id *id, struct sockaddr *addr)
 	if (af_ib_support)
 		return rdma_bind_addr2(id, addr, addrlen);
 
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_BIND_IP, size);
+	CMA_INIT_CMD(&cmd, sizeof cmd, BIND_IP);
 	id_priv = container_of(id, struct cma_id_private, id);
-	cmd->id = id_priv->handle;
-	memcpy(&cmd->addr, addr, addrlen);
+	cmd.id = id_priv->handle;
+	memcpy(&cmd.addr, addr, addrlen);
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	return ucma_query_route(id);
@@ -817,23 +770,21 @@ static int rdma_resolve_addr2(struct rdma_cm_id *id, struct sockaddr *src_addr,
 			      socklen_t src_len, struct sockaddr *dst_addr,
 			      socklen_t dst_len, int timeout_ms)
 {
-	struct ucma_abi_resolve_addr *cmd;
+	struct ucma_abi_resolve_addr cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size;
+	int ret;
 	
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_RESOLVE_ADDR, size);
+	CMA_INIT_CMD(&cmd, sizeof cmd, RESOLVE_ADDR);
 	id_priv = container_of(id, struct cma_id_private, id);
-	cmd->id = id_priv->handle;
-	if ((cmd->src_size = src_len))
-		memcpy(&cmd->src_addr, src_addr, src_len);
-	memcpy(&cmd->dst_addr, dst_addr, dst_len);
-	cmd->dst_size = dst_len;
-	cmd->timeout_ms = timeout_ms;
-	cmd->reserved = 0;
-
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	cmd.id = id_priv->handle;
+	if ((cmd.src_size = src_len))
+		memcpy(&cmd.src_addr, src_addr, src_len);
+	memcpy(&cmd.dst_addr, dst_addr, dst_len);
+	cmd.dst_size = dst_len;
+	cmd.timeout_ms = timeout_ms;
+
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	memcpy(&id->route.addr.dst_addr, dst_addr, dst_len);
@@ -843,10 +794,9 @@ static int rdma_resolve_addr2(struct rdma_cm_id *id, struct sockaddr *src_addr,
 int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 		      struct sockaddr *dst_addr, int timeout_ms)
 {
-	struct ucma_abi_resolve_ip *cmd;
+	struct ucma_abi_resolve_ip cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size, dst_len, src_len;
+	int ret, dst_len, src_len;
 	
 	dst_len = ucma_addrlen(dst_addr);
 	if (!dst_len)
@@ -857,16 +807,16 @@ int rdma_resolve_addr(struct rdma_cm_id *id, struct sockaddr *src_addr,
 		return rdma_resolve_addr2(id, src_addr, src_len, dst_addr,
 					  dst_len, timeout_ms);
 
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_RESOLVE_IP, size);
+	CMA_INIT_CMD(&cmd, sizeof cmd, RESOLVE_IP);
 	id_priv = container_of(id, struct cma_id_private, id);
-	cmd->id = id_priv->handle;
+	cmd.id = id_priv->handle;
 	if (src_addr)
-		memcpy(&cmd->src_addr, src_addr, src_len);
-	memcpy(&cmd->dst_addr, dst_addr, dst_len);
-	cmd->timeout_ms = timeout_ms;
+		memcpy(&cmd.src_addr, src_addr, src_len);
+	memcpy(&cmd.dst_addr, dst_addr, dst_len);
+	cmd.timeout_ms = timeout_ms;
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	memcpy(&id->route.addr.dst_addr, dst_addr, dst_len);
@@ -898,10 +848,9 @@ static int ucma_set_ib_route(struct rdma_cm_id *id)
 
 int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 {
-	struct ucma_abi_resolve_route *cmd;
+	struct ucma_abi_resolve_route cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size;
+	int ret;
 
 	id_priv = container_of(id, struct cma_id_private, id);
 	if (id->verbs->device->transport_type == IBV_TRANSPORT_IB) {
@@ -910,12 +859,12 @@ int rdma_resolve_route(struct rdma_cm_id *id, int timeout_ms)
 			goto out;
 	}
 
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_RESOLVE_ROUTE, size);
-	cmd->id = id_priv->handle;
-	cmd->timeout_ms = timeout_ms;
+	CMA_INIT_CMD(&cmd, sizeof cmd, RESOLVE_ROUTE);
+	cmd.id = id_priv->handle;
+	cmd.timeout_ms = timeout_ms;
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 out:
@@ -930,25 +879,24 @@ static int ucma_is_ud_qp(enum ibv_qp_type qp_type)
 static int rdma_init_qp_attr(struct rdma_cm_id *id, struct ibv_qp_attr *qp_attr,
 			     int *qp_attr_mask)
 {
-	struct ucma_abi_init_qp_attr *cmd;
-	struct ibv_kern_qp_attr *resp;
+	struct ucma_abi_init_qp_attr cmd;
+	struct ibv_kern_qp_attr resp;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size;
+	int ret;
 	
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_INIT_QP_ATTR, size);
+	CMA_INIT_CMD_RESP(&cmd, sizeof cmd, INIT_QP_ATTR, &resp, sizeof resp);
 	id_priv = container_of(id, struct cma_id_private, id);
-	cmd->id = id_priv->handle;
-	cmd->qp_state = qp_attr->qp_state;
+	cmd.id = id_priv->handle;
+	cmd.qp_state = qp_attr->qp_state;
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
+	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
-	ibv_copy_qp_attr_from_kern(qp_attr, resp);
-	*qp_attr_mask = resp->qp_attr_mask;
+	ibv_copy_qp_attr_from_kern(qp_attr, &resp);
+	*qp_attr_mask = resp.qp_attr_mask;
 	return 0;
 }
 
@@ -1334,10 +1282,9 @@ static void ucma_copy_conn_param_to_kern(struct cma_id_private *id_priv,
 
 int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 {
-	struct ucma_abi_connect *cmd;
+	struct ucma_abi_connect cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size;
+	int ret;
 	
 	id_priv = container_of(id, struct cma_id_private, id);
 	ret = ucma_valid_param(id_priv, conn_param);
@@ -1353,23 +1300,23 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 	else
 		id_priv->responder_resources = id_priv->cma_dev->max_responder_resources;
 
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_CONNECT, size);
-	cmd->id = id_priv->handle;
+	CMA_INIT_CMD(&cmd, sizeof cmd, CONNECT);
+	cmd.id = id_priv->handle;
 	if (id->qp) {
-		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
+		ucma_copy_conn_param_to_kern(id_priv, &cmd.conn_param,
 					     conn_param, id->qp->qp_num,
 					     (id->qp->srq != NULL));
 	} else if (conn_param) {
-		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
+		ucma_copy_conn_param_to_kern(id_priv, &cmd.conn_param,
 					     conn_param, conn_param->qp_num,
 					     conn_param->srq);
 	} else {
-		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
+		ucma_copy_conn_param_to_kern(id_priv, &cmd.conn_param,
 					     conn_param, 0, 0);
 	}
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	if (id_priv->connect) {
@@ -1382,18 +1329,17 @@ int rdma_connect(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 
 int rdma_listen(struct rdma_cm_id *id, int backlog)
 {
-	struct ucma_abi_listen *cmd;
+	struct ucma_abi_listen cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size;
+	int ret;
 	
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_LISTEN, size);
+	CMA_INIT_CMD(&cmd, sizeof cmd, LISTEN);
 	id_priv = container_of(id, struct cma_id_private, id);
-	cmd->id = id_priv->handle;
-	cmd->backlog = backlog;
+	cmd.id = id_priv->handle;
+	cmd.backlog = backlog;
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	if (af_ib_support)
@@ -1451,10 +1397,9 @@ err:
 
 int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 {
-	struct ucma_abi_accept *cmd;
+	struct ucma_abi_accept cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size;
+	int ret;
 
 	id_priv = container_of(id, struct cma_id_private, id);
 	ret = ucma_valid_param(id_priv, conn_param);
@@ -1484,20 +1429,20 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 			return ret;
 	}
 
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_ACCEPT, size);
-	cmd->id = id_priv->handle;
-	cmd->uid = (uintptr_t) id_priv;
+	CMA_INIT_CMD(&cmd, sizeof cmd, ACCEPT);
+	cmd.id = id_priv->handle;
+	cmd.uid = (uintptr_t) id_priv;
 	if (id->qp)
-		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
+		ucma_copy_conn_param_to_kern(id_priv, &cmd.conn_param,
 					     conn_param, id->qp->qp_num,
 					     (id->qp->srq != NULL));
 	else
-		ucma_copy_conn_param_to_kern(id_priv, &cmd->conn_param,
+		ucma_copy_conn_param_to_kern(id_priv, &cmd.conn_param,
 					     conn_param, conn_param->qp_num,
 					     conn_param->srq);
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size) {
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd) {
 		ucma_modify_qp_err(id);
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 	}
@@ -1511,23 +1456,21 @@ int rdma_accept(struct rdma_cm_id *id, struct rdma_conn_param *conn_param)
 int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 		uint8_t private_data_len)
 {
-	struct ucma_abi_reject *cmd;
+	struct ucma_abi_reject cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size;
+	int ret;
 	
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_REJECT, size);
+	CMA_INIT_CMD(&cmd, sizeof cmd, REJECT);
 
 	id_priv = container_of(id, struct cma_id_private, id);
-	cmd->id = id_priv->handle;
+	cmd.id = id_priv->handle;
 	if (private_data && private_data_len) {
-		memcpy(cmd->private_data, private_data, private_data_len);
-		cmd->private_data_len = private_data_len;
-	} else
-		cmd->private_data_len = 0;
+		memcpy(cmd.private_data, private_data, private_data_len);
+		cmd.private_data_len = private_data_len;
+	}
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
@@ -1535,18 +1478,17 @@ int rdma_reject(struct rdma_cm_id *id, const void *private_data,
 
 int rdma_notify(struct rdma_cm_id *id, enum ibv_event_type event)
 {
-	struct ucma_abi_notify *cmd;
+	struct ucma_abi_notify cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size;
+	int ret;
 	
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_NOTIFY, size);
+	CMA_INIT_CMD(&cmd, sizeof cmd, NOTIFY);
 
 	id_priv = container_of(id, struct cma_id_private, id);
-	cmd->id = id_priv->handle;
-	cmd->event = event;
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	cmd.id = id_priv->handle;
+	cmd.event = event;
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
@@ -1554,10 +1496,9 @@ int rdma_notify(struct rdma_cm_id *id, enum ibv_event_type event)
 
 int rdma_disconnect(struct rdma_cm_id *id)
 {
-	struct ucma_abi_disconnect *cmd;
+	struct ucma_abi_disconnect cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size;
+	int ret;
 
 	switch (id->verbs->device->transport_type) {
 	case IBV_TRANSPORT_IB:
@@ -1572,12 +1513,12 @@ int rdma_disconnect(struct rdma_cm_id *id)
 	if (ret)
 		return ret;
 
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_DISCONNECT, size);
+	CMA_INIT_CMD(&cmd, sizeof cmd, DISCONNECT);
 	id_priv = container_of(id, struct cma_id_private, id);
-	cmd->id = id_priv->handle;
+	cmd.id = id_priv->handle;
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	return ucma_complete(id_priv);
@@ -1586,11 +1527,10 @@ int rdma_disconnect(struct rdma_cm_id *id)
 static int rdma_join_multicast2(struct rdma_cm_id *id, struct sockaddr *addr,
 				socklen_t addrlen, void *context)
 {
-	struct ucma_abi_create_id_resp *resp;
+	struct ucma_abi_create_id_resp resp;
 	struct cma_id_private *id_priv;
 	struct cma_multicast *mc, **pos;
-	void *msg;
-	int ret, size;
+	int ret;
 	
 	id_priv = container_of(id, struct cma_id_private, id);
 	mc = calloc(1, sizeof *mc);
@@ -1611,32 +1551,38 @@ static int rdma_join_multicast2(struct rdma_cm_id *id, struct sockaddr *addr,
 	pthread_mutex_unlock(&id_priv->mut);
 
 	if (af_ib_support) {
-		struct ucma_abi_join_mcast *cmd;
-
-		CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_JOIN_MCAST, size);
-		cmd->id = id_priv->handle;
-		memcpy(&cmd->addr, addr, addrlen);
-		cmd->addr_size = addrlen;
-		cmd->uid = (uintptr_t) mc;
-		cmd->reserved = 0;
+		struct ucma_abi_join_mcast cmd;
+
+		CMA_INIT_CMD_RESP(&cmd, sizeof cmd, JOIN_MCAST, &resp, sizeof resp);
+		cmd.id = id_priv->handle;
+		memcpy(&cmd.addr, addr, addrlen);
+		cmd.addr_size = addrlen;
+		cmd.uid = (uintptr_t) mc;
+		cmd.reserved = 0;
+
+		ret = write(id->channel->fd, &cmd, sizeof cmd);
+		if (ret != sizeof cmd) {
+			ret = (ret >= 0) ? ERR(ENODATA) : -1;
+			goto err2;
+		}
 	} else {
-		struct ucma_abi_join_ip_mcast *cmd;
+		struct ucma_abi_join_ip_mcast cmd;
 
-		CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_JOIN_IP_MCAST, size);
-		cmd->id = id_priv->handle;
-		memcpy(&cmd->addr, addr, addrlen);
-		cmd->uid = (uintptr_t) mc;
-	}
+		CMA_INIT_CMD_RESP(&cmd, sizeof cmd, JOIN_IP_MCAST, &resp, sizeof resp);
+		cmd.id = id_priv->handle;
+		memcpy(&cmd.addr, addr, addrlen);
+		cmd.uid = (uintptr_t) mc;
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size) {
-		ret = (ret >= 0) ? ERR(ENODATA) : -1;
-		goto err2;
+		ret = write(id->channel->fd, &cmd, sizeof cmd);
+		if (ret != sizeof cmd) {
+			ret = (ret >= 0) ? ERR(ENODATA) : -1;
+			goto err2;
+		}
 	}
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
+	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
-	mc->handle = resp->id;
+	mc->handle = resp.id;
 	return ucma_complete(id_priv);
 
 err2:
@@ -1664,12 +1610,11 @@ int rdma_join_multicast(struct rdma_cm_id *id, struct sockaddr *addr,
 
 int rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 {
-	struct ucma_abi_destroy_id *cmd;
-	struct ucma_abi_destroy_id_resp *resp;
+	struct ucma_abi_destroy_id cmd;
+	struct ucma_abi_destroy_id_resp resp;
 	struct cma_id_private *id_priv;
 	struct cma_multicast *mc, **pos;
-	void *msg;
-	int ret, size, addrlen;
+	int ret, addrlen;
 	
 	addrlen = ucma_addrlen(addr);
 	if (!addrlen)
@@ -1691,19 +1636,19 @@ int rdma_leave_multicast(struct rdma_cm_id *id, struct sockaddr *addr)
 	if (id->qp)
 		ibv_detach_mcast(id->qp, &mc->mgid, mc->mlid);
 	
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_LEAVE_MCAST, size);
-	cmd->id = mc->handle;
+	CMA_INIT_CMD_RESP(&cmd, sizeof cmd, LEAVE_MCAST, &resp, sizeof resp);
+	cmd.id = mc->handle;
 
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size) {
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd) {
 		ret = (ret >= 0) ? ERR(ENODATA) : -1;
 		goto free;
 	}
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
+	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	pthread_mutex_lock(&id_priv->mut);
-	while (mc->events_completed < resp->events_reported)
+	while (mc->events_completed < resp.events_reported)
 		pthread_cond_wait(&mc->cond, &id_priv->mut);
 	pthread_mutex_unlock(&id_priv->mut);
 
@@ -1841,9 +1786,8 @@ err1:
 
 static int ucma_process_conn_resp(struct cma_id_private *id_priv)
 {
-	struct ucma_abi_accept *cmd;
-	void *msg;
-	int ret, size;
+	struct ucma_abi_accept cmd;
+	int ret;
 
 	ret = ucma_modify_qp_rtr(&id_priv->id, RDMA_MAX_RESP_RES);
 	if (ret)
@@ -1853,11 +1797,11 @@ static int ucma_process_conn_resp(struct cma_id_private *id_priv)
 	if (ret)
 		goto err;
 
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_ACCEPT, size);
-	cmd->id = id_priv->handle;
+	CMA_INIT_CMD(&cmd, sizeof cmd, ACCEPT);
+	cmd.id = id_priv->handle;
 
-	ret = write(id_priv->id.channel->fd, msg, size);
-	if (ret != size) {
+	ret = write(id_priv->id.channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd) {
 		ret = (ret >= 0) ? ERR(ENODATA) : -1;
 		goto err;
 	}
@@ -1921,11 +1865,10 @@ static void ucma_copy_ud_event(struct cma_event *event,
 int rdma_get_cm_event(struct rdma_event_channel *channel,
 		      struct rdma_cm_event **event)
 {
-	struct ucma_abi_event_resp *resp;
-	struct ucma_abi_get_event *cmd;
+	struct ucma_abi_event_resp resp;
+	struct ucma_abi_get_event cmd;
 	struct cma_event *evt;
-	void *msg;
-	int ret, size;
+	int ret;
 
 	ret = ucma_init();
 	if (ret)
@@ -1940,21 +1883,21 @@ int rdma_get_cm_event(struct rdma_event_channel *channel,
 
 retry:
 	memset(evt, 0, sizeof *evt);
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_GET_EVENT, size);
-	ret = write(channel->fd, msg, size);
-	if (ret != size) {
+	CMA_INIT_CMD_RESP(&cmd, sizeof cmd, GET_EVENT, &resp, sizeof resp);
+	ret = write(channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd) {
 		free(evt);
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 	}
 	
-	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
+	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
-	evt->event.event = resp->event;
-	evt->id_priv = (void *) (uintptr_t) resp->uid;
+	evt->event.event = resp.event;
+	evt->id_priv = (void *) (uintptr_t) resp.uid;
 	evt->event.id = &evt->id_priv->id;
-	evt->event.status = resp->status;
+	evt->event.status = resp.status;
 
-	switch (resp->event) {
+	switch (resp.event) {
 	case RDMA_CM_EVENT_ADDR_RESOLVED:
 		ucma_process_addr_resolved(evt);
 		break;
@@ -1962,18 +1905,18 @@ retry:
 		ucma_process_route_resolved(evt);
 		break;
 	case RDMA_CM_EVENT_CONNECT_REQUEST:
-		evt->id_priv = (void *) (uintptr_t) resp->uid;
+		evt->id_priv = (void *) (uintptr_t) resp.uid;
 		if (ucma_is_ud_qp(evt->id_priv->id.qp_type))
-			ucma_copy_ud_event(evt, &resp->param.ud);
+			ucma_copy_ud_event(evt, &resp.param.ud);
 		else
-			ucma_copy_conn_event(evt, &resp->param.conn);
+			ucma_copy_conn_event(evt, &resp.param.conn);
 
-		ret = ucma_process_conn_req(evt, resp->id);
+		ret = ucma_process_conn_req(evt, resp.id);
 		if (ret)
 			goto retry;
 		break;
 	case RDMA_CM_EVENT_CONNECT_RESPONSE:
-		ucma_copy_conn_event(evt, &resp->param.conn);
+		ucma_copy_conn_event(evt, &resp.param.conn);
 		evt->event.status = ucma_process_conn_resp(evt->id_priv);
 		if (!evt->event.status)
 			evt->event.event = RDMA_CM_EVENT_ESTABLISHED;
@@ -1984,18 +1927,18 @@ retry:
 		break;
 	case RDMA_CM_EVENT_ESTABLISHED:
 		if (ucma_is_ud_qp(evt->id_priv->id.qp_type)) {
-			ucma_copy_ud_event(evt, &resp->param.ud);
+			ucma_copy_ud_event(evt, &resp.param.ud);
 			break;
 		}
 
-		ucma_copy_conn_event(evt, &resp->param.conn);
+		ucma_copy_conn_event(evt, &resp.param.conn);
 		break;
 	case RDMA_CM_EVENT_REJECTED:
 		if (evt->id_priv->connect_error) {
 			ucma_complete_event(evt->id_priv);
 			goto retry;
 		}
-		ucma_copy_conn_event(evt, &resp->param.conn);
+		ucma_copy_conn_event(evt, &resp.param.conn);
 		ucma_modify_qp_err(evt->event.id);
 		break;
 	case RDMA_CM_EVENT_DISCONNECTED:
@@ -2003,32 +1946,32 @@ retry:
 			ucma_complete_event(evt->id_priv);
 			goto retry;
 		}
-		ucma_copy_conn_event(evt, &resp->param.conn);
+		ucma_copy_conn_event(evt, &resp.param.conn);
 		break;
 	case RDMA_CM_EVENT_MULTICAST_JOIN:
-		evt->mc = (void *) (uintptr_t) resp->uid;
+		evt->mc = (void *) (uintptr_t) resp.uid;
 		evt->id_priv = evt->mc->id_priv;
 		evt->event.id = &evt->id_priv->id;
-		ucma_copy_ud_event(evt, &resp->param.ud);
+		ucma_copy_ud_event(evt, &resp.param.ud);
 		evt->event.param.ud.private_data = evt->mc->context;
 		evt->event.status = ucma_process_join(evt);
 		if (evt->event.status)
 			evt->event.event = RDMA_CM_EVENT_MULTICAST_ERROR;
 		break;
 	case RDMA_CM_EVENT_MULTICAST_ERROR:
-		evt->mc = (void *) (uintptr_t) resp->uid;
+		evt->mc = (void *) (uintptr_t) resp.uid;
 		evt->id_priv = evt->mc->id_priv;
 		evt->event.id = &evt->id_priv->id;
 		evt->event.param.ud.private_data = evt->mc->context;
 		break;
 	default:
-		evt->id_priv = (void *) (uintptr_t) resp->uid;
+		evt->id_priv = (void *) (uintptr_t) resp.uid;
 		evt->event.id = &evt->id_priv->id;
-		evt->event.status = resp->status;
+		evt->event.status = resp.status;
 		if (ucma_is_ud_qp(evt->id_priv->id.qp_type))
-			ucma_copy_ud_event(evt, &resp->param.ud);
+			ucma_copy_ud_event(evt, &resp.param.ud);
 		else
-			ucma_copy_conn_event(evt, &resp->param.conn);
+			ucma_copy_conn_event(evt, &resp.param.conn);
 		break;
 	}
 
@@ -2079,21 +2022,20 @@ const char *rdma_event_str(enum rdma_cm_event_type event)
 int rdma_set_option(struct rdma_cm_id *id, int level, int optname,
 		    void *optval, size_t optlen)
 {
-	struct ucma_abi_set_option *cmd;
+	struct ucma_abi_set_option cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size;
+	int ret;
 	
-	CMA_CREATE_MSG_CMD(msg, cmd, UCMA_CMD_SET_OPTION, size);
+	CMA_INIT_CMD(&cmd, sizeof cmd, SET_OPTION);
 	id_priv = container_of(id, struct cma_id_private, id);
-	cmd->id = id_priv->handle;
-	cmd->optval = (uintptr_t) optval;
-	cmd->level = level;
-	cmd->optname = optname;
-	cmd->optlen = optlen;
-
-	ret = write(id->channel->fd, msg, size);
-	if (ret != size)
+	cmd.id = id_priv->handle;
+	cmd.optval = (uintptr_t) optval;
+	cmd.level = level;
+	cmd.optname = optname;
+	cmd.optlen = optlen;
+
+	ret = write(id->channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
 	return 0;
@@ -2101,11 +2043,10 @@ int rdma_set_option(struct rdma_cm_id *id, int level, int optname,
 
 int rdma_migrate_id(struct rdma_cm_id *id, struct rdma_event_channel *channel)
 {
-	struct ucma_abi_migrate_resp *resp;
-	struct ucma_abi_migrate_id *cmd;
+	struct ucma_abi_migrate_resp resp;
+	struct ucma_abi_migrate_id cmd;
 	struct cma_id_private *id_priv;
-	void *msg;
-	int ret, size, sync;
+	int ret, sync;
 
 	id_priv = container_of(id, struct cma_id_private, id);
 	if (id_priv->sync && !channel)
@@ -2117,15 +2058,15 @@ int rdma_migrate_id(struct rdma_cm_id *id, struct rdma_event_channel *channel)
 			return -1;
 	}
 
-	CMA_CREATE_MSG_CMD_RESP(msg, cmd, resp, UCMA_CMD_MIGRATE_ID, size);
-	cmd->id = id_priv->handle;
-	cmd->fd = id->channel->fd;
+	CMA_INIT_CMD_RESP(&cmd, sizeof cmd, MIGRATE_ID, &resp, sizeof resp);
+	cmd.id = id_priv->handle;
+	cmd.fd = id->channel->fd;
 
-	ret = write(channel->fd, msg, size);
-	if (ret != size)
+	ret = write(channel->fd, &cmd, sizeof cmd);
+	if (ret != sizeof cmd)
 		return (ret >= 0) ? ERR(ENODATA) : -1;
 
-	VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
+	VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
 
 	if (id_priv->sync) {
 		if (id->event) {
@@ -2145,7 +2086,7 @@ int rdma_migrate_id(struct rdma_cm_id *id, struct rdma_event_channel *channel)
 	pthread_mutex_lock(&id_priv->mut);
 	id_priv->sync = sync;
 	id->channel = channel;
-	while (id_priv->events_completed < resp->events_reported)
+	while (id_priv->events_completed < resp.events_reported)
 		pthread_cond_wait(&id_priv->cond, &id_priv->mut);
 	pthread_mutex_unlock(&id_priv->mut);
 


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
