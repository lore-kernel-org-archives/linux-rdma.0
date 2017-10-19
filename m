From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 2/6] IB/mlx4: Exposing modify CQ callback to uverbs layer
Date: Thu, 19 Oct 2017 08:35:20 +0300
Message-ID: <20171019053524.11135-3-leon@kernel.org>
References: <20171019053524.11135-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171019053524.11135-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Exposed mlx4_ib_modify_cq to be called from ib device
verb list.

Signed-off-by: Yonatan Cohen <yonatanc-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c    | 3 +++
 drivers/infiniband/hw/mlx4/mlx4_ib.h | 1 +
 include/linux/mlx4/cq.h              | 3 +++
 3 files changed, 7 insertions(+)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index c636842c5be0..58845e67dad1 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2733,6 +2733,9 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.get_dev_fw_str    = get_fw_ver_str;
 	ibdev->ib_dev.disassociate_ucontext = mlx4_ib_disassociate_ucontext;
 
+	ibdev->ib_dev.uverbs_ex_cmd_mask |=
+		(1ull << IB_USER_VERBS_EX_CMD_MODIFY_CQ);
+
 	if ((dev->caps.flags2 & MLX4_DEV_CAP_FLAG2_RSS) &&
 	    ((mlx4_ib_port_link_layer(&ibdev->ib_dev, 1) ==
 	    IB_LINK_LAYER_ETHERNET) ||
diff --git a/drivers/infiniband/hw/mlx4/mlx4_ib.h b/drivers/infiniband/hw/mlx4/mlx4_ib.h
index 1fa19820355a..9a55064ed69a 100644
--- a/drivers/infiniband/hw/mlx4/mlx4_ib.h
+++ b/drivers/infiniband/hw/mlx4/mlx4_ib.h
@@ -47,6 +47,7 @@
 #include <linux/mlx4/device.h>
 #include <linux/mlx4/doorbell.h>
 #include <linux/mlx4/qp.h>
+#include <linux/mlx4/cq.h>
 
 #define MLX4_IB_DRV_NAME	"mlx4_ib"
 
diff --git a/include/linux/mlx4/cq.h b/include/linux/mlx4/cq.h
index 09cebe528488..508e8cc5ee86 100644
--- a/include/linux/mlx4/cq.h
+++ b/include/linux/mlx4/cq.h
@@ -136,6 +136,9 @@ enum {
 	MLX4_CQE_BAD_FCS                 = 1 << 4,
 };
 
+#define MLX4_MAX_CQ_PERIOD (BIT(16) - 1)
+#define MLX4_MAX_CQ_COUNT (BIT(16) - 1)
+
 static inline void mlx4_cq_arm(struct mlx4_cq *cq, u32 cmd,
 			       void __iomem *uar_page,
 			       spinlock_t *doorbell_lock)
-- 
2.14.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
