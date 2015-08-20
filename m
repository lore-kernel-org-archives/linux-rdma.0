From: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 08/10] IB/mlx5: Support IB device's callbacks for adding/deleting GIDs
Date: Thu, 20 Aug 2015 19:46:27 +0300
Message-ID: <1440089189-3361-9-git-send-email-achiad@mellanox.com>
References: <1440089189-3361-1-git-send-email-achiad@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1440089189-3361-1-git-send-email-achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVS1Z/+hSey0Gg@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These callbacks write into the mlx5 RoCE address table.
Upon del_gid we write a zero'd GID.

Signed-off-by: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 89 +++++++++++++++++++++++++++++++++++++++
 include/linux/mlx5/device.h       | 20 +++++++++
 2 files changed, 109 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 612dc3a..975e332 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -165,6 +165,93 @@ static int mlx5_query_port_roce(struct ib_device *device, u8 port_num,
 	return 0;
 }
 
+static void ib_gid_to_mlx5_roce_addr(const union ib_gid *gid,
+				     const struct ib_gid_attr *attr,
+				     void *mlx5_addr)
+{
+#define MLX5_SET_RA(p, f, v) MLX5_SET(roce_addr_layout, p, f, v)
+	char *mlx5_addr_l3_addr	= MLX5_ADDR_OF(roce_addr_layout, mlx5_addr,
+					       source_l3_address);
+	void *mlx5_addr_mac	= MLX5_ADDR_OF(roce_addr_layout, mlx5_addr,
+					       source_mac_47_32);
+
+	if (!gid)
+		return;
+
+	ether_addr_copy(mlx5_addr_mac, attr->ndev->dev_addr);
+
+	if (is_vlan_dev(attr->ndev)) {
+		MLX5_SET_RA(mlx5_addr, vlan_valid, 1);
+		MLX5_SET_RA(mlx5_addr, vlan_id, vlan_dev_vlan_id(attr->ndev));
+	}
+
+	switch (attr->gid_type) {
+	case IB_GID_TYPE_IB:
+		MLX5_SET_RA(mlx5_addr, roce_version, MLX5_ROCE_VERSION_1);
+		break;
+	case IB_GID_TYPE_ROCE_UDP_ENCAP:
+		MLX5_SET_RA(mlx5_addr, roce_version, MLX5_ROCE_VERSION_2);
+		break;
+
+	default:
+		WARN_ON(true);
+	}
+
+	if (attr->gid_type != IB_GID_TYPE_IB) {
+		if (ipv6_addr_v4mapped((void *)gid))
+			MLX5_SET_RA(mlx5_addr, roce_l3_type,
+				    MLX5_ROCE_L3_TYPE_IPV4);
+		else
+			MLX5_SET_RA(mlx5_addr, roce_l3_type,
+				    MLX5_ROCE_L3_TYPE_IPV6);
+	}
+
+	if ((attr->gid_type == IB_GID_TYPE_IB) ||
+	    !ipv6_addr_v4mapped((void *)gid))
+		memcpy(mlx5_addr_l3_addr, gid, sizeof(*gid));
+	else
+		memcpy(&mlx5_addr_l3_addr[12], &gid->raw[12], 4);
+}
+
+static int set_roce_addr(struct ib_device *device, u8 port_num,
+			 unsigned int index,
+			 const union ib_gid *gid,
+			 const struct ib_gid_attr *attr)
+{
+	struct mlx5_ib_dev *dev	= to_mdev(device);
+	u32  in[MLX5_ST_SZ_DW(set_roce_address_in)];
+	u32 out[MLX5_ST_SZ_DW(set_roce_address_out)];
+	void *in_addr = MLX5_ADDR_OF(set_roce_address_in, in, roce_address);
+	enum rdma_link_layer ll = mlx5_ib_port_link_layer(device, port_num);
+
+	if (ll != IB_LINK_LAYER_ETHERNET)
+		return -EINVAL;
+
+	memset(in, 0, sizeof(in));
+
+	ib_gid_to_mlx5_roce_addr(gid, attr, in_addr);
+
+	MLX5_SET(set_roce_address_in, in, roce_address_index, index);
+	MLX5_SET(set_roce_address_in, in, opcode, MLX5_CMD_OP_SET_ROCE_ADDRESS);
+
+	memset(out, 0, sizeof(out));
+	return mlx5_cmd_exec(dev->mdev, in, sizeof(in), out, sizeof(out));
+}
+
+static int mlx5_ib_add_gid(struct ib_device *device, u8 port_num,
+			   unsigned int index, const union ib_gid *gid,
+			   const struct ib_gid_attr *attr,
+			   __always_unused void **context)
+{
+	return set_roce_addr(device, port_num, index, gid, attr);
+}
+
+static int mlx5_ib_del_gid(struct ib_device *device, u8 port_num,
+			   unsigned int index, __always_unused void **context)
+{
+	return set_roce_addr(device, port_num, index, NULL, NULL);
+}
+
 static int mlx5_use_mad_ifc(struct mlx5_ib_dev *dev)
 {
 	return !dev->mdev->issi;
@@ -1584,6 +1671,8 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	if (ll == IB_LINK_LAYER_ETHERNET)
 		dev->ib_dev.get_netdev	= mlx5_ib_get_netdev;
 	dev->ib_dev.query_gid		= mlx5_ib_query_gid;
+	dev->ib_dev.add_gid		= mlx5_ib_add_gid;
+	dev->ib_dev.del_gid		= mlx5_ib_del_gid;
 	dev->ib_dev.query_pkey		= mlx5_ib_query_pkey;
 	dev->ib_dev.modify_device	= mlx5_ib_modify_device;
 	dev->ib_dev.modify_port		= mlx5_ib_modify_port;
diff --git a/include/linux/mlx5/device.h b/include/linux/mlx5/device.h
index 2777794..90406b4 100644
--- a/include/linux/mlx5/device.h
+++ b/include/linux/mlx5/device.h
@@ -279,6 +279,26 @@ enum {
 };
 
 enum {
+	MLX5_ROCE_VERSION_1		= 0,
+	MLX5_ROCE_VERSION_2		= 2,
+};
+
+enum {
+	MLX5_ROCE_VERSION_1_CAP		= 1 << MLX5_ROCE_VERSION_1,
+	MLX5_ROCE_VERSION_2_CAP		= 1 << MLX5_ROCE_VERSION_2,
+};
+
+enum {
+	MLX5_ROCE_L3_TYPE_IPV4		= 0,
+	MLX5_ROCE_L3_TYPE_IPV6		= 1,
+};
+
+enum {
+	MLX5_ROCE_L3_TYPE_IPV4_CAP	= 1 << 1,
+	MLX5_ROCE_L3_TYPE_IPV6_CAP	= 1 << 2,
+};
+
+enum {
 	MLX5_OPCODE_NOP			= 0x00,
 	MLX5_OPCODE_SEND_INVAL		= 0x01,
 	MLX5_OPCODE_RDMA_WRITE		= 0x08,
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
