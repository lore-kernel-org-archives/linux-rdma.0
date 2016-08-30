From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 4/7] Extend create QP to get RX hash data
Date: Tue, 30 Aug 2016 18:09:53 +0300
Message-ID: <1472569796-26162-5-git-send-email-yishaih@mellanox.com>
References: <1472569796-26162-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1472569796-26162-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Extend create QP to get RX hash data, this is needed
to enable RSS based on some RX configuration.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 37 ++++++++++++++++++++++++++++++++++++-
 1 file changed, 36 insertions(+), 1 deletion(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index 284bac5..88ac4bb 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -214,6 +214,30 @@ struct ibv_tso_caps {
 	uint32_t supported_qpts;
 };
 
+/* RX Hash function flags */
+enum ibv_rx_hash_function_flags {
+	IBV_RX_HASH_FUNC_TOEPLITZ	= 1 << 0,
+};
+
+/*
+ * RX Hash fields enable to set which incoming packet's field should
+ * participates in RX Hash. Each flag represent certain packet's field,
+ * when the flag is set the field that is represented by the flag will
+ * participate in RX Hash calculation.
+ * Note: *IPV4 and *IPV6 flags can't be enabled together on the same QP
+ * and *TCP and *UDP flags can't be enabled together on the same QP.
+*/
+enum ibv_rx_hash_fields {
+	IBV_RX_HASH_SRC_IPV4	= 1 << 0,
+	IBV_RX_HASH_DST_IPV4	= 1 << 1,
+	IBV_RX_HASH_SRC_IPV6	= 1 << 2,
+	IBV_RX_HASH_DST_IPV6	= 1 << 3,
+	IBV_RX_HASH_SRC_PORT_TCP	= 1 << 4,
+	IBV_RX_HASH_DST_PORT_TCP	= 1 << 5,
+	IBV_RX_HASH_SRC_PORT_UDP	= 1 << 6,
+	IBV_RX_HASH_DST_PORT_UDP	= 1 << 7
+};
+
 struct ibv_device_attr_ex {
 	struct ibv_device_attr	orig_attr;
 	uint32_t		comp_mask;
@@ -713,7 +737,8 @@ enum ibv_qp_init_attr_mask {
 	IBV_QP_INIT_ATTR_CREATE_FLAGS	= 1 << 2,
 	IBV_QP_INIT_ATTR_MAX_TSO_HEADER = 1 << 3,
 	IBV_QP_INIT_ATTR_IND_TABLE	= 1 << 4,
-	IBV_QP_INIT_ATTR_RESERVED	= 1 << 5
+	IBV_QP_INIT_ATTR_RX_HASH	= 1 << 5,
+	IBV_QP_INIT_ATTR_RESERVED	= 1 << 6
 };
 
 enum ibv_qp_create_flags {
@@ -721,6 +746,15 @@ enum ibv_qp_create_flags {
 	IBV_QP_CREATE_SCATTER_FCS		= 1 << 8,
 };
 
+struct ibv_rx_hash_conf {
+	/* enum ibv_rx_hash_function_flags */
+	uint8_t	rx_hash_function;
+	uint8_t	rx_hash_key_len;
+	uint8_t	*rx_hash_key;
+	/* enum ibv_rx_hash_fields */
+	uint64_t	rx_hash_fields_mask;
+};
+
 struct ibv_qp_init_attr_ex {
 	void		       *qp_context;
 	struct ibv_cq	       *send_cq;
@@ -736,6 +770,7 @@ struct ibv_qp_init_attr_ex {
 	uint32_t                create_flags;
 	uint16_t		max_tso_header;
 	struct ibv_rwq_ind_table       *rwq_ind_tbl;
+	struct ibv_rx_hash_conf	rx_hash_conf;
 };
 
 enum ibv_qp_open_attr_mask {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
