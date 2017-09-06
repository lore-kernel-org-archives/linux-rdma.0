From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 1/3] verbs: Enable creating QP with a given source QP number
Date: Wed,  6 Sep 2017 17:38:47 +0300
Message-ID: <1504708729-15249-2-git-send-email-yishaih@mellanox.com>
References: <1504708729-15249-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1504708729-15249-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Enable QP creation with a given source QP number.
The created QP will use the source QPN as its wire QP number.

This comes as a pre-patch for downstream patches in this series to
allow user space applications to accelerate traffic which is
typically handled by IPoIB ULP.

In the IPoIB use case, the source QPN can be achieved by using some
networking tool as of ifconfig, ip link show on the interface and use
the value of 3 bytes from the hardware address starting after the first
byte.

Signed-off-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c                  | 6 +++++-
 libibverbs/kern-abi.h             | 2 +-
 libibverbs/man/ibv_create_qp_ex.3 | 1 +
 libibverbs/verbs.h                | 2 ++
 4 files changed, 9 insertions(+), 2 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index 7a266ee..9d2140f 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -927,7 +927,8 @@ static void create_qp_handle_resp_common(struct ibv_context *context,
 enum {
 	CREATE_QP_EX2_SUP_CREATE_FLAGS = IBV_QP_CREATE_BLOCK_SELF_MCAST_LB |
 					 IBV_QP_CREATE_SCATTER_FCS |
-					 IBV_QP_CREATE_CVLAN_STRIPPING,
+					 IBV_QP_CREATE_CVLAN_STRIPPING |
+					 IBV_QP_CREATE_SOURCE_QPN,
 };
 
 int ibv_cmd_create_qp_ex2(struct ibv_context *context,
@@ -967,6 +968,9 @@ int ibv_cmd_create_qp_ex2(struct ibv_context *context,
 				    sizeof(qp_attr->create_flags))
 			return EINVAL;
 		cmd->create_flags = qp_attr->create_flags;
+
+		if (qp_attr->create_flags & IBV_QP_CREATE_SOURCE_QPN)
+			cmd->source_qpn = qp_attr->source_qpn;
 	}
 
 	if (qp_attr->comp_mask & IBV_QP_INIT_ATTR_IND_TABLE) {
diff --git a/libibverbs/kern-abi.h b/libibverbs/kern-abi.h
index 8d42faf..3a0e02a 100644
--- a/libibverbs/kern-abi.h
+++ b/libibverbs/kern-abi.h
@@ -679,7 +679,7 @@ struct ibv_create_qp_ex {
 	__u32 comp_mask;
 	__u32 create_flags;
 	__u32 ind_tbl_handle;
-	__u32 reserved1;
+	__u32 source_qpn;
 };
 
 struct ibv_create_qp_resp_ex {
diff --git a/libibverbs/man/ibv_create_qp_ex.3 b/libibverbs/man/ibv_create_qp_ex.3
index 99ae497..3272c09 100644
--- a/libibverbs/man/ibv_create_qp_ex.3
+++ b/libibverbs/man/ibv_create_qp_ex.3
@@ -38,6 +38,7 @@ enum ibv_qp_create_flags create_flags;	/* Creation flags for this QP */
 uint16_t                max_tso_header; /* Maximum TSO header size */
 struct ibv_rwq_ind_table *rwq_ind_tbl;  /* Indirection table to be associated with the QP */
 struct ibv_rx_hash_conf  rx_hash_conf;  /* RX hash configuration to be used */
+uint32_t                source_qpn;     /* Source QP number, creation flag IBV_QP_CREATE_SOURCE_QPN should be set */
 .in -8
 };
 .sp
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 922a011..3c8b2c9 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -790,6 +790,7 @@ enum ibv_qp_create_flags {
 	IBV_QP_CREATE_BLOCK_SELF_MCAST_LB	= 1 << 1,
 	IBV_QP_CREATE_SCATTER_FCS		= 1 << 8,
 	IBV_QP_CREATE_CVLAN_STRIPPING		= 1 << 9,
+	IBV_QP_CREATE_SOURCE_QPN		= 1 << 10,
 };
 
 struct ibv_rx_hash_conf {
@@ -817,6 +818,7 @@ struct ibv_qp_init_attr_ex {
 	uint16_t		max_tso_header;
 	struct ibv_rwq_ind_table       *rwq_ind_tbl;
 	struct ibv_rx_hash_conf	rx_hash_conf;
+	uint32_t		source_qpn;
 };
 
 enum ibv_qp_open_attr_mask {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
