From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core] rdma: Handle uninitialized data for ibv_cmd_modify_qp
Date: Tue, 10 Jan 2017 19:24:30 +0200
Message-ID: <1484069070-17174-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Instead of checking per field whether wasn't set then use explicit = 0,
go over the providers and initialize their input command by using = {}.

This comes as a pre-patch before introducing the ibv_cmd_modify_qp_ex
which will do the same.

The above drops the need to add an extra 'zeroing' code each time
when a new field is introduced.

This improves commit 77fbb25e4c2a1f99d812752f85a28978ece32fe0 as pointed
above.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c                 | 47 +---------------------------------------
 providers/cxgb3/verbs.c          |  2 +-
 providers/cxgb4/qp.c             |  2 +-
 providers/cxgb4/verbs.c          |  2 +-
 providers/hfi1verbs/verbs.c      |  2 +-
 providers/hns/hns_roce_u_hw_v1.c |  2 +-
 providers/i40iw/i40iw_uverbs.c   |  2 +-
 providers/ipathverbs/verbs.c     |  2 +-
 providers/mlx4/verbs.c           |  2 +-
 providers/mlx5/verbs.c           |  2 +-
 providers/mthca/verbs.c          |  2 +-
 providers/nes/nes_uverbs.c       |  2 +-
 providers/ocrdma/ocrdma_verbs.c  |  2 +-
 providers/qedr/qelr_verbs.c      |  2 +-
 providers/rxe/rxe.c              |  2 +-
 15 files changed, 15 insertions(+), 60 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index a702d67..36faf59 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1226,35 +1226,18 @@ int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 
 	if (attr_mask & IBV_QP_STATE)
 		cmd->qp_state = attr->qp_state;
-	else
-		cmd->qp_state = 0;
-
 	if (attr_mask & IBV_QP_CUR_STATE)
 		cmd->cur_qp_state = attr->cur_qp_state;
-	else
-		cmd->cur_qp_state = 0;
-
 	if (attr_mask & IBV_QP_EN_SQD_ASYNC_NOTIFY)
 		cmd->en_sqd_async_notify = attr->en_sqd_async_notify;
-	else
-		cmd->en_sqd_async_notify = 0;
-
 	if (attr_mask & IBV_QP_ACCESS_FLAGS)
 		cmd->qp_access_flags = attr->qp_access_flags;
-	else
-		cmd->qp_access_flags = 0;
 	if (attr_mask & IBV_QP_PKEY_INDEX)
 		cmd->pkey_index = attr->pkey_index;
-	else
-		cmd->pkey_index = 0;
 	if (attr_mask & IBV_QP_PORT)
 		cmd->port_num = attr->port_num;
-	else
-		cmd->port_num = 0;
 	if (attr_mask & IBV_QP_QKEY)
 		cmd->qkey = attr->qkey;
-	else
-		cmd->qkey = 0;
 
 	if (attr_mask & IBV_QP_AV) {
 		memcpy(cmd->dest.dgid, attr->ah_attr.grh.dgid.raw, 16);
@@ -1269,33 +1252,20 @@ int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		cmd->dest.static_rate = attr->ah_attr.static_rate;
 		cmd->dest.is_global = attr->ah_attr.is_global;
 		cmd->dest.port_num = attr->ah_attr.port_num;
-	} else
-		memset(&cmd->dest, 0, sizeof(cmd->dest));
+	}
 
 	if (attr_mask & IBV_QP_PATH_MTU)
 		cmd->path_mtu = attr->path_mtu;
-	else
-		cmd->path_mtu = 0;
 	if (attr_mask & IBV_QP_TIMEOUT)
 		cmd->timeout = attr->timeout;
-	else
-		cmd->timeout = 0;
 	if (attr_mask & IBV_QP_RETRY_CNT)
 		cmd->retry_cnt = attr->retry_cnt;
-	else
-		cmd->retry_cnt = 0;
 	if (attr_mask & IBV_QP_RNR_RETRY)
 		cmd->rnr_retry = attr->rnr_retry;
-	else
-		cmd->rnr_retry = 0;
 	if (attr_mask & IBV_QP_RQ_PSN)
 		cmd->rq_psn = attr->rq_psn;
-	else
-		cmd->rq_psn = 0;
 	if (attr_mask & IBV_QP_MAX_QP_RD_ATOMIC)
 		cmd->max_rd_atomic = attr->max_rd_atomic;
-	else
-		cmd->max_rd_atomic = 0;
 
 	if (attr_mask & IBV_QP_ALT_PATH) {
 		cmd->alt_pkey_index = attr->alt_pkey_index;
@@ -1315,33 +1285,18 @@ int ibv_cmd_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		cmd->alt_dest.static_rate = attr->alt_ah_attr.static_rate;
 		cmd->alt_dest.is_global = attr->alt_ah_attr.is_global;
 		cmd->alt_dest.port_num = attr->alt_ah_attr.port_num;
-	} else {
-		cmd->alt_pkey_index = 0;
-		cmd->alt_port_num = 0;
-		cmd->alt_timeout = 0;
-		memset(&cmd->alt_dest, 0, sizeof(cmd->alt_dest));
 	}
 
 	if (attr_mask & IBV_QP_MIN_RNR_TIMER)
 		cmd->min_rnr_timer = attr->min_rnr_timer;
