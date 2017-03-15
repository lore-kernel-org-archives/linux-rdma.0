From: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V1 rdma-core 6/6] ibverbs: Add support for scatter FCS ability in WQ
Date: Wed, 15 Mar 2017 17:27:46 +0200
Message-ID: <1489591666-14062-7-git-send-email-yishaih@mellanox.com>
References: <1489591666-14062-1-git-send-email-yishaih@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1489591666-14062-1-git-send-email-yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Enable the user to create a workqueue object with the scatter FCS
offload.
If this option is set, the FCS (Frame Check Sequence) field of an
incoming raw Ethernet packet will be scattered into host memory along
the packet payload as it appeared on the wire.

Signed-off-by: Noa Osherovich <noaos-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 libibverbs/man/ibv_create_wq.3 | 3 ++-
 libibverbs/verbs.h             | 5 +++--
 2 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/libibverbs/man/ibv_create_wq.3 b/libibverbs/man/ibv_create_wq.3
index 9a541fe..4a8b83c 100644
--- a/libibverbs/man/ibv_create_wq.3
+++ b/libibverbs/man/ibv_create_wq.3
@@ -40,7 +40,8 @@ uint32_t                   create_flags    /* Creation flags for this WQ, use en
 enum ibv_wq_flags {
 .in +8
 IBV_WQ_FLAGS_CVLAN_STRIPPING		= 1 << 0, /* CVLAN field will be stripped from incoming packets */
-IBV_WQ_FLAGS_RESERVED			= 1 << 1,
+IBV_WQ_FLAGS_SCATTER_FCS		= 1 << 1, /* FCS field will be scattered to host memory */
+IBV_WQ_FLAGS_RESERVED			= 1 << 2,
 .in -8
 };
 .nf
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
