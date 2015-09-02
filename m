From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v1] mlx5: Fix incorrect wc pkey_index assignment for GSI messages
Date: Wed,  2 Sep 2015 22:23:04 +0300
Message-ID: <1441221784-21734-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Since patch series "Demux IB CM requests in the rdma_cm module" the
P_Key index is taken from the work completion rather than the message
itself.

The HCA provides us with the message P_Key. In order to provide the
P_Key index, we need to look it up. Given that this is relevant only
for GSI messages (session establishments) which is less performance critical,
micro-optimize against the GSI (is_qp1) branch.

Fixes: 4c21b5bcef73 ("IB/cma: Add net_dev and private data checks to
RDMA CM")
Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes from v0:
- Added Fixes tag

 drivers/infiniband/hw/mlx5/cq.c      |   10 +++++++++-
 drivers/infiniband/hw/mlx5/mlx5_ib.h |    5 +++++
 drivers/infiniband/hw/mlx5/qp.c      |    5 -----
 3 files changed, 14 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/cq.c b/drivers/infiniband/hw/mlx5/cq.c
index 640c54e..3dfd287 100644
--- a/drivers/infiniband/hw/mlx5/cq.c
+++ b/drivers/infiniband/hw/mlx5/cq.c
@@ -33,6 +33,7 @@
 #include <linux/kref.h>
 #include <rdma/ib_umem.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/ib_cache.h>
 #include "mlx5_ib.h"
 #include "user.h"
 
@@ -227,7 +228,14 @@ static void handle_responder(struct ib_wc *wc, struct mlx5_cqe64 *cqe,
 	wc->dlid_path_bits = cqe->ml_path;
 	g = (be32_to_cpu(cqe->flags_rqpn) >> 28) & 3;
 	wc->wc_flags |= g ? IB_WC_GRH : 0;
-	wc->pkey_index     = be32_to_cpu(cqe->imm_inval_pkey) & 0xffff;
+	if (unlikely(is_qp1(qp->ibqp.qp_type))) {
+		u16 pkey = be32_to_cpu(cqe->imm_inval_pkey) & 0xffff;
+
+		ib_find_cached_pkey(&dev->ib_dev, qp->port, pkey,
+				    &wc->pkey_index);
+	} else {
+		wc->pkey_index = 0;
+	}
 }
 
 static void dump_cqe(struct mlx5_ib_dev *dev, struct mlx5_err_cqe *cqe)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index fc987fe..a4ef6a7 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -656,6 +656,11 @@ static inline u8 convert_access(int acc)
 	       MLX5_PERM_LOCAL_READ;
 }
 
+static inline int is_qp1(enum ib_qp_type qp_type)
+{
+	return qp_type == IB_QPT_GSI;
+}
+
 #define MLX5_MAX_UMR_SHIFT 16
 #define MLX5_MAX_UMR_PAGES (1 << MLX5_MAX_UMR_SHIFT)
 
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 9380d2d..8c51ea3 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -76,11 +76,6 @@ static int is_qp0(enum ib_qp_type qp_type)
 	return qp_type == IB_QPT_SMI;
 }
 
-static int is_qp1(enum ib_qp_type qp_type)
-{
-	return qp_type == IB_QPT_GSI;
-}
-
 static int is_sqp(enum ib_qp_type qp_type)
 {
 	return is_qp0(qp_type) || is_qp1(qp_type);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
