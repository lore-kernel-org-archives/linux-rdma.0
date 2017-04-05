From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 4/5] ibverbs: Add support for reading flow tag from a CQ
Date: Wed,  5 Apr 2017 18:19:23 +0300
Message-ID: <1491405564-19735-5-git-send-email-yishaih@mellanox.com>
References: <1491405564-19735-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1491405564-19735-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Each steering flow may be marked with a tag which exposed in the
completion. Extend the poll_cq_ex mechanism with read_flow_tag callback
which reads the flow tag from the work completion.

Signed-off-by: Moses Reuben <mosesr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_create_cq_ex.3 |  4 ++++
 libibverbs/verbs.h                | 10 +++++++++-
 2 files changed, 13 insertions(+), 1 deletion(-)

diff --git a/libibverbs/man/ibv_create_cq_ex.3 b/libibverbs/man/ibv_create_cq_ex.3
index 020bbb4..7dfbef2 100644
--- a/libibverbs/man/ibv_create_cq_ex.3
+++ b/libibverbs/man/ibv_create_cq_ex.3
@@ -42,6 +42,7 @@ enum ibv_wc_flags_ex {
         IBV_WC_EX_WITH_DLID_PATH_BITS        = 1 << 6,  /* Require dlid path bits in WC */
         IBV_WC_EX_WITH_COMPLETION_TIMESTAMP  = 1 << 7,  /* Require completion timestamp in WC /*
         IBV_WC_EX_WITH_CVLAN                 = 1 << 8,  /* Require VLAN info in WC */
+        IBV_WC_EX_WITH_FLOW_TAG		     = 1 << 9,  /* Require flow tag in WC */
 };
 
 enum ibv_cq_init_attr_mask {
@@ -133,6 +134,9 @@ Below members and functions are used in order to poll the current completion. Th
 .BI "uint16_t ibv_wc_read_cvlan(struct ibv_cq_ex " "*cq"); \c
  Get the CVLAN field from the current completion.
 
+.BI "uint32_t ibv_wc_read_flow_tag(struct ibv_cq_ex " "*cq"); \c
+ Get flow tag from the current completion.
+
 .SH "RETURN VALUE"
 .B ibv_create_cq_ex()
 returns a pointer to the CQ, or NULL if the request fails.
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 5a4dcbc..b27dfd1 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -437,6 +437,7 @@ enum ibv_create_cq_wc_flags {
 	IBV_WC_EX_WITH_DLID_PATH_BITS	= 1 << 6,
 	IBV_WC_EX_WITH_COMPLETION_TIMESTAMP	= 1 << 7,
 	IBV_WC_EX_WITH_CVLAN		= 1 << 8,
+	IBV_WC_EX_WITH_FLOW_TAG		= 1 << 9,
 };
 
 enum {
@@ -452,7 +453,8 @@ enum {
 enum {
 	IBV_CREATE_CQ_SUP_WC_FLAGS = IBV_WC_STANDARD_FLAGS |
 				IBV_WC_EX_WITH_COMPLETION_TIMESTAMP |
-				IBV_WC_EX_WITH_CVLAN
+				IBV_WC_EX_WITH_CVLAN |
+				IBV_WC_EX_WITH_FLOW_TAG
 };
 
 enum ibv_wc_flags {
@@ -1100,6 +1102,7 @@ struct ibv_cq_ex {
 	uint8_t (*read_dlid_path_bits)(struct ibv_cq_ex *current);
 	uint64_t (*read_completion_ts)(struct ibv_cq_ex *current);
 	uint16_t (*read_cvlan)(struct ibv_cq_ex *current);
+	uint32_t (*read_flow_tag)(struct ibv_cq_ex *current);
 };
 
 static inline struct ibv_cq *ibv_cq_ex_to_cq(struct ibv_cq_ex *cq)
@@ -1183,6 +1186,11 @@ static inline uint16_t ibv_wc_read_cvlan(struct ibv_cq_ex *cq)
 	return cq->read_cvlan(cq);
 }
 
+static inline uint32_t ibv_wc_read_flow_tag(struct ibv_cq_ex *cq)
+{
+	return cq->read_flow_tag(cq);
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
