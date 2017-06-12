From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 3/5] verbs: Tag matching list manipulation interface
Date: Mon, 12 Jun 2017 09:42:45 +0300
Message-ID: <1497249767-15353-4-git-send-email-artemyko@mellanox.com>
References: <1497249767-15353-1-git-send-email-artemyko@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497249767-15353-1-git-send-email-artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, anag-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

TM-SRQ shows demand of robust offload configuration primitive.
This patch introduced a new verb named ibv_post_srq_ops() to supply an
API to perform such operations like tag matching list manipulations.

Change-Id: I9fd8df2152b12f06b6b1545afec9ea1a259c0f58
Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h | 58 +++++++++++++++++++++++++++++++++++++++++++++++++++---
 1 file changed, 55 insertions(+), 3 deletions(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 120471a..42d7967 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -420,7 +420,8 @@ enum ibv_wc_status {
 	IBV_WC_INV_EEC_STATE_ERR,
 	IBV_WC_FATAL_ERR,
 	IBV_WC_RESP_TIMEOUT_ERR,
-	IBV_WC_GENERAL_ERR
+	IBV_WC_GENERAL_ERR,
+	IBV_WC_TM_ERR
 };
 const char *ibv_wc_status_str(enum ibv_wc_status status);
 
@@ -438,7 +439,11 @@ enum ibv_wc_opcode {
  * receive by testing (opcode & IBV_WC_RECV).
  */
 	IBV_WC_RECV			= 1 << 7,
-	IBV_WC_RECV_RDMA_WITH_IMM
+	IBV_WC_RECV_RDMA_WITH_IMM,
+
+	IBV_WC_TM_ADD,
+	IBV_WC_TM_DEL,
+	IBV_WC_TM_SYNC
 };
 
 enum {
@@ -479,7 +484,8 @@ enum ibv_wc_flags {
 	IBV_WC_GRH		= 1 << 0,
 	IBV_WC_WITH_IMM		= 1 << 1,
 	IBV_WC_IP_CSUM_OK	= 1 << IBV_WC_IP_CSUM_OK_SHIFT,
-	IBV_WC_WITH_INV         = 1 << 3
+	IBV_WC_WITH_INV		= 1 << 3,
+	IBV_WC_TM_SYNC_REQ	= 1 << 4
 };
 
 struct ibv_wc {
@@ -1011,6 +1017,35 @@ struct ibv_recv_wr {
 	int			num_sge;
 };
 
+enum ibv_ops_wr_opcode {
+	IBV_WR_TAG_ADD,
+	IBV_WR_TAG_DEL,
+	IBV_WR_TAG_SYNC
+};
+
+enum ibv_ops_flags {
+	IBV_OPS_SIGNALED = 1 << 0,
+	IBV_OPS_TM_SYNC  = 1 << 1
+};
+
+struct ibv_ops_wr {
+	uint64_t				wr_id;
+	struct ibv_ops_wr		       *next;
+	enum ibv_ops_wr_opcode			opcode;
+	int					flags;
+	struct {
+		uint32_t			unexpected_cnt;
+		uint32_t			handle;
+		struct {
+			uint64_t		recv_wr_id;
+			struct ibv_sge	       *sg_list;
+			int			num_sge;
+			uint64_t		tag;
+			uint64_t		mask;
+		} add;
+	} tm;
+};
+
 struct ibv_mw_bind {
 	uint64_t		wr_id;
 	int			send_flags;
@@ -1540,6 +1575,9 @@ enum verbs_context_mask {
 
 struct verbs_context {
 	/*  "grows up" - new fields go here */
+	int (*post_srq_ops)(struct ibv_srq *srq,
+			    struct ibv_ops_wr *op,
+			    struct ibv_ops_wr **bad_op);
 	int (*destroy_rwq_ind_table)(struct ibv_rwq_ind_table *rwq_ind_table);
 	struct ibv_rwq_ind_table *(*create_rwq_ind_table)(struct ibv_context *context,
 							  struct ibv_rwq_ind_table_init_attr *init_attr);
@@ -2038,6 +2076,20 @@ static inline int ibv_post_srq_recv(struct ibv_srq *srq,
 	return srq->context->ops.post_srq_recv(srq, recv_wr, bad_recv_wr);
 }
 
+static inline int ibv_post_srq_ops(struct ibv_srq *srq,
+				   struct ibv_ops_wr *op,
+				   struct ibv_ops_wr **bad_op)
+{
+	struct verbs_context *vctx;
+
+	vctx = verbs_get_ctx_op(srq->context, post_srq_ops);
+	if (!vctx) {
+		*bad_op = op;
+		return ENOSYS;
+	}
+	return vctx->post_srq_ops(srq, op, bad_op);
+}
+
 /**
  * ibv_create_qp - Create a queue pair.
  */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