-	else
-		cmd->min_rnr_timer = 0;
 	if (attr_mask & IBV_QP_SQ_PSN)
 		cmd->sq_psn = attr->sq_psn;
-	else
-		cmd->sq_psn = 0;
 	if (attr_mask & IBV_QP_MAX_DEST_RD_ATOMIC)
 		cmd->max_dest_rd_atomic = attr->max_dest_rd_atomic;
-	else
-		cmd->max_dest_rd_atomic = 0;
 	if (attr_mask & IBV_QP_PATH_MIG_STATE)
 		cmd->path_mig_state = attr->path_mig_state;
-	else
-		cmd->path_mig_state = 0;
 	if (attr_mask & IBV_QP_DEST_QPN)
 		cmd->dest_qp_num = attr->dest_qp_num;
-	else
-		cmd->dest_qp_num = 0;
 
 	cmd->reserved[0] = cmd->reserved[1] = 0;
 
diff --git a/providers/cxgb3/verbs.c b/providers/cxgb3/verbs.c
index 0cb78d7..79112a5 100644
--- a/providers/cxgb3/verbs.c
+++ b/providers/cxgb3/verbs.c
@@ -376,7 +376,7 @@ static void reset_qp(struct iwch_qp *qhp)
 int iwch_modify_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
 		   int attr_mask)
 {
-	struct ibv_modify_qp cmd;
+	struct ibv_modify_qp cmd = {};
 	struct iwch_qp *qhp = to_iwch_qp(ibqp);
 	int ret;
 
diff --git a/providers/cxgb4/qp.c b/providers/cxgb4/qp.c
index 3b448dd..700fe02 100644
--- a/providers/cxgb4/qp.c
+++ b/providers/cxgb4/qp.c
@@ -269,7 +269,7 @@ static int build_rdma_recv(struct c4iw_qp *qhp, union t4_recv_wr *wqe,
 
 static void ring_kernel_db(struct c4iw_qp *qhp, u32 qid, u16 idx)
 {
-	struct ibv_modify_qp cmd;
+	struct ibv_modify_qp cmd = {};
 	struct ibv_qp_attr attr;
 	int mask;
 	int __attribute__((unused)) ret;
diff --git a/providers/cxgb4/verbs.c b/providers/cxgb4/verbs.c
index 70d250f..32ed44c 100644
--- a/providers/cxgb4/verbs.c
+++ b/providers/cxgb4/verbs.c
@@ -579,7 +579,7 @@ static void reset_qp(struct c4iw_qp *qhp)
 int c4iw_modify_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
 		   int attr_mask)
 {
-	struct ibv_modify_qp cmd;
+	struct ibv_modify_qp cmd = {};
 	struct c4iw_qp *qhp = to_c4iw_qp(ibqp);
 	int ret;
 
diff --git a/providers/hfi1verbs/verbs.c b/providers/hfi1verbs/verbs.c
index 06ddbb7..6590951 100644
--- a/providers/hfi1verbs/verbs.c
+++ b/providers/hfi1verbs/verbs.c
@@ -396,7 +396,7 @@ int hfi1_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 int hfi1_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		    int attr_mask)
 {
-	struct ibv_modify_qp cmd;
+	struct ibv_modify_qp cmd = {};
 
 	return ibv_cmd_modify_qp(qp, attr, attr_mask, &cmd, sizeof cmd);
 }
diff --git a/providers/hns/hns_roce_u_hw_v1.c b/providers/hns/hns_roce_u_hw_v1.c
index e5cfe48..ff39593 100644
--- a/providers/hns/hns_roce_u_hw_v1.c
+++ b/providers/hns/hns_roce_u_hw_v1.c
@@ -642,7 +642,7 @@ static int hns_roce_u_v1_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 				   int attr_mask)
 {
 	int ret;
-	struct ibv_modify_qp cmd;
+	struct ibv_modify_qp cmd = {};
 	struct hns_roce_qp *hr_qp = to_hr_qp(qp);
 
 	ret = ibv_cmd_modify_qp(qp, attr, attr_mask, &cmd, sizeof(cmd));
diff --git a/providers/i40iw/i40iw_uverbs.c b/providers/i40iw/i40iw_uverbs.c
index 4a868ea..b132112 100644
--- a/providers/i40iw/i40iw_uverbs.c
+++ b/providers/i40iw/i40iw_uverbs.c
@@ -754,7 +754,7 @@ int i40iw_uquery_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr, int attr_mask,
  */
 int i40iw_umodify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr, int attr_mask)
 {
-	struct ibv_modify_qp cmd;
+	struct ibv_modify_qp cmd = {};
 
 	return ibv_cmd_modify_qp(qp, attr, attr_mask, &cmd, sizeof(cmd));
 }
diff --git a/providers/ipathverbs/verbs.c b/providers/ipathverbs/verbs.c
index 35b2162..6388560 100644
--- a/providers/ipathverbs/verbs.c
+++ b/providers/ipathverbs/verbs.c
@@ -372,7 +372,7 @@ int ipath_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 int ipath_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		    int attr_mask)
 {
-	struct ibv_modify_qp cmd;
+	struct ibv_modify_qp cmd = {};
 
 	return ibv_cmd_modify_qp(qp, attr, attr_mask, &cmd, sizeof cmd);
 }
