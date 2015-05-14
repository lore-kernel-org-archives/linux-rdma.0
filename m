From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 5/5] IB/core: Convert management helpers to core capability bits
Date: Wed, 13 May 2015 20:02:59 -0400
Message-ID: <1431561779-13714-6-git-send-email-ira.weiny@intel.com>
References: <1431561779-13714-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1431561779-13714-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Remove query_protocol callback

Use the new Core Capability bits for:

rdma_protocol_*
rdma_cap_ib_mad
rdma_cap_ib_smi
rdma_cap_ib_cm
rdma_cap_iw_cm
rdma_cap_ib_sa
rdma_cap_ib_mcast
rdma_cap_af_ib
rdma_cap_eth_ah

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

---
Changes since V1:
	Change IBOE to ROCE
	Clean up flag checks when returning bool

 drivers/infiniband/core/device.c             |  1 -
 drivers/infiniband/hw/amso1100/c2_provider.c |  8 +---
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  8 +---
 drivers/infiniband/hw/cxgb4/provider.c       |  8 +---
 drivers/infiniband/hw/ehca/ehca_hca.c        |  6 ---
 drivers/infiniband/hw/ehca/ehca_main.c       |  2 +-
 drivers/infiniband/hw/ipath/ipath_verbs.c    |  8 +---
 drivers/infiniband/hw/mlx4/main.c            | 15 +++----
 drivers/infiniband/hw/mlx5/main.c            |  8 +---
 drivers/infiniband/hw/mthca/mthca_provider.c |  8 +---
 drivers/infiniband/hw/nes/nes_verbs.c        |  8 +---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |  2 +-
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  6 ---
 drivers/infiniband/hw/qib/qib_verbs.c        |  8 +---
 drivers/infiniband/hw/usnic/usnic_ib_main.c  |  1 -
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  6 ---
 include/rdma/ib_verbs.h                      | 64 +++++++++++++++++++++-------
 17 files changed, 63 insertions(+), 104 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 4aa4f5420bc9..8d07c12ab718 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -76,7 +76,6 @@ static int ib_device_check_mandatory(struct ib_device *device)
 	} mandatory_table[] = {
 		IB_MANDATORY_FUNC(query_device),
 		IB_MANDATORY_FUNC(query_port),
-		IB_MANDATORY_FUNC(query_protocol),
 		IB_MANDATORY_FUNC(query_pkey),
 		IB_MANDATORY_FUNC(query_gid),
 		IB_MANDATORY_FUNC(alloc_pd),
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index fa638963908f..d396c39918de 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -99,12 +99,6 @@ static int c2_query_port(struct ib_device *ibdev,
 	return 0;
 }
 
-static enum rdma_protocol_type
-c2_query_protocol(struct ib_device *device, u8 port_num)
-{
-	return RDMA_PROTOCOL_IWARP;
-}
-
 static int c2_query_pkey(struct ib_device *ibdev,
 			 u8 port, u16 index, u16 * pkey)
 {
@@ -775,6 +769,7 @@ static int c2_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
 
 	return 0;
 }
@@ -823,7 +818,6 @@ int c2_register_device(struct c2_dev *dev)
 	dev->ibdev.dma_device = &dev->pcidev->dev;
 	dev->ibdev.query_device = c2_query_device;
 	dev->ibdev.query_port = c2_query_port;
-	dev->ibdev.query_protocol = c2_query_protocol;
 	dev->ibdev.query_pkey = c2_query_pkey;
 	dev->ibdev.query_gid = c2_query_gid;
 	dev->ibdev.alloc_ucontext = c2_alloc_ucontext;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 590ba0f422a1..061ef08c92e2 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1232,12 +1232,6 @@ static int iwch_query_port(struct ib_device *ibdev,
 	return 0;
 }
 
-static enum rdma_protocol_type
-iwch_query_protocol(struct ib_device *device, u8 port_num)
-{
-	return RDMA_PROTOCOL_IWARP;
-}
-
 static ssize_t show_rev(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
@@ -1361,6 +1355,7 @@ static int iwch_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
 
 	return 0;
 }
@@ -1407,7 +1402,6 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.dma_device = &(dev->rdev.rnic_info.pdev->dev);
 	dev->ibdev.query_device = iwch_query_device;
 	dev->ibdev.query_port = iwch_query_port;
-	dev->ibdev.query_protocol = iwch_query_protocol;
 	dev->ibdev.query_pkey = iwch_query_pkey;
 	dev->ibdev.query_gid = iwch_query_gid;
 	dev->ibdev.alloc_ucontext = iwch_alloc_ucontext;
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 5eded1b3bbad..ef08a9f29451 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -390,12 +390,6 @@ static int c4iw_query_port(struct ib_device *ibdev, u8 port,
 	return 0;
 }
 
-static enum rdma_protocol_type
-c4iw_query_protocol(struct ib_device *device, u8 port_num)
-{
-	return RDMA_PROTOCOL_IWARP;
-}
-
 static ssize_t show_rev(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
@@ -483,6 +477,7 @@ static int c4iw_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
 
 	return 0;
 }
@@ -528,7 +523,6 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.dma_device = &(dev->rdev.lldi.pdev->dev);
 	dev->ibdev.query_device = c4iw_query_device;
 	dev->ibdev.query_port = c4iw_query_port;
-	dev->ibdev.query_protocol = c4iw_query_protocol;
 	dev->ibdev.query_pkey = c4iw_query_pkey;
 	dev->ibdev.query_gid = c4iw_query_gid;
 	dev->ibdev.alloc_ucontext = c4iw_alloc_ucontext;
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 1f4dc9c87bf9..9ed4d2588304 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -242,12 +242,6 @@ query_port1:
 	return ret;
 }
 
