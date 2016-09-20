From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v3 1/3] Add new call ibv_cmd_create_ah_ex which supports extra parameters
Date: Tue, 20 Sep 2016 08:22:24 +0200
Message-ID: <d551c3792e884443903c67212f505082cd53b135.1474352400.git-series.knut.omang@oracle.com>
References: <cover.b0b7418bec346c028215053b3e58e097aa822563.1474352400.git-series.knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.b0b7418bec346c028215053b3e58e097aa822563.1474352400.git-series.knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The original call ibv_cmd_create_ah does not allow vendor specific request or
response parameters to be defined and passed through to kernel space.

To keep backward compatibility, introduce a new extended call which accepts
cmd and resp parameters similar to other parts of the API.
Reimplement the old call to just use the new extended call.

The new call is versioned in the shared library as IBVERBS_1.4.

Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/infiniband/driver.h |  4 +++-
 src/cmd.c                   | 50 +++++++++++++++++++++-----------------
 src/libibverbs.map          |  6 ++++-
 3 files changed, 37 insertions(+), 23 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index ea3dade..9356dc8 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -234,6 +234,10 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
 			  struct ibv_recv_wr **bad_wr);
 int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
 		      struct ibv_ah_attr *attr);
+int ibv_cmd_create_ah_ex(struct ibv_pd *pd, struct ibv_ah *ah,
+			struct ibv_ah_attr *attr,
+			struct ibv_create_ah *cmd, size_t cmd_size,
+			struct ibv_create_ah_resp *resp, size_t resp_size);
 int ibv_cmd_destroy_ah(struct ibv_ah *ah);
 int ibv_cmd_attach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
 int ibv_cmd_detach_mcast(struct ibv_qp *qp, const union ibv_gid *gid, uint16_t lid);
diff --git a/src/cmd.c b/src/cmd.c
index 11f6509..58b9dcd 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -1493,38 +1493,44 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
 	return ret;
 }
 
-int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
-		      struct ibv_ah_attr *attr)
+int ibv_cmd_create_ah_ex(struct ibv_pd *pd, struct ibv_ah *ah, struct ibv_ah_attr *attr,
+			 struct ibv_create_ah *cmd, size_t cmd_size,
+			 struct ibv_create_ah_resp *resp, size_t resp_size)
 {
-	struct ibv_create_ah      cmd;
-	struct ibv_create_ah_resp resp;
-
-	IBV_INIT_CMD_RESP(&cmd, sizeof cmd, CREATE_AH, &resp, sizeof resp);
-	cmd.user_handle            = (uintptr_t) ah;
-	cmd.pd_handle              = pd->handle;
-	cmd.attr.dlid              = attr->dlid;
-	cmd.attr.sl                = attr->sl;
-	cmd.attr.src_path_bits     = attr->src_path_bits;
-	cmd.attr.static_rate       = attr->static_rate;
-	cmd.attr.is_global         = attr->is_global;
-	cmd.attr.port_num          = attr->port_num;
-	cmd.attr.grh.flow_label    = attr->grh.flow_label;
-	cmd.attr.grh.sgid_index    = attr->grh.sgid_index;
-	cmd.attr.grh.hop_limit     = attr->grh.hop_limit;
-	cmd.attr.grh.traffic_class = attr->grh.traffic_class;
-	memcpy(cmd.attr.grh.dgid, attr->grh.dgid.raw, 16);
+	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_AH, resp, resp_size);
+	cmd->user_handle            = (uintptr_t) ah;
+	cmd->pd_handle              = pd->handle;
+	cmd->attr.dlid              = attr->dlid;
+	cmd->attr.sl                = attr->sl;
+	cmd->attr.src_path_bits     = attr->src_path_bits;
+	cmd->attr.static_rate       = attr->static_rate;
+	cmd->attr.is_global         = attr->is_global;
+	cmd->attr.port_num          = attr->port_num;
+	cmd->attr.grh.flow_label    = attr->grh.flow_label;
+	cmd->attr.grh.sgid_index    = attr->grh.sgid_index;
+	cmd->attr.grh.hop_limit     = attr->grh.hop_limit;
+	cmd->attr.grh.traffic_class = attr->grh.traffic_class;
+	memcpy(cmd->attr.grh.dgid, attr->grh.dgid.raw, 16);
 
-	if (write(pd->context->cmd_fd, &cmd, sizeof cmd) != sizeof cmd)
+	if (write(pd->context->cmd_fd, cmd, cmd_size) != cmd_size)
 		return errno;
 
-	(void) VALGRIND_MAKE_MEM_DEFINED(&resp, sizeof resp);
+	(void) VALGRIND_MAKE_MEM_DEFINED(resp, sizeof *resp);
 
-	ah->handle  = resp.handle;
+	ah->handle  = resp->handle;
 	ah->context = pd->context;
 
 	return 0;
 }
 
+int ibv_cmd_create_ah(struct ibv_pd *pd, struct ibv_ah *ah,
+		      struct ibv_ah_attr *attr)
+{
+	struct ibv_create_ah      cmd;
+	struct ibv_create_ah_resp resp; 
+	return ibv_cmd_create_ah_ex(pd, ah, attr, &cmd, sizeof(cmd), &resp, sizeof(resp));
+}
+
 int ibv_cmd_destroy_ah(struct ibv_ah *ah)
 {
 	struct ibv_destroy_ah cmd;
diff --git a/src/libibverbs.map b/src/libibverbs.map
index 46744e5..ddba63a 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -118,7 +118,6 @@ IBVERBS_1.1 {
 		ibv_cmd_create_qp_ex2;
 		ibv_cmd_open_qp;
 		ibv_cmd_rereg_mr;
-
 } IBVERBS_1.0;
 
 IBVERBS_1.3 {
@@ -130,3 +129,8 @@ IBVERBS_1.3 {
 		ibv_cmd_destroy_rwq_ind_table;
 		ibv_query_gid_type;
 } IBVERBS_1.1;
+
+IBVERBS_1.4 {
+	global:
+		ibv_cmd_create_ah_ex;
+} IBVERBS_1.3;
-- 
git-series 0.8.10
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
