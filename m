From: Sagi Grimberg <sagig@mellanox.com>
Subject: [PATCH 1/7] IB/mlx5: Use enumerations for PI copy mask
Date: Wed, 13 Aug 2014 19:54:29 +0300
Message-ID: <1407948875-733-2-git-send-email-sagig@mellanox.com>
References: <1407948875-733-1-git-send-email-sagig@mellanox.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1407948875-733-1-git-send-email-sagig@mellanox.com>
Sender: target-devel-owner@vger.kernel.org
To: roland@kernel.org, nab@linux-iscsi.org
Cc: martin.petersen@oracle.com, linux-rdma@vger.kernel.org, target-devel@vger.kernel.org, oren@mellanox.com
List-Id: linux-rdma@vger.kernel.org

In case input and output space parameters match, we can
use a copy mask from input and output space. Use enums
for those.

Signed-off-by: Sagi Grimberg <sagig@mellanox.com>
---
 drivers/infiniband/hw/mlx5/qp.c |    6 +++---
 include/linux/mlx5/qp.h         |    3 +++
 2 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index e847ecf..af3b7fa 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2095,11 +2095,11 @@ static int mlx5_set_bsf(struct ib_mr *sig_mr,
 			/* Same block structure */
 			basic->bsf_size_sbs = 1 << 4;
 			if (mem->sig.dif.bg_type == wire->sig.dif.bg_type)
-				basic->wire.copy_byte_mask |= 0xc0;
+				basic->wire.copy_byte_mask |= MLX5_CPY_GRD_MASK;
 			if (mem->sig.dif.app_tag == wire->sig.dif.app_tag)
-				basic->wire.copy_byte_mask |= 0x30;
+				basic->wire.copy_byte_mask |= MLX5_CPY_APP_MASK;
 			if (mem->sig.dif.ref_tag == wire->sig.dif.ref_tag)
-				basic->wire.copy_byte_mask |= 0x0f;
+				basic->wire.copy_byte_mask |= MLX5_CPY_REF_MASK;
 		} else
 			basic->wire.bs_selector = bs_selector(wire->sig.dif.pi_interval);
 
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index 9709b30..4aa5634 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -40,6 +40,9 @@
 #define MLX5_SIG_WQE_SIZE	(MLX5_SEND_WQE_BB * 5)
 #define MLX5_DIF_SIZE		8
 #define MLX5_STRIDE_BLOCK_OP	0x400
+#define MLX5_CPY_GRD_MASK	0xc0
+#define MLX5_CPY_APP_MASK	0x30
+#define MLX5_CPY_REF_MASK	0x0f
 
 enum mlx5_qp_optpar {
 	MLX5_QP_OPTPAR_ALT_ADDR_PATH		= 1 << 0,
-- 
1.7.1