-enum rdma_protocol_type
-ehca_query_protocol(struct ib_device *device, u8 port_num)
-{
-	return RDMA_PROTOCOL_IB;
-}
-
 int ehca_query_sma_attr(struct ehca_shca *shca,
 			u8 port, struct ehca_sma_attr *attr)
 {
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index 8454186e16ab..5e30b72d3677 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -443,6 +443,7 @@ static int ehca_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
 
 	return 0;
 }
@@ -483,7 +484,6 @@ static int ehca_init_device(struct ehca_shca *shca)
 	shca->ib_device.dma_device          = &shca->ofdev->dev;
 	shca->ib_device.query_device        = ehca_query_device;
 	shca->ib_device.query_port          = ehca_query_port;
-	shca->ib_device.query_protocol      = ehca_query_protocol;
 	shca->ib_device.query_gid           = ehca_query_gid;
 	shca->ib_device.query_pkey          = ehca_query_pkey;
 	/* shca->in_device.modify_device    = ehca_modify_device    */
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 49b774b6f7e8..764081d305b6 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1638,12 +1638,6 @@ static int ipath_query_port(struct ib_device *ibdev,
 	return 0;
 }
 
-static enum rdma_protocol_type
-ipath_query_protocol(struct ib_device *device, u8 port_num)
-{
-	return RDMA_PROTOCOL_IB;
-}
-
 static int ipath_modify_device(struct ib_device *device,
 			       int device_modify_mask,
 			       struct ib_device_modify *device_modify)
@@ -1998,6 +1992,7 @@ static int ipath_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
 
 	return 0;
 }
@@ -2162,7 +2157,6 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 	dev->query_device = ipath_query_device;
 	dev->modify_device = ipath_modify_device;
 	dev->query_port = ipath_query_port;
-	dev->query_protocol = ipath_query_protocol;
 	dev->modify_port = ipath_modify_port;
 	dev->query_pkey = ipath_query_pkey;
 	dev->query_gid = ipath_query_gid;
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index b2befe574033..73f66b566077 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -420,15 +420,6 @@ static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
 	return __mlx4_ib_query_port(ibdev, port, props, 0);
 }
 
-static enum rdma_protocol_type
-mlx4_ib_query_protocol(struct ib_device *device, u8 port_num)
-{
-	struct mlx4_dev *dev = to_mdev(device)->dev;
-
-	return dev->caps.port_mask[port_num] == MLX4_PORT_TYPE_IB ?
-		RDMA_PROTOCOL_IB : RDMA_PROTOCOL_IBOE;
-}
-
 int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 			union ib_gid *gid, int netw_view)
 {
@@ -2137,6 +2128,11 @@ static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
 
+	if (mlx4_ib_port_link_layer(ibdev, port_num) == IB_LINK_LAYER_INFINIBAND)
+		immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
+	else
+		immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
+
 	return 0;
 }
 
@@ -2227,7 +2223,6 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 
 	ibdev->ib_dev.query_device	= mlx4_ib_query_device;
 	ibdev->ib_dev.query_port	= mlx4_ib_query_port;
-	ibdev->ib_dev.query_protocol	= mlx4_ib_query_protocol;
 	ibdev->ib_dev.get_link_layer	= mlx4_ib_port_link_layer;
 	ibdev->ib_dev.query_gid		= mlx4_ib_query_gid;
 	ibdev->ib_dev.query_pkey	= mlx4_ib_query_pkey;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8db0edca6dd8..b2fdb9cfa645 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -262,12 +262,6 @@ out:
 	return err;
 }
 
