From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 3/6] ibverbs: Allow creation of QP with cvlan stripping offload
Date: Wed, 15 Mar 2017 17:27:43 +0200
Message-ID: <1489591666-14062-4-git-send-email-yishaih@mellanox.com>
References: <1489591666-14062-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489591666-14062-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Allow users to create a QP that uses cvlan stripping capabilities if
supported by the hardware.

Setting cvlan stripping offload will cause the device to strip the
cvlan from incoming raw Ethernet packets and provide its data in the
matching work completion.

In addition, aligned ibv_create_qp_ex's man page with current code
(added ibv_qp_create_flags enum).

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c                  | 3 ++-
 libibverbs/man/ibv_create_qp_ex.3 | 8 ++++++++
 libibverbs/verbs.h                | 1 +
 3 files changed, 11 insertions(+), 1 deletion(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index b8fe76d..06ec671 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -926,7 +926,8 @@ static void create_qp_handle_resp_common(struct ibv_context *context,
 
 enum {
 	CREATE_QP_EX2_SUP_CREATE_FLAGS = IBV_QP_CREATE_BLOCK_SELF_MCAST_LB |
-		IBV_QP_CREATE_SCATTER_FCS,
+					 IBV_QP_CREATE_SCATTER_FCS |
+					 IBV_QP_CREATE_CVLAN_STRIPPING,
 };
 
 int ibv_cmd_create_qp_ex2(struct ibv_context *context,
diff --git a/libibverbs/man/ibv_create_qp_ex.3 b/libibverbs/man/ibv_create_qp_ex.3
index c778d15..99ae497 100644
--- a/libibverbs/man/ibv_create_qp_ex.3
+++ b/libibverbs/man/ibv_create_qp_ex.3
@@ -52,6 +52,14 @@ uint32_t                max_inline_data;/* Requested max number of data (bytes)
 .in -8
 };
 .nf
+enum ibv_qp_create_flags {
+.in +8
+IBV_QP_CREATE_BLOCK_SELF_MCAST_LB       = 1 << 1, /* Prevent self multicast loopback */
+IBV_QP_CREATE_SCATTER_FCS               = 1 << 8, /* FCS field will be scattered to host memory */
+IBV_QP_CREATE_CVLAN_STRIPPING           = 1 << 9, /* CVLAN field will be stripped from incoming packets */
+.in -8
+};
+.nf
 struct ibv_rx_hash_conf {
 .in +8
 uint8_t                rx_hash_function;       /* RX hash function, use enum ibv_rx_hash_function_flags */
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 3398566..c9084ea 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -780,6 +780,7 @@ enum ibv_qp_init_attr_mask {
 enum ibv_qp_create_flags {
 	IBV_QP_CREATE_BLOCK_SELF_MCAST_LB	= 1 << 1,
 	IBV_QP_CREATE_SCATTER_FCS		= 1 << 8,
+	IBV_QP_CREATE_CVLAN_STRIPPING		= 1 << 9,
 };
 
 struct ibv_rx_hash_conf {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