diff --git a/providers/mlx4/verbs.c b/providers/mlx4/verbs.c
index 50a4434..21ec1d1 100644
--- a/providers/mlx4/verbs.c
+++ b/providers/mlx4/verbs.c
@@ -773,7 +773,7 @@ int mlx4_query_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
 int mlx4_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		    int attr_mask)
 {
-	struct ibv_modify_qp cmd;
+	struct ibv_modify_qp cmd = {};
 	struct ibv_port_attr port_attr;
 	struct mlx4_qp *mqp = to_mqp(qp);
 	struct ibv_device_attr device_attr;
diff --git a/providers/mlx5/verbs.c b/providers/mlx5/verbs.c
index e288ebf..ae68c84 100644
--- a/providers/mlx5/verbs.c
+++ b/providers/mlx5/verbs.c
@@ -1501,7 +1501,7 @@ int mlx5_query_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
 int mlx5_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		   int attr_mask)
 {
-	struct ibv_modify_qp cmd;
+	struct ibv_modify_qp cmd = {};
 	struct mlx5_qp *mqp = to_mqp(qp);
 	struct mlx5_context *context = to_mctx(qp->context);
 	int ret;
diff --git a/providers/mthca/verbs.c b/providers/mthca/verbs.c
index 60dd440..044d6b7 100644
--- a/providers/mthca/verbs.c
+++ b/providers/mthca/verbs.c
@@ -613,7 +613,7 @@ int mthca_query_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 int mthca_modify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
 		    int attr_mask)
 {
-	struct ibv_modify_qp cmd;
+	struct ibv_modify_qp cmd = {};
 	int ret;
 
 	ret = ibv_cmd_modify_qp(qp, attr, attr_mask, &cmd, sizeof cmd);
diff --git a/providers/nes/nes_uverbs.c b/providers/nes/nes_uverbs.c
index 7e7bb90..867c39e 100644
--- a/providers/nes/nes_uverbs.c
+++ b/providers/nes/nes_uverbs.c
@@ -1106,7 +1106,7 @@ int nes_uquery_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr,
  */
 int nes_umodify_qp(struct ibv_qp *qp, struct ibv_qp_attr *attr, int attr_mask)
 {
-	struct ibv_modify_qp cmd;
+	struct ibv_modify_qp cmd = {};
 	return ibv_cmd_modify_qp(qp, attr, attr_mask, &cmd, sizeof cmd);
 }
 
diff --git a/providers/ocrdma/ocrdma_verbs.c b/providers/ocrdma/ocrdma_verbs.c
index 7e066dc..37e9d18 100644
--- a/providers/ocrdma/ocrdma_verbs.c
+++ b/providers/ocrdma/ocrdma_verbs.c
@@ -831,7 +831,7 @@ static int ocrdma_qp_state_machine(struct ocrdma_qp *qp,
 int ocrdma_modify_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
 		     int attr_mask)
 {
-	struct ibv_modify_qp cmd;
+	struct ibv_modify_qp cmd = {};
 	struct ocrdma_qp *qp = get_ocrdma_qp(ibqp);
 	int status;
 
diff --git a/providers/qedr/qelr_verbs.c b/providers/qedr/qelr_verbs.c
index 793b1f4..a7c4503 100644
--- a/providers/qedr/qelr_verbs.c
+++ b/providers/qedr/qelr_verbs.c
@@ -763,7 +763,7 @@ static int qelr_update_qp_state(struct qelr_qp *qp,
 int qelr_modify_qp(struct ibv_qp *ibqp, struct ibv_qp_attr *attr,
 		     int attr_mask)
 {
-	struct ibv_modify_qp cmd;
+	struct ibv_modify_qp cmd = {};
 	struct qelr_qp *qp = get_qelr_qp(ibqp);
 	struct qelr_devctx *cxt = get_qelr_ctx(ibqp->context);
 	int rc;
diff --git a/providers/rxe/rxe.c b/providers/rxe/rxe.c
index d23ef3d..f9bbb72 100644
--- a/providers/rxe/rxe.c
+++ b/providers/rxe/rxe.c
@@ -506,7 +506,7 @@ static int rxe_modify_qp(struct ibv_qp *ibvqp,
 			 struct ibv_qp_attr *attr,
 			 int attr_mask)
 {
-	struct ibv_modify_qp cmd;
+	struct ibv_modify_qp cmd = {};
 
 	return ibv_cmd_modify_qp(ibvqp, attr, attr_mask, &cmd, sizeof cmd);
 }
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