-static enum rdma_protocol_type
-mlx5_ib_query_protocol(struct ib_device *device, u8 port_num)
-{
-	return RDMA_PROTOCOL_IB;
-}
-
 static int mlx5_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 			     union ib_gid *gid)
 {
@@ -1200,6 +1194,7 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
 
 	return 0;
 }
@@ -1266,7 +1261,6 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 
 	dev->ib_dev.query_device	= mlx5_ib_query_device;
 	dev->ib_dev.query_port		= mlx5_ib_query_port;
-	dev->ib_dev.query_protocol	= mlx5_ib_query_protocol;
 	dev->ib_dev.query_gid		= mlx5_ib_query_gid;
 	dev->ib_dev.query_pkey		= mlx5_ib_query_pkey;
 	dev->ib_dev.modify_device	= mlx5_ib_modify_device;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 4662fd20b8e6..509d59e7a15a 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -179,12 +179,6 @@ static int mthca_query_port(struct ib_device *ibdev,
 	return err;
 }
 
-static enum rdma_protocol_type
-mthca_query_protocol(struct ib_device *device, u8 port_num)
-{
-	return RDMA_PROTOCOL_IB;
-}
-
 static int mthca_modify_device(struct ib_device *ibdev,
 			       int mask,
 			       struct ib_device_modify *props)
@@ -1262,6 +1256,7 @@ static int mthca_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
 
 	return 0;
 }
@@ -1303,7 +1298,6 @@ int mthca_register_device(struct mthca_dev *dev)
 	dev->ib_dev.dma_device           = &dev->pdev->dev;
 	dev->ib_dev.query_device         = mthca_query_device;
 	dev->ib_dev.query_port           = mthca_query_port;
-	dev->ib_dev.query_protocol       = mthca_query_protocol;
 	dev->ib_dev.modify_device        = mthca_modify_device;
 	dev->ib_dev.modify_port          = mthca_modify_port;
 	dev->ib_dev.query_pkey           = mthca_query_pkey;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 4ed2d967d324..05530e3f6ff0 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -606,12 +606,6 @@ static int nes_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr
 	return 0;
 }
 
-static enum rdma_protocol_type
-nes_query_protocol(struct ib_device *device, u8 port_num)
-{
-	return RDMA_PROTOCOL_IWARP;
-}
-
 /**
  * nes_query_pkey
  */
@@ -3845,6 +3839,7 @@ static int nes_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->core_cap_flags = RDMA_CORE_PORT_IWARP;
 
 	return 0;
 }
@@ -3899,7 +3894,6 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	nesibdev->ibdev.dev.parent = &nesdev->pcidev->dev;
 	nesibdev->ibdev.query_device = nes_query_device;
 	nesibdev->ibdev.query_port = nes_query_port;
-	nesibdev->ibdev.query_protocol = nes_query_protocol;
 	nesibdev->ibdev.query_pkey = nes_query_pkey;
 	nesibdev->ibdev.query_gid = nes_query_gid;
 	nesibdev->ibdev.alloc_ucontext = nes_alloc_ucontext;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 21744be6cac5..f55289869357 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -214,6 +214,7 @@ static int ocrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
 
 	return 0;
 }
@@ -260,7 +261,6 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 	/* mandatory verbs. */
 	dev->ibdev.query_device = ocrdma_query_device;
 	dev->ibdev.query_port = ocrdma_query_port;
-	dev->ibdev.query_protocol = ocrdma_query_protocol;
 	dev->ibdev.modify_port = ocrdma_modify_port;
 	dev->ibdev.query_gid = ocrdma_query_gid;
 	dev->ibdev.get_link_layer = ocrdma_link_layer;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 3e98360e908d..877175563634 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -187,12 +187,6 @@ int ocrdma_query_port(struct ib_device *ibdev,
 	return 0;
 }
 
