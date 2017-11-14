From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 2/2] verbs: Enable QP and WQ creation with PCI write end padding option
Date: Tue, 14 Nov 2017 15:47:08 +0200
Message-ID: <1510667228-18579-3-git-send-email-yishaih@mellanox.com>
References: <1510667228-18579-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1510667228-18579-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Update QP and WQ creation flags to allow setting the PCI write end
padding capability during QP/WQ creation.

Man pages were updated accordingly.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c                  | 3 ++-
 libibverbs/man/ibv_create_qp_ex.3 | 1 +
 libibverbs/man/ibv_create_wq.3    | 3 ++-
 libibverbs/verbs.h                | 4 +++-
 4 files changed, 8 insertions(+), 3 deletions(-)

diff --git a/libibverbs/cmd.c b/libibverbs/cmd.c
index eb5f263..62fcd0e 100644
--- a/libibverbs/cmd.c
+++ b/libibverbs/cmd.c
@@ -966,7 +966,8 @@ enum {
 	CREATE_QP_EX2_SUP_CREATE_FLAGS = IBV_QP_CREATE_BLOCK_SELF_MCAST_LB |
 					 IBV_QP_CREATE_SCATTER_FCS |
 					 IBV_QP_CREATE_CVLAN_STRIPPING |
-					 IBV_QP_CREATE_SOURCE_QPN,
+					 IBV_QP_CREATE_SOURCE_QPN |
+					 IBV_QP_CREATE_PCI_WRITE_END_PADDING,
 };
 
 int ibv_cmd_create_qp_ex2(struct ibv_context *context,
diff --git a/libibverbs/man/ibv_create_qp_ex.3 b/libibverbs/man/ibv_create_qp_ex.3
index fac0e03..865b5fe 100644
--- a/libibverbs/man/ibv_create_qp_ex.3
+++ b/libibverbs/man/ibv_create_qp_ex.3
@@ -59,6 +59,7 @@ IBV_QP_CREATE_BLOCK_SELF_MCAST_LB       = 1 << 1, /* Prevent self multicast loop
 IBV_QP_CREATE_SCATTER_FCS               = 1 << 8, /* FCS field will be scattered to host memory */
 IBV_QP_CREATE_CVLAN_STRIPPING           = 1 << 9, /* CVLAN field will be stripped from incoming packets */
 IBV_QP_CREATE_SOURCE_QPN                = 1 << 10, /* The created QP will use the source_qpn as its wire QP number */
+IBV_QP_CREATE_PCI_WRITE_END_PADDING     = 1 << 11, /* Incoming packets will be padded to cacheline size */
 .in -8
 };
 .nf
diff --git a/libibverbs/man/ibv_create_wq.3 b/libibverbs/man/ibv_create_wq.3
index a540130..10fe965 100644
--- a/libibverbs/man/ibv_create_wq.3
+++ b/libibverbs/man/ibv_create_wq.3
@@ -42,7 +42,8 @@ enum ibv_wq_flags {
 IBV_WQ_FLAGS_CVLAN_STRIPPING            = 1 << 0, /* CVLAN field will be stripped from incoming packets */
 IBV_WQ_FLAGS_SCATTER_FCS                = 1 << 1, /* FCS field will be scattered to host memory */
 IBV_WQ_FLAGS_DELAY_DROP                 = 1 << 2, /* Packets won't be dropped immediately if no receive WQEs */
-IBV_WQ_FLAGS_RESERVED                   = 1 << 3,
+IBV_WQ_FLAGS_PCI_WRITE_END_PADDING      = 1 << 3, /* Incoming packets will be padded to cacheline size */
+IBV_WQ_FLAGS_RESERVED                   = 1 << 4,
 .in -8
 };
 .nf
diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 025e321..b39dc30 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -739,7 +739,8 @@ enum ibv_wq_flags {
 	IBV_WQ_FLAGS_CVLAN_STRIPPING		= 1 << 0,
 	IBV_WQ_FLAGS_SCATTER_FCS		= 1 << 1,
 	IBV_WQ_FLAGS_DELAY_DROP			= 1 << 2,
-	IBV_WQ_FLAGS_RESERVED			= 1 << 3,
+	IBV_WQ_FLAGS_PCI_WRITE_END_PADDING	= 1 << 3,
+	IBV_WQ_FLAGS_RESERVED			= 1 << 4,
 };
 
 struct ibv_wq_init_attr {
@@ -848,6 +849,7 @@ enum ibv_qp_create_flags {
 	IBV_QP_CREATE_SCATTER_FCS		= 1 << 8,
 	IBV_QP_CREATE_CVLAN_STRIPPING		= 1 << 9,
 	IBV_QP_CREATE_SOURCE_QPN		= 1 << 10,
+	IBV_QP_CREATE_PCI_WRITE_END_PADDING	= 1 << 11,
 };
 
 struct ibv_rx_hash_conf {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
