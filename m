From: "Sean Hefty" <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 3/37] librdmacm: add ability to query IB path records
Date: Wed, 7 Apr 2010 10:12:44 -0700
Message-ID: <24E8C3E31E794941839B37DB267D6168@amr.corp.intel.com>
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

The current query_route command only supports 2 path records.
Add support for query_path, which is capable of supporting
multiple paths.

Signed-off-by: Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---

 include/rdma/rdma_cma_abi.h |   10 +++++
 src/cma.c                   |   82 +++++++++++++++++++++++++++++++++++++++++++
 2 files changed, 91 insertions(+), 1 deletions(-)

diff --git a/include/rdma/rdma_cma_abi.h b/include/rdma/rdma_cma_abi.h
index 5c736fb..6c83fe8 100644
--- a/include/rdma/rdma_cma_abi.h
+++ b/include/rdma/rdma_cma_abi.h
@@ -35,6 +35,7 @@
 
 #include <infiniband/kern-abi.h>
 #include <infiniband/sa-kern-abi.h>
+#include <infiniband/sa.h>
 
 /*
  * This file must be kept in sync with the kernel's version of rdma_user_cm.h
@@ -114,7 +115,8 @@ struct ucma_abi_resolve_route {
 };
 
 enum {
-	UCMA_QUERY_ADDR
+	UCMA_QUERY_ADDR,
+	UCMA_QUERY_PATH
 };
 
 struct ucma_abi_query {
@@ -144,6 +146,12 @@ struct ucma_abi_query_addr_resp {
 	struct sockaddr_storage dst_addr;
 };
 
+struct ucma_abi_query_path_resp {
+	__u32 num_paths;
+	__u32 reserved;
+	struct ib_path_data path_data[0];
+};
+
 struct ucma_abi_conn_param {
 	__u32 qp_num;
 	__u32 reserved;
diff --git a/src/cma.c b/src/cma.c
index 2aef594..c3c6b73 100644
--- a/src/cma.c
+++ b/src/cma.c
@@ -506,6 +506,88 @@ static int ucma_query_addr(struct rdma_cm_id *id)
 	return 0;
 }
 
+static void ucma_convert_path(struct ib_path_data *path_data,
+			      struct ibv_sa_path_rec *sa_path)
+{
+	uint32_t fl_hop;
+
+	sa_path->dgid = path_data->path.dgid;
+	sa_path->sgid = path_data->path.sgid;
+	sa_path->dlid = path_data->path.dlid;
+	sa_path->slid = path_data->path.slid;
+	sa_path->raw_traffic = 0;
+
+	fl_hop = ntohl(path_data->path.flowlabel_hoplimit);
+	sa_path->flow_label = htonl(fl_hop >> 8);
+	sa_path->hop_limit = (uint8_t) fl_hop;
+
+	sa_path->traffic_class = path_data->path.tclass;
+	sa_path->reversible = path_data->path.reversible_numpath >> 7;
+	sa_path->numb_path = 1;
+	sa_path->pkey = path_data->path.pkey;
+	sa_path->sl = ntohs(path_data->path.qosclass_sl) & 0xF;
+	sa_path->mtu_selector = 1;
+	sa_path->mtu = path_data->path.mtu & 0x1F;
+	sa_path->rate_selector = 1;
+	sa_path->rate = path_data->path.rate & 0x1F;
+	sa_path->packet_life_time_selector = 1;
+	sa_path->packet_life_time = path_data->path.packetlifetime & 0x1F;
+
+	sa_path->preference = (uint8_t) path_data->flags;
+}
+
+static int ucma_query_path(struct rdma_cm_id *id)
+{
+	struct ucma_abi_query_path_resp *resp;
+	struct ucma_abi_query *cmd;
+	struct ucma_abi_cmd_hdr *hdr;
+	struct cma_id_private *id_priv;
+	void *msg;
+	int ret, size, i;
+
+	size = sizeof(*hdr) + sizeof(*cmd);
+	msg = alloca(size);
+	if (!msg)
+		return ERR(ENOMEM);
+
+	hdr = msg;
+	cmd = msg + sizeof(*hdr);
+
+	hdr->cmd = UCMA_CMD_QUERY;
+	hdr->in  = sizeof(*cmd);
+	hdr->out = sizeof(*resp) + sizeof(struct ib_path_data) * 6;
+
+	memset(cmd, 0, sizeof(*cmd));
+
+	resp = alloca(hdr->out);
+	if (!resp)
+		return ERR(ENOMEM);
+
+	id_priv = container_of(id, struct cma_id_private, id);
+	cmd->response = (uintptr_t) resp;
+	cmd->id = id_priv->handle;
+	cmd->option = UCMA_QUERY_PATH;
+
+	ret = write(id->channel->fd, msg, size);
+	if (ret != size)
+		return (ret >= 0) ? ERR(ENODATA) : -1;
+
+	VALGRIND_MAKE_MEM_DEFINED(resp, hdr->out);
+
+	if (resp->num_paths) {
+		id->route.path_rec = malloc(sizeof(*id->route.path_rec) *
+					    resp->num_paths);
+		if (!id->route.path_rec)
+			return ERR(ENOMEM);
+
+		id->route.num_paths = resp->num_paths;
+		for (i = 0; i < resp->num_paths; i++)
+			ucma_convert_path(&resp->path_data[i], &id->route.path_rec[i]);
+	}
+
+	return 0;
+}
+
 static int ucma_query_route(struct rdma_cm_id *id)
 {
 	struct ucma_abi_query_route_resp *resp;



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