-enum rdma_protocol_type
-ocrdma_query_protocol(struct ib_device *device, u8 port_num)
-{
-	return RDMA_PROTOCOL_IBOE;
-}
-
 int ocrdma_modify_port(struct ib_device *ibdev, u8 port, int mask,
 		       struct ib_port_modify *props)
 {
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 48f4784c53a6..dba1c92f1a54 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1650,12 +1650,6 @@ static int qib_query_port(struct ib_device *ibdev, u8 port,
 	return 0;
 }
 
-static enum rdma_protocol_type
-qib_query_protocol(struct ib_device *device, u8 port_num)
-{
-	return RDMA_PROTOCOL_IB;
-}
-
 static int qib_modify_device(struct ib_device *device,
 			     int device_modify_mask,
 			     struct ib_device_modify *device_modify)
@@ -2058,6 +2052,7 @@ static int qib_port_immutable(struct ib_device *ibdev, u8 port_num,
 
 	immutable->pkey_tbl_len = attr.pkey_tbl_len;
 	immutable->gid_tbl_len = attr.gid_tbl_len;
+	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_IB;
 
 	return 0;
 }
@@ -2206,7 +2201,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->query_device = qib_query_device;
 	ibdev->modify_device = qib_modify_device;
 	ibdev->query_port = qib_query_port;
-	ibdev->query_protocol = qib_query_protocol;
 	ibdev->modify_port = qib_modify_port;
 	ibdev->query_pkey = qib_query_pkey;
 	ibdev->query_gid = qib_query_gid;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index ce3e19bcfe00..34c49b8105fe 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -376,7 +376,6 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 
 	us_ibdev->ib_dev.query_device = usnic_ib_query_device;
 	us_ibdev->ib_dev.query_port = usnic_ib_query_port;
-	us_ibdev->ib_dev.query_protocol = usnic_ib_query_protocol;
 	us_ibdev->ib_dev.query_pkey = usnic_ib_query_pkey;
 	us_ibdev->ib_dev.query_gid = usnic_ib_query_gid;
 	us_ibdev->ib_dev.get_link_layer = usnic_ib_port_link_layer;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 732b5c5eeb32..53bd6a2d9cdb 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -348,12 +348,6 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 	return 0;
 }
 
-enum rdma_protocol_type
-usnic_ib_query_protocol(struct ib_device *device, u8 port_num)
-{
-	return RDMA_PROTOCOL_USNIC_UDP;
-}
-
 int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
 				int qp_attr_mask,
 				struct ib_qp_init_attr *qp_init_attr)
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index de08dabcfa6a..29095fb6db5c 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -353,6 +353,40 @@ union rdma_protocol_stats {
 	struct iw_protocol_stats	iw;
 };
 
