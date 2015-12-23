From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 06/10] IB/mlx5: Extend query_device/port to support RoCE
Date: Wed, 23 Dec 2015 15:17:50 +0200
Message-ID: <1450876674-21695-7-git-send-email-matanb@mellanox.com>
References: <1450876674-21695-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1450876674-21695-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Eran Ben Elisha <eranbe-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Using the vport access functions to retrieve the Ethernet
specific information and return this information in
ib_query_device and ib_query_port.

Signed-off-by: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 75 +++++++++++++++++++++++++++++++++++----
 include/linux/mlx5/driver.h       |  7 ----
 2 files changed, 69 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 48da17d..7f34b5e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -40,6 +40,7 @@
 #include <linux/io-mapping.h>
 #include <linux/sched.h>
 #include <rdma/ib_user_verbs.h>
+#include <rdma/ib_addr.h>
 #include <linux/mlx5/vport.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_umem.h>
@@ -120,6 +121,50 @@ static struct net_device *mlx5_ib_get_netdev(struct ib_device *device,
 	return ndev;
 }
 
+static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
+				struct ib_port_attr *props)
+{
+	struct mlx5_ib_dev *dev = to_mdev(device);
+	struct net_device *ndev;
+	enum ib_mtu ndev_ib_mtu;
+
+	memset(props, 0, sizeof(*props));
+
+	props->port_cap_flags  |= IB_PORT_CM_SUP;
+	props->port_cap_flags  |= IB_PORT_IP_BASED_GIDS;
+
+	props->gid_tbl_len      = MLX5_CAP_ROCE(dev->mdev,
+						roce_address_table_size);
+	props->max_mtu          = IB_MTU_4096;
+	props->max_msg_sz       = 1 << MLX5_CAP_GEN(dev->mdev, log_max_msg);
+	props->pkey_tbl_len     = 1;
+	props->state            = IB_PORT_DOWN;
+	props->phys_state       = 3;
+
+	mlx5_query_nic_vport_qkey_viol_cntr(dev->mdev,
+					    (u16 *)&props->qkey_viol_cntr);
+
+	ndev = mlx5_ib_get_netdev(device, port_num);
+	if (!ndev)
+		return 0;
+
+	if (netif_running(ndev) && netif_carrier_ok(ndev)) {
+		props->state      = IB_PORT_ACTIVE;
+		props->phys_state = 5;
+	}
+
+	ndev_ib_mtu = iboe_get_mtu(ndev->mtu);
+
+	dev_put(ndev);
+
+	props->active_mtu	= min(props->max_mtu, ndev_ib_mtu);
+
+	props->active_width	= IB_WIDTH_4X;  /* TODO */
+	props->active_speed	= IB_SPEED_QDR; /* TODO */
+
+	return 0;
+}
+
 static int mlx5_use_mad_ifc(struct mlx5_ib_dev *dev)
 {
 	return !dev->mdev->issi;
@@ -158,13 +203,21 @@ static int mlx5_query_system_image_guid(struct ib_device *ibdev,
 
 	case MLX5_VPORT_ACCESS_METHOD_HCA:
 		err = mlx5_query_hca_vport_system_image_guid(mdev, &tmp);
-		if (!err)
-			*sys_image_guid = cpu_to_be64(tmp);
-		return err;
+		break;
+
+	case MLX5_VPORT_ACCESS_METHOD_NIC:
+		err = mlx5_query_nic_vport_system_image_guid(mdev, &tmp);
+		break;
 
 	default:
 		return -EINVAL;
 	}
+
+	if (!err)
+		*sys_image_guid = cpu_to_be64(tmp);
+
+	return err;
+
 }
 
 static int mlx5_query_max_pkeys(struct ib_device *ibdev,
@@ -218,13 +271,20 @@ static int mlx5_query_node_guid(struct mlx5_ib_dev *dev,
 
 	case MLX5_VPORT_ACCESS_METHOD_HCA:
 		err = mlx5_query_hca_vport_node_guid(dev->mdev, &tmp);
-		if (!err)
-			*node_guid = cpu_to_be64(tmp);
-		return err;
+		break;
+
+	case MLX5_VPORT_ACCESS_METHOD_NIC:
+		err = mlx5_query_nic_vport_node_guid(dev->mdev, &tmp);
+		break;
 
 	default:
 		return -EINVAL;
 	}
+
+	if (!err)
+		*node_guid = cpu_to_be64(tmp);
+
+	return err;
 }
 
 struct mlx5_reg_node_desc {
@@ -516,6 +576,9 @@ int mlx5_ib_query_port(struct ib_device *ibdev, u8 port,
 	case MLX5_VPORT_ACCESS_METHOD_HCA:
 		return mlx5_query_hca_port(ibdev, port, props);
 
+	case MLX5_VPORT_ACCESS_METHOD_NIC:
+		return mlx5_query_port_roce(ibdev, port, props);
+
 	default:
 		return -EINVAL;
 	}
diff --git a/include/linux/mlx5/driver.h b/include/linux/mlx5/driver.h
index 5c857f2..7b9c976 100644
--- a/include/linux/mlx5/driver.h
+++ b/include/linux/mlx5/driver.h
@@ -632,13 +632,6 @@ extern struct workqueue_struct *mlx5_core_wq;
 	.struct_offset_bytes = offsetof(struct ib_unpacked_ ## header, field),      \
 	.struct_size_bytes   = sizeof((struct ib_unpacked_ ## header *)0)->field
 
-struct ib_field {
-	size_t struct_offset_bytes;
-	size_t struct_size_bytes;
-	int    offset_bits;
-	int    size_bits;
-};
-
 static inline struct mlx5_core_dev *pci2mlx5_core_dev(struct pci_dev *pdev)
 {
 	return pci_get_drvdata(pdev);
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
