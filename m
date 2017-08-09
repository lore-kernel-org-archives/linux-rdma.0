From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [PATCH] net/mlx5: Uninitialized variable in esw_add_uc_addr()
Date: Thu, 10 Aug 2017 00:28:11 +0300
Message-ID: <20170809072418.e4x5xmbvboadhe5w@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <kernel-janitors-owner@vger.kernel.org>
Content-Disposition: inline
Sender: kernel-janitors-owner@vger.kernel.org
To: Saeed Mahameed <saeedm@mellanox.com>
Cc: Matan Barak <matanb@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, linux-rdma@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

"err" isn't initialized if we hit the "goto fdb_add;".

Fixes: eeb66cdb6826 ("net/mlx5: Separate between E-Switch and MPFS")
Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index fd51f0ea8df9..baed45c0dabe 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -376,7 +376,7 @@ static int esw_add_uc_addr(struct mlx5_eswitch *esw, struct vport_addr *vaddr)
 {
 	u8 *mac = vaddr->node.addr;
 	u32 vport = vaddr->vport;
-	int err;
+	int err = 0;
 
 	/* Skip mlx5_mpfs_add_mac for PFs,
 	 * it is already done by the PF netdev in mlx5e_execute_l2_action
