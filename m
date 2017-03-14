From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-core 7/7] ibverbs: Add support for scatter FCS ability in WQ
Date: Tue, 14 Mar 2017 13:15:43 +0200
Message-ID: <1489490143-29018-8-git-send-email-yishaih@mellanox.com>
References: <1489490143-29018-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489490143-29018-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enable the user to create a workqueue object with the scatter FCS
offload.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/verbs.h | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/libibverbs/verbs.h b/libibverbs/verbs.h
index 15e93b3..3f5e9fe 100644
--- a/libibverbs/verbs.h
+++ b/libibverbs/verbs.h
@@ -675,7 +675,8 @@ enum ibv_wq_init_attr_mask {
 
 enum ibv_wq_flags {
 	IBV_WQ_FLAGS_CVLAN_STRIPPING		= 1 << 0,
-	IBV_WQ_FLAGS_RESERVED			= 1 << 1,
+	IBV_WQ_FLAGS_SCATTER_FCS		= 1 << 1,
+	IBV_WQ_FLAGS_RESERVED			= 1 << 2,
 };
 
 struct ibv_wq_init_attr {
@@ -685,7 +686,7 @@ struct ibv_wq_init_attr {
 	uint32_t		max_sge;
 	struct	ibv_pd	       *pd;
 	struct	ibv_cq	       *cq;
-	uint32_t		comp_mask;
+	uint32_t		comp_mask; /* Use ibv_wq_init_attr_mask */
 	uint32_t		create_flags; /* use ibv_wq_flags */
 };
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
