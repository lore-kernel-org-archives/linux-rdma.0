From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 3/7] ibverbs: Allow creation of QP with cvlan stripping offload
Date: Tue, 14 Mar 2017 13:15:39 +0200
Message-ID: <1489490143-29018-4-git-send-email-yishaih@mellanox.com>
References: <1489490143-29018-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489490143-29018-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Allow users to create a QP that uses cvlan tripping capabilities if
supported by the hardware.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/cmd.c   | 3 ++-
 libibverbs/verbs.h | 1 +
 2 files changed, 3 insertions(+), 1 deletion(-)

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
