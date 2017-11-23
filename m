From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/3] verbs: Add support in RSS of the inner packet
Date: Thu, 23 Nov 2017 15:53:24 +0200
Message-ID: <1511445206-18951-2-git-send-email-yishaih@mellanox.com>
References: <1511445206-18951-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1511445206-18951-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Some user space application would like to do RSS on the inner packet
fields instead of the outer. When user will set the IBV_RX_HASH_INNER
bit with one of the other hash fields, then the RSS will be on the inner
packet.

Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_create_qp_ex.3 | 21 +++++++++++++++++++++
 libibverbs/verbs.h                |  7 ++++++-
 2 files changed, 27 insertions(+), 1 deletion(-)

diff --git a/libibverbs/man/ibv_create_qp_ex.3 b/libibverbs/man/ibv_create_qp_ex.3
index 865b5fe..e7f8a49 100644
--- a/libibverbs/man/ibv_create_qp_ex.3
+++ b/libibverbs/man/ibv_create_qp_ex.3
@@ -72,6 +72,27 @@ uint64_t               rx_hash_fields_mask;    /* RX fields that should particip
 .in -8
 };
 .fi
+
+.nf
+enum ibv_rx_hash_fields {
+.in +8
+IBV_RX_HASH_SRC_IPV4            = 1 << 0,
+IBV_RX_HASH_DST_IPV4            = 1 << 1,
+IBV_RX_HASH_SRC_IPV6            = 1 << 2,
+IBV_RX_HASH_DST_IPV6            = 1 << 3,
+IBV_RX_HASH_SRC_PORT_TCP        = 1 << 4,
+IBV_RX_HASH_DST_PORT_TCP        = 1 << 5,
+IBV_RX_HASH_SRC_PORT_UDP        = 1 << 6,
+IBV_RX_HASH_DST_PORT_UDP        = 1 << 7,
+.in -8
+};
+
+/* When set with one of the L3/L4 fields,
+ * then the RSS will be applied on the inner packet. */
+#define IBV_RX_HASH_INNER       = (1ULL << 31)
+
+.fi
+
 .PP
 The function
 .B ibv_create_qp_ex()
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index ce18b50..dcfe94e 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -241,9 +241,14 @@ enum ibv_rx_hash_fields {
 	IBV_RX_HASH_SRC_PORT_TCP	= 1 << 4,
 	IBV_RX_HASH_DST_PORT_TCP	= 1 << 5,
 	IBV_RX_HASH_SRC_PORT_UDP	= 1 << 6,
-	IBV_RX_HASH_DST_PORT_UDP	= 1 << 7
+	IBV_RX_HASH_DST_PORT_UDP	= 1 << 7,
 };
 
+/* In some systems/compilers enum range might be limited
+ * to signed 4 bytes.
+ */
+#define IBV_RX_HASH_INNER (1ULL << 31)
+
 struct ibv_rss_caps {
 	uint32_t supported_qpts;
 	uint32_t max_rwq_indirection_tables;
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
