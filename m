From: Saeed Mahameed <saeedm@mellanox.com>
Subject: [for-next 04/15] net/mlx5: Add merged e-switch cap
Date: Thu, 17 May 2018 18:22:47 -0700
Message-ID: <20180518012258.26968-5-saeedm@mellanox.com>
References: <20180518012258.26968-1-saeedm@mellanox.com>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180518012258.26968-1-saeedm@mellanox.com>
Sender: netdev-owner@vger.kernel.org
To: "David S. Miller" <davem@davemloft.net>, Doug Ledford <dledford@redhat.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, Leon Romanovsky <leonro@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, netdev@vger.kernel.org, linux-rdma@vger.kernel.org, Roi Dayan <roid@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>
List-Id: linux-rdma@vger.kernel.org

From: Roi Dayan <roid@mellanox.com>

When merged e-switch is supported, the per-port e-switch is logically
merged into one e-switch that spans both physical ports and all the VFs.
Under merged eswitch, both the matching on source vport and setting
destination vport can have a 2nd attribute which is the vhca id of the
eswitch owner.

For example:
esw0: {match: <src vport=1 owner=0> action: fwd to <dst vport=7, owner=1>}
is a flow set on eswitch0 matching on source vport=1 from his eswitch
and the action being fwd to dest vport=7 of eswitch1.

Signed-off-by: Roi Dayan <roid@mellanox.com>
Reviewed-by: Shahar Klein <shahark@mellanox.com>
Reviewed-by: Or Gerlitz Klein <ogerlitz@mellanox.com>
Signed-off-by: Saeed Mahameed <saeedm@mellanox.com>
---
 include/linux/mlx5/mlx5_ifc.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/include/linux/mlx5/mlx5_ifc.h b/include/linux/mlx5/mlx5_ifc.h
index 1aad455538f4..ef15f751a984 100644
--- a/include/linux/mlx5/mlx5_ifc.h
+++ b/include/linux/mlx5/mlx5_ifc.h
@@ -557,7 +557,8 @@ struct mlx5_ifc_e_switch_cap_bits {
 	u8         vport_svlan_insert[0x1];
 	u8         vport_cvlan_insert_if_not_exist[0x1];
 	u8         vport_cvlan_insert_overwrite[0x1];
-	u8         reserved_at_5[0x19];
+	u8         reserved_at_5[0x18];
+	u8         merged_eswitch[0x1];
 	u8         nic_vport_node_guid_modify[0x1];
 	u8         nic_vport_port_guid_modify[0x1];
 
-- 
2.17.0
