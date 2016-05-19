From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH libibverbs 3/3] Add SCATTER_FCS QP create flag
Date: Thu, 19 May 2016 15:52:49 +0300
Message-ID: <1463662369-18395-4-git-send-email-yishaih@mellanox.com>
References: <1463662369-18395-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463662369-18395-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Raw Packet QPs that were created with Scatter FCS will scatter
the FCS into the receive buffers.

Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/infiniband/verbs.h | 1 +
 src/cmd.c                  | 3 ++-
 2 files changed, 3 insertions(+), 1 deletion(-)

diff --git a/include/infiniband/verbs.h b/include/infiniband/verbs.h
index f45667f..a9cae4d 100644
--- a/include/infiniband/verbs.h
+++ b/include/infiniband/verbs.h
@@ -613,6 +613,7 @@ enum ibv_qp_init_attr_mask {
 
 enum ibv_qp_create_flags {
 	IBV_QP_CREATE_BLOCK_SELF_MCAST_LB       = 1 << 1,
+	IBV_QP_CREATE_SCATTER_FCS		= 1 << 8,
 };
 
 struct ibv_qp_init_attr_ex {
diff --git a/src/cmd.c b/src/cmd.c
index b9c5c67..1e2d5e4 100644
--- a/src/cmd.c
+++ b/src/cmd.c
@@ -828,7 +828,8 @@ static void create_qp_handle_resp_common(struct ibv_context *context,
 }
 
 enum {
-	CREATE_QP_EX2_SUP_CREATE_FLAGS = IBV_QP_CREATE_BLOCK_SELF_MCAST_LB,
+	CREATE_QP_EX2_SUP_CREATE_FLAGS = IBV_QP_CREATE_BLOCK_SELF_MCAST_LB |
+		IBV_QP_CREATE_SCATTER_FCS,
 };
 
 int ibv_cmd_create_qp_ex2(struct ibv_context *context,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
