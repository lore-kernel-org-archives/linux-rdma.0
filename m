From: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH rdma-next V1 03/10] IB/core: Add subnet prefix to port info
Date: Mon,  7 Mar 2016 23:08:53 +0200
Message-ID: <1457384940-11951-4-git-send-email-eli@mellanox.com>
References: <1457384940-11951-1-git-send-email-eli@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1457384940-11951-1-git-send-email-eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The subnet prefix is a part of the port_info MAD returned and should be
available at the ib_port_attr struct. We define it here and implement
for all the hardware drivers. The subnet prefix is required when
creating the address vector to access the SA in networks where GRH must
be used.

Signed-off-by: Eli Cohen <eli-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c  | 7 +++++++
 drivers/infiniband/hw/cxgb4/provider.c       | 7 +++++++
 drivers/infiniband/hw/mlx4/main.c            | 1 +
 drivers/infiniband/hw/mlx5/mad.c             | 1 +
 drivers/infiniband/hw/mlx5/main.c            | 9 +++++++++
 drivers/infiniband/hw/mthca/mthca_provider.c | 1 +
 drivers/infiniband/hw/nes/nes_verbs.c        | 7 +++++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  | 7 +++++++
 drivers/infiniband/hw/qib/qib_verbs.c        | 7 +++++++
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c | 7 +++++++
 include/rdma/ib_verbs.h                      | 1 +
 11 files changed, 55 insertions(+)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 42a7b8952d13..e801112db599 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1127,6 +1127,8 @@ static int iwch_query_port(struct ib_device *ibdev,
 	struct iwch_dev *dev;
 	struct net_device *netdev;
 	struct in_device *inetdev;
+	union ib_gid gid;
+	int err;
 
 	PDBG("%s ibdev %p\n", __func__, ibdev);
 
@@ -1171,6 +1173,11 @@ static int iwch_query_port(struct ib_device *ibdev,
 	props->active_width = 2;
 	props->active_speed = IB_SPEED_DDR;
 	props->max_msg_sz = -1;
+	err = ib_query_gid(ibdev, port, 0, &gid, NULL);
+	if (err)
+		return err;
+
+	props->subnet_prefix = be64_to_cpu(gid.global.subnet_prefix);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index ec04272fbdc2..fc98a4a77db7 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -350,6 +350,8 @@ static int c4iw_query_port(struct ib_device *ibdev, u8 port,
 	struct c4iw_dev *dev;
 	struct net_device *netdev;
 	struct in_device *inetdev;
+	union ib_gid gid;
+	int err;
 
 	PDBG("%s ibdev %p\n", __func__, ibdev);
 
@@ -394,6 +396,11 @@ static int c4iw_query_port(struct ib_device *ibdev, u8 port,
 	props->active_width = 2;
 	props->active_speed = IB_SPEED_DDR;
 	props->max_msg_sz = -1;
+	err = ib_query_gid(ibdev, port, 0, &gid, NULL);
+	if (err)
+		return err;
+
+	props->subnet_prefix = be64_to_cpu(gid.global.subnet_prefix);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 1c7ab6cabbb8..e50d13ee3717 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -606,6 +606,7 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 		goto out;
 
 
+	props->subnet_prefix	= be64_to_cpup((__be64 *)(out_mad->data + 8));
 	props->lid		= be16_to_cpup((__be16 *) (out_mad->data + 16));
 	props->lmc		= out_mad->data[34] & 0x7;
 	props->sm_lid		= be16_to_cpup((__be16 *) (out_mad->data + 18));
diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 41d8a0036465..2ba01740b3d8 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -527,6 +527,7 @@ int mlx5_query_mad_ifc_port(struct ib_device *ibdev, u8 port,
 		goto out;
 	}
 
+	props->subnet_prefix	= be64_to_cpup((__be64 *)(out_mad->data + 8));
 	props->lid		= be16_to_cpup((__be16 *)(out_mad->data + 16));
 	props->lmc		= out_mad->data[34] & 0x7;
 	props->sm_lid		= be16_to_cpup((__be16 *)(out_mad->data + 18));
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 79ee6997daa2..4d0cbea6cbd1 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -672,6 +672,7 @@ static int mlx5_query_hca_port(struct ib_device *ibdev, u8 port,
 	int err;
 	u8 ib_link_width_oper;
 	u8 vl_hw_cap;
+	union ib_gid gid;
 
 	rep = kzalloc(sizeof(*rep), GFP_KERNEL);
 	if (!rep) {
@@ -727,6 +728,14 @@ static int mlx5_query_hca_port(struct ib_device *ibdev, u8 port,
 
 	err = translate_max_vl_num(ibdev, vl_hw_cap,
 				   &props->max_vl_num);
+	if (err)
+		goto out;
+
+	err = mlx5_query_hca_vport_gid(mdev, 0,  port, 0, 0, &gid);
+	if (err)
+		goto out;
+
+	props->subnet_prefix = be64_to_cpu(gid.global.subnet_prefix);
 out:
 	kfree(rep);
 	return err;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 9866c35cc977..699b2a0795ea 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -157,6 +157,7 @@ static int mthca_query_port(struct ib_device *ibdev,
 	if (err)
 		goto out;
 
+	props->subnet_prefix	 = be64_to_cpup((__be64 *)(out_mad->data + 8));
 	props->lid               = be16_to_cpup((__be16 *) (out_mad->data + 16));
 	props->lmc               = out_mad->data[34] & 0x7;
 	props->sm_lid            = be16_to_cpup((__be16 *) (out_mad->data + 18));
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 5af19b4cde51..af977113b96c 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -475,6 +475,8 @@ static int nes_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr
 {
 	struct nes_vnic *nesvnic = to_nesvnic(ibdev);
 	struct net_device *netdev = nesvnic->netdev;
+	union ib_gid gid;
+	int err;
 
 	memset(props, 0, sizeof(*props));
 
@@ -510,6 +512,11 @@ static int nes_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr
 	props->active_width = IB_WIDTH_4X;
 	props->active_speed = IB_SPEED_SDR;
 	props->max_msg_sz = 0x80000000;
+	err = ib_query_gid(ibdev, port, 0, &gid, NULL);
+	if (err)
+		return err;
+
+	props->subnet_prefix = be64_to_cpu(gid.global.subnet_prefix);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 12420e4ecf3d..38a73371f43e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -209,6 +209,8 @@ int ocrdma_query_port(struct ib_device *ibdev,
 	enum ib_port_state port_state;
 	struct ocrdma_dev *dev;
 	struct net_device *netdev;
+	union ib_gid gid;
+	int err;
 
 	dev = get_ocrdma_dev(ibdev);
 	if (port > 1) {
@@ -244,6 +246,11 @@ int ocrdma_query_port(struct ib_device *ibdev,
 				 &props->active_width);
 	props->max_msg_sz = 0x80000000;
 	props->max_vl_num = 4;
+	err = ib_query_gid(ibdev, port, 0, &gid, NULL);
+	if (err)
+		return err;
+
+	props->subnet_prefix = be64_to_cpu(gid.global.subnet_prefix);
 	return 0;
 }
 
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index baf1e42b6896..4ab7d6617467 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1629,6 +1629,8 @@ static int qib_query_port(struct ib_device *ibdev, u8 port,
 	struct qib_pportdata *ppd = ppd_from_ibp(ibp);
 	enum ib_mtu mtu;
 	u16 lid = ppd->lid;
+	union ib_gid gid;
+	int err;
 
 	memset(props, 0, sizeof(*props));
 	props->lid = lid ? lid : be16_to_cpu(IB_LID_PERMISSIVE);
@@ -1671,6 +1673,11 @@ static int qib_query_port(struct ib_device *ibdev, u8 port,
 	}
 	props->active_mtu = mtu;
 	props->subnet_timeout = ibp->subnet_timeout;
+	err = ib_query_gid(ibdev, port, 0, &gid, NULL);
+	if (err)
+		return err;
+
+	props->subnet_prefix = be64_to_cpu(gid.global.subnet_prefix);
 
 	return 0;
 }
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 6cdb4d23f78f..68d36ab1e33b 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -327,6 +327,8 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 {
 	struct usnic_ib_dev *us_ibdev = to_usdev(ibdev);
 	struct ethtool_cmd cmd;
+	union ib_gid gid;
+	int err;
 
 	usnic_dbg("\n");
 
@@ -363,6 +365,11 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 	props->max_msg_sz = us_ibdev->ufdev->mtu;
 	props->max_vl_num = 1;
 	mutex_unlock(&us_ibdev->usdev_lock);
+	err = ib_query_gid(ibdev, port, 0, &gid, NULL);
+	if (err)
+		return err;
+
+	props->subnet_prefix = be64_to_cpu(gid.global.subnet_prefix);
 
 	return 0;
 }
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index d83bc300c2b3..b3646e30e25d 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -509,6 +509,7 @@ struct ib_port_attr {
 	u8			active_width;
 	u8			active_speed;
 	u8                      phys_state;
+	u64			subnet_prefix;
 };
 
 enum ib_device_modify_flags {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
