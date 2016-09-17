From: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v2 1/3] Add new call ibv_cmd_create_ah_ex which supports extra parameters
Date: Sat, 17 Sep 2016 05:59:11 +0200
Message-ID: <5cc0157c0f05701d8cb1334e6ee11e1e7be6fa24.1474063039.git-series.knut.omang@oracle.com>
References: <cover.0e6854f557aa8aa6ed7681cdf58397ef4f106505.1474063039.git-series.knut.omang@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.0e6854f557aa8aa6ed7681cdf58397ef4f106505.1474063039.git-series.knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>, Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The original call ibv_cmd_create_ah does not allow vendor specific request or
response parameters to be defined and passed through to kernel space.

To keep backward compatibility, introduce a new extended call which accepts
cmd and resp parameters similar to other parts of the API.
Reimplement the old call to just use the new extended call.

The new call is versioned in the shared library as IBVERBS_1.3
to leave room for a 1.2 that should have been added for other changes.

Signed-off-by: Knut Omang <knut.omang-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Reviewed-by: Mukesh Kacker <mukesh.kacker-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 include/infiniband/driver.h |  4 +++-
 src/cmd.c                   | 50 +++++++++++++++++++++-----------------
 src/libibverbs.map          |  4 +++-
 3 files changed, 36 insertions(+), 22 deletions(-)

diff --git a/include/infiniband/driver.h b/include/infiniband/driver.h
index 65fa44f..c46c55f 100644
--- a/include/infiniband/driver.h
+++ b/include/infiniband/driver.h
@@ -229,6 +229,10 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
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
index cb9e34c..12d8640 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -1463,38 +1463,44 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
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
index 5134bd9..e327a84 100644
--- a/src/libibverbs.map
+++ b/src/libibverbs.map
@@ -118,5 +118,9 @@ IBVERBS_1.1 {
 		ibv_cmd_create_qp_ex2;
 		ibv_cmd_open_qp;
 		ibv_cmd_rereg_mr;
+};
 
+IBVERBS_1.3 {
+	global:
+		ibv_cmd_create_ah_ex;
 } IBVERBS_1.0;
-- 
git-series 0.8.10
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
