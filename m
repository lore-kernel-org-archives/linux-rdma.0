From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 11/15] {net,IB}/mlx5: Change set_roce_gid to take a port number
Date: Sun, 24 Dec 2017 14:57:37 +0200
Message-ID: <20171224125741.25464-12-leon@kernel.org>
References: <20171224125741.25464-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20171224125741.25464-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

When in dual port mode setting a RoCE GID for any port flows through the
master ports mlx5_core_dev. Provide an interface to set the port when
sending this command.

Signed-off-by: Daniel Jurgens <danielj-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c                   | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c | 7 ++++---
 drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c   | 5 ++++-
 include/linux/mlx5/driver.h                         | 2 +-
 4 files changed, 10 insertions(+), 6 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index e61c0b2f29ba..261c2a8db6b3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -477,7 +477,7 @@ static int set_roce_addr(struct mlx5_ib_dev *dev, u8 port_num,
 
 	return mlx5_core_roce_gid_set(dev->mdev, index, roce_version,
 				      roce_l3_type, gid->raw, mac, vlan,
-				      vlan_id);
+				      vlan_id, port_num);
 }
 
 static int mlx5_ib_add_gid(struct ib_device *device, u8 port_num,
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
index c841b03c3e48..e6175f8ac0e4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fpga/conn.c
@@ -888,7 +888,8 @@ struct mlx5_fpga_conn *mlx5_fpga_conn_create(struct mlx5_fpga_device *fdev,
 	err = mlx5_core_roce_gid_set(fdev->mdev, conn->qp.sgid_index,
 				     MLX5_ROCE_VERSION_2,
 				     MLX5_ROCE_L3_TYPE_IPV6,
-				     remote_ip, remote_mac, true, 0);
+				     remote_ip, remote_mac, true, 0,
+				     MLX5_FPGA_PORT_NUM);
 	if (err) {
 		mlx5_fpga_err(fdev, "Failed to set SGID: %d\n", err);
 		ret = ERR_PTR(err);
@@ -954,7 +955,7 @@ struct mlx5_fpga_conn *mlx5_fpga_conn_create(struct mlx5_fpga_device *fdev,
 	mlx5_fpga_conn_destroy_cq(conn);
 err_gid:
 	mlx5_core_roce_gid_set(fdev->mdev, conn->qp.sgid_index, 0, 0, NULL,
-			       NULL, false, 0);
+			       NULL, false, 0, MLX5_FPGA_PORT_NUM);
 err_rsvd_gid:
 	mlx5_core_reserved_gid_free(fdev->mdev, conn->qp.sgid_index);
 err:
@@ -982,7 +983,7 @@ void mlx5_fpga_conn_destroy(struct mlx5_fpga_conn *conn)
 	mlx5_fpga_conn_destroy_cq(conn);
 
 	mlx5_core_roce_gid_set(conn->fdev->mdev, conn->qp.sgid_index, 0, 0,
-			       NULL, NULL, false, 0);
+			       NULL, NULL, false, 0, MLX5_FPGA_PORT_NUM);
 	mlx5_core_reserved_gid_free(conn->fdev->mdev, conn->qp.sgid_index);
 	kfree(conn);
 }
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
index 573f59f46d41..7722a3f9bb68 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/gid.c
@@ -121,7 +121,7 @@ EXPORT_SYMBOL_GPL(mlx5_core_reserved_gids_count);
 
 int mlx5_core_roce_gid_set(struct mlx5_core_dev *dev, unsigned int index,
 			   u8 roce_version, u8 roce_l3_type, const u8 *gid,
-			   const u8 *mac, bool vlan, u16 vlan_id)
+			   const u8 *mac, bool vlan, u16 vlan_id, u8 port_num)
 {
 #define MLX5_SET_RA(p, f, v) MLX5_SET(roce_addr_layout, p, f, v)
 	u32  in[MLX5_ST_SZ_DW(set_roce_address_in)] = {0};
@@ -148,6 +148,9 @@ int mlx5_core_roce_gid_set(struct mlx5_core_dev *dev, unsigned int index,
 		memcpy(addr_l3_addr, gid, gidsz);
 	}
 
+	if (MLX5_CAP_GEN(dev, num_vhca_ports) > 0)
+		MLX5_SET(set_roce_address_in, in, vhca_port_num, port_num);
+
 	MLX5_SET(set_roce_address_in, in, roce_address_index, index);
 	MLX5_SET(set_roce_address_in, in, opcode, MLX5_CMD_OP_SET_ROCE_ADDRESS);
 	return mlx5_cmd_exec(dev, in, sizeof(in), out, sizeof(out));
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index c2c78bc42432..bc494ddefcf8 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -1101,7 +1101,7 @@ void mlx5_free_bfreg(struct mlx5_core_dev *mdev, struct mlx5_sq_bfreg *bfreg);
 unsigned int mlx5_core_reserved_gids_count(struct mlx5_core_dev *dev);
 int mlx5_core_roce_gid_set(struct mlx5_core_dev *dev, unsigned int index,
 			   u8 roce_version, u8 roce_l3_type, const u8 *gid,
-			   const u8 *mac, bool vlan, u16 vlan_id);
+			   const u8 *mac, bool vlan, u16 vlan_id, u8 port_num);
 
 static inline int fw_initializing(struct mlx5_core_dev *dev)
 {
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
