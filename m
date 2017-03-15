From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 4/6] ibverbs: Add an option to poll cvlan value from a CQ
Date: Wed, 15 Mar 2017 17:27:44 +0200
Message-ID: <1489591666-14062-5-git-send-email-yishaih@mellanox.com>
References: <1489591666-14062-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489591666-14062-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When a WQ or a QP is created with cvlan stripping option, it is
stripped from the incoming packet and included in the work
completion.
Extend the poll_cq_ex mechanism with a function that reads the
stripped cvlan value from the work completion.

In addition, as a part of introcuding the new functionality in the
man page, align it with current code (typo fix, add a missing field).

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih@mellanox>
---
 libibverbs/man/ibv_create_cq_ex.3 |  9 +++++++--
 libibverbs/verbs.h                | 10 +++++++++-
 2 files changed, 16 insertions(+), 3 deletions(-)

diff --git a/libibverbs/man/ibv_create_cq_ex.3 b/libibverbs/man/ibv_create_cq_ex.3
index a6ae769..020bbb4 100644
--- a/libibverbs/man/ibv_create_cq_ex.3
+++ b/libibverbs/man/ibv_create_cq_ex.3
@@ -17,10 +17,10 @@ creates a completion queue (CQ) for RDMA device context
 .I context\fR.
 The argument
 .I cq_attr
-is a pointer to struct ibv_create_cq_attr_ex as defined in <infiniband/verbs.h>.
+is a pointer to struct ibv_cq_init_attr_ex as defined in <infiniband/verbs.h>.
 .PP
 .nf
-struct ibv_create_cq_attr_ex {
+struct ibv_cq_init_attr_ex {
 .in +8
 int                     cqe;               /* Minimum number of entries required for CQ */
 void                    *cq_context;       /* Consumer-supplied context returned for completion events */
@@ -28,6 +28,7 @@ struct ibv_comp_channel *channel;          /* Completion channel where completio
 int                     comp_vector;       /* Completion vector used to signal completion events. Must be >= 0 and < context->num_comp_vectors. */
 uint64_t                wc_flags;          /* The wc_flags that should be returned in ibv_poll_cq_ex. Or'ed bit of enum ibv_wc_flags_ex. */
 uint32_t                comp_mask;         /* compatibility mask (extended verb). */
+uint32_t                flags              /* One or more flags from enum ibv_create_cq_attr_flags */
 .in -8
 };
 
@@ -40,6 +41,7 @@ enum ibv_wc_flags_ex {
         IBV_WC_EX_WITH_SL                    = 1 << 5,  /* Require sl in WC */
         IBV_WC_EX_WITH_DLID_PATH_BITS        = 1 << 6,  /* Require dlid path bits in WC */
         IBV_WC_EX_WITH_COMPLETION_TIMESTAMP  = 1 << 7,  /* Require completion timestamp in WC /*
+        IBV_WC_EX_WITH_CVLAN                 = 1 << 8,  /* Require VLAN info in WC */
 };
 
 enum ibv_cq_init_attr_mask {
@@ -128,6 +130,9 @@ Below members and functions are used in order to poll the current completion. Th
 .BI "uint64_t ibv_wc_read_completion_ts(struct ibv_cq_ex " "*cq"); \c
  Get the completion timestamp from the current completion.
 
+.BI "uint16_t ibv_wc_read_cvlan(struct ibv_cq_ex " "*cq"); \c
+ Get the CVLAN field from the current completion.
+
 .SH "RETURN VALUE"
 .B ibv_create_cq_ex()
 returns a pointer to the CQ, or NULL if the request fails.
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index c9084ea..15e93b3 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -435,6 +435,7 @@ enum ibv_create_cq_wc_flags {
 	IBV_WC_EX_WITH_SL		= 1 << 5,
 	IBV_WC_EX_WITH_DLID_PATH_BITS	= 1 << 6,
 	IBV_WC_EX_WITH_COMPLETION_TIMESTAMP	= 1 << 7,
+	IBV_WC_EX_WITH_CVLAN		= 1 << 8,
 };
 
 enum {
@@ -449,7 +450,8 @@ enum {
 
 enum {
 	IBV_CREATE_CQ_SUP_WC_FLAGS = IBV_WC_STANDARD_FLAGS |
-				IBV_WC_EX_WITH_COMPLETION_TIMESTAMP
+				IBV_WC_EX_WITH_COMPLETION_TIMESTAMP |
+				IBV_WC_EX_WITH_CVLAN
 };
 
 enum ibv_wc_flags {
@@ -1092,6 +1094,7 @@ struct ibv_cq_ex {
 	uint8_t (*read_sl)(struct ibv_cq_ex *current);
 	uint8_t (*read_dlid_path_bits)(struct ibv_cq_ex *current);
 	uint64_t (*read_completion_ts)(struct ibv_cq_ex *current);
+	uint16_t (*read_cvlan)(struct ibv_cq_ex *current);
 };
 
 static inline struct ibv_cq *ibv_cq_ex_to_cq(struct ibv_cq_ex *cq)
@@ -1170,6 +1173,11 @@ static inline uint64_t ibv_wc_read_completion_ts(struct ibv_cq_ex *cq)
 	return cq->read_completion_ts(cq);
 }
 
+static inline uint16_t ibv_wc_read_cvlan(struct ibv_cq_ex *cq)
+{
+	return cq->read_cvlan(cq);
+}
+
 static inline int ibv_post_wq_recv(struct ibv_wq *wq,
 				   struct ibv_recv_wr *recv_wr,
 				   struct ibv_recv_wr **bad_recv_wr)
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
