From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-rc 2/4] IB/mlx4: Fix incorrectly releasing steerable UD QPs when have only ETH ports
Date: Fri, 12 Jan 2018 07:58:40 +0200
Message-ID: <20180112055842.23125-3-leon@kernel.org>
References: <20180112055842.23125-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180112055842.23125-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>, RDMA mailing list <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Bodong Wang <bodong-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>, Parav Pandit <parav-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Allocating steerable UD QPs depends on having at least one IB port,
while releasing those QPs does not.

As a result, when there are only ETH ports, the IB (RoCE) driver
requests releasing a qp range whose base qp is zero, with
qp count zero.

When SR-IOV is enabled, and the VF driver is running on a VM over
a hypervisor which treats such qp release calls as errors
(rather than NOPs), we see lines in the VM message log like:

 mlx4_core 0002:00:02.0: Failed to release qp range base:0 cnt:0

Fix this by adding a check for a zero count in mlx4_release_qp_range()
(which thus treats releasing 0 qps as a nop), and eliminating the
check for device managed flow steering when releasing steerable UD QPs.
(Freeing ib_uc_qpns_bitmap unconditionally is also OK, since it
remains NULL when steerable UD QPs are not allocated).

Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Fixes: 4196670be786 ("IB/mlx4: Don't allocate range of steerable UD QPs for Ethernet-only device")
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c       | 13 +++++--------
 drivers/net/ethernet/mellanox/mlx4/qp.c |  3 +++
 2 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 8c8a16791a3f..5caf37ba7fff 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2995,9 +2995,8 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	kfree(ibdev->ib_uc_qpns_bitmap);
 
 err_steer_qp_release:
-	if (ibdev->steering_support == MLX4_STEERING_MODE_DEVICE_MANAGED)
-		mlx4_qp_release_range(dev, ibdev->steer_qpn_base,
-				      ibdev->steer_qpn_count);
+	mlx4_qp_release_range(dev, ibdev->steer_qpn_base,
+			      ibdev->steer_qpn_count);
 err_counter:
 	for (i = 0; i < ibdev->num_ports; ++i)
 		mlx4_ib_delete_counters_table(ibdev, &ibdev->counters_table[i]);
@@ -3102,11 +3101,9 @@ static void mlx4_ib_remove(struct mlx4_dev *dev, void *ibdev_ptr)
 		ibdev->iboe.nb.notifier_call = NULL;
 	}
 
-	if (ibdev->steering_support == MLX4_STEERING_MODE_DEVICE_MANAGED) {
-		mlx4_qp_release_range(dev, ibdev->steer_qpn_base,
-				      ibdev->steer_qpn_count);
-		kfree(ibdev->ib_uc_qpns_bitmap);
-	}
+	mlx4_qp_release_range(dev, ibdev->steer_qpn_base,
+			      ibdev->steer_qpn_count);
+	kfree(ibdev->ib_uc_qpns_bitmap);
 
 	iounmap(ibdev->uar_map);
 	for (p = 0; p < ibdev->num_ports; ++p)
diff --git a/drivers/net/ethernet/mellanox/mlx4/qp.c b/drivers/net/ethernet/mellanox/mlx4/qp.c
index 769598f7b6c8..3aaf4bad6c5a 100644
--- a/drivers/net/ethernet/mellanox/mlx4/qp.c
+++ b/drivers/net/ethernet/mellanox/mlx4/qp.c
@@ -287,6 +287,9 @@ void mlx4_qp_release_range(struct mlx4_dev *dev, int base_qpn, int cnt)
 	u64 in_param = 0;
 	int err;
 
+	if (!cnt)
+		return;
+
 	if (mlx4_is_mfunc(dev)) {
 		set_param_l(&in_param, base_qpn);
 		set_param_h(&in_param, cnt);
-- 
2.15.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
