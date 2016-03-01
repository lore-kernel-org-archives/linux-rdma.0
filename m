From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 06/10] net/mlx5_core: Add VF param when querying vport counter
Date: Tue,  1 Mar 2016 18:52:19 +0200
Message-ID: <1456851143-138332-7-git-send-email-eli@mellanox.com>
References: <1456851143-138332-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1456851143-138332-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Add a vf parameter to mlx5_core_query_vport_counter so we can call it to
query counters of virtual functions. Also update current users of the
API.

PFs may call mlx5_core_query_vport_counter with other_vport set to
indicate that they are querying a virtual function. The virtual
function to be queried is given by the vf parameter. Virtual function
numbering is zero based so the first VF is 0 and so on. When a PF
queries its own function, the other_vport parameter is cleared.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/mad.c                | 2 +-
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 5 +++--
 include/linux/mlx5/vport.h                      | 3 ++-
 3 files changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 41d8a0036465..1534af113058 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -208,7 +208,7 @@ static int process_pma_cmd(struct ib_device *ibdev, u8 port_num,
 		if (!out_cnt)
 			return IB_MAD_RESULT_FAILURE;
 
-		err = mlx5_core_query_vport_counter(dev->mdev, 0,
+		err = mlx5_core_query_vport_counter(dev->mdev, 0, 0,
 						    port_num, out_cnt, sz);
 		if (!err)
 			pma_cnt_ext_assign(pma_cnt_ext, out_cnt);
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index 90ab09e375b8..2b836d0b4738 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -852,7 +852,8 @@ int mlx5_nic_vport_disable_roce(struct mlx5_core_dev *mdev)
 EXPORT_SYMBOL_GPL(mlx5_nic_vport_disable_roce);
 
 int mlx5_core_query_vport_counter(struct mlx5_core_dev *dev, u8 other_vport,
-				  u8 port_num, void *out, size_t out_sz)
+				  int vf, u8 port_num, void *out,
+				  size_t out_sz)
 {
 	int	in_sz = MLX5_ST_SZ_BYTES(query_vport_counter_in);
 	int	is_group_manager;
@@ -871,7 +872,7 @@ int mlx5_core_query_vport_counter(struct mlx5_core_dev *dev, u8 other_vport,
 	if (other_vport) {
 		if (is_group_manager) {
 			MLX5_SET(query_vport_counter_in, in, other_vport, 1);
-			MLX5_SET(query_vport_counter_in, in, vport_number, 0);
+			MLX5_SET(query_vport_counter_in, in, vport_number, vf + 1);
 		} else {
 			err = -EPERM;
 			goto free;
diff --git a/include/linux/mlx5/vport.h b/include/linux/mlx5/vport.h
index a9f2bcc98cab..aafb3e48b5f8 100644
--- a/include/linux/mlx5/vport.h
+++ b/include/linux/mlx5/vport.h
@@ -93,6 +93,7 @@ int mlx5_modify_nic_vport_vlans(struct mlx5_core_dev *dev,
 int mlx5_nic_vport_enable_roce(struct mlx5_core_dev *mdev);
 int mlx5_nic_vport_disable_roce(struct mlx5_core_dev *mdev);
 int mlx5_core_query_vport_counter(struct mlx5_core_dev *dev, u8 other_vport,
-				  u8 port_num, void *out, size_t out_sz);
+				  int vf, u8 port_num, void *out,
+				  size_t out_sz);
 
 #endif /* __MLX5_VPORT_H__ */
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
