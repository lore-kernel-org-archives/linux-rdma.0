From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 07/17] verbs: Use kernel uapi names for identical structs
Date: Thu, 11 Jan 2018 15:13:30 -0700
Message-ID: <20180111221340.965-8-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

And delete the duplicates from kern-abi.h

A script was made to find the trivially duplicate structs, which
produced this sed script:

$ sed -i \
 -e 's/struct[ \t]ibv_alloc_mw_resp\([ \t,]\)/struct ib_uverbs_alloc_mw_resp\1/g' \
 -e 's/struct[ \t]ibv_alloc_pd_resp\([ \t,]\)/struct ib_uverbs_alloc_pd_resp\1/g' \
 -e 's/struct[ \t]ibv_comp_event\([ \t,]\)/struct ib_uverbs_comp_event_desc\1/g' \
 -e 's/struct[ \t]ibv_create_comp_channel_resp\([ \t,]\)/struct ib_uverbs_create_comp_channel_resp\1/g' \
 -e 's/struct[ \t]ibv_create_cq_resp\([ \t,]\)/struct ib_uverbs_create_cq_resp\1/g' \
 -e 's/struct[ \t]ibv_create_cq_resp_ex\([ \t,]\)/struct ib_uverbs_ex_create_cq_resp\1/g' \
 -e 's/struct[ \t]ibv_create_flow_resp\([ \t,]\)/struct ib_uverbs_destroy_flow \1/g' \
 -e 's/struct[ \t]ibv_create_qp_resp\([ \t,]\)/struct ib_uverbs_create_qp_resp\1/g' \
 -e 's/struct[ \t]ibv_create_qp_resp_ex\([ \t,]\)/struct ib_uverbs_ex_create_qp_resp\1/g' \
 -e 's/struct[ \t]ibv_create_rwq_ind_table_resp\([ \t,]\)/struct ib_uverbs_ex_create_rwq_ind_table_resp\1/g' \
 -e 's/struct[ \t]ibv_create_srq_resp\([ \t,]\)/struct ib_uverbs_create_srq_resp\1/g' \
 -e 's/struct[ \t]ibv_create_wq_resp\([ \t,]\)/struct ib_uverbs_ex_create_wq_resp\1/g' \
 -e 's/struct[ \t]ibv_destroy_cq_resp\([ \t,]\)/struct ib_uverbs_destroy_cq_resp\1/g' \
 -e 's/struct[ \t]ibv_destroy_qp_resp\([ \t,]\)/struct ib_uverbs_destroy_qp_resp\1/g' \
 -e 's/struct[ \t]ibv_destroy_srq_resp\([ \t,]\)/struct ib_uverbs_destroy_qp_resp\1/g' \
 -e 's/struct[ \t]ibv_destroy_wq_resp\([ \t,]\)/struct ib_uverbs_ex_destroy_wq_resp\1/g' \
 -e 's/struct[ \t]ibv_get_context_resp\([ \t,]\)/struct ib_uverbs_get_context_resp\1/g' \
 -e 's/struct[ \t]ibv_kern_ah_attr\([ \t,]\)/struct ib_uverbs_ah_attr\1/g' \
 -e 's/struct[ \t]ibv_kern_async_event\([ \t,]\)/struct ib_uverbs_async_event_desc\1/g' \
 -e 's/struct[ \t]ibv_kern_eth_filter\([ \t,]\)/struct ib_uverbs_flow_eth_filter\1/g' \
 -e 's/struct[ \t]ibv_kern_flow_attr\([ \t,]\)/struct ib_uverbs_flow_attr\1/g' \
 -e 's/struct[ \t]ibv_kern_global_route\([ \t,]\)/struct ib_uverbs_global_route\1/g' \
 -e 's/struct[ \t]ibv_kern_ipv4_ext_filter\([ \t,]\)/struct ib_uverbs_flow_ipv4_filter\1/g' \
 -e 's/struct[ \t]ibv_kern_ipv6_filter\([ \t,]\)/struct ib_uverbs_flow_ipv6_filter\1/g' \
 -e 's/struct[ \t]ibv_kern_modify_cq_attr\([ \t,]\)/struct ib_uverbs_cq_moderation\1/g' \
 -e 's/struct[ \t]ibv_kern_qp_attr\([ \t,]\)/struct ib_uverbs_qp_attr\1/g' \
 -e 's/struct[ \t]ibv_kern_recv_wr\([ \t,]\)/struct ib_uverbs_recv_wr\1/g' \
 -e 's/struct[ \t]ibv_kern_tcp_udp_filter\([ \t,]\)/struct ib_uverbs_flow_tcp_udp_filter\1/g' \
 -e 's/struct[ \t]ibv_kern_tunnel_filter\([ \t,]\)/struct ib_uverbs_flow_tunnel_filter\1/g' \
 -e 's/struct[ \t]ibv_modify_qp_resp_ex\([ \t,]\)/struct ib_uverbs_ex_modify_qp_resp\1/g' \
 -e 's/struct[ \t]ibv_odp_caps_resp\([ \t,]\)/struct ib_uverbs_odp_caps\1/g' \
 -e 's/struct[ \t]ibv_open_xrcd_resp\([ \t,]\)/struct ib_uverbs_close_xrcd\1/g' \
 -e 's/struct[ \t]ibv_post_recv_resp\([ \t,]\)/struct ib_uverbs_post_send_resp\1/g' \
 -e 's/struct[ \t]ibv_post_send_resp\([ \t,]\)/struct ib_uverbs_post_send_resp\1/g' \
 -e 's/struct[ \t]ibv_post_srq_recv_resp\([ \t,]\)/struct ib_uverbs_post_recv_resp\1/g' \
 -e 's/struct[ \t]ibv_qp_dest\([ \t,]\)/struct ib_uverbs_qp_dest\1/g' \
 -e 's/struct[ \t]ibv_query_device_resp\([ \t,]\)/struct ib_uverbs_query_device_resp\1/g' \
 -e 's/struct[ \t]ibv_query_port_resp\([ \t,]\)/struct ib_uverbs_query_port_resp\1/g' \
 -e 's/struct[ \t]ibv_query_qp_resp\([ \t,]\)/struct ib_uverbs_query_qp_resp\1/g' \
 -e 's/struct[ \t]ibv_query_srq_resp\([ \t,]\)/struct ib_uverbs_query_srq_resp\1/g' \
 -e 's/struct[ \t]ibv_reg_mr_resp\([ \t,]\)/struct ib_uverbs_reg_mr_resp\1/g' \
 -e 's/struct[ \t]ibv_rereg_mr_resp\([ \t,]\)/struct ib_uverbs_rereg_mr_resp\1/g' \
 -e 's/struct[ \t]ibv_resize_cq_resp\([ \t,]\)/struct ib_uverbs_resize_cq_resp\1/g' \
 -e 's/struct[ \t]ibv_rss_caps_resp\([ \t,]\)/struct ib_uverbs_rss_caps\1/g' \
 -e 's/struct[ \t]ibv_tm_caps_resp\([ \t,]\)/struct ib_uverbs_tm_caps\1/g' \
 `git ls-files`

Followed by hand checking and removing the changed structs from
kern-abi.h and fixing the trivial residual compiler errors.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibcm/cm.c                          |   2 +-
 libibverbs/cmd.c                      |  82 +++---
 libibverbs/device.c                   |   2 +-
 libibverbs/driver.h                   |  36 +--
 libibverbs/kern-abi.h                 | 453 ++--------------------------------
 libibverbs/marshall.c                 |   4 +-
 libibverbs/marshall.h                 |   4 +-
 libibverbs/verbs.c                    |   4 +-
 librdmacm/cma.c                       |   2 +-
 librdmacm/rdma_cma_abi.h              |   2 +-
 providers/bnxt_re/bnxt_re-abi.h       |  10 +-
 providers/cxgb3/iwch-abi.h            |  12 +-
 providers/cxgb4/cxgb4-abi.h           |  10 +-
 providers/cxgb4/verbs.c               |   4 +-
 providers/hfi1verbs/hfi-abi.h         |  10 +-
 providers/hfi1verbs/hfiverbs.c        |   2 +-
 providers/hfi1verbs/verbs.c           |  12 +-
 providers/hns/hns_roce_u_abi.h        |   6 +-
 providers/hns/hns_roce_u_verbs.c      |   6 +-
 providers/i40iw/i40iw-abi.h           |   8 +-
 providers/i40iw/i40iw_uverbs.c        |   6 +-
 providers/ipathverbs/ipath-abi.h      |  10 +-
 providers/ipathverbs/ipathverbs.c     |   2 +-
 providers/ipathverbs/verbs.c          |  12 +-
 providers/mlx4/mlx4-abi.h             |  14 +-
 providers/mlx4/verbs.c                |  18 +-
 providers/mlx5/mlx5-abi.h             |  18 +-
 providers/mlx5/verbs.c                |  10 +-
 providers/mthca/mthca-abi.h           |   8 +-
 providers/mthca/verbs.c               |   6 +-
 providers/nes/nes-abi.h               |   8 +-
 providers/nes/nes_uverbs.c            |   6 +-
 providers/ocrdma/ocrdma_abi.h         |  12 +-
 providers/ocrdma/ocrdma_verbs.c       |   2 +-
 providers/qedr/qelr_abi.h             |  10 +-
 providers/rxe/rxe-abi.h               |  10 +-
 providers/rxe/rxe.c                   |   8 +-
 providers/vmw_pvrdma/pvrdma-abi-fix.h |   8 +-
 providers/vmw_pvrdma/qp.c             |   4 +-
 providers/vmw_pvrdma/verbs.c          |   2 +-
 40 files changed, 217 insertions(+), 628 deletions(-)

