From: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC 5/5] verbs: Tag matching receive interface
Date: Mon, 12 Jun 2017 09:42:47 +0300
Message-ID: <1497249767-15353-6-git-send-email-artemyko@mellanox.com>
References: <1497249767-15353-1-git-send-email-artemyko@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1497249767-15353-1-git-send-email-artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, yosefe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, anag-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Extending poll_cq with tag matching support.
New read function named ibv_wc_read_tm_info was added to read
additional TM related information from CQE.

Change-Id: Ia5bae6732d03ce6d12d731fdd675a2668e258934
Signed-off-by: Artemy Kovalyov <artemyko-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h | 28 ++++++++++++++++++++++++----
 1 file changed, 24 insertions(+), 4 deletions(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 42d7967..0c5be05 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -421,7 +421,8 @@ enum ibv_wc_status {
 	IBV_WC_FATAL_ERR,
 	IBV_WC_RESP_TIMEOUT_ERR,
 	IBV_WC_GENERAL_ERR,
-	IBV_WC_TM_ERR
+	IBV_WC_TM_ERR,
+	IBV_WC_TM_RNDV_INCOMPLETE
 };
 const char *ibv_wc_status_str(enum ibv_wc_status status);
 
@@ -443,7 +444,9 @@ enum ibv_wc_opcode {
 
 	IBV_WC_TM_ADD,
 	IBV_WC_TM_DEL,
-	IBV_WC_TM_SYNC
+	IBV_WC_TM_SYNC,
+	IBV_WC_TM_RECV,
+	IBV_WC_TM_NO_TAG
 };
 
 enum {
@@ -461,6 +464,7 @@ enum ibv_create_cq_wc_flags {
 	IBV_WC_EX_WITH_COMPLETION_TIMESTAMP	= 1 << 7,
 	IBV_WC_EX_WITH_CVLAN		= 1 << 8,
 	IBV_WC_EX_WITH_FLOW_TAG		= 1 << 9,
+	IBV_WC_EX_WITH_TM_INFO		= 1 << 10
 };
 
 enum {
@@ -477,7 +481,8 @@ enum {
 	IBV_CREATE_CQ_SUP_WC_FLAGS = IBV_WC_STANDARD_FLAGS |
 				IBV_WC_EX_WITH_COMPLETION_TIMESTAMP |
 				IBV_WC_EX_WITH_CVLAN |
-				IBV_WC_EX_WITH_FLOW_TAG
+				IBV_WC_EX_WITH_FLOW_TAG |
+				IBV_WC_EX_WITH_TM_INFO
 };
 
 enum ibv_wc_flags {
@@ -485,7 +490,9 @@ enum ibv_wc_flags {
 	IBV_WC_WITH_IMM		= 1 << 1,
 	IBV_WC_IP_CSUM_OK	= 1 << IBV_WC_IP_CSUM_OK_SHIFT,
 	IBV_WC_WITH_INV		= 1 << 3,
-	IBV_WC_TM_SYNC_REQ	= 1 << 4
+	IBV_WC_TM_SYNC_REQ	= 1 << 4,
+	IBV_WC_TM_MATCH		= 1 << 5,
+	IBV_WC_TM_DATA_VALID	= 1 << 6
 };
 
 struct ibv_wc {
@@ -1132,6 +1139,11 @@ struct ibv_poll_cq_attr {
 	uint32_t comp_mask;
 };
 
+struct ibv_wc_tm_info {
+	uint64_t		tag;	 /* Tag information */
+	uint32_t		priv;	 /* Application context */
+};
+
 struct ibv_cq_ex {
 	struct ibv_context     *context;
 	struct ibv_comp_channel *channel;
@@ -1164,6 +1176,8 @@ struct ibv_cq_ex {
 	uint64_t (*read_completion_ts)(struct ibv_cq_ex *current);
 	uint16_t (*read_cvlan)(struct ibv_cq_ex *current);
 	uint32_t (*read_flow_tag)(struct ibv_cq_ex *current);
+	void (*read_tm_info)(struct ibv_cq_ex *current,
+			     struct ibv_wc_tm_info *tm_info);
 };
 
 static inline struct ibv_cq *ibv_cq_ex_to_cq(struct ibv_cq_ex *cq)
@@ -1252,6 +1266,12 @@ static inline uint32_t ibv_wc_read_flow_tag(struct ibv_cq_ex *cq)
 	return cq->read_flow_tag(cq);
 }
 
+static inline void ibv_wc_read_tm_info(struct ibv_cq_ex *cq,
+				       struct ibv_wc_tm_info *tm_info)
+{
+	cq->read_tm_info(cq, tm_info);
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
