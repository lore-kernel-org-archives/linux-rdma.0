From: Varsha Rao <rvarsha016@gmail.com>
Subject: [PATCH] net: ethernet: mlx4: Remove unnecessary parentheses
Date: Fri,  1 Jun 2018 07:30:49 +0530
Message-ID: <20180601020049.3704-1-rvarsha016@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Tariq Toukan <tariqt@mellanox.com>, "David S. Miller" <davem@davemloft.net>, Nicholas Mc Guire <der.herr@hofr.at>, Lukas Bulwahn <lukas.bulwahn@gmail.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Varsha Rao <rvarsha016@gmail.com>
List-Id: linux-rdma@vger.kernel.org

This patch fixes the clang warning of extraneous parentheses, with the
following coccinelle script.

@@
identifier i;
expression e;
statement s;
@@
if (
-(i == e)
+i == e
 )
s

Suggested-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>
Signed-off-by: Varsha Rao <rvarsha016@gmail.com>
---
 drivers/net/ethernet/mellanox/mlx4/port.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/port.c b/drivers/net/ethernet/mellanox/mlx4/port.c
index 3ef3406ff4cb..10fcc22f4590 100644
--- a/drivers/net/ethernet/mellanox/mlx4/port.c
+++ b/drivers/net/ethernet/mellanox/mlx4/port.c
@@ -614,9 +614,9 @@ int __mlx4_register_vlan(struct mlx4_dev *dev, u8 port, u16 vlan,
 		int index_at_dup_port = -1;
 
 		for (i = MLX4_VLAN_REGULAR; i < MLX4_MAX_VLAN_NUM; i++) {
-			if ((vlan == (MLX4_VLAN_MASK & be32_to_cpu(table->entries[i]))))
+			if (vlan == (MLX4_VLAN_MASK & be32_to_cpu(table->entries[i])))
 				index_at_port = i;
-			if ((vlan == (MLX4_VLAN_MASK & be32_to_cpu(dup_table->entries[i]))))
+			if (vlan == (MLX4_VLAN_MASK & be32_to_cpu(dup_table->entries[i])))
 				index_at_dup_port = i;
 		}
 		/* check that same vlan is not in the tables at different indices */
-- 
2.17.0