+/* Define bits for the various functionality this port needs to be supported by
+ * the core.
+ */
+/* Management                           0x00000FFF */
+#define RDMA_CORE_CAP_IB_MAD            0x00000001
+#define RDMA_CORE_CAP_IB_SMI            0x00000002
+#define RDMA_CORE_CAP_IB_CM             0x00000004
+#define RDMA_CORE_CAP_IW_CM             0x00000008
+#define RDMA_CORE_CAP_IB_SA             0x00000010
+
+/* Address format                       0x000FF000 */
+#define RDMA_CORE_CAP_AF_IB             0x00001000
+#define RDMA_CORE_CAP_ETH_AH            0x00002000
+
+/* Protocol                             0xFFF00000 */
+#define RDMA_CORE_CAP_PROT_IB           0x00100000
+#define RDMA_CORE_CAP_PROT_ROCE         0x00200000
+#define RDMA_CORE_CAP_PROT_IWARP        0x00400000
+
+#define RDMA_CORE_PORT_IBA_IB          (RDMA_CORE_CAP_PROT_IB  \
+					| RDMA_CORE_CAP_IB_MAD \
+					| RDMA_CORE_CAP_IB_SMI \
+					| RDMA_CORE_CAP_IB_CM  \
+					| RDMA_CORE_CAP_IB_SA  \
+					| RDMA_CORE_CAP_AF_IB)
+#define RDMA_CORE_PORT_IBA_ROCE        (RDMA_CORE_CAP_PROT_ROCE \
+					| RDMA_CORE_CAP_IB_MAD  \
+					| RDMA_CORE_CAP_IB_CM   \
+					| RDMA_CORE_CAP_IB_SA   \
+					| RDMA_CORE_CAP_AF_IB   \
+					| RDMA_CORE_CAP_ETH_AH)
+#define RDMA_CORE_PORT_IWARP           (RDMA_CORE_CAP_PROT_IWARP \
+					| RDMA_CORE_CAP_IW_CM)
+
 struct ib_port_attr {
 	enum ib_port_state	state;
 	enum ib_mtu		max_mtu;
@@ -1484,6 +1518,7 @@ struct iw_cm_verbs;
 struct ib_port_immutable {
 	int                           pkey_tbl_len;
 	int                           gid_tbl_len;
+	u32                           core_cap_flags;
 };
 
 struct ib_device {
@@ -1515,8 +1550,6 @@ struct ib_device {
 	int		           (*query_port)(struct ib_device *device,
 						 u8 port_num,
 						 struct ib_port_attr *port_attr);
-	enum rdma_protocol_type    (*query_protocol)(struct ib_device *device,
-						     u8 port_num);
 	enum rdma_link_layer	   (*get_link_layer)(struct ib_device *device,
 						     u8 port_num);
 	int		           (*query_gid)(struct ib_device *device,
@@ -1796,24 +1829,23 @@ static inline u8 rdma_end_port(const struct ib_device *device)
 
 static inline bool rdma_protocol_ib(struct ib_device *device, u8 port_num)
 {
-	return device->query_protocol(device, port_num) == RDMA_PROTOCOL_IB;
+	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_IB;
 }
 
 static inline bool rdma_protocol_iboe(struct ib_device *device, u8 port_num)
 {
-	return device->query_protocol(device, port_num) == RDMA_PROTOCOL_IBOE;
+	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_ROCE;
 }
 
 static inline bool rdma_protocol_iwarp(struct ib_device *device, u8 port_num)
 {
-	return device->query_protocol(device, port_num) == RDMA_PROTOCOL_IWARP;
+	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_IWARP;
 }
 
 static inline bool rdma_ib_or_iboe(struct ib_device *device, u8 port_num)
 {
-	enum rdma_protocol_type pt = device->query_protocol(device, port_num);
-
-	return (pt == RDMA_PROTOCOL_IB || pt == RDMA_PROTOCOL_IBOE);
+	return device->port_immutable[port_num].core_cap_flags &
+		(RDMA_CORE_CAP_PROT_IB | RDMA_CORE_CAP_PROT_ROCE);
 }
 
 /**
@@ -1828,7 +1860,7 @@ static inline bool rdma_ib_or_iboe(struct ib_device *device, u8 port_num)
  */
 static inline bool rdma_cap_ib_mad(struct ib_device *device, u8 port_num)
 {
-	return rdma_ib_or_iboe(device, port_num);
+	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_IB_MAD;
 }
 
 /**
@@ -1843,7 +1875,7 @@ static inline bool rdma_cap_ib_mad(struct ib_device *device, u8 port_num)
  */
 static inline bool rdma_cap_ib_smi(struct ib_device *device, u8 port_num)
 {
-	return rdma_protocol_ib(device, port_num);
+	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_IB_SMI;
 }
 
 /**
@@ -1858,7 +1890,7 @@ static inline bool rdma_cap_ib_smi(struct ib_device *device, u8 port_num)
  */
 static inline bool rdma_cap_ib_cm(struct ib_device *device, u8 port_num)
 {
-	return rdma_ib_or_iboe(device, port_num);
+	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_IB_CM;
 }
 
 /**
@@ -1873,7 +1905,7 @@ static inline bool rdma_cap_ib_cm(struct ib_device *device, u8 port_num)
  */
 static inline bool rdma_cap_iw_cm(struct ib_device *device, u8 port_num)
 {
-	return rdma_protocol_iwarp(device, port_num);
+	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_IW_CM;
 }
 
 /**
@@ -1888,7 +1920,7 @@ static inline bool rdma_cap_iw_cm(struct ib_device *device, u8 port_num)
  */
 static inline bool rdma_cap_ib_sa(struct ib_device *device, u8 port_num)
 {
-	return rdma_protocol_ib(device, port_num);
+	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_IB_SA;
 }
 
 /**
@@ -1918,7 +1950,7 @@ static inline bool rdma_cap_ib_mcast(struct ib_device *device, u8 port_num)
  */
 static inline bool rdma_cap_af_ib(struct ib_device *device, u8 port_num)
 {
-	return rdma_ib_or_iboe(device, port_num);
+	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_AF_IB;
 }
 
 /**
@@ -1933,7 +1965,7 @@ static inline bool rdma_cap_af_ib(struct ib_device *device, u8 port_num)
  */
 static inline bool rdma_cap_eth_ah(struct ib_device *device, u8 port_num)
 {
-	return rdma_protocol_iboe(device, port_num);
+	return device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_ETH_AH;
 }
 
 /**
@@ -1949,7 +1981,7 @@ static inline bool rdma_cap_eth_ah(struct ib_device *device, u8 port_num)
 static inline bool rdma_cap_read_multi_sge(struct ib_device *device,
 					   u8 port_num)
 {
-	return !rdma_protocol_iwarp(device, port_num);
+	return !(device->port_immutable[port_num].core_cap_flags & RDMA_CORE_CAP_PROT_IWARP);
 }
 
 int ib_query_gid(struct ib_device *device,
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
