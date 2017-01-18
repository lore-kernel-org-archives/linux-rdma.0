From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 6/7] IB/mlx5: Assign DSCP for R-RoCE QPs Address Path
Date: Wed, 18 Jan 2017 14:10:35 +0200
Message-ID: <20170118121036.32642-7-leon@kernel.org>
References: <20170118121036.32642-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170118121036.32642-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

For Routable RoCE QPs, the DSCP should be set in the QP's
address path.

The DSCP's value is derived from the traffic class.

Fixes: 2811ba51b049 ("IB/mlx5: Add RoCE fields to Address Vector")
Cc: Achiad Shochat <achiad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c    | 21 +++++++++++++++++++++
 drivers/infiniband/hw/mlx5/mlx5_ib.h |  2 ++
 drivers/infiniband/hw/mlx5/qp.c      |  7 +++++++
 3 files changed, 30 insertions(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 1dea407..6a81f027 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -325,6 +325,27 @@ __be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *dev, u8 port_num,
 	return cpu_to_be16(MLX5_CAP_ROCE(dev->mdev, r_roce_min_src_udp_port));
 }
 
+int mlx5_get_roce_gid_type(struct mlx5_ib_dev *dev, u8 port_num,
+			   int index, enum ib_gid_type *gid_type)
+{
+	struct ib_gid_attr attr;
+	union ib_gid gid;
+	int ret;
+
+	ret = ib_get_cached_gid(&dev->ib_dev, port_num, index, &gid, &attr);
+	if (ret)
+		return ret;
+
+	if (!attr.ndev)
+		return -ENODEV;
+
+	dev_put(attr.ndev);
+
+	*gid_type = attr.gid_type;
+
+	return 0;
+}
+
 static int mlx5_use_mad_ifc(struct mlx5_ib_dev *dev)
 {
 	if (MLX5_CAP_GEN(dev->mdev, port_type) == MLX5_CAP_PORT_TYPE_IB)
diff --git a/drivers/infiniband/hw/mlx5/mlx5_ib.h b/drivers/infiniband/hw/mlx5/mlx5_ib.h
index e1a4b93d..dda01d7 100644
--- a/drivers/infiniband/hw/mlx5/mlx5_ib.h
+++ b/drivers/infiniband/hw/mlx5/mlx5_ib.h
@@ -872,6 +872,8 @@ int mlx5_ib_set_vf_guid(struct ib_device *device, int vf, u8 port,
 
 __be16 mlx5_get_roce_udp_sport(struct mlx5_ib_dev *dev, u8 port_num,
 			       int index);
+int mlx5_get_roce_gid_type(struct mlx5_ib_dev *dev, u8 port_num,
+			   int index, enum ib_gid_type *gid_type);
 
 /* GSI QP helper functions */
 struct ib_qp *mlx5_ib_gsi_create_qp(struct ib_pd *pd,
diff --git a/drivers/infiniband/hw/mlx5/qp.c b/drivers/infiniband/hw/mlx5/qp.c
index 9af9b95..e22d957 100644
--- a/drivers/infiniband/hw/mlx5/qp.c
+++ b/drivers/infiniband/hw/mlx5/qp.c
@@ -2198,6 +2198,7 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 {
 	enum rdma_link_layer ll = rdma_port_get_link_layer(&dev->ib_dev, port);
 	int err;
+	enum ib_gid_type gid_type;
 
 	if (attr_mask & IB_QP_PKEY_INDEX)
 		path->pkey_index = cpu_to_be16(alt ? attr->alt_pkey_index :
@@ -2216,10 +2217,16 @@ static int mlx5_set_path(struct mlx5_ib_dev *dev, struct mlx5_ib_qp *qp,
 	if (ll == IB_LINK_LAYER_ETHERNET) {
 		if (!(ah->ah_flags & IB_AH_GRH))
 			return -EINVAL;
+		err = mlx5_get_roce_gid_type(dev, port, ah->grh.sgid_index,
+					     &gid_type);
+		if (err)
+			return err;
 		memcpy(path->rmac, ah->dmac, sizeof(ah->dmac));
 		path->udp_sport = mlx5_get_roce_udp_sport(dev, port,
 							  ah->grh.sgid_index);
 		path->dci_cfi_prio_sl = (ah->sl & 0x7) << 4;
+		if (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP)
+			path->ecn_dscp = (ah->grh.traffic_class >> 2) & 0x3f;
 	} else {
 		path->fl_free_ar = (path_flags & MLX5_PATH_FLAG_FL) ? 0x80 : 0;
 		path->fl_free_ar |=
-- 
2.10.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
