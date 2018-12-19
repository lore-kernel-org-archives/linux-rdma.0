From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 2/2] IB/mlx5: Use uid as part of alloc/dealloc transport domain
Date: Wed, 19 Dec 2018 16:28:11 +0200
Message-ID: <20181219142811.21301-3-leon@kernel.org>
References: <20181219142811.21301-1-leon@kernel.org>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20181219142811.21301-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Artemy Kovalyov <artemyko@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Use uid as part of alloc/dealloc transport domain to let firmware
manages the resources correctly.

Fixes: d2d19121ae2f("IB/mlx5: Set uid as part of TD commands)
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Reviewed-by: Artemy Kovalyov <artemyko@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/hw/mlx5/cmd.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/cmd.c b/drivers/infiniband/hw/mlx5/cmd.c
index 752c60426a1c..356bccc715ee 100644
--- a/drivers/infiniband/hw/mlx5/cmd.c
+++ b/drivers/infiniband/hw/mlx5/cmd.c
@@ -240,6 +240,7 @@ int mlx5_cmd_alloc_transport_domain(struct mlx5_core_dev *dev, u32 *tdn,
 
 	MLX5_SET(alloc_transport_domain_in, in, opcode,
 		 MLX5_CMD_OP_ALLOC_TRANSPORT_DOMAIN);
+	MLX5_SET(alloc_transport_domain_in, in, uid, uid);
 
 	err = mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 	if (!err)
@@ -257,6 +258,7 @@ void mlx5_cmd_dealloc_transport_domain(struct mlx5_core_dev *dev, u32 tdn,
 
 	MLX5_SET(dealloc_transport_domain_in, in, opcode,
 		 MLX5_CMD_OP_DEALLOC_TRANSPORT_DOMAIN);
+	MLX5_SET(dealloc_transport_domain_in, in, uid, uid);
 	MLX5_SET(dealloc_transport_domain_in, in, transport_domain, tdn);
 	mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
 }
-- 
2.19.1
