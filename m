From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 2/6] IB/uapi: expose uverbs send WR flags
Date: Thu, 24 Dec 2015 15:39:23 +0100
Message-ID: <1450967967-12479-3-git-send-email-hch@lst.de>
References: <1450967967-12479-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450967967-12479-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This exposes the send WR flags supported by uverbs as part of the uapi
headers.  It follows the same scheme as the WR opcodes.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  6 +++---
 include/rdma/ib_verbs.h              | 14 ++++++--------
 include/uapi/rdma/ib_verbs.h         |  9 +++++++++
 3 files changed, 18 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index 2f82a08..6c264f0 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -118,9 +118,9 @@ struct mlx5_ib_pd {
  * enum ib_send_flags and enum ib_qp_type for low-level driver
  */
 
-#define MLX5_IB_SEND_UMR_UNREG	IB_SEND_RESERVED_START
-#define MLX5_IB_SEND_UMR_FAIL_IF_FREE (IB_SEND_RESERVED_START << 1)
-#define MLX5_IB_SEND_UMR_UPDATE_MTT (IB_SEND_RESERVED_START << 2)
+#define MLX5_IB_SEND_UMR_UNREG	IB_SEND_END
+#define MLX5_IB_SEND_UMR_FAIL_IF_FREE (IB_SEND_END << 1)
+#define MLX5_IB_SEND_UMR_UPDATE_MTT (IB_SEND_END << 2)
 #define MLX5_IB_QPT_REG_UMR	IB_QPT_RESERVED1
 #define MLX5_IB_WR_UMR		(IB_WR_END + 0)
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 94509e0..5dccc6a 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1134,15 +1134,13 @@ enum ib_wr_opcode {
 };
 
 enum ib_send_flags {
-	IB_SEND_FENCE		= 1,
-	IB_SEND_SIGNALED	= (1<<1),
-	IB_SEND_SOLICITED	= (1<<2),
-	IB_SEND_INLINE		= (1<<3),
-	IB_SEND_IP_CSUM		= (1<<4),
+	IB_SEND_FENCE		= IB_UVERBS_SEND_FENCE,
+	IB_SEND_SIGNALED	= IB_UVERBS_SEND_SIGNALED,
+	IB_SEND_SOLICITED	= IB_UVERBS_SEND_SOLICITED,
+	IB_SEND_INLINE		= IB_UVERBS_SEND_INLINE,
+	IB_SEND_IP_CSUM		= IB_UVERBS_SEND_IP_CSUM,
 
-	/* reserve bits 26-31 for low level drivers' internal use */
-	IB_SEND_RESERVED_START	= (1 << 26),
-	IB_SEND_RESERVED_END	= (1 << 31),
+	IB_SEND_END		= IB_UVERBS_SEND_END,
 };
 
 struct ib_sge {
diff --git a/include/uapi/rdma/ib_verbs.h b/include/uapi/rdma/ib_verbs.h
index 330175e..3be3152 100644
--- a/include/uapi/rdma/ib_verbs.h
+++ b/include/uapi/rdma/ib_verbs.h
@@ -20,4 +20,13 @@ enum ib_uverbs_wr_opcode {
 	IB_UVERBS_WR_END			= 9,
 };
 
+enum ib_uverbs_send_flags {
+	IB_UVERBS_SEND_FENCE			= (1 << 0),
+	IB_UVERBS_SEND_SIGNALED			= (1 << 1),
+	IB_UVERBS_SEND_SOLICITED		= (1 << 2),
+	IB_UVERBS_SEND_INLINE			= (1 << 3),
+	IB_UVERBS_SEND_IP_CSUM			= (1 << 4),
+	IB_UVERBS_SEND_END			= (1 << 5),
+};
+
 #endif /* _UAPI_RDMA_IB_VERBS_H */
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