diff --git a/libibcm/cm.c b/libibcm/cm.c
index 4fd3fdd6510a2f..ec9252673bdb5b 100644
--- a/libibcm/cm.c
+++ b/libibcm/cm.c
@@ -335,7 +335,7 @@ int ib_cm_init_qp_attr(struct ib_cm_id *cm_id,
 		       struct ibv_qp_attr *qp_attr,
 		       int *qp_attr_mask)
 {
-	struct ibv_kern_qp_attr *resp;
+	struct ib_uverbs_qp_attr *resp;
 	struct ib_ucm_init_qp_attr *cmd;
 	void *msg;
 	int result;
diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index fbd87d475a2751..a675bfb7d02fd3 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -46,7 +46,7 @@
 
 int ibv_cmd_get_context(struct verbs_context *context_ex,
 			struct ibv_get_context *cmd, size_t cmd_size,
-			struct ibv_get_context_resp *resp, size_t resp_size)
+			struct ib_uverbs_get_context_resp *resp, size_t resp_size)
 {
 	IBV_INIT_CMD_RESP(cmd, cmd_size, GET_CONTEXT, resp, resp_size);
 
@@ -62,7 +62,7 @@ int ibv_cmd_get_context(struct verbs_context *context_ex,
 }
 
 static void copy_query_dev_fields(struct ibv_device_attr *device_attr,
-				  struct ibv_query_device_resp *resp,
+				  struct ib_uverbs_query_device_resp *resp,
 				  uint64_t *raw_fw_ver)
 {
 	*raw_fw_ver				= resp->fw_ver;
@@ -112,7 +112,7 @@ int ibv_cmd_query_device(struct ibv_context *context,
 			 uint64_t *raw_fw_ver,
 			 struct ibv_query_device *cmd, size_t cmd_size)
 {
-	struct ibv_query_device_resp resp;
+	struct ib_uverbs_query_device_resp resp;
 
 	IBV_INIT_CMD_RESP(cmd, cmd_size, QUERY_DEVICE, &resp, sizeof resp);
 
@@ -269,7 +269,7 @@ int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
 		       struct ibv_port_attr *port_attr,
 		       struct ibv_query_port *cmd, size_t cmd_size)
 {
-	struct ibv_query_port_resp resp;
+	struct ib_uverbs_query_port_resp resp;
 
 	IBV_INIT_CMD_RESP(cmd, cmd_size, QUERY_PORT, &resp, sizeof resp);
 	cmd->port_num = port_num;
@@ -306,7 +306,7 @@ int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
 
 int ibv_cmd_alloc_pd(struct ibv_context *context, struct ibv_pd *pd,
 		     struct ibv_alloc_pd *cmd, size_t cmd_size,
-		     struct ibv_alloc_pd_resp *resp, size_t resp_size)
+		     struct ib_uverbs_alloc_pd_resp *resp, size_t resp_size)
 {
 	IBV_INIT_CMD_RESP(cmd, cmd_size, ALLOC_PD, resp, resp_size);
 
@@ -338,7 +338,7 @@ int ibv_cmd_open_xrcd(struct ibv_context *context, struct verbs_xrcd *xrcd,
 		      int vxrcd_size,
 		      struct ibv_xrcd_init_attr *attr,
 		      struct ibv_open_xrcd *cmd, size_t cmd_size,
-		      struct ibv_open_xrcd_resp *resp, size_t resp_size)
+		      struct ib_uverbs_close_xrcd *resp, size_t resp_size)
 {
 	IBV_INIT_CMD_RESP(cmd, cmd_size, OPEN_XRCD, resp, resp_size);
 
@@ -383,7 +383,7 @@ int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 		   uint64_t hca_va, int access,
 		   struct ibv_mr *mr, struct ibv_reg_mr *cmd,
 		   size_t cmd_size,
-		   struct ibv_reg_mr_resp *resp, size_t resp_size)
+		   struct ib_uverbs_reg_mr_resp *resp, size_t resp_size)
 {
 
 	IBV_INIT_CMD_RESP(cmd, cmd_size, REG_MR, resp, resp_size);
@@ -410,7 +410,7 @@ int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 int ibv_cmd_rereg_mr(struct ibv_mr *mr, uint32_t flags, void *addr,
 		     size_t length, uint64_t hca_va, int access,
 		     struct ibv_pd *pd, struct ibv_rereg_mr *cmd,
-		     size_t cmd_sz, struct ibv_rereg_mr_resp *resp,
+		     size_t cmd_sz, struct ib_uverbs_rereg_mr_resp *resp,
 		     size_t resp_sz)
 {
 	IBV_INIT_CMD_RESP(cmd, cmd_sz, REREG_MR, resp, resp_sz);
@@ -452,7 +452,7 @@ int ibv_cmd_dereg_mr(struct ibv_mr *mr)
 int ibv_cmd_alloc_mw(struct ibv_pd *pd, enum ibv_mw_type type,
 		     struct ibv_mw *mw, struct ibv_alloc_mw *cmd,
 		     size_t cmd_size,
-		     struct ibv_alloc_mw_resp *resp, size_t resp_size)
+		     struct ib_uverbs_alloc_mw_resp *resp, size_t resp_size)
 {
 	IBV_INIT_CMD_RESP(cmd, cmd_size, ALLOC_MW, resp, resp_size);
 	cmd->pd_handle	= pd->handle;
@@ -490,7 +490,7 @@ int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
 		      struct ibv_comp_channel *channel,
 		      int comp_vector, struct ibv_cq *cq,
 		      struct ibv_create_cq *cmd, size_t cmd_size,
-		      struct ibv_create_cq_resp *resp, size_t resp_size)
+		      struct ib_uverbs_create_cq_resp *resp, size_t resp_size)
 {
 	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_CQ, resp, resp_size);
 	cmd->user_handle   = (uintptr_t) cq;
@@ -517,7 +517,7 @@ int ibv_cmd_create_cq_ex(struct ibv_context *context,
 			 struct ibv_create_cq_ex *cmd,
 			 size_t cmd_core_size,
 			 size_t cmd_size,
-			 struct ibv_create_cq_resp_ex *resp,
+			 struct ib_uverbs_ex_create_cq_resp *resp,
 			 size_t resp_core_size,
 			 size_t resp_size)
 {
@@ -622,7 +622,7 @@ int ibv_cmd_req_notify_cq(struct ibv_cq *ibcq, int solicited_only)
 
 int ibv_cmd_resize_cq(struct ibv_cq *cq, int cqe,
 		      struct ibv_resize_cq *cmd, size_t cmd_size,
-		      struct ibv_resize_cq_resp *resp, size_t resp_size)
+		      struct ib_uverbs_resize_cq_resp *resp, size_t resp_size)
 {
 	IBV_INIT_CMD_RESP(cmd, cmd_size, RESIZE_CQ, resp, resp_size);
 	cmd->cq_handle = cq->handle;
@@ -641,7 +641,7 @@ int ibv_cmd_resize_cq(struct ibv_cq *cq, int cqe,
 int ibv_cmd_destroy_cq(struct ibv_cq *cq)
 {
 	struct ibv_destroy_cq      cmd;
-	struct ibv_destroy_cq_resp resp;
+	struct ib_uverbs_destroy_cq_resp resp;
 
 	IBV_INIT_CMD_RESP(&cmd, sizeof cmd, DESTROY_CQ, &resp, sizeof resp);
 	cmd.cq_handle = cq->handle;
@@ -664,7 +664,7 @@ int ibv_cmd_destroy_cq(struct ibv_cq *cq)
 int ibv_cmd_create_srq(struct ibv_pd *pd,
 		       struct ibv_srq *srq, struct ibv_srq_init_attr *attr,
 		       struct ibv_create_srq *cmd, size_t cmd_size,
-		       struct ibv_create_srq_resp *resp, size_t resp_size)
+		       struct ib_uverbs_create_srq_resp *resp, size_t resp_size)
 {
 	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_SRQ, resp, resp_size);
 	cmd->user_handle = (uintptr_t) srq;
@@ -700,7 +700,7 @@ int ibv_cmd_create_srq_ex(struct ibv_context *context,
 			  struct verbs_srq *srq, int vsrq_sz,
 			  struct ibv_srq_init_attr_ex *attr_ex,
 			  struct ibv_create_xsrq *cmd, size_t cmd_size,
-			  struct ibv_create_srq_resp *resp, size_t resp_size)
+			  struct ib_uverbs_create_srq_resp *resp, size_t resp_size)
 {
 	struct verbs_xrcd *vxrcd = NULL;
 
@@ -835,7 +835,7 @@ int ibv_cmd_modify_srq(struct ibv_srq *srq,
 int ibv_cmd_query_srq(struct ibv_srq *srq, struct ibv_srq_attr *srq_attr,
 		      struct ibv_query_srq *cmd, size_t cmd_size)
 {
-	struct ibv_query_srq_resp resp;
+	struct ib_uverbs_query_srq_resp resp;
 
 	IBV_INIT_CMD_RESP(cmd, cmd_size, QUERY_SRQ, &resp, sizeof resp);
 	cmd->srq_handle = srq->handle;
@@ -856,7 +856,7 @@ int ibv_cmd_query_srq(struct ibv_srq *srq, struct ibv_srq_attr *srq_attr,
 int ibv_cmd_destroy_srq(struct ibv_srq *srq)
 {
 	struct ibv_destroy_srq      cmd;
-	struct ibv_destroy_srq_resp resp;
+	struct ib_uverbs_destroy_qp_resp resp;
 
 	IBV_INIT_CMD_RESP(&cmd, sizeof cmd, DESTROY_SRQ, &resp, sizeof resp);
 	cmd.srq_handle = srq->handle;
@@ -925,7 +925,7 @@ static int create_qp_ex_common(struct verbs_qp *qp,
 static void create_qp_handle_resp_common(struct ibv_context *context,
 					 struct verbs_qp *qp,
 					 struct ibv_qp_init_attr_ex *qp_attr,
-					 struct ibv_create_qp_resp *resp,
+					 struct ib_uverbs_create_qp_resp *resp,
 					 struct verbs_xrcd *vxrcd,
 					 int vqp_sz)
 {
@@ -973,7 +973,7 @@ int ibv_cmd_create_qp_ex2(struct ibv_context *context,
 			  struct ibv_create_qp_ex *cmd,
 			  size_t cmd_core_size,
 			  size_t cmd_size,
-			  struct ibv_create_qp_resp_ex *resp,
+			  struct ib_uverbs_ex_create_qp_resp *resp,
 			  size_t resp_core_size,
 			  size_t resp_size)
 {
@@ -984,7 +984,7 @@ int ibv_cmd_create_qp_ex2(struct ibv_context *context,
 		return EINVAL;
 
 	if (resp_core_size <
-	    offsetof(struct ibv_create_qp_resp_ex, response_length) +
+	    offsetof(struct ib_uverbs_ex_create_qp_resp, response_length) +
 	    sizeof(resp->response_length))
 		return EINVAL;
 
@@ -1033,7 +1033,7 @@ int ibv_cmd_create_qp_ex(struct ibv_context *context,
 			 struct verbs_qp *qp, int vqp_sz,
 			 struct ibv_qp_init_attr_ex *attr_ex,
 			 struct ibv_create_qp *cmd, size_t cmd_size,
-			 struct ibv_create_qp_resp *resp, size_t resp_size)
+			 struct ib_uverbs_create_qp_resp *resp, size_t resp_size)
 {
 	struct verbs_xrcd *vxrcd = NULL;
 	int err;
@@ -1077,7 +1077,7 @@ int ibv_cmd_create_qp_ex(struct ibv_context *context,
 int ibv_cmd_create_qp(struct ibv_pd *pd,
 		      struct ibv_qp *qp, struct ibv_qp_init_attr *attr,
 		      struct ibv_create_qp *cmd, size_t cmd_size,
-		      struct ibv_create_qp_resp *resp, size_t resp_size)
+		      struct ib_uverbs_create_qp_resp *resp, size_t resp_size)
 {
 	IBV_INIT_CMD_RESP(cmd, cmd_size, CREATE_QP, resp, resp_size);
 
@@ -1136,7 +1136,7 @@ int ibv_cmd_open_qp(struct ibv_context *context, struct verbs_qp *qp,
 		    int vqp_sz,
 		    struct ibv_qp_open_attr *attr,
 		    struct ibv_open_qp *cmd, size_t cmd_size,
-		    struct ibv_create_qp_resp *resp, size_t resp_size)
+		    struct ib_uverbs_create_qp_resp *resp, size_t resp_size)
 {
 	struct verbs_xrcd *xrcd;
 	IBV_INIT_CMD_RESP(cmd, cmd_size, OPEN_QP, resp, resp_size);
@@ -1187,7 +1187,7 @@ int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		     struct ibv_qp_init_attr *init_attr,
 		     struct ibv_query_qp *cmd, size_t cmd_size)
 {
-	struct ibv_query_qp_resp resp;
+	struct ib_uverbs_query_qp_resp resp;
 
 	/*
 	 * Starting with IBV_QP_RATE_LIMIT the attribute must go through the
@@ -1379,10 +1379,10 @@ int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 int ibv_cmd_modify_qp_ex(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 			 int attr_mask, struct ibv_modify_qp_ex *cmd,
 			 size_t cmd_core_size, size_t cmd_size,
-			 struct ibv_modify_qp_resp_ex *resp,
+			 struct ib_uverbs_ex_modify_qp_resp *resp,
 			 size_t resp_core_size, size_t resp_size)
 {
-	if (resp_core_size < offsetof(struct ibv_modify_qp_resp_ex,
+	if (resp_core_size < offsetof(struct ib_uverbs_ex_modify_qp_resp,
 			     response_length) + sizeof(resp->response_length))
 		return EINVAL;
 
@@ -1411,7 +1411,7 @@ int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		      struct ibv_send_wr **bad_wr)
 {
 	struct ibv_post_send     *cmd;
-	struct ibv_post_send_resp resp;
+	struct ib_uverbs_post_send_resp resp;
 	struct ibv_send_wr       *i;
 	struct ibv_kern_send_wr  *n, *tmp;
 	struct ibv_sge           *s;
@@ -1501,9 +1501,9 @@ int ibv_cmd_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 		      struct ibv_recv_wr **bad_wr)
 {
 	struct ibv_post_recv     *cmd;
-	struct ibv_post_recv_resp resp;
+	struct ib_uverbs_post_send_resp resp;
 	struct ibv_recv_wr       *i;
-	struct ibv_kern_recv_wr  *n, *tmp;
+	struct ib_uverbs_recv_wr  *n, *tmp;
 	struct ibv_sge           *s;
 	unsigned                  wr_count = 0;
 	unsigned                  sge_count = 0;
@@ -1524,7 +1524,7 @@ int ibv_cmd_post_recv(struct ibv_qp *ibqp, struct ibv_recv_wr *wr,
 	cmd->sge_count = sge_count;
 	cmd->wqe_size  = sizeof *n;
 
-	n = (struct ibv_kern_recv_wr *) ((void *) cmd + sizeof *cmd);
+	n = (struct ib_uverbs_recv_wr *) ((void *) cmd + sizeof *cmd);
 	s = (struct ibv_sge *) (n + wr_count);
 
 	tmp = n;
@@ -1562,9 +1562,9 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
 		      struct ibv_recv_wr **bad_wr)
 {
 	struct ibv_post_srq_recv *cmd;
-	struct ibv_post_srq_recv_resp resp;
+	struct ib_uverbs_post_recv_resp resp;
 	struct ibv_recv_wr       *i;
-	struct ibv_kern_recv_wr  *n, *tmp;
+	struct ib_uverbs_recv_wr  *n, *tmp;
 	struct ibv_sge           *s;
 	unsigned                  wr_count = 0;
 	unsigned                  sge_count = 0;
@@ -1585,7 +1585,7 @@ int ibv_cmd_post_srq_recv(struct ibv_srq *srq, struct ibv_recv_wr *wr,
 	cmd->sge_count = sge_count;
 	cmd->wqe_size  = sizeof *n;
 
-	n = (struct ibv_kern_recv_wr *) ((void *) cmd + sizeof *cmd);
+	n = (struct ib_uverbs_recv_wr *) ((void *) cmd + sizeof *cmd);
 	s = (struct ibv_sge *) (n + wr_count);
 
 	tmp = n;
@@ -1668,7 +1668,7 @@ int ibv_cmd_destroy_ah(struct ibv_ah *ah)
 int ibv_cmd_destroy_qp(struct ibv_qp *qp)
 {
 	struct ibv_destroy_qp      cmd;
-	struct ibv_destroy_qp_resp resp;
+	struct ib_uverbs_destroy_qp_resp resp;
 
 	IBV_INIT_CMD_RESP(&cmd, sizeof cmd, DESTROY_QP, &resp, sizeof resp);
 	cmd.qp_handle = qp->handle;
@@ -1738,7 +1738,7 @@ static int get_filters_size(struct ibv_flow_spec *ib_spec,
 	switch (type) {
 	case IBV_FLOW_SPEC_IPV4_EXT:
 		min_filter_size =
-			offsetof(struct ibv_kern_ipv4_ext_filter, flags) +
+			offsetof(struct ib_uverbs_flow_ipv4_filter, flags) +
 			sizeof(kern_spec->ipv4_ext.mask.flags);
 		curr_kern_filter_size = min_filter_size;
 		ib_spec_filter_mask = (void *)&ib_spec->ipv4_ext.val +
@@ -1746,7 +1746,7 @@ static int get_filters_size(struct ibv_flow_spec *ib_spec,
 		break;
 	case IBV_FLOW_SPEC_IPV6:
 		min_filter_size =
-			offsetof(struct ibv_kern_ipv6_filter, hop_limit) +
+			offsetof(struct ib_uverbs_flow_ipv6_filter, hop_limit) +
 			sizeof(kern_spec->ipv6.mask.hop_limit);
 		curr_kern_filter_size = min_filter_size;
 		ib_spec_filter_mask = (void *)&ib_spec->ipv6.val +
@@ -1754,7 +1754,7 @@ static int get_filters_size(struct ibv_flow_spec *ib_spec,
 		break;
 	case IBV_FLOW_SPEC_VXLAN_TUNNEL:
 		min_filter_size =
-			offsetof(struct ibv_kern_tunnel_filter,
+			offsetof(struct ib_uverbs_flow_tunnel_filter,
 				 tunnel_id) +
 			sizeof(kern_spec->tunnel.mask.tunnel_id);
 		curr_kern_filter_size = min_filter_size;
@@ -1877,7 +1877,7 @@ int ibv_cmd_create_flow(struct ibv_qp *qp,
 			struct ibv_flow_attr *flow_attr)
 {
 	struct ibv_create_flow *cmd;
-	struct ibv_create_flow_resp resp;
+	struct ib_uverbs_destroy_flow  resp;
 	size_t cmd_size;
 	size_t written_size;
 	int i, err;
@@ -1946,7 +1946,7 @@ int ibv_cmd_create_wq(struct ibv_context *context,
 		      struct ibv_create_wq *cmd,
 		      size_t cmd_core_size,
 		      size_t cmd_size,
-		      struct ibv_create_wq_resp *resp,
+		      struct ib_uverbs_ex_create_wq_resp *resp,
 		      size_t resp_core_size,
 		      size_t resp_size)
 {
@@ -2033,7 +2033,7 @@ int ibv_cmd_modify_wq(struct ibv_wq *wq, struct ibv_wq_attr *attr,
 int ibv_cmd_destroy_wq(struct ibv_wq *wq)
 {
 	struct ibv_destroy_wq cmd;
-	struct ibv_destroy_wq_resp resp;
+	struct ib_uverbs_ex_destroy_wq_resp resp;
 	int ret = 0;
 
 	memset(&cmd, 0, sizeof(cmd));
@@ -2062,7 +2062,7 @@ int ibv_cmd_create_rwq_ind_table(struct ibv_context *context,
 				 struct ibv_create_rwq_ind_table *cmd,
 				 size_t cmd_core_size,
 				 size_t cmd_size,
-				 struct ibv_create_rwq_ind_table_resp *resp,
+				 struct ib_uverbs_ex_create_rwq_ind_table_resp *resp,
 				 size_t resp_core_size,
 				 size_t resp_size)
 {
diff --git a/libibverbs/device.c b/libibverbs/device.c
index 7626ce992aa03e..682a504f863802 100644
--- a/libibverbs/device.c
+++ b/libibverbs/device.c
@@ -322,7 +322,7 @@ LATEST_SYMVER_FUNC(ibv_get_async_event, 1_1, "IBVERBS_1.1",
 		   struct ibv_context *context,
 		   struct ibv_async_event *event)
 {
-	struct ibv_kern_async_event ev;
+	struct ib_uverbs_async_event_desc ev;
 
 	if (read(context->async_fd, &ev, sizeof ev) != sizeof ev)
 		return -1;
diff --git a/libibverbs/driver.h b/libibverbs/driver.h
index 1bb37c63c14d37..0c5a8e9a43f366 100644
--- a/libibverbs/driver.h
+++ b/libibverbs/driver.h
@@ -319,7 +319,7 @@ void verbs_init_cq(struct ibv_cq *cq, struct ibv_context *context,
 
 int ibv_cmd_get_context(struct verbs_context *context,
 			struct ibv_get_context *cmd, size_t cmd_size,
-			struct ibv_get_context_resp *resp, size_t resp_size);
+			struct ib_uverbs_get_context_resp *resp, size_t resp_size);
 int ibv_cmd_query_device(struct ibv_context *context,
 			 struct ibv_device_attr *device_attr,
 			 uint64_t *raw_fw_ver,
@@ -339,50 +339,50 @@ int ibv_cmd_query_port(struct ibv_context *context, uint8_t port_num,
 		       struct ibv_query_port *cmd, size_t cmd_size);
 int ibv_cmd_alloc_pd(struct ibv_context *context, struct ibv_pd *pd,
 		     struct ibv_alloc_pd *cmd, size_t cmd_size,
-		     struct ibv_alloc_pd_resp *resp, size_t resp_size);
+		     struct ib_uverbs_alloc_pd_resp *resp, size_t resp_size);
 int ibv_cmd_dealloc_pd(struct ibv_pd *pd);
 int ibv_cmd_open_xrcd(struct ibv_context *context, struct verbs_xrcd *xrcd,
 		      int vxrcd_size,
 		      struct ibv_xrcd_init_attr *attr,
 		      struct ibv_open_xrcd *cmd, size_t cmd_size,
-		      struct ibv_open_xrcd_resp *resp, size_t resp_size);
+		      struct ib_uverbs_close_xrcd *resp, size_t resp_size);
 int ibv_cmd_close_xrcd(struct verbs_xrcd *xrcd);
 int ibv_cmd_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 		   uint64_t hca_va, int access,
 		   struct ibv_mr *mr, struct ibv_reg_mr *cmd,
 		   size_t cmd_size,
-		   struct ibv_reg_mr_resp *resp, size_t resp_size);
+		   struct ib_uverbs_reg_mr_resp *resp, size_t resp_size);
 int ibv_cmd_rereg_mr(struct ibv_mr *mr, uint32_t flags, void *addr,
 		     size_t length, uint64_t hca_va, int access,
 		     struct ibv_pd *pd, struct ibv_rereg_mr *cmd,
-		     size_t cmd_sz, struct ibv_rereg_mr_resp *resp,
+		     size_t cmd_sz, struct ib_uverbs_rereg_mr_resp *resp,
 		     size_t resp_sz);
 int ibv_cmd_dereg_mr(struct ibv_mr *mr);
 int ibv_cmd_alloc_mw(struct ibv_pd *pd, enum ibv_mw_type type,
 		     struct ibv_mw *mw, struct ibv_alloc_mw *cmd,
 		     size_t cmd_size,
-		     struct ibv_alloc_mw_resp *resp, size_t resp_size);
+		     struct ib_uverbs_alloc_mw_resp *resp, size_t resp_size);
 int ibv_cmd_dealloc_mw(struct ibv_mw *mw,
 		       struct ibv_dealloc_mw *cmd, size_t cmd_size);
 int ibv_cmd_create_cq(struct ibv_context *context, int cqe,
 		      struct ibv_comp_channel *channel,
 		      int comp_vector, struct ibv_cq *cq,
 		      struct ibv_create_cq *cmd, size_t cmd_size,
-		      struct ibv_create_cq_resp *resp, size_t resp_size);
+		      struct ib_uverbs_create_cq_resp *resp, size_t resp_size);
 int ibv_cmd_create_cq_ex(struct ibv_context *context,
 			 struct ibv_cq_init_attr_ex *cq_attr,
 			 struct ibv_cq_ex *cq,
 			 struct ibv_create_cq_ex *cmd,
 			 size_t cmd_core_size,
 			 size_t cmd_size,
-			 struct ibv_create_cq_resp_ex *resp,
+			 struct ib_uverbs_ex_create_cq_resp *resp,
 			 size_t resp_core_size,
 			 size_t resp_size);
 int ibv_cmd_poll_cq(struct ibv_cq *cq, int ne, struct ibv_wc *wc);
 int ibv_cmd_req_notify_cq(struct ibv_cq *cq, int solicited_only);
 int ibv_cmd_resize_cq(struct ibv_cq *cq, int cqe,
 		      struct ibv_resize_cq *cmd, size_t cmd_size,
-		      struct ibv_resize_cq_resp *resp, size_t resp_size);
+		      struct ib_uverbs_resize_cq_resp *resp, size_t resp_size);
 int ibv_cmd_destroy_cq(struct ibv_cq *cq);
 int ibv_cmd_modify_cq(struct ibv_cq *cq,
 		      struct ibv_modify_cq_attr *attr,
@@ -392,12 +392,12 @@ int ibv_cmd_modify_cq(struct ibv_cq *cq,
 int ibv_cmd_create_srq(struct ibv_pd *pd,
 		       struct ibv_srq *srq, struct ibv_srq_init_attr *attr,
 		       struct ibv_create_srq *cmd, size_t cmd_size,
-		       struct ibv_create_srq_resp *resp, size_t resp_size);
+		       struct ib_uverbs_create_srq_resp *resp, size_t resp_size);
 int ibv_cmd_create_srq_ex(struct ibv_context *context,
 			  struct verbs_srq *srq, int vsrq_sz,
 			  struct ibv_srq_init_attr_ex *attr_ex,
 			  struct ibv_create_xsrq *cmd, size_t cmd_size,
-			  struct ibv_create_srq_resp *resp, size_t resp_size);
+			  struct ib_uverbs_create_srq_resp *resp, size_t resp_size);
 int ibv_cmd_modify_srq(struct ibv_srq *srq,
 		       struct ibv_srq_attr *srq_attr,
 		       int srq_attr_mask,
@@ -410,26 +410,26 @@ int ibv_cmd_destroy_srq(struct ibv_srq *srq);
 int ibv_cmd_create_qp(struct ibv_pd *pd,
 		      struct ibv_qp *qp, struct ibv_qp_init_attr *attr,
 		      struct ibv_create_qp *cmd, size_t cmd_size,
-		      struct ibv_create_qp_resp *resp, size_t resp_size);
+		      struct ib_uverbs_create_qp_resp *resp, size_t resp_size);
 int ibv_cmd_create_qp_ex(struct ibv_context *context,
 			 struct verbs_qp *qp, int vqp_sz,
 			 struct ibv_qp_init_attr_ex *attr_ex,
 			 struct ibv_create_qp *cmd, size_t cmd_size,
-			 struct ibv_create_qp_resp *resp, size_t resp_size);
+			 struct ib_uverbs_create_qp_resp *resp, size_t resp_size);
 int ibv_cmd_create_qp_ex2(struct ibv_context *context,
 			  struct verbs_qp *qp, int vqp_sz,
 			  struct ibv_qp_init_attr_ex *qp_attr,
 			  struct ibv_create_qp_ex *cmd,
 			  size_t cmd_core_size,
 			  size_t cmd_size,
-			  struct ibv_create_qp_resp_ex *resp,
+			  struct ib_uverbs_ex_create_qp_resp *resp,
 			  size_t resp_core_size,
 			  size_t resp_size);
 int ibv_cmd_open_qp(struct ibv_context *context,
 		    struct verbs_qp *qp,  int vqp_sz,
 		    struct ibv_qp_open_attr *attr,
 		    struct ibv_open_qp *cmd, size_t cmd_size,
-		    struct ibv_create_qp_resp *resp, size_t resp_size);
+		    struct ib_uverbs_create_qp_resp *resp, size_t resp_size);
 int ibv_cmd_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *qp_attr,
 		     int attr_mask,
 		     struct ibv_qp_init_attr *qp_init_attr,
@@ -440,7 +440,7 @@ int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 int ibv_cmd_modify_qp_ex(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 			 int attr_mask, struct ibv_modify_qp_ex *cmd,
 			 size_t cmd_core_size, size_t cmd_size,
-			 struct ibv_modify_qp_resp_ex *resp,
+			 struct ib_uverbs_ex_modify_qp_resp *resp,
 			 size_t resp_core_size, size_t resp_size);
 int ibv_cmd_destroy_qp(struct ibv_qp *qp);
 int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
@@ -467,7 +467,7 @@ int ibv_cmd_create_wq(struct ibv_context *context,
 		      struct ibv_create_wq *cmd,
 		      size_t cmd_core_size,
 		      size_t cmd_size,
-		      struct ibv_create_wq_resp *resp,
+		      struct ib_uverbs_ex_create_wq_resp *resp,
 		      size_t resp_core_size,
 		      size_t resp_size);
 
@@ -481,7 +481,7 @@ int ibv_cmd_create_rwq_ind_table(struct ibv_context *context,
 				 struct ibv_create_rwq_ind_table *cmd,
 				 size_t cmd_core_size,
 				 size_t cmd_size,
-				 struct ibv_create_rwq_ind_table_resp *resp,
+				 struct ib_uverbs_ex_create_rwq_ind_table_resp *resp,
 				 size_t resp_core_size,
 				 size_t resp_size);
 int ibv_cmd_destroy_rwq_ind_table(struct ibv_rwq_ind_table *rwq_ind_table);
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index e4bca3aea4f906..3468e5497c3531 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -80,16 +80,6 @@ struct ex_hdr {
 	};
 };
 
-struct ibv_kern_async_event {
-	__u64 element;
-	__u32 event_type;
-	__u32 reserved;
-};
-
-struct ibv_comp_event {
-	__u64 cq_handle;
-};
-
 /*
  * All commands from userspace should start with a __u32 command field
  * followed by __u16 in_words and out_words fields (which give the
@@ -106,11 +96,6 @@ struct ibv_get_context {
 	__u64 driver_data[0];
 };
 
-struct ibv_get_context_resp {
-	__u32 async_fd;
-	__u32 num_comp_vectors;
-};
-
 struct ibv_query_device {
 	__u32 command;
 	__u16 in_words;
@@ -119,82 +104,12 @@ struct ibv_query_device {
 	__u64 driver_data[0];
 };
 
-struct ibv_query_device_resp {
-	__u64 fw_ver;
-	__be64 node_guid;
-	__be64 sys_image_guid;
-	__u64 max_mr_size;
-	__u64 page_size_cap;
-	__u32 vendor_id;
-	__u32 vendor_part_id;
-	__u32 hw_ver;
-	__u32 max_qp;
-	__u32 max_qp_wr;
-	__u32 device_cap_flags;
-	__u32 max_sge;
-	__u32 max_sge_rd;
-	__u32 max_cq;
-	__u32 max_cqe;
-	__u32 max_mr;
-	__u32 max_pd;
-	__u32 max_qp_rd_atom;
-	__u32 max_ee_rd_atom;
-	__u32 max_res_rd_atom;
-	__u32 max_qp_init_rd_atom;
-	__u32 max_ee_init_rd_atom;
-	__u32 atomic_cap;
-	__u32 max_ee;
-	__u32 max_rdd;
-	__u32 max_mw;
-	__u32 max_raw_ipv6_qp;
-	__u32 max_raw_ethy_qp;
-	__u32 max_mcast_grp;
-	__u32 max_mcast_qp_attach;
-	__u32 max_total_mcast_qp_attach;
-	__u32 max_ah;
-	__u32 max_fmr;
-	__u32 max_map_per_fmr;
-	__u32 max_srq;
-	__u32 max_srq_wr;
-	__u32 max_srq_sge;
-	__u16 max_pkeys;
-	__u8  local_ca_ack_delay;
-	__u8  phys_port_cnt;
-	__u8  reserved[4];
-};
-
 struct ibv_query_device_ex {
 	struct ex_hdr	hdr;
 	__u32		comp_mask;
 	__u32		reserved;
 };
 
-struct ibv_odp_caps_resp {
-	__u64 general_caps;
-	struct {
-		__u32 rc_odp_caps;
-		__u32 uc_odp_caps;
-		__u32 ud_odp_caps;
-	} per_transport_caps;
-	__u32 reserved;
-};
-
-struct ibv_rss_caps_resp {
-	__u32 supported_qpts;
-	__u32 max_rwq_indirection_tables;
-	__u32 max_rwq_indirection_table_size;
-	__u32 reserved;
-};
-
-struct ibv_tm_caps_resp {
-	__u32 max_rndv_hdr_size;
-	__u32 max_num_tags;
-	__u32 flags;
-	__u32 max_ops;
-	__u32 max_sge;
-	__u32 reserved;
-};
-
 struct ibv_cq_moderation_caps_resp {
 	__u16  cq_count;
 	__u16  cq_period;
@@ -202,17 +117,17 @@ struct ibv_cq_moderation_caps_resp {
 };
 
 struct ibv_query_device_resp_ex {
-	struct ibv_query_device_resp base;
+	struct ib_uverbs_query_device_resp base;
 	__u32 comp_mask;
 	__u32 response_length;
-	struct ibv_odp_caps_resp odp_caps;
+	struct ib_uverbs_odp_caps odp_caps;
 	__u64 timestamp_mask;
 	__u64 hca_core_clock;
 	__u64 device_cap_flags_ex;
-	struct ibv_rss_caps_resp rss_caps;
+	struct ib_uverbs_rss_caps rss_caps;
 	__u32  max_wq_type_rq;
 	__u32 raw_packet_caps;
-	struct ibv_tm_caps_resp tm_caps;
+	struct ib_uverbs_tm_caps tm_caps;
 	struct ibv_cq_moderation_caps_resp cq_mod_caps;
 };
 
@@ -226,30 +141,6 @@ struct ibv_query_port {
 	__u64 driver_data[0];
 };
 
-struct ibv_query_port_resp {
-	__u32 port_cap_flags;
-	__u32 max_msg_sz;
-	__u32 bad_pkey_cntr;
-	__u32 qkey_viol_cntr;
-	__u32 gid_tbl_len;
-	__u16 pkey_tbl_len;
-	__u16 lid;
-	__u16 sm_lid;
-	__u8  state;
-	__u8  max_mtu;
-	__u8  active_mtu;
-	__u8  lmc;
-	__u8  max_vl_num;
-	__u8  sm_sl;
-	__u8  subnet_timeout;
-	__u8  init_type_reply;
-	__u8  active_width;
-	__u8  active_speed;
-	__u8  phys_state;
-	__u8  link_layer;
-	__u8  reserved[2];
-};
-
 struct ibv_alloc_pd {
 	__u32 command;
 	__u16 in_words;
@@ -258,10 +149,6 @@ struct ibv_alloc_pd {
 	__u64 driver_data[0];
 };
 
-struct ibv_alloc_pd_resp {
-	__u32 pd_handle;
-};
-
 struct ibv_dealloc_pd {
 	__u32 command;
 	__u16 in_words;
@@ -279,10 +166,6 @@ struct ibv_open_xrcd {
 	__u64 driver_data[0];
 };
 
-struct ibv_open_xrcd_resp {
-	__u32 xrcd_handle;
-};
-
 struct ibv_close_xrcd {
 	__u32 command;
 	__u16 in_words;
@@ -303,12 +186,6 @@ struct ibv_reg_mr {
 	__u64 driver_data[0];
 };
 
-struct ibv_reg_mr_resp {
-	__u32 mr_handle;
-	__u32 lkey;
-	__u32 rkey;
-};
-
 struct ibv_rereg_mr {
 	__u32 command;
 	__u16 in_words;
@@ -324,11 +201,6 @@ struct ibv_rereg_mr {
 	__u64 driver_data[0];
 };
 
-struct ibv_rereg_mr_resp {
-	__u32 lkey;
-	__u32 rkey;
-};
-
 struct ibv_dereg_mr {
 	__u32 command;
 	__u16 in_words;
@@ -346,11 +218,6 @@ struct ibv_alloc_mw {
 	__u8  reserved[3];
 };
 
-struct ibv_alloc_mw_resp {
-	__u32 mw_handle;
-	__u32 rkey;
-};
-
 struct ibv_dealloc_mw {
 	__u32 command;
 	__u16 in_words;
@@ -366,10 +233,6 @@ struct ibv_create_comp_channel {
 	__u64 response;
 };
 
-struct ibv_create_comp_channel_resp {
-	__u32 fd;
-};
-
 struct ibv_create_cq {
 	__u32 command;
 	__u16 in_words;
@@ -383,11 +246,6 @@ struct ibv_create_cq {
 	__u64 driver_data[0];
 };
 
-struct ibv_create_cq_resp {
-	__u32 cq_handle;
-	__u32 cqe;
-};
-
 enum ibv_create_cq_ex_kernel_flags {
 	IBV_CREATE_CQ_EX_KERNEL_FLAG_COMPLETION_TIMESTAMP = 1 << 0,
 };
@@ -403,12 +261,6 @@ struct ibv_create_cq_ex {
 	__u32		reserved;
 };
 
-struct ibv_create_cq_resp_ex {
-	struct ibv_create_cq_resp	base;
-	__u32				comp_mask;
-	__u32				response_length;
-};
-
 struct ibv_kern_wc {
 	__u64  wr_id;
 	__u32  status;
@@ -460,12 +312,6 @@ struct ibv_resize_cq {
 	__u64 driver_data[0];
 };
 
-struct ibv_resize_cq_resp {
-	__u32 cqe;
-	__u32 reserved;
-	__u64 driver_data[0];
-};
-
 struct ibv_destroy_cq {
 	__u32 command;
 	__u16 in_words;
@@ -475,69 +321,6 @@ struct ibv_destroy_cq {
 	__u32 reserved;
 };
 
-struct ibv_destroy_cq_resp {
-	__u32 comp_events_reported;
-	__u32 async_events_reported;
-};
-
-struct ibv_kern_global_route {
-	__u8  dgid[16];
-	__u32 flow_label;
-	__u8  sgid_index;
-	__u8  hop_limit;
-	__u8  traffic_class;
-	__u8  reserved;
-};
-
-struct ibv_kern_ah_attr {
-	struct ibv_kern_global_route grh;
-	__u16 dlid;
-	__u8  sl;
-	__u8  src_path_bits;
-	__u8  static_rate;
-	__u8  is_global;
-	__u8  port_num;
-	__u8  reserved;
-};
-
-struct ibv_kern_qp_attr {
-	__u32	qp_attr_mask;
-	__u32	qp_state;
-	__u32	cur_qp_state;
-	__u32	path_mtu;
-	__u32	path_mig_state;
-	__u32	qkey;
-	__u32	rq_psn;
-	__u32	sq_psn;
-	__u32	dest_qp_num;
-	__u32	qp_access_flags;
-
-	struct ibv_kern_ah_attr ah_attr;
-	struct ibv_kern_ah_attr alt_ah_attr;
-
-	/* ib_qp_cap */
-	__u32	max_send_wr;
-	__u32	max_recv_wr;
-	__u32	max_send_sge;
-	__u32	max_recv_sge;
-	__u32	max_inline_data;
-
-	__u16	pkey_index;
-	__u16	alt_pkey_index;
-	__u8	en_sqd_async_notify;
-	__u8	sq_draining;
-	__u8	max_rd_atomic;
-	__u8	max_dest_rd_atomic;
-	__u8	min_rnr_timer;
-	__u8	port_num;
-	__u8	timeout;
-	__u8	retry_cnt;
-	__u8	rnr_retry;
-	__u8	alt_port_num;
-	__u8	alt_timeout;
-	__u8	reserved[5];
-};
-
 #define IBV_CREATE_QP_COMMON	\
 	__u64 user_handle;	\
 	__u32 pd_handle;	\
@@ -580,17 +363,6 @@ struct ibv_open_qp {
 	__u64 driver_data[0];
 };
 
-/* also used for open response */
-struct ibv_create_qp_resp {
-	__u32 qp_handle;
-	__u32 qpn;
-	__u32 max_send_wr;
-	__u32 max_recv_wr;
-	__u32 max_send_sge;
-	__u32 max_recv_sge;
-	__u32 max_inline_data;
-	__u32 reserved;
-};
 
 enum ibv_create_qp_ex_kernel_mask {
 	IBV_CREATE_QP_EX_KERNEL_MASK_IND_TABLE = 1 << 0,
@@ -605,27 +377,6 @@ struct ibv_create_qp_ex {
 	__u32 source_qpn;
 };
 
-struct ibv_create_qp_resp_ex {
-	struct ibv_create_qp_resp base;
-	__u32 comp_mask;
-	__u32 response_length;
-};
-
-struct ibv_qp_dest {
-	__u8  dgid[16];
-	__u32 flow_label;
-	__u16 dlid;
-	__u16 reserved;
-	__u8  sgid_index;
-	__u8  hop_limit;
-	__u8  traffic_class;
-	__u8  sl;
-	__u8  src_path_bits;
-	__u8  static_rate;
-	__u8  is_global;
-	__u8  port_num;
-};
-
 struct ibv_query_qp {
 	__u32 command;
 	__u16 in_words;
@@ -636,43 +387,9 @@ struct ibv_query_qp {
 	__u64 driver_data[0];
 };
 
-struct ibv_query_qp_resp {
-	struct ibv_qp_dest dest;
-	struct ibv_qp_dest alt_dest;
-	__u32 max_send_wr;
-	__u32 max_recv_wr;
-	__u32 max_send_sge;
-	__u32 max_recv_sge;
-	__u32 max_inline_data;
-	__u32 qkey;
-	__u32 rq_psn;
-	__u32 sq_psn;
-	__u32 dest_qp_num;
-	__u32 qp_access_flags;
-	__u16 pkey_index;
-	__u16 alt_pkey_index;
-	__u8  qp_state;
-	__u8  cur_qp_state;
-	__u8  path_mtu;
-	__u8  path_mig_state;
-	__u8  sq_draining;
-	__u8  max_rd_atomic;
-	__u8  max_dest_rd_atomic;
-	__u8  min_rnr_timer;
-	__u8  port_num;
-	__u8  timeout;
-	__u8  retry_cnt;
-	__u8  rnr_retry;
-	__u8  alt_port_num;
-	__u8  alt_timeout;
-	__u8  sq_sig_all;
-	__u8  reserved[5];
-	__u64 driver_data[0];
-};
-
 struct ibv_modify_qp_common {
-	struct ibv_qp_dest dest;
-	struct ibv_qp_dest alt_dest;
+	struct ib_uverbs_qp_dest dest;
+	struct ib_uverbs_qp_dest alt_dest;
 	__u32 qp_handle;
 	__u32 attr_mask;
 	__u32 qkey;
@@ -714,11 +431,6 @@ struct ibv_modify_qp_ex {
 	__u32  reserved;
 };
 
-struct ibv_modify_qp_resp_ex {
-	__u32  comp_mask;
-	__u32  response_length;
-};
-
 struct ibv_destroy_qp {
 	__u32 command;
 	__u16 in_words;
@@ -728,10 +440,6 @@ struct ibv_destroy_qp {
 	__u32 reserved;
 };
 
-struct ibv_destroy_qp_resp {
-	__u32 events_reported;
-};
-
 struct ibv_kern_send_wr {
 	__u64 wr_id;
 	__u32 num_sge;
@@ -765,19 +473,12 @@ struct ibv_kern_send_wr {
 	} qp_type;
 };
 
-struct ibv_kern_eth_filter {
-	__u8  dst_mac[6];
-	__u8  src_mac[6];
-	__be16  ether_type;
-	__be16  vlan_tag;
-};
-
 struct ibv_kern_spec_eth {
 	__u32 type;
 	__u16  size;
 	__u16 reserved;
-	struct ibv_kern_eth_filter val;
-	struct ibv_kern_eth_filter mask;
+	struct ib_uverbs_flow_eth_filter val;
+	struct ib_uverbs_flow_eth_filter mask;
 };
 
 struct ibv_kern_ipv4_filter {
@@ -793,52 +494,28 @@ struct ibv_kern_spec_ipv4 {
 	struct ibv_kern_ipv4_filter mask;
 };
 
-struct ibv_kern_ipv4_ext_filter {
-	__be32 src_ip;
-	__be32 dst_ip;
-	__u8  proto;
-	__u8  tos;
-	__u8  ttl;
-	__u8  flags;
-};
-
 struct ibv_kern_spec_ipv4_ext {
 	__u32  type;
 	__u16  size;
 	__u16 reserved;
-	struct ibv_kern_ipv4_ext_filter val;
-	struct ibv_kern_ipv4_ext_filter mask;
-};
-
-struct ibv_kern_ipv6_filter {
-	__u8  src_ip[16];
-	__u8  dst_ip[16];
-	__be32 flow_label;
-	__u8  next_hdr;
-	__u8  traffic_class;
-	__u8  hop_limit;
-	__u8  reserved;
+	struct ib_uverbs_flow_ipv4_filter val;
+	struct ib_uverbs_flow_ipv4_filter mask;
 };
 
 struct ibv_kern_spec_ipv6 {
 	__u32  type;
 	__u16  size;
 	__u16 reserved;
-	struct ibv_kern_ipv6_filter val;
-	struct ibv_kern_ipv6_filter mask;
-};
-
-struct ibv_kern_tcp_udp_filter {
-	__be16 dst_port;
-	__be16 src_port;
+	struct ib_uverbs_flow_ipv6_filter val;
+	struct ib_uverbs_flow_ipv6_filter mask;
 };
 
 struct ibv_kern_spec_tcp_udp {
 	__u32  type;
 	__u16  size;
 	__u16 reserved;
-	struct ibv_kern_tcp_udp_filter val;
-	struct ibv_kern_tcp_udp_filter mask;
+	struct ib_uverbs_flow_tcp_udp_filter val;
+	struct ib_uverbs_flow_tcp_udp_filter mask;
 };
 
 struct ibv_kern_spec_action_tag {
@@ -849,16 +526,12 @@ struct ibv_kern_spec_action_tag {
 	__u32 reserved1;
 };
 
-struct ibv_kern_tunnel_filter {
-	__be32 tunnel_id;
-};
-
 struct ibv_kern_spec_tunnel {
 	__u32  type;
 	__u16  size;
 	__u16 reserved;
-	struct ibv_kern_tunnel_filter val;
-	struct ibv_kern_tunnel_filter mask;
+	struct ib_uverbs_flow_tunnel_filter val;
+	struct ib_uverbs_flow_tunnel_filter mask;
 };
 
 struct ibv_kern_spec_action_drop {
@@ -885,21 +558,6 @@ struct ibv_kern_spec {
 	};
 };
 
-struct ibv_kern_flow_attr {
-	__u32 type;
-	__u16 size;
-	__u16 priority;
-	__u8 num_of_specs;
-	__u8 reserved[2];
-	__u8 port;
-	__u32 flags;
-	/* Following are the optional layers according to user request
-	 * struct ibv_kern_flow_spec_xxx
-	 * struct ibv_kern_flow_spec_yyy
-	 */
-	struct ib_uverbs_flow_spec_hdr flow_specs[0];
-};
-
 struct ibv_post_send {
 	__u32 command;
 	__u16 in_words;
@@ -912,16 +570,6 @@ struct ibv_post_send {
 	struct ibv_kern_send_wr send_wr[0];
 };
 
-struct ibv_post_send_resp {
-	__u32 bad_wr;
-};
-
-struct ibv_kern_recv_wr {
-	__u64 wr_id;
-	__u32 num_sge;
-	__u32 reserved;
-};
-
 struct ibv_post_recv {
 	__u32 command;
 	__u16 in_words;
@@ -931,11 +579,7 @@ struct ibv_post_recv {
 	__u32 wr_count;
 	__u32 sge_count;
 	__u32 wqe_size;
-	struct ibv_kern_recv_wr recv_wr[0];
-};
-
-struct ibv_post_recv_resp {
-	__u32 bad_wr;
+	struct ib_uverbs_recv_wr recv_wr[0];
 };
 
 struct ibv_post_srq_recv {
@@ -947,11 +591,7 @@ struct ibv_post_srq_recv {
 	__u32 wr_count;
 	__u32 sge_count;
 	__u32 wqe_size;
-	struct ibv_kern_recv_wr recv_wr[0];
-};
-
-struct ibv_post_srq_recv_resp {
-	__u32 bad_wr;
+	struct ib_uverbs_recv_wr recv_wr[0];
 };
 
 struct ibv_create_ah {
@@ -962,7 +602,7 @@ struct ibv_create_ah {
 	__u64 user_handle;
 	__u32 pd_handle;
 	__u32 reserved;
-	struct ibv_kern_ah_attr attr;
+	struct ib_uverbs_ah_attr attr;
 };
 
 struct ibv_create_ah_resp {
@@ -991,12 +631,7 @@ struct ibv_create_flow  {
 	struct ex_hdr hdr;
 	__u32 comp_mask;
 	__u32 qp_handle;
-	struct ibv_kern_flow_attr flow_attr;
-};
-
-struct ibv_create_flow_resp {
-	__u32 comp_mask;
-	__u32 flow_handle;
+	struct ib_uverbs_flow_attr flow_attr;
 };
 
 struct ibv_destroy_flow  {
@@ -1046,13 +681,6 @@ struct ibv_create_xsrq {
 	__u64 driver_data[0];
 };
 
-struct ibv_create_srq_resp {
-	__u32 srq_handle;
-	__u32 max_wr;
-	__u32 max_sge;
-	__u32 srqn;
-};
-
 struct ibv_modify_srq {
 	__u32 command;
 	__u16 in_words;
@@ -1074,13 +702,6 @@ struct ibv_query_srq {
 	__u64 driver_data[0];
 };
 
-struct ibv_query_srq_resp {
-	__u32 max_wr;
-	__u32 max_sge;
-	__u32 srq_limit;
-	__u32 reserved;
-};
-
 struct ibv_destroy_srq {
 	__u32 command;
 	__u16 in_words;
@@ -1090,10 +711,6 @@ struct ibv_destroy_srq {
 	__u32 reserved;
 };
 
-struct ibv_destroy_srq_resp {
-	__u32 events_reported;
-};
-
 struct ibv_modify_srq_v3 {
 	__u32 command;
 	__u16 in_words;
@@ -1139,28 +756,12 @@ struct ibv_create_wq {
 	__u32 reserved;
 };
 
-struct ibv_create_wq_resp {
-	__u32 comp_mask;
-	__u32 response_length;
-	__u32 wq_handle;
-	__u32 max_wr;
-	__u32 max_sge;
-	__u32 wqn;
-};
-
 struct ibv_destroy_wq {
 	struct ex_hdr hdr;
 	__u32 comp_mask;
 	__u32 wq_handle;
 };
 
-struct ibv_destroy_wq_resp {
-	__u32 comp_mask;
-	__u32 response_length;
-	__u32 events_reported;
-	__u32 reserved;
-};
-
 struct ibv_modify_wq  {
 	struct ex_hdr hdr;
 	__u32 attr_mask;
@@ -1181,29 +782,17 @@ struct ibv_create_rwq_ind_table {
 	 */
 };
 
-struct ibv_create_rwq_ind_table_resp {
-	__u32 comp_mask;
-	__u32 response_length;
-	__u32 ind_tbl_handle;
-	__u32 ind_tbl_num;
-};
-
 struct ibv_destroy_rwq_ind_table {
 	struct ex_hdr hdr;
 	__u32 comp_mask;
 	__u32 ind_tbl_handle;
 };
 
-struct ibv_kern_modify_cq_attr {
-	__u16 cq_count;
-	__u16 cq_period;
-};
-
 struct ibv_modify_cq {
 	struct ex_hdr hdr;
 	__u32 cq_handle;
 	__u32 attr_mask;
-	struct ibv_kern_modify_cq_attr attr;
+	struct ib_uverbs_cq_moderation attr;
 	__u32 reserved;
 };
 
diff --git a/libibverbs/marshall.c b/libibverbs/marshall.c
index 5b0260832ca797..20c2ba9e6410b4 100644
--- a/libibverbs/marshall.c
+++ b/libibverbs/marshall.c
@@ -37,7 +37,7 @@
 #include <infiniband/marshall.h>
 
 void ibv_copy_ah_attr_from_kern(struct ibv_ah_attr *dst,
-				struct ibv_kern_ah_attr *src)
+				struct ib_uverbs_ah_attr *src)
 {
 	memcpy(dst->grh.dgid.raw, src->grh.dgid, sizeof dst->grh.dgid);
 	dst->grh.flow_label = src->grh.flow_label;
@@ -54,7 +54,7 @@ void ibv_copy_ah_attr_from_kern(struct ibv_ah_attr *dst,
 }
 
 void ibv_copy_qp_attr_from_kern(struct ibv_qp_attr *dst,
-				struct ibv_kern_qp_attr *src)
+				struct ib_uverbs_qp_attr *src)
 {
 	dst->cur_qp_state = src->cur_qp_state;
 	dst->path_mtu = src->path_mtu;
diff --git a/libibverbs/marshall.h b/libibverbs/marshall.h
index c5ba62ccfc1c26..723f4f485b4d78 100644
--- a/libibverbs/marshall.h
+++ b/libibverbs/marshall.h
@@ -43,10 +43,10 @@ extern "C" {
 #endif
 
 void ibv_copy_qp_attr_from_kern(struct ibv_qp_attr *dst,
-				struct ibv_kern_qp_attr *src);
+				struct ib_uverbs_qp_attr *src);
 
 void ibv_copy_ah_attr_from_kern(struct ibv_ah_attr *dst,
-				struct ibv_kern_ah_attr *src);
+				struct ib_uverbs_ah_attr *src);
 
 void ibv_copy_path_rec_from_kern(struct ibv_sa_path_rec *dst,
 				 struct ib_user_path_rec *src);
diff --git a/libibverbs/verbs.c b/libibverbs/verbs.c
index 4b2696e2aac020..3b5c31090f3f6b 100644
--- a/libibverbs/verbs.c
+++ b/libibverbs/verbs.c
@@ -319,7 +319,7 @@ struct ibv_comp_channel *ibv_create_comp_channel(struct ibv_context *context)
 {
 	struct ibv_comp_channel            *channel;
 	struct ibv_create_comp_channel      cmd;
-	struct ibv_create_comp_channel_resp resp;
+	struct ib_uverbs_create_comp_channel_resp resp;
 
 	channel = malloc(sizeof *channel);
 	if (!channel)
@@ -410,7 +410,7 @@ LATEST_SYMVER_FUNC(ibv_get_cq_event, 1_1, "IBVERBS_1.1",
 		   struct ibv_comp_channel *channel,
 		   struct ibv_cq **cq, void **cq_context)
 {
-	struct ibv_comp_event ev;
+	struct ib_uverbs_comp_event_desc ev;
 
 	if (read(channel->fd, &ev, sizeof ev) != sizeof ev)
 		return -1;
diff --git a/librdmacm/cma.c b/librdmacm/cma.c
index ca1b5fb4772aaf..db2b01e608bd61 100644
--- a/librdmacm/cma.c
+++ b/librdmacm/cma.c
@@ -993,7 +993,7 @@ static int rdma_init_qp_attr(struct rdma_cm_id *id, struct ibv_qp_attr *qp_attr,
 			     int *qp_attr_mask)
 {
 	struct ucma_abi_init_qp_attr cmd;
-	struct ibv_kern_qp_attr resp;
+	struct ib_uverbs_qp_attr resp;
 	struct cma_id_private *id_priv;
 	int ret;
 	
diff --git a/librdmacm/rdma_cma_abi.h b/librdmacm/rdma_cma_abi.h
index deb37a41643a76..0ebdad96ec484a 100644
--- a/librdmacm/rdma_cma_abi.h
+++ b/librdmacm/rdma_cma_abi.h
@@ -216,7 +216,7 @@ struct ucma_abi_conn_param {
 struct ucma_abi_ud_param {
 	__u32 qp_num;
 	__u32 qkey;
-	struct ibv_kern_ah_attr ah_attr;
+	struct ib_uverbs_ah_attr ah_attr;
 	__u8 private_data[RDMA_MAX_PRIVATE_DATA];
 	__u8 private_data_len;
 	__u8 reserved[7];
diff --git a/providers/bnxt_re/bnxt_re-abi.h b/providers/bnxt_re/bnxt_re-abi.h
index 73beef59808554..94ec7b367f9bca 100644
--- a/providers/bnxt_re/bnxt_re-abi.h
+++ b/providers/bnxt_re/bnxt_re-abi.h
@@ -196,7 +196,7 @@ struct bnxt_re_db_hdr {
 };
 
 struct bnxt_re_cntx_resp {
-	struct ibv_get_context_resp resp;
+	struct ib_uverbs_get_context_resp resp;
 	__u32 dev_id;
 	__u32 max_qp; /* To allocate qp-table */
 	__u32 pg_size;
@@ -206,14 +206,14 @@ struct bnxt_re_cntx_resp {
 };
 
 struct bnxt_re_pd_resp {
-	struct ibv_alloc_pd_resp resp;
+	struct ib_uverbs_alloc_pd_resp resp;
 	__u32 pdid;
 	__u32 dpi;
 	__u64 dbr;
 };
 
 struct bnxt_re_mr_resp {
-	struct ibv_reg_mr_resp resp;
+	struct ib_uverbs_reg_mr_resp resp;
 };
 
 struct bnxt_re_cq_req {
@@ -223,7 +223,7 @@ struct bnxt_re_cq_req {
 };
 
 struct bnxt_re_cq_resp {
-	struct ibv_create_cq_resp resp;
+	struct ib_uverbs_create_cq_resp resp;
 	__u32 cqid;
 	__u32 tail;
 	__u32 phase;
@@ -271,7 +271,7 @@ struct bnxt_re_qp_req {
 };
 
 struct bnxt_re_qp_resp {
-	struct ibv_create_qp_resp resp;
+	struct ib_uverbs_create_qp_resp resp;
 	__u32 qpid;
 	__u32 rsvd;
 };
diff --git a/providers/cxgb3/iwch-abi.h b/providers/cxgb3/iwch-abi.h
index 7f2c12d98107f9..50741ded5052be 100644
--- a/providers/cxgb3/iwch-abi.h
+++ b/providers/cxgb3/iwch-abi.h
@@ -36,11 +36,11 @@
 #include <infiniband/kern-abi.h>
 
 struct iwch_alloc_ucontext_resp {
-	struct ibv_get_context_resp ibv_resp;
+	struct ib_uverbs_get_context_resp ibv_resp;
 };
 
 struct iwch_alloc_pd_resp {
-	struct ibv_alloc_pd_resp ibv_resp;
+	struct ib_uverbs_alloc_pd_resp ibv_resp;
 	uint32_t pdid;
 };
 
@@ -50,19 +50,19 @@ struct iwch_create_cq {
 };
 
 struct iwch_reg_mr_resp {
-	struct ibv_reg_mr_resp ibv_resp;
+	struct ib_uverbs_reg_mr_resp ibv_resp;
 	uint32_t pbl_addr;
 };
 
 struct iwch_create_cq_resp_v0 {
-	struct ibv_create_cq_resp ibv_resp;
+	struct ib_uverbs_create_cq_resp ibv_resp;
 	uint64_t physaddr;
 	uint32_t cqid;
 	uint32_t size_log2;
 };
 
 struct iwch_create_cq_resp_v1 {
-	struct ibv_create_cq_resp ibv_resp;
+	struct ib_uverbs_create_cq_resp ibv_resp;
 	uint64_t physaddr;
 	uint32_t cqid;
 	uint32_t size_log2;
@@ -75,7 +75,7 @@ struct iwch_create_qp {
 };
 
 struct iwch_create_qp_resp {
-	struct ibv_create_qp_resp ibv_resp;
+	struct ib_uverbs_create_qp_resp ibv_resp;
 	uint64_t physaddr;
 	uint64_t doorbell;
 	uint32_t qpid;
diff --git a/providers/cxgb4/cxgb4-abi.h b/providers/cxgb4/cxgb4-abi.h
index 91e68d552b293d..b18d03d25907f9 100644
--- a/providers/cxgb4/cxgb4-abi.h
+++ b/providers/cxgb4/cxgb4-abi.h
@@ -36,19 +36,19 @@
 #include <infiniband/kern-abi.h>
 
 struct c4iw_alloc_ucontext_resp {
-	struct ibv_get_context_resp ibv_resp;
+	struct ib_uverbs_get_context_resp ibv_resp;
 	__u64 status_page_key;
 	__u32 status_page_size;
 	__u32 reserved;
 };
 
 struct c4iw_alloc_pd_resp {
-	struct ibv_alloc_pd_resp ibv_resp;
+	struct ib_uverbs_alloc_pd_resp ibv_resp;
 	uint32_t pdid;
 };
 
 struct c4iw_create_cq_resp {
-	struct ibv_create_cq_resp ibv_resp;
+	struct ib_uverbs_create_cq_resp ibv_resp;
 	__u64 key;
 	__u64 gts_key;
 	__u64 memsize;
@@ -63,7 +63,7 @@ enum {
 };
 
 struct c4iw_create_qp_resp_v0 {
-	struct ibv_create_qp_resp ibv_resp;
+	struct ib_uverbs_create_qp_resp ibv_resp;
 	__u64 sq_key;
 	__u64 rq_key;
 	__u64 sq_db_gts_key;
@@ -78,7 +78,7 @@ struct c4iw_create_qp_resp_v0 {
 };
 
 struct c4iw_create_qp_resp {
-	struct ibv_create_qp_resp ibv_resp;
+	struct ib_uverbs_create_qp_resp ibv_resp;
 	__u64 ma_sync_key;
 	__u64 sq_key;
 	__u64 rq_key;
diff --git a/providers/cxgb4/verbs.c b/providers/cxgb4/verbs.c
index 251a337d2b4183..9a7fa3cf61fc32 100644
--- a/providers/cxgb4/verbs.c
+++ b/providers/cxgb4/verbs.c
@@ -113,7 +113,7 @@ static struct ibv_mr *__c4iw_reg_mr(struct ibv_pd *pd, void *addr,
 {
 	struct c4iw_mr *mhp;
 	struct ibv_reg_mr cmd;
-	struct ibv_reg_mr_resp resp;
+	struct ib_uverbs_reg_mr_resp resp;
 	struct c4iw_dev *dev = to_c4iw_dev(pd->context->device);
 
 	mhp = malloc(sizeof *mhp);
@@ -245,7 +245,7 @@ int c4iw_resize_cq(struct ibv_cq *ibcq, int cqe)
 	int ret;
 
 	struct ibv_resize_cq cmd;
-	struct ibv_resize_cq_resp resp;
+	struct ib_uverbs_resize_cq_resp resp;
 	ret = ibv_cmd_resize_cq(ibcq, cqe, &cmd, sizeof cmd, &resp, sizeof resp);
 	PDBG("%s ret %d\n", __func__, ret);
 	return ret;
diff --git a/providers/hfi1verbs/hfi-abi.h b/providers/hfi1verbs/hfi-abi.h
index 2df637d00db76d..edf05e820ff1fa 100644
--- a/providers/hfi1verbs/hfi-abi.h
+++ b/providers/hfi1verbs/hfi-abi.h
@@ -60,27 +60,27 @@
 #include <infiniband/kern-abi.h>
 
 struct hfi1_get_context_resp {
-	struct ibv_get_context_resp	ibv_resp;
+	struct ib_uverbs_get_context_resp	ibv_resp;
 	__u32				version;
 };
 
 struct hfi1_create_cq_resp {
-	struct ibv_create_cq_resp	ibv_resp;
+	struct ib_uverbs_create_cq_resp	ibv_resp;
 	__u64				offset;
 };
 
 struct hfi1_resize_cq_resp {
-	struct ibv_resize_cq_resp	ibv_resp;
+	struct ib_uverbs_resize_cq_resp	ibv_resp;
 	__u64				offset;
 };
 
 struct hfi1_create_qp_resp {
-	struct ibv_create_qp_resp	ibv_resp;
+	struct ib_uverbs_create_qp_resp	ibv_resp;
 	__u64				offset;
 };
 
 struct hfi1_create_srq_resp {
-	struct ibv_create_srq_resp	ibv_resp;
+	struct ib_uverbs_create_srq_resp	ibv_resp;
 	__u64				offset;
 };
 
diff --git a/providers/hfi1verbs/hfiverbs.c b/providers/hfi1verbs/hfiverbs.c
index e9d3261f599e3f..d46ad8666abc31 100644
--- a/providers/hfi1verbs/hfiverbs.c
+++ b/providers/hfi1verbs/hfiverbs.c
@@ -141,7 +141,7 @@ static struct verbs_context *hfi1_alloc_context(struct ibv_device *ibdev,
 {
 	struct hfi1_context	    *context;
 	struct ibv_get_context       cmd;
-	struct ibv_get_context_resp  resp;
+	struct ib_uverbs_get_context_resp  resp;
 	struct hfi1_device         *dev;
 
 	context = verbs_init_and_alloc_context(ibdev, cmd_fd, context, ibv_ctx);
diff --git a/providers/hfi1verbs/verbs.c b/providers/hfi1verbs/verbs.c
index 145708d7b4ba7a..8e616b8b2198b8 100644
--- a/providers/hfi1verbs/verbs.c
+++ b/providers/hfi1verbs/verbs.c
@@ -101,7 +101,7 @@ int hfi1_query_port(struct ibv_context *context, uint8_t port,
 struct ibv_pd *hfi1_alloc_pd(struct ibv_context *context)
 {
 	struct ibv_alloc_pd	  cmd;
-	struct ibv_alloc_pd_resp  resp;
+	struct ib_uverbs_alloc_pd_resp  resp;
 	struct ibv_pd		 *pd;
 
 	pd = malloc(sizeof *pd);
@@ -134,7 +134,7 @@ struct ibv_mr *hfi1_reg_mr(struct ibv_pd *pd, void *addr,
 {
 	struct ibv_mr *mr;
 	struct ibv_reg_mr cmd;
-	struct ibv_reg_mr_resp resp;
+	struct ib_uverbs_reg_mr_resp resp;
 	int ret;
 
 	mr = malloc(sizeof *mr);
@@ -206,7 +206,7 @@ struct ibv_cq *hfi1_create_cq_v1(struct ibv_context *context, int cqe,
 {
 	struct ibv_cq		   *cq;
 	struct ibv_create_cq	    cmd;
-	struct ibv_create_cq_resp   resp;
+	struct ib_uverbs_create_cq_resp   resp;
 	int			    ret;
 
 	cq = malloc(sizeof *cq);
@@ -257,7 +257,7 @@ int hfi1_resize_cq(struct ibv_cq *ibcq, int cqe)
 int hfi1_resize_cq_v1(struct ibv_cq *ibcq, int cqe)
 {
 	struct ibv_resize_cq		cmd;
-	struct ibv_resize_cq_resp	resp;
+	struct ib_uverbs_resize_cq_resp	resp;
 
 	return ibv_cmd_resize_cq(ibcq, cqe, &cmd, sizeof cmd,
 				 &resp, sizeof resp);
@@ -364,7 +364,7 @@ struct ibv_qp *hfi1_create_qp_v1(struct ibv_pd *pd,
 				  struct ibv_qp_init_attr *attr)
 {
 	struct ibv_create_qp	     cmd;
-	struct ibv_create_qp_resp    resp;
+	struct ib_uverbs_create_qp_resp    resp;
 	struct ibv_qp		    *qp;
 	int			     ret;
 
@@ -561,7 +561,7 @@ struct ibv_srq *hfi1_create_srq_v1(struct ibv_pd *pd,
 {
 	struct ibv_srq *srq;
 	struct ibv_create_srq cmd;
-	struct ibv_create_srq_resp resp;
+	struct ib_uverbs_create_srq_resp resp;
 	int ret;
 
 	srq = malloc(sizeof *srq);
diff --git a/providers/hns/hns_roce_u_abi.h b/providers/hns/hns_roce_u_abi.h
index 2a57f464ac6798..251a5c920a3557 100644
--- a/providers/hns/hns_roce_u_abi.h
+++ b/providers/hns/hns_roce_u_abi.h
@@ -36,12 +36,12 @@
 #include <infiniband/kern-abi.h>
 
 struct hns_roce_alloc_ucontext_resp {
-	struct ibv_get_context_resp	ibv_resp;
+	struct ib_uverbs_get_context_resp	ibv_resp;
 	__u32				qp_tab_size;
 };
 
 struct hns_roce_alloc_pd_resp {
-	struct ibv_alloc_pd_resp	ibv_resp;
+	struct ib_uverbs_alloc_pd_resp	ibv_resp;
 	__u32				pdn;
 	__u32				reserved;
 };
@@ -53,7 +53,7 @@ struct hns_roce_create_cq {
 };
 
 struct hns_roce_create_cq_resp {
-	struct ibv_create_cq_resp	ibv_resp;
+	struct ib_uverbs_create_cq_resp	ibv_resp;
 	__u32				cqn;
 	__u32				reserved;
 };
diff --git a/providers/hns/hns_roce_u_verbs.c b/providers/hns/hns_roce_u_verbs.c
index 3def78d25a9a71..11390de0efd366 100644
--- a/providers/hns/hns_roce_u_verbs.c
+++ b/providers/hns/hns_roce_u_verbs.c
@@ -124,7 +124,7 @@ struct ibv_mr *hns_roce_u_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 	int ret;
 	struct ibv_mr *mr;
 	struct ibv_reg_mr cmd;
-	struct ibv_reg_mr_resp resp;
+	struct ib_uverbs_reg_mr_resp resp;
 
 	if (!addr) {
 		fprintf(stderr, "2nd parm addr is NULL!\n");
@@ -154,7 +154,7 @@ int hns_roce_u_rereg_mr(struct ibv_mr *mr, int flags, struct ibv_pd *pd,
 			void *addr, size_t length, int access)
 {
 	struct ibv_rereg_mr cmd;
-	struct ibv_rereg_mr_resp resp;
+	struct ib_uverbs_rereg_mr_resp resp;
 
 	return ibv_cmd_rereg_mr(mr, flags, addr, length, (uintptr_t)addr,
 				access, pd, &cmd, sizeof(cmd), &resp,
@@ -502,7 +502,7 @@ struct ibv_qp *hns_roce_u_create_qp(struct ibv_pd *pd,
 	int ret;
 	struct hns_roce_qp *qp = NULL;
 	struct hns_roce_create_qp cmd;
-	struct ibv_create_qp_resp resp;
+	struct ib_uverbs_create_qp_resp resp;
 	struct hns_roce_context *context = to_hr_ctx(pd->context);
 	unsigned int sge_ex_count;
 
diff --git a/providers/i40iw/i40iw-abi.h b/providers/i40iw/i40iw-abi.h
index df2df07659c022..8b35a8decfb9cf 100644
--- a/providers/i40iw/i40iw-abi.h
+++ b/providers/i40iw/i40iw-abi.h
@@ -47,7 +47,7 @@ struct i40iw_get_context {
 };
 
 struct i40iw_ualloc_ucontext_resp {
-	struct ibv_get_context_resp ibv_resp;
+	struct ib_uverbs_get_context_resp ibv_resp;
 	__u32 max_pds;		/* maximum pds allowed for this user process */
 	__u32 max_qps;		/* maximum qps allowed for this user process */
 	__u32 wq_size;		/* defines the size of the WQs (sq+rq) allocated to the mmaped area */
@@ -56,7 +56,7 @@ struct i40iw_ualloc_ucontext_resp {
 };
 
 struct i40iw_ualloc_pd_resp {
-	struct ibv_alloc_pd_resp ibv_resp;
+	struct ib_uverbs_alloc_pd_resp ibv_resp;
 	__u32 pd_id;
 	__u8 reserved[4];
 };
@@ -67,7 +67,7 @@ struct i40iw_ucreate_cq {
 };
 
 struct i40iw_ucreate_cq_resp {
-	struct ibv_create_cq_resp ibv_resp;
+	struct ib_uverbs_create_cq_resp ibv_resp;
 	__u32 cq_id;
 	__u32 cq_size;
 	__u32 mmap_db_index;
@@ -95,7 +95,7 @@ struct i40iw_ucreate_qp {
 };
 
 struct i40iw_ucreate_qp_resp {
-	struct ibv_create_qp_resp ibv_resp;
+	struct ib_uverbs_create_qp_resp ibv_resp;
 	__u32 qp_id;
 	__u32 actual_sq_size;
 	__u32 actual_rq_size;
diff --git a/providers/i40iw/i40iw_uverbs.c b/providers/i40iw/i40iw_uverbs.c
index 851f1cdf4d9f9a..7cde44577985a3 100644
--- a/providers/i40iw/i40iw_uverbs.c
+++ b/providers/i40iw/i40iw_uverbs.c
@@ -153,7 +153,7 @@ struct ibv_mr *i40iw_ureg_mr(struct ibv_pd *pd, void *addr, size_t length, int a
 {
 	struct ibv_mr *mr;
 	struct i40iw_ureg_mr cmd;
-	struct ibv_reg_mr_resp resp;
+	struct ib_uverbs_reg_mr_resp resp;
 
 	mr = malloc(sizeof(*mr));
 	if (!mr)
@@ -218,7 +218,7 @@ struct ibv_cq *i40iw_ucreate_cq(struct ibv_context *context, int cqe,
 
 	struct i40iw_ureg_mr reg_mr_cmd;
 
-	struct ibv_reg_mr_resp reg_mr_resp;
+	struct ib_uverbs_reg_mr_resp reg_mr_resp;
 
 	if (cqe > I40IW_MAX_CQ_SIZE)
 		return NULL;
@@ -502,7 +502,7 @@ static int i40iw_vmapped_qp(struct i40iw_uqp *iwuqp, struct ibv_pd *pd,
 	int ret;
 	struct i40iw_ureg_mr reg_mr_cmd;
 	u32 sq_pages, rq_pages;
-	struct ibv_reg_mr_resp reg_mr_resp;
+	struct ib_uverbs_reg_mr_resp reg_mr_resp;
 
 	memset(&reg_mr_cmd, 0, sizeof(reg_mr_cmd));
 	sqsize = sqdepth * I40IW_QP_WQE_MIN_SIZE;
diff --git a/providers/ipathverbs/ipath-abi.h b/providers/ipathverbs/ipath-abi.h
index bd3cde23eacfe9..2b2e3290c5b233 100644
--- a/providers/ipathverbs/ipath-abi.h
+++ b/providers/ipathverbs/ipath-abi.h
@@ -40,27 +40,27 @@
 #include <infiniband/kern-abi.h>
 
 struct ipath_get_context_resp {
-	struct ibv_get_context_resp	ibv_resp;
+	struct ib_uverbs_get_context_resp	ibv_resp;
 	__u32				version;
 };
 
 struct ipath_create_cq_resp {
-	struct ibv_create_cq_resp	ibv_resp;
+	struct ib_uverbs_create_cq_resp	ibv_resp;
 	__u64				offset;
 };
 
 struct ipath_resize_cq_resp {
-	struct ibv_resize_cq_resp	ibv_resp;
+	struct ib_uverbs_resize_cq_resp	ibv_resp;
 	__u64				offset;
 };
 
 struct ipath_create_qp_resp {
-	struct ibv_create_qp_resp	ibv_resp;
+	struct ib_uverbs_create_qp_resp	ibv_resp;
 	__u64				offset;
 };
 
 struct ipath_create_srq_resp {
-	struct ibv_create_srq_resp	ibv_resp;
+	struct ib_uverbs_create_srq_resp	ibv_resp;
 	__u64				offset;
 };
 
diff --git a/providers/ipathverbs/ipathverbs.c b/providers/ipathverbs/ipathverbs.c
index f2c96187d8cb5d..00d84b7f84a855 100644
--- a/providers/ipathverbs/ipathverbs.c
+++ b/providers/ipathverbs/ipathverbs.c
@@ -140,7 +140,7 @@ static struct verbs_context *ipath_alloc_context(struct ibv_device *ibdev,
 {
 	struct ipath_context	    *context;
 	struct ibv_get_context       cmd;
-	struct ibv_get_context_resp  resp;
+	struct ib_uverbs_get_context_resp  resp;
 	struct ipath_device         *dev;
 
 	context = verbs_init_and_alloc_context(ibdev, cmd_fd, context, ibv_ctx);
diff --git a/providers/ipathverbs/verbs.c b/providers/ipathverbs/verbs.c
index b81a98253fa639..e0b247bf337583 100644
--- a/providers/ipathverbs/verbs.c
+++ b/providers/ipathverbs/verbs.c
@@ -81,7 +81,7 @@ int ipath_query_port(struct ibv_context *context, uint8_t port,
 struct ibv_pd *ipath_alloc_pd(struct ibv_context *context)
 {
 	struct ibv_alloc_pd	  cmd;
-	struct ibv_alloc_pd_resp  resp;
+	struct ib_uverbs_alloc_pd_resp  resp;
 	struct ibv_pd		 *pd;
 
 	pd = malloc(sizeof *pd);
@@ -114,7 +114,7 @@ struct ibv_mr *ipath_reg_mr(struct ibv_pd *pd, void *addr,
 {
 	struct ibv_mr *mr;
 	struct ibv_reg_mr cmd;
-	struct ibv_reg_mr_resp resp;
+	struct ib_uverbs_reg_mr_resp resp;
 	int ret;
 
 	mr = malloc(sizeof *mr);
@@ -184,7 +184,7 @@ struct ibv_cq *ipath_create_cq_v1(struct ibv_context *context, int cqe,
 {
 	struct ibv_cq		   *cq;
 	struct ibv_create_cq	    cmd;
-	struct ibv_create_cq_resp   resp;
+	struct ib_uverbs_create_cq_resp   resp;
 	int			    ret;
 
 	cq = malloc(sizeof *cq);
@@ -234,7 +234,7 @@ int ipath_resize_cq(struct ibv_cq *ibcq, int cqe)
 int ipath_resize_cq_v1(struct ibv_cq *ibcq, int cqe)
 {
 	struct ibv_resize_cq		cmd;
-	struct ibv_resize_cq_resp	resp;
+	struct ib_uverbs_resize_cq_resp	resp;
 
 	return ibv_cmd_resize_cq(ibcq, cqe, &cmd, sizeof cmd,
 				 &resp, sizeof resp);
@@ -341,7 +341,7 @@ struct ibv_qp *ipath_create_qp_v1(struct ibv_pd *pd,
 				  struct ibv_qp_init_attr *attr)
 {
 	struct ibv_create_qp	     cmd;
-	struct ibv_create_qp_resp    resp;
+	struct ib_uverbs_create_qp_resp    resp;
 	struct ibv_qp		    *qp;
 	int			     ret;
 
@@ -537,7 +537,7 @@ struct ibv_srq *ipath_create_srq_v1(struct ibv_pd *pd,
 {
 	struct ibv_srq *srq;
 	struct ibv_create_srq cmd;
-	struct ibv_create_srq_resp resp;
+	struct ib_uverbs_create_srq_resp resp;
 	int ret;
 
 	srq = malloc(sizeof *srq);
diff --git a/providers/mlx4/mlx4-abi.h b/providers/mlx4/mlx4-abi.h
index c4783d29e19cee..5f8ce28d70713d 100644
--- a/providers/mlx4/mlx4-abi.h
+++ b/providers/mlx4/mlx4-abi.h
@@ -45,7 +45,7 @@ enum {
 };
 
 struct mlx4_alloc_ucontext_resp_v3 {
-	struct ibv_get_context_resp	ibv_resp;
+	struct ib_uverbs_get_context_resp	ibv_resp;
 	__u32				qp_tab_size;
 	__u16				bf_reg_size;
 	__u16				bf_regs_per_page;
@@ -56,7 +56,7 @@ enum mlx4_query_dev_ex_resp_mask {
 };
 
 struct mlx4_alloc_ucontext_resp {
-	struct ibv_get_context_resp	ibv_resp;
+	struct ib_uverbs_get_context_resp	ibv_resp;
 	__u32				dev_caps;
 	__u32				qp_tab_size;
 	__u16				bf_reg_size;
@@ -65,7 +65,7 @@ struct mlx4_alloc_ucontext_resp {
 };
 
 struct mlx4_alloc_pd_resp {
-	struct ibv_alloc_pd_resp	ibv_resp;
+	struct ib_uverbs_alloc_pd_resp	ibv_resp;
 	__u32				pdn;
 	__u32				reserved;
 };
@@ -77,7 +77,7 @@ struct mlx4_create_cq {
 };
 
 struct mlx4_create_cq_resp {
-	struct ibv_create_cq_resp	ibv_resp;
+	struct ib_uverbs_create_cq_resp	ibv_resp;
 	__u32				cqn;
 	__u32				reserved;
 };
@@ -89,7 +89,7 @@ struct mlx4_create_cq_ex {
 };
 
 struct mlx4_create_cq_resp_ex {
-	struct ibv_create_cq_resp_ex	ibv_resp;
+	struct ib_uverbs_ex_create_cq_resp	ibv_resp;
 	__u32				cqn;
 	__u32				reserved;
 };
@@ -131,7 +131,7 @@ struct mlx4_create_xsrq {
 };
 
 struct mlx4_create_srq_resp {
-	struct ibv_create_srq_resp	ibv_resp;
+	struct ib_uverbs_create_srq_resp	ibv_resp;
 	__u32				srqn;
 	__u32				reserved;
 };
@@ -176,7 +176,7 @@ struct mlx4_create_qp_ex {
 };
 
 struct mlx4_create_qp_resp_ex {
-	struct ibv_create_qp_resp_ex	ibv_resp;
+	struct ib_uverbs_ex_create_qp_resp	ibv_resp;
 };
 
 struct mlx4_drv_create_wq {
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index c525aeb0b89ea8..879af38f71dffe 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -235,7 +235,7 @@ struct ibv_xrcd *mlx4_open_xrcd(struct ibv_context *context,
 				struct ibv_xrcd_init_attr *attr)
 {
 	struct ibv_open_xrcd cmd;
-	struct ibv_open_xrcd_resp resp;
+	struct ib_uverbs_close_xrcd resp;
 	struct verbs_xrcd *xrcd;
 	int ret;
 
@@ -273,7 +273,7 @@ struct ibv_mr *mlx4_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 {
 	struct ibv_mr *mr;
 	struct ibv_reg_mr cmd;
-	struct ibv_reg_mr_resp resp;
+	struct ib_uverbs_reg_mr_resp resp;
 	int ret;
 
 	mr = malloc(sizeof *mr);
@@ -297,7 +297,7 @@ int mlx4_rereg_mr(struct ibv_mr *mr,
 		  size_t length, int access)
 {
 	struct ibv_rereg_mr cmd;
-	struct ibv_rereg_mr_resp resp;
+	struct ib_uverbs_rereg_mr_resp resp;
 
 	if (flags & IBV_REREG_MR_KEEP_VALID)
 		return ENOTSUP;
@@ -325,7 +325,7 @@ struct ibv_mw *mlx4_alloc_mw(struct ibv_pd *pd, enum ibv_mw_type type)
 {
 	struct ibv_mw *mw;
 	struct ibv_alloc_mw cmd;
-	struct ibv_alloc_mw_resp resp;
+	struct ib_uverbs_alloc_mw_resp resp;
 	int ret;
 
 	mw = calloc(1, sizeof(*mw));
@@ -588,7 +588,7 @@ int mlx4_resize_cq(struct ibv_cq *ibcq, int cqe)
 {
 	struct mlx4_cq *cq = to_mcq(ibcq);
 	struct mlx4_resize_cq cmd;
-	struct ibv_resize_cq_resp resp;
+	struct ib_uverbs_resize_cq_resp resp;
 	struct mlx4_buf buf;
 	int old_cqe, outst_cqe, ret;
 
@@ -863,7 +863,7 @@ static struct ibv_qp *create_qp_ex(struct ibv_context *context,
 {
 	struct mlx4_context *ctx = to_mctx(context);
 	struct mlx4_create_qp     cmd = {};
-	struct ibv_create_qp_resp resp = {};
+	struct ib_uverbs_create_qp_resp resp = {};
 	struct mlx4_qp		 *qp;
 	int			  ret;
 
@@ -1042,7 +1042,7 @@ struct ibv_qp *mlx4_create_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 struct ibv_qp *mlx4_open_qp(struct ibv_context *context, struct ibv_qp_open_attr *attr)
 {
 	struct ibv_open_qp cmd;
-	struct ibv_create_qp_resp resp;
+	struct ib_uverbs_create_qp_resp resp;
 	struct mlx4_qp *qp;
 	int ret;
 
@@ -1398,7 +1398,7 @@ struct ibv_wq *mlx4_create_wq(struct ibv_context *context,
 {
 	struct mlx4_context		*ctx = to_mctx(context);
 	struct mlx4_create_wq		cmd = {};
-	struct ibv_create_wq_resp	resp = {};
+	struct ib_uverbs_ex_create_wq_resp	resp = {};
 	struct mlx4_qp			*qp;
 	int				ret;
 
@@ -1600,7 +1600,7 @@ struct ibv_rwq_ind_table *mlx4_create_rwq_ind_table(struct ibv_context *context,
 						    struct ibv_rwq_ind_table_init_attr *init_attr)
 {
 	struct ibv_create_rwq_ind_table *cmd;
-	struct ibv_create_rwq_ind_table_resp resp = {};
+	struct ib_uverbs_ex_create_rwq_ind_table_resp resp = {};
 	struct ibv_rwq_ind_table *ind_table;
 	uint32_t required_tbl_size;
 	unsigned int num_tbl_entries;
diff --git a/providers/mlx5/mlx5-abi.h b/providers/mlx5/mlx5-abi.h
index 7b964290d4e669..0f2db819889cf9 100644
--- a/providers/mlx5/mlx5-abi.h
+++ b/providers/mlx5/mlx5-abi.h
@@ -82,7 +82,7 @@ enum mlx5_ib_alloc_ucontext_resp_mask {
 };
 
 struct mlx5_alloc_ucontext_resp {
-	struct ibv_get_context_resp	ibv_resp;
+	struct ib_uverbs_get_context_resp	ibv_resp;
 	__u32				qp_tab_size;
 	__u32				bf_reg_size;
 	__u32				tot_uuars;
@@ -114,7 +114,7 @@ struct mlx5_create_ah_resp {
 };
 
 struct mlx5_alloc_pd_resp {
-	struct ibv_alloc_pd_resp	ibv_resp;
+	struct ib_uverbs_alloc_pd_resp	ibv_resp;
 	__u32				pdn;
 };
 
@@ -133,7 +133,7 @@ struct mlx5_create_cq {
 };
 
 struct mlx5_create_cq_resp {
-	struct ibv_create_cq_resp	ibv_resp;
+	struct ib_uverbs_create_cq_resp	ibv_resp;
 	__u32				cqn;
 };
 
@@ -145,7 +145,7 @@ struct mlx5_create_srq {
 };
 
 struct mlx5_create_srq_resp {
-	struct ibv_create_srq_resp	ibv_resp;
+	struct ib_uverbs_create_srq_resp	ibv_resp;
 	__u32				srqn;
 	__u32				reserved;
 };
@@ -190,7 +190,7 @@ struct mlx5_create_qp_ex_rss {
 };
 
 struct mlx5_create_qp_resp_ex {
-	struct ibv_create_qp_resp_ex	ibv_resp;
+	struct ib_uverbs_ex_create_qp_resp	ibv_resp;
 	__u32				uuar_index;
 	__u32				reserved;
 };
@@ -210,7 +210,7 @@ struct mlx5_create_qp {
 };
 
 struct mlx5_create_qp_resp {
-	struct ibv_create_qp_resp	ibv_resp;
+	struct ib_uverbs_create_qp_resp	ibv_resp;
 	__u32				uuar_index;
 };
 
@@ -237,7 +237,7 @@ struct mlx5_create_wq {
 };
 
 struct mlx5_create_wq_resp {
-	struct ibv_create_wq_resp	ibv_resp;
+	struct ib_uverbs_ex_create_wq_resp	ibv_resp;
 	__u32			response_length;
 	__u32			reserved;
 };
@@ -249,7 +249,7 @@ struct mlx5_modify_wq {
 };
 
 struct mlx5_create_rwq_ind_table_resp {
-	struct ibv_create_rwq_ind_table_resp ibv_resp;
+	struct ib_uverbs_ex_create_rwq_ind_table_resp ibv_resp;
 };
 
 struct mlx5_destroy_rwq_ind_table {
@@ -265,7 +265,7 @@ struct mlx5_resize_cq {
 };
 
 struct mlx5_resize_cq_resp {
-	struct ibv_resize_cq_resp	ibv_resp;
+	struct ib_uverbs_resize_cq_resp	ibv_resp;
 };
 
 struct mlx5_query_device_ex {
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index fb80561bdb242b..5f62a2b24eba81 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -373,7 +373,7 @@ struct ibv_mr *mlx5_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 	struct ibv_reg_mr cmd;
 	int ret;
 	enum ibv_access_flags access = (enum ibv_access_flags)acc;
-	struct ibv_reg_mr_resp resp;
+	struct ib_uverbs_reg_mr_resp resp;
 
 	mr = calloc(1, sizeof(*mr));
 	if (!mr)
@@ -396,7 +396,7 @@ int mlx5_rereg_mr(struct ibv_mr *ibmr, int flags, struct ibv_pd *pd, void *addr,
 		  size_t length, int access)
 {
 	struct ibv_rereg_mr cmd;
-	struct ibv_rereg_mr_resp resp;
+	struct ib_uverbs_rereg_mr_resp resp;
 
 	if (flags & IBV_REREG_MR_KEEP_VALID)
 		return ENOTSUP;
@@ -423,7 +423,7 @@ struct ibv_mw *mlx5_alloc_mw(struct ibv_pd *pd, enum ibv_mw_type type)
 {
 	struct ibv_mw *mw;
 	struct ibv_alloc_mw cmd;
-	struct ibv_alloc_mw_resp resp;
+	struct ib_uverbs_alloc_mw_resp resp;
 	int ret;
 
 	mw = malloc(sizeof(*mw));
@@ -1875,7 +1875,7 @@ int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 {
 	struct ibv_modify_qp cmd = {};
 	struct ibv_modify_qp_ex cmd_ex = {};
-	struct ibv_modify_qp_resp_ex resp = {};
+	struct ib_uverbs_ex_modify_qp_resp resp = {};
 	struct mlx5_qp *mqp = to_mqp(qp);
 	struct mlx5_context *context = to_mctx(qp->context);
 	int ret;
@@ -2106,7 +2106,7 @@ mlx5_open_xrcd(struct ibv_context *context,
 	int err;
 	struct verbs_xrcd *xrcd;
 	struct ibv_open_xrcd cmd = {};
-	struct ibv_open_xrcd_resp resp = {};
+	struct ib_uverbs_close_xrcd resp = {};
 
 	xrcd = calloc(1, sizeof(*xrcd));
 	if (!xrcd)
diff --git a/providers/mthca/mthca-abi.h b/providers/mthca/mthca-abi.h
index 4fbd98bc08c3bc..396480f267d16a 100644
--- a/providers/mthca/mthca-abi.h
+++ b/providers/mthca/mthca-abi.h
@@ -39,13 +39,13 @@
 #define MTHCA_UVERBS_ABI_VERSION	1
 
 struct mthca_alloc_ucontext_resp {
-	struct ibv_get_context_resp	ibv_resp;
+	struct ib_uverbs_get_context_resp	ibv_resp;
 	__u32				qp_tab_size;
 	__u32				uarc_size;
 };
 
 struct mthca_alloc_pd_resp {
-	struct ibv_alloc_pd_resp	ibv_resp;
+	struct ib_uverbs_alloc_pd_resp	ibv_resp;
 	__u32				pdn;
 	__u32				reserved;
 };
@@ -72,7 +72,7 @@ struct mthca_create_cq {
 };
 
 struct mthca_create_cq_resp {
-	struct ibv_create_cq_resp	ibv_resp;
+	struct ib_uverbs_create_cq_resp	ibv_resp;
 	__u32				cqn;
 	__u32				reserved;
 };
@@ -91,7 +91,7 @@ struct mthca_create_srq {
 };
 
 struct mthca_create_srq_resp {
-	struct ibv_create_srq_resp	ibv_resp;
+	struct ib_uverbs_create_srq_resp	ibv_resp;
 	__u32				srqn;
 	__u32				reserved;
 };
diff --git a/providers/mthca/verbs.c b/providers/mthca/verbs.c
index 33024be2e750d3..df132576865a05 100644
--- a/providers/mthca/verbs.c
+++ b/providers/mthca/verbs.c
@@ -119,7 +119,7 @@ static struct ibv_mr *__mthca_reg_mr(struct ibv_pd *pd, void *addr,
 {
 	struct ibv_mr *mr;
 	struct mthca_reg_mr cmd;
-	struct ibv_reg_mr_resp resp;
+	struct ib_uverbs_reg_mr_resp resp;
 	int ret;
 
 	/*
@@ -275,7 +275,7 @@ int mthca_resize_cq(struct ibv_cq *ibcq, int cqe)
 	struct mthca_resize_cq cmd;
 	struct ibv_mr *mr;
 	struct mthca_buf buf;
-	struct ibv_resize_cq_resp resp;
+	struct ib_uverbs_resize_cq_resp resp;
 	int old_cqe;
 	int ret;
 
@@ -490,7 +490,7 @@ int mthca_destroy_srq(struct ibv_srq *srq)
 struct ibv_qp *mthca_create_qp(struct ibv_pd *pd, struct ibv_qp_init_attr *attr)
 {
 	struct mthca_create_qp    cmd;
-	struct ibv_create_qp_resp resp;
+	struct ib_uverbs_create_qp_resp resp;
 	struct mthca_qp          *qp;
 	int                       ret;
 
diff --git a/providers/nes/nes-abi.h b/providers/nes/nes-abi.h
index f363f95e809b9d..3c3362a2ec5faf 100644
--- a/providers/nes/nes-abi.h
+++ b/providers/nes/nes-abi.h
@@ -48,7 +48,7 @@ struct nes_get_context {
 
 
 struct nes_ualloc_ucontext_resp {
-	struct ibv_get_context_resp ibv_resp;
+	struct ib_uverbs_get_context_resp ibv_resp;
 	__u32 max_pds; 	/* maximum pds allowed for this user process */
 	__u32 max_qps; 	/* maximum qps allowed for this user process */
 	__u32 wq_size; 	/* defines the size of the WQs (sq+rq) allocated to the mmaped area */
@@ -58,7 +58,7 @@ struct nes_ualloc_ucontext_resp {
 };
 
 struct nes_ualloc_pd_resp {
-	struct ibv_alloc_pd_resp ibv_resp;
+	struct ib_uverbs_alloc_pd_resp ibv_resp;
 	__u32 pd_id;
 	__u32 db_index;
 };
@@ -71,7 +71,7 @@ struct nes_ucreate_cq {
 };
 
 struct nes_ucreate_cq_resp {
-	struct ibv_create_cq_resp ibv_resp;
+	struct ib_uverbs_create_cq_resp ibv_resp;
 	__u32 cq_id;
 	__u32 cq_size;
 	__u32 mmap_db_index;
@@ -97,7 +97,7 @@ struct nes_ucreate_qp {
 };
 
 struct nes_ucreate_qp_resp {
-	struct ibv_create_qp_resp ibv_resp;
+	struct ib_uverbs_create_qp_resp ibv_resp;
 	__u32 qp_id;
 	__u32 actual_sq_size;
 	__u32 actual_rq_size;
diff --git a/providers/nes/nes_uverbs.c b/providers/nes/nes_uverbs.c
index 7817ccf6e75b38..a3bd65f6c743f6 100644
--- a/providers/nes/nes_uverbs.c
+++ b/providers/nes/nes_uverbs.c
@@ -170,7 +170,7 @@ struct ibv_mr *nes_ureg_mr(struct ibv_pd *pd, void *addr,
 {
 	struct ibv_mr *mr;
 	struct nes_ureg_mr cmd;
-	struct ibv_reg_mr_resp resp;
+	struct ib_uverbs_reg_mr_resp resp;
 
 	mr = malloc(sizeof *mr);
 	if (!mr)
@@ -212,7 +212,7 @@ struct ibv_cq *nes_ucreate_cq(struct ibv_context *context, int cqe,
 {
 	struct nes_ucq *nesucq;
 	struct nes_ureg_mr reg_mr_cmd;
-	struct ibv_reg_mr_resp reg_mr_resp;
+	struct ib_uverbs_reg_mr_resp reg_mr_resp;
 	struct nes_ucreate_cq cmd;
 	struct nes_ucreate_cq_resp resp;
 	int ret;
@@ -937,7 +937,7 @@ static int nes_vmapped_qp(struct nes_uqp *nesuqp, struct ibv_pd *pd, struct ibv_
 {
 	struct nes_ucreate_qp cmd;
 	struct nes_ureg_mr reg_mr_cmd;
-        struct ibv_reg_mr_resp reg_mr_resp;
+	struct ib_uverbs_reg_mr_resp reg_mr_resp;
 	int totalqpsize;
 	int ret;
 
diff --git a/providers/ocrdma/ocrdma_abi.h b/providers/ocrdma/ocrdma_abi.h
index e43e30aa7817d0..f45707632a5a7f 100644
--- a/providers/ocrdma/ocrdma_abi.h
+++ b/providers/ocrdma/ocrdma_abi.h
@@ -66,7 +66,7 @@ struct ocrdma_get_context {
 };
 
 struct ocrdma_alloc_ucontext_resp {
-	struct ibv_get_context_resp ibv_resp;
+	struct ib_uverbs_get_context_resp ibv_resp;
 	uint32_t dev_id;
 	uint32_t wqe_size;
 	uint32_t max_inline_data;
@@ -85,7 +85,7 @@ struct ocrdma_alloc_pd_req {
 };
 
 struct ocrdma_alloc_pd_resp {
-	struct ibv_alloc_pd_resp ibv_resp;
+	struct ib_uverbs_alloc_pd_resp ibv_resp;
 	uint32_t id;
 	uint32_t dpp_enabled;
 	uint32_t dpp_page_addr_hi;
@@ -101,7 +101,7 @@ struct ocrdma_create_cq_req {
 
 #define MAX_CQ_PAGES 8
 struct ocrdma_create_cq_resp {
-	struct ibv_create_cq_resp ibv_resp;
+	struct ib_uverbs_create_cq_resp ibv_resp;
 	uint32_t cq_id;
 	uint32_t size;
 	uint32_t num_pages;
@@ -119,7 +119,7 @@ struct ocrdma_reg_mr {
 };
 
 struct ocrdma_reg_mr_resp {
-	struct ibv_reg_mr_resp ibv_resp;
+	struct ib_uverbs_reg_mr_resp ibv_resp;
 };
 
 struct ocrdma_create_qp_cmd {
@@ -134,7 +134,7 @@ struct ocrdma_create_qp_cmd {
 #define MAX_UD_HDR_PAGES 8
 
 struct ocrdma_create_qp_uresp {
-	struct ibv_create_qp_resp ibv_resp;
+	struct ib_uverbs_create_qp_resp ibv_resp;
 	uint16_t qp_id;
 	uint16_t sq_dbid;
 	uint16_t rq_dbid;
@@ -162,7 +162,7 @@ struct ocrdma_create_srq_cmd {
 };
 
 struct ocrdma_create_srq_resp {
-	struct ibv_create_srq_resp ibv_resp;
+	struct ib_uverbs_create_srq_resp ibv_resp;
 	uint16_t rq_dbid;
 	uint16_t resv0;
 	uint32_t resv1;
diff --git a/providers/ocrdma/ocrdma_verbs.c b/providers/ocrdma/ocrdma_verbs.c
index 6f140c33dbe509..5b8da32b1bdcdd 100644
--- a/providers/ocrdma/ocrdma_verbs.c
+++ b/providers/ocrdma/ocrdma_verbs.c
@@ -308,7 +308,7 @@ int ocrdma_resize_cq(struct ibv_cq *ibcq, int new_entries)
 {
 	int status;
 	struct ibv_resize_cq cmd;
-	struct ibv_resize_cq_resp resp;
+	struct ib_uverbs_resize_cq_resp resp;
 	status = ibv_cmd_resize_cq(ibcq, new_entries,
 				   &cmd, sizeof cmd, &resp, sizeof resp);
 	if (status == 0)
diff --git a/providers/qedr/qelr_abi.h b/providers/qedr/qelr_abi.h
index a7a0638e9f838e..95c880b6ab80a4 100644
--- a/providers/qedr/qelr_abi.h
+++ b/providers/qedr/qelr_abi.h
@@ -42,7 +42,7 @@ struct qelr_get_context {
 };
 
 struct qelr_alloc_ucontext_resp {
-	struct ibv_get_context_resp ibv_resp;	/* must be first */
+	struct ib_uverbs_get_context_resp ibv_resp;	/* must be first */
 	__u64 db_pa;
 	__u32 db_size;
 
@@ -60,7 +60,7 @@ struct qelr_alloc_pd_req {
 };
 
 struct qelr_alloc_pd_resp {
-	struct ibv_alloc_pd_resp ibv_resp;	/* must be first */
+	struct ib_uverbs_alloc_pd_resp ibv_resp;	/* must be first */
 	__u32 pd_id;
 };
 
@@ -72,7 +72,7 @@ struct qelr_create_cq_req {
 };
 
 struct qelr_create_cq_resp {
-	struct ibv_create_cq_resp ibv_resp;	/* must be first */
+	struct ib_uverbs_create_cq_resp ibv_resp;	/* must be first */
 	__u32 db_offset;
 	__u16 icid;
 };
@@ -82,7 +82,7 @@ struct qelr_reg_mr {
 };
 
 struct qelr_reg_mr_resp {
-	struct ibv_reg_mr_resp ibv_resp;	/* must be first */
+	struct ib_uverbs_reg_mr_resp ibv_resp;	/* must be first */
 };
 
 struct qelr_create_qp_req {
@@ -101,7 +101,7 @@ struct qelr_create_qp_req {
 };
 
 struct qelr_create_qp_resp {
-	struct ibv_create_qp_resp ibv_resp;	/* must be first */
+	struct ib_uverbs_create_qp_resp ibv_resp;	/* must be first */
 
 	__u32 qp_id;
 	__u32 atomic_supported;
diff --git a/providers/rxe/rxe-abi.h b/providers/rxe/rxe-abi.h
index 18e45a38356ccd..72b8438dbf6009 100644
--- a/providers/rxe/rxe-abi.h
+++ b/providers/rxe/rxe-abi.h
@@ -44,28 +44,28 @@ struct mmap_info {
 };
 
 struct rxe_get_context_resp {
-	struct ibv_get_context_resp ibv_resp;
+	struct ib_uverbs_get_context_resp ibv_resp;
 	__u32 version;
 };
 
 struct rxe_create_cq_resp {
-	struct ibv_create_cq_resp ibv_resp;
+	struct ib_uverbs_create_cq_resp ibv_resp;
 	struct mmap_info mi;
 };
 
 struct rxe_resize_cq_resp {
-	struct ibv_resize_cq_resp ibv_resp;
+	struct ib_uverbs_resize_cq_resp ibv_resp;
 	struct mmap_info mi;
 };
 
 struct rxe_create_qp_resp {
-	struct ibv_create_qp_resp ibv_resp;
+	struct ib_uverbs_create_qp_resp ibv_resp;
 	struct mmap_info rq_mi;
 	struct mmap_info sq_mi;
 };
 
 struct rxe_create_srq_resp {
-	struct ibv_create_srq_resp ibv_resp;
+	struct ib_uverbs_create_srq_resp ibv_resp;
 	struct mmap_info mi;
 	__u32 srq_num;
 };
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index 2856afc48cc243..ebdef7a73e83a6 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -97,7 +97,7 @@ static int rxe_query_port(struct ibv_context *context, uint8_t port,
 static struct ibv_pd *rxe_alloc_pd(struct ibv_context *context)
 {
 	struct ibv_alloc_pd cmd;
-	struct ibv_alloc_pd_resp resp;
+	struct ib_uverbs_alloc_pd_resp resp;
 	struct ibv_pd *pd;
 
 	pd = malloc(sizeof *pd);
@@ -128,7 +128,7 @@ static struct ibv_mr *rxe_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 {
 	struct ibv_mr *mr;
 	struct ibv_reg_mr cmd;
-	struct ibv_reg_mr_resp resp;
+	struct ib_uverbs_reg_mr_resp resp;
 	int ret;
 
 	mr = malloc(sizeof *mr);
@@ -670,7 +670,7 @@ static int post_one_send(struct rxe_qp *qp, struct rxe_wq *sq,
 static int post_send_db(struct ibv_qp *ibqp)
 {
 	struct ibv_post_send cmd;
-	struct ibv_post_send_resp resp;
+	struct ib_uverbs_post_send_resp resp;
 
 	cmd.command	= IB_USER_VERBS_CMD_POST_SEND;
 	cmd.in_words	= sizeof(cmd)/4;
@@ -862,7 +862,7 @@ static struct verbs_context *rxe_alloc_context(struct ibv_device *ibdev,
 {
 	struct rxe_context *context;
 	struct ibv_get_context cmd;
-	struct ibv_get_context_resp resp;
+	struct ib_uverbs_get_context_resp resp;
 
 	context = verbs_init_and_alloc_context(ibdev, cmd_fd, context, ibv_ctx);
 	if (!context)
diff --git a/providers/vmw_pvrdma/pvrdma-abi-fix.h b/providers/vmw_pvrdma/pvrdma-abi-fix.h
index 8ff9d7cececa55..7c028aeb6b7972 100644
--- a/providers/vmw_pvrdma/pvrdma-abi-fix.h
+++ b/providers/vmw_pvrdma/pvrdma-abi-fix.h
@@ -50,12 +50,12 @@
 #include <rdma/vmw_pvrdma-abi.h>
 
 struct user_pvrdma_alloc_ucontext_resp {
-	struct ibv_get_context_resp		ibv_resp;
+	struct ib_uverbs_get_context_resp		ibv_resp;
 	struct pvrdma_alloc_ucontext_resp	udata;
 };
 
 struct user_pvrdma_alloc_pd_resp {
-	struct ibv_alloc_pd_resp	ibv_resp;
+	struct ib_uverbs_alloc_pd_resp	ibv_resp;
 	struct pvrdma_alloc_pd_resp	udata;
 };
 
@@ -65,7 +65,7 @@ struct user_pvrdma_create_cq {
 };
 
 struct user_pvrdma_create_cq_resp {
-	struct ibv_create_cq_resp	ibv_resp;
+	struct ib_uverbs_create_cq_resp	ibv_resp;
 	struct pvrdma_create_cq_resp	udata;
 };
 
@@ -75,7 +75,7 @@ struct user_pvrdma_create_srq {
 };
 
 struct user_pvrdma_create_srq_resp {
-	struct ibv_create_srq_resp	ibv_resp;
+	struct ib_uverbs_create_srq_resp	ibv_resp;
 	struct pvrdma_create_srq_resp	udata;
 };
 
diff --git a/providers/vmw_pvrdma/qp.c b/providers/vmw_pvrdma/qp.c
index 25b4841b2f2a0c..34c8020793c8a1 100644
--- a/providers/vmw_pvrdma/qp.c
+++ b/providers/vmw_pvrdma/qp.c
@@ -108,7 +108,7 @@ struct ibv_srq *pvrdma_create_srq(struct ibv_pd *pd,
 {
 	struct pvrdma_device *dev = to_vdev(pd->context->device);
 	struct user_pvrdma_create_srq cmd;
-	struct ibv_create_srq_resp resp;
+	struct ib_uverbs_create_srq_resp resp;
 	struct pvrdma_srq *srq;
 	int ret;
 
@@ -211,7 +211,7 @@ struct ibv_qp *pvrdma_create_qp(struct ibv_pd *pd,
 {
 	struct pvrdma_device *dev = to_vdev(pd->context->device);
 	struct user_pvrdma_create_qp cmd;
-	struct ibv_create_qp_resp resp;
+	struct ib_uverbs_create_qp_resp resp;
 	struct pvrdma_qp *qp;
 	int ret;
 	int is_srq = !!(attr->srq);
diff --git a/providers/vmw_pvrdma/verbs.c b/providers/vmw_pvrdma/verbs.c
index a32046b5caab0b..b1ba0d652c1cf2 100644
--- a/providers/vmw_pvrdma/verbs.c
+++ b/providers/vmw_pvrdma/verbs.c
@@ -116,7 +116,7 @@ struct ibv_mr *pvrdma_reg_mr(struct ibv_pd *pd, void *addr, size_t length,
 {
 	struct ibv_mr *mr;
 	struct ibv_reg_mr cmd;
-	struct ibv_reg_mr_resp resp;
+	struct ib_uverbs_reg_mr_resp resp;
 	int ret;
 
 	mr = malloc(sizeof(*mr));
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
