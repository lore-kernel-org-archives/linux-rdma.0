From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH 2/2] IB/mlx5: Fix existence check for extended address vector
Date: Mon, 12 Jun 2017 10:36:16 +0300
Message-ID: <20170612073616.14852-2-leon@kernel.org>
References: <20170612073616.14852-1-leon@kernel.org>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <20170612073616.14852-1-leon@kernel.org>
Sender: stable-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: linux-rdma@vger.kernel.org, Majd Dibbiny <majd@mellanox.com>, stable@vger.kernel.org, Leon Romanovsky <leonro@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro@mellanox.com>

The extended address vector is the highest bit in be32 variable,
but it was compared with the lowest. This patch fixes the endianness
of that check and removes already declared define.

Fixes: 17d2f88f92ce ("IB/mlx5: Add ODP atomics support")
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/odp.c | 2 +-
 include/linux/mlx5/qp.h          | 1 -
 2 files changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index ae0746754008..3d701c7a4c91 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -939,7 +939,7 @@ static int mlx5_ib_mr_initiator_pfault_handler(

 	if (qp->ibqp.qp_type != IB_QPT_RC) {
 		av = *wqe;
-		if (av->dqp_dct & be32_to_cpu(MLX5_WQE_AV_EXT))
+		if (av->dqp_dct & cpu_to_be32(MLX5_EXTENDED_UD_AV))
 			*wqe += sizeof(struct mlx5_av);
 		else
 			*wqe += sizeof(struct mlx5_base_av);
diff --git a/include/linux/mlx5/qp.h b/include/linux/mlx5/qp.h
index bef80d0a0e30..a6d710aa6db3 100644
--- a/include/linux/mlx5/qp.h
+++ b/include/linux/mlx5/qp.h
@@ -212,7 +212,6 @@ struct mlx5_wqe_ctrl_seg {
 #define MLX5_WQE_CTRL_OPCODE_MASK 0xff
 #define MLX5_WQE_CTRL_WQE_INDEX_MASK 0x00ffff00
 #define MLX5_WQE_CTRL_WQE_INDEX_SHIFT 8
-#define MLX5_WQE_AV_EXT 0x80000000

 enum {
 	MLX5_ETH_WQE_L3_INNER_CSUM      = 1 << 4,
