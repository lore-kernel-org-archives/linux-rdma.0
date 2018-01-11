From: Jason Gunthorpe <jgg-uk2M96/98Pc@public.gmane.org>
Subject: [PATCH rdma-core 12/17] verbs: Use kernel uapi header for ibv_kern_send_wr
Date: Thu, 11 Jan 2018 15:13:35 -0700
Message-ID: <20180111221340.965-13-jgg@ziepe.ca>
References: <20180111221340.965-1-jgg@ziepe.ca>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180111221340.965-1-jgg-uk2M96/98Pc@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The kern_wc is slightly different, and the kernel API version is
missing a be32 (patch going to Linux separately)

The unused and curious qp_type.xrc.remote_srqn is deleted.

Signed-off-by: Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 buildlib/fixup-include/rdma-ib_user_verbs.h |  2 +-
 libibverbs/cmd.c                            |  6 ++---
 libibverbs/kern-abi.h                       | 35 +----------------------------
 3 files changed, 5 insertions(+), 38 deletions(-)

diff --git a/buildlib/fixup-include/rdma-ib_user_verbs.h b/buildlib/fixup-include/rdma-ib_user_verbs.h
index 0573c0bb9fd059..fd035641cf41ce 100644
--- a/buildlib/fixup-include/rdma-ib_user_verbs.h
+++ b/buildlib/fixup-include/rdma-ib_user_verbs.h
@@ -765,7 +765,7 @@ struct ib_uverbs_send_wr {
 	__u32 opcode;
 	__u32 send_flags;
 	union {
-		__u32 imm_data;
+		__be32 imm_data;
 		__u32 invalidate_rkey;
 	} ex;
 	union {
diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 51366f05cfc9c5..99e94233f320d1 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -1413,7 +1413,7 @@ int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	struct ibv_post_send     *cmd;
 	struct ib_uverbs_post_send_resp resp;
 	struct ibv_send_wr       *i;
-	struct ibv_kern_send_wr  *n, *tmp;
+	struct ib_uverbs_send_wr  *n, *tmp;
 	struct ibv_sge           *s;
 	unsigned                  wr_count = 0;
 	unsigned                  sge_count = 0;
@@ -1434,7 +1434,7 @@ int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 	cmd->sge_count = sge_count;
 	cmd->wqe_size  = sizeof *n;
 
-	n = (struct ibv_kern_send_wr *) ((void *) cmd + sizeof *cmd);
+	n = (struct ib_uverbs_send_wr *) ((void *) cmd + sizeof *cmd);
 	s = (struct ibv_sge *) (n + wr_count);
 
 	tmp = n;
@@ -1443,7 +1443,7 @@ int ibv_cmd_post_send(struct ibv_qp *ibqp, struct ibv_send_wr *wr,
 		tmp->num_sge 	= i->num_sge;
 		tmp->opcode 	= i->opcode;
 		tmp->send_flags = i->send_flags;
-		tmp->imm_data 	= i->imm_data;
+		tmp->ex.imm_data = i->imm_data;
 		if (ibqp->qp_type == IBV_QPT_UD) {
 			tmp->wr.ud.ah 	       = i->wr.ud.ah->handle;
 			tmp->wr.ud.remote_qpn  = i->wr.ud.remote_qpn;
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 5d332f7b22c3f7..6284d0e45e9784 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -395,39 +395,6 @@ struct ibv_destroy_qp {
 	__u32 reserved;
 };
 
-struct ibv_kern_send_wr {
-	__u64 wr_id;
-	__u32 num_sge;
-	__u32 opcode;
-	__u32 send_flags;
-	__be32 imm_data;
-	union {
-		struct {
-			__u64 remote_addr;
-			__u32 rkey;
-			__u32 reserved;
-		} rdma;
-		struct {
-			__u64 remote_addr;
-			__u64 compare_add;
-			__u64 swap;
-			__u32 rkey;
-			__u32 reserved;
-		} atomic;
-		struct {
-			__u32 ah;
-			__u32 remote_qpn;
-			__u32 remote_qkey;
-			__u32 reserved;
-		} ud;
-	} wr;
-	union {
-		struct {
-			__u32 remote_srqn;
-		} xrc;
-	} qp_type;
-};
-
 struct ibv_kern_spec_eth {
 	__u32 type;
 	__u16  size;
@@ -522,7 +489,7 @@ struct ibv_post_send {
 	__u32 wr_count;
 	__u32 sge_count;
 	__u32 wqe_size;
-	struct ibv_kern_send_wr send_wr[0];
+	struct ib_uverbs_send_wr send_wr[0];
 };
 
 struct ibv_post_recv {
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
