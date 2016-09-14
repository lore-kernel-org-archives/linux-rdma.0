From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 libibverbs 3/7] Extend create QP to get a Receive Work Queue indirection table
Date: Wed, 14 Sep 2016 16:56:24 +0300
Message-ID: <1473861388-22064-4-git-send-email-yishaih@mellanox.com>
References: <1473861388-22064-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1473861388-22064-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Extend create QP to get a Receive Work Queue indirection table,
this is needed to enable RSS on some set of Receive Work Queues.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/kern-abi.h |  6 ++++++
 include/infiniband/verbs.h    |  4 +++-
 src/cmd.c                     | 28 +++++++++++++++++++++++-----
 3 files changed, 32 insertions(+), 6 deletions(-)

diff --git a/include/infiniband/kern-abi.h b/include/infiniband/kern-abi.h
index 674045b..9f7964e 100644
--- a/include/infiniband/kern-abi.h
+++ b/include/infiniband/kern-abi.h
@@ -657,11 +657,17 @@ struct ibv_create_qp_resp {
 	__u32 reserved;
 };
 
+enum ibv_create_qp_ex_kernel_mask {
+	IBV_CREATE_QP_EX_KERNEL_MASK_IND_TABLE = 1 << 0,
+};
+
 struct ibv_create_qp_ex {
 	struct ex_hdr	hdr;
 	struct ibv_create_qp_common base;
 	__u32 comp_mask;
 	__u32 create_flags;
+	__u32 ind_tbl_handle;
+	__u32 reserved1;
 };
 
 struct ibv_create_qp_resp_ex {
diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 491e254..284bac5 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -712,7 +712,8 @@ enum ibv_qp_init_attr_mask {
 	IBV_QP_INIT_ATTR_XRCD		= 1 << 1,
 	IBV_QP_INIT_ATTR_CREATE_FLAGS	= 1 << 2,
 	IBV_QP_INIT_ATTR_MAX_TSO_HEADER = 1 << 3,
-	IBV_QP_INIT_ATTR_RESERVED	= 1 << 4
+	IBV_QP_INIT_ATTR_IND_TABLE	= 1 << 4,
+	IBV_QP_INIT_ATTR_RESERVED	= 1 << 5
 };
 
 enum ibv_qp_create_flags {
@@ -734,6 +735,7 @@ struct ibv_qp_init_attr_ex {
 	struct ibv_xrcd	       *xrcd;
 	uint32_t                create_flags;
 	uint16_t		max_tso_header;
+	struct ibv_rwq_ind_table       *rwq_ind_tbl;
 };
 
 enum ibv_qp_open_attr_mask {
diff --git a/src/cmd.c b/src/cmd.c
index 11f5de9..21f972a 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -830,12 +830,22 @@ static int create_qp_ex_common(struct verbs_qp *qp,
 			return EINVAL;
 
 		cmd->pd_handle	= qp_attr->pd->handle;
-		cmd->send_cq_handle = qp_attr->send_cq->handle;
+		if (qp_attr->comp_mask & IBV_QP_INIT_ATTR_IND_TABLE) {
+			if (cmd->max_recv_wr || cmd->max_recv_sge ||
+			    cmd->recv_cq_handle || qp_attr->srq)
+				return EINVAL;
+
+			/* send_cq is optinal */
+			if (qp_attr->cap.max_send_wr)
+				cmd->send_cq_handle = qp_attr->send_cq->handle;
+		} else {
+			cmd->send_cq_handle = qp_attr->send_cq->handle;
 
-		if (qp_attr->qp_type != IBV_QPT_XRC_SEND) {
-			cmd->recv_cq_handle = qp_attr->recv_cq->handle;
-			cmd->srq_handle = qp_attr->srq ? qp_attr->srq->handle :
-							 0;
+			if (qp_attr->qp_type != IBV_QPT_XRC_SEND) {
+				cmd->recv_cq_handle = qp_attr->recv_cq->handle;
+				cmd->srq_handle = qp_attr->srq ? qp_attr->srq->handle :
+								 0;
+			}
 		}
 	}
 
@@ -933,6 +943,14 @@ int ibv_cmd_create_qp_ex2(struct ibv_context *context,
 		cmd->create_flags = qp_attr->create_flags;
 	}
 
+	if (qp_attr->comp_mask & IBV_QP_INIT_ATTR_IND_TABLE) {
+		if (cmd_core_size < offsetof(struct ibv_create_qp_ex, ind_tbl_handle) +
+				    sizeof(cmd->ind_tbl_handle))
+			return EINVAL;
+		cmd->ind_tbl_handle = qp_attr->rwq_ind_tbl->ind_tbl_handle;
+		cmd->comp_mask = IBV_CREATE_QP_EX_KERNEL_MASK_IND_TABLE;
+	}
+
 	err = write(context->cmd_fd, cmd, cmd_size);
 	if (err != cmd_size)
 		return errno;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
