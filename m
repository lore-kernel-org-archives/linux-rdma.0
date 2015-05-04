From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [RFC PATCH 2/5] IB/core: Replace query_protocol callback with Core Capability flags check
Date: Mon,  4 May 2015 02:14:56 -0400
Message-ID: <1430720099-32512-3-git-send-email-ira.weiny@intel.com>
References: <1430720099-32512-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1430720099-32512-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Replace the query_protocol with a check against the Core Capabilities Flags.
This is more efficient than a function call.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/device.c             |    1 -
 drivers/infiniband/hw/amso1100/c2_provider.c |    8 +-------
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |    8 +-------
 drivers/infiniband/hw/cxgb4/provider.c       |    8 +-------
 drivers/infiniband/hw/ehca/ehca_hca.c        |    8 ++------
 drivers/infiniband/hw/ehca/ehca_main.c       |    1 -
 drivers/infiniband/hw/ipath/ipath_verbs.c    |    8 +-------
 drivers/infiniband/hw/mlx4/main.c            |   13 +++----------
 drivers/infiniband/hw/mlx5/main.c            |    9 ++-------
 drivers/infiniband/hw/mthca/mthca_provider.c |    8 +-------
 drivers/infiniband/hw/nes/nes_verbs.c        |    8 +-------
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |    1 -
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |    7 +------
 drivers/infiniband/hw/qib/qib_verbs.c        |    8 +-------
 drivers/infiniband/hw/usnic/usnic_ib_main.c  |    1 -
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |    7 +------
 include/rdma/ib_verbs.h                      |   13 ++++++-------
 17 files changed, 22 insertions(+), 95 deletions(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 6a37255..fd8961a 100644
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
index 6fe329a..b9300db 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -95,16 +95,11 @@ static int c2_query_port(struct ib_device *ibdev,
 	props->qkey_viol_cntr = 0;
 	props->active_width = 1;
 	props->active_speed = IB_SPEED_SDR;
+	props->core_cap_flags = RDMA_CORE_CAP_PROT_IWARP;
 
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
@@ -807,7 +802,6 @@ int c2_register_device(struct c2_dev *dev)
 	dev->ibdev.dma_device = &dev->pcidev->dev;
 	dev->ibdev.query_device = c2_query_device;
 	dev->ibdev.query_port = c2_query_port;
-	dev->ibdev.query_protocol = c2_query_protocol;
 	dev->ibdev.query_pkey = c2_query_pkey;
 	dev->ibdev.query_gid = c2_query_gid;
 	dev->ibdev.alloc_ucontext = c2_alloc_ucontext;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 298d1ca..e270846 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1228,16 +1228,11 @@ static int iwch_query_port(struct ib_device *ibdev,
 	props->active_width = 2;
 	props->active_speed = IB_SPEED_DDR;
 	props->max_msg_sz = -1;
+	props->core_cap_flags = RDMA_CORE_CAP_PROT_IWARP;
 
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
@@ -1391,7 +1386,6 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.dma_device = &(dev->rdev.rnic_info.pdev->dev);
 	dev->ibdev.query_device = iwch_query_device;
 	dev->ibdev.query_port = iwch_query_port;
-	dev->ibdev.query_protocol = iwch_query_protocol;
 	dev->ibdev.query_pkey = iwch_query_pkey;
 	dev->ibdev.query_gid = iwch_query_gid;
 	dev->ibdev.alloc_ucontext = iwch_alloc_ucontext;
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index f52ee63..ff63344 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -386,16 +386,11 @@ static int c4iw_query_port(struct ib_device *ibdev, u8 port,
 	props->active_width = 2;
 	props->active_speed = IB_SPEED_DDR;
 	props->max_msg_sz = -1;
+	props->core_cap_flags = RDMA_CORE_CAP_PROT_IWARP;
 
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
@@ -512,7 +507,6 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.dma_device = &(dev->rdev.lldi.pdev->dev);
 	dev->ibdev.query_device = c4iw_query_device;
 	dev->ibdev.query_port = c4iw_query_port;
-	dev->ibdev.query_protocol = c4iw_query_protocol;
 	dev->ibdev.query_pkey = c4iw_query_pkey;
 	dev->ibdev.query_gid = c4iw_query_gid;
 	dev->ibdev.alloc_ucontext = c4iw_alloc_ucontext;
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 1f4dc9c..75f5353 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -236,18 +236,14 @@ int ehca_query_port(struct ib_device *ibdev,
 		props->active_speed    = IB_SPEED_SDR;
 	}
 
+	props->core_cap_flags = RDMA_CORE_CAP_PROT_IB;
+
 query_port1:
 	ehca_free_fw_ctrlblock(rblock);
 
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
index 321545b..cd8d290 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -467,7 +467,6 @@ static int ehca_init_device(struct ehca_shca *shca)
 	shca->ib_device.dma_device          = &shca->ofdev->dev;
 	shca->ib_device.query_device        = ehca_query_device;
 	shca->ib_device.query_port          = ehca_query_port;
-	shca->ib_device.query_protocol      = ehca_query_protocol;
 	shca->ib_device.query_gid           = ehca_query_gid;
 	shca->ib_device.query_pkey          = ehca_query_pkey;
 	/* shca->in_device.modify_device    = ehca_modify_device    */
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 34b94c3..94a03eb 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1634,16 +1634,11 @@ static int ipath_query_port(struct ib_device *ibdev,
 	}
 	props->active_mtu = mtu;
 	props->subnet_timeout = dev->subnet_timeout;
+	props->core_cap_flags = RDMA_CORE_CAP_PROT_IB;
 
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
@@ -2146,7 +2141,6 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 	dev->query_device = ipath_query_device;
 	dev->modify_device = ipath_modify_device;
 	dev->query_port = ipath_query_port;
-	dev->query_protocol = ipath_query_protocol;
 	dev->modify_port = ipath_modify_port;
 	dev->query_pkey = ipath_query_pkey;
 	dev->query_gid = ipath_query_gid;
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 26678d2..fa4e45c 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -330,6 +330,8 @@ static int ib_link_query_port(struct ib_device *ibdev, u8 port,
 	if (props->state == IB_PORT_DOWN)
 		 props->active_speed = IB_SPEED_SDR;
 
+	props->core_cap_flags = RDMA_CORE_CAP_PROT_IB;
+
 out:
 	kfree(in_mad);
 	kfree(out_mad);
@@ -390,6 +392,7 @@ static int eth_link_query_port(struct ib_device *ibdev, u8 port,
 	props->state		= (netif_running(ndev) && netif_carrier_ok(ndev)) ?
 					IB_PORT_ACTIVE : IB_PORT_DOWN;
 	props->phys_state	= state_to_phys_state(props->state);
+	props->core_cap_flags   = RDMA_CORE_CAP_PROT_IBOE;
 out_unlock:
 	spin_unlock_bh(&iboe->lock);
 	if (is_bonded)
@@ -420,15 +423,6 @@ static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
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
@@ -2211,7 +2205,6 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 
 	ibdev->ib_dev.query_device	= mlx4_ib_query_device;
 	ibdev->ib_dev.query_port	= mlx4_ib_query_port;
-	ibdev->ib_dev.query_protocol	= mlx4_ib_query_protocol;
 	ibdev->ib_dev.get_link_layer	= mlx4_ib_port_link_layer;
 	ibdev->ib_dev.query_gid		= mlx4_ib_query_gid;
 	ibdev->ib_dev.query_pkey	= mlx4_ib_query_pkey;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 8dec380..e3cdc17 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -255,6 +255,8 @@ int mlx5_ib_query_port(struct ib_device *ibdev, u8 port,
 		}
 	}
 
+	props->core_cap_flags   = RDMA_CORE_CAP_PROT_IB;
+
 out:
 	kfree(in_mad);
 	kfree(out_mad);
@@ -262,12 +264,6 @@ out:
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
@@ -1250,7 +1246,6 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 
 	dev->ib_dev.query_device	= mlx5_ib_query_device;
 	dev->ib_dev.query_port		= mlx5_ib_query_port;
-	dev->ib_dev.query_protocol	= mlx5_ib_query_protocol;
 	dev->ib_dev.query_gid		= mlx5_ib_query_gid;
 	dev->ib_dev.query_pkey		= mlx5_ib_query_pkey;
 	dev->ib_dev.modify_device	= mlx5_ib_modify_device;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index ad1cca3..e49aece 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -172,6 +172,7 @@ static int mthca_query_port(struct ib_device *ibdev,
 	props->subnet_timeout    = out_mad->data[51] & 0x1f;
 	props->max_vl_num        = out_mad->data[37] >> 4;
 	props->init_type_reply   = out_mad->data[41] >> 4;
+	props->core_cap_flags    = RDMA_CORE_CAP_PROT_IB;
 
  out:
 	kfree(in_mad);
@@ -179,12 +180,6 @@ static int mthca_query_port(struct ib_device *ibdev,
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
@@ -1287,7 +1282,6 @@ int mthca_register_device(struct mthca_dev *dev)
 	dev->ib_dev.dma_device           = &dev->pdev->dev;
 	dev->ib_dev.query_device         = mthca_query_device;
 	dev->ib_dev.query_port           = mthca_query_port;
-	dev->ib_dev.query_protocol       = mthca_query_protocol;
 	dev->ib_dev.modify_device        = mthca_modify_device;
 	dev->ib_dev.modify_port          = mthca_modify_port;
 	dev->ib_dev.query_pkey           = mthca_query_pkey;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 027f6d1..187eda6 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -602,16 +602,11 @@ static int nes_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr
 	props->active_width = IB_WIDTH_4X;
 	props->active_speed = IB_SPEED_SDR;
 	props->max_msg_sz = 0x80000000;
+	props->core_cap_flags = RDMA_CORE_CAP_PROT_IWARP;
 
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
@@ -3884,7 +3879,6 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	nesibdev->ibdev.dev.parent = &nesdev->pcidev->dev;
 	nesibdev->ibdev.query_device = nes_query_device;
 	nesibdev->ibdev.query_port = nes_query_port;
-	nesibdev->ibdev.query_protocol = nes_query_protocol;
 	nesibdev->ibdev.query_pkey = nes_query_pkey;
 	nesibdev->ibdev.query_gid = nes_query_gid;
 	nesibdev->ibdev.alloc_ucontext = nes_alloc_ucontext;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 85d99e9..7a2b59a 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -244,7 +244,6 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 	/* mandatory verbs. */
 	dev->ibdev.query_device = ocrdma_query_device;
 	dev->ibdev.query_port = ocrdma_query_port;
-	dev->ibdev.query_protocol = ocrdma_query_protocol;
 	dev->ibdev.modify_port = ocrdma_modify_port;
 	dev->ibdev.query_gid = ocrdma_query_gid;
 	dev->ibdev.get_link_layer = ocrdma_link_layer;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 3e98360..4b8f8e6 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -184,15 +184,10 @@ int ocrdma_query_port(struct ib_device *ibdev,
 				 &props->active_width);
 	props->max_msg_sz = 0x80000000;
 	props->max_vl_num = 4;
+	props->core_cap_flags = RDMA_CORE_CAP_PROT_IBOE;
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
index 9fd4b28..6e52946 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1646,16 +1646,11 @@ static int qib_query_port(struct ib_device *ibdev, u8 port,
 	}
 	props->active_mtu = mtu;
 	props->subnet_timeout = ibp->subnet_timeout;
+	props->core_cap_flags = RDMA_CORE_CAP_PROT_IB;
 
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
@@ -2190,7 +2185,6 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->query_device = qib_query_device;
 	ibdev->modify_device = qib_modify_device;
 	ibdev->query_port = qib_query_port;
-	ibdev->query_protocol = qib_query_protocol;
 	ibdev->modify_port = qib_modify_port;
 	ibdev->query_pkey = qib_query_pkey;
 	ibdev->query_gid = qib_query_gid;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index bd9f364..0d0f986 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -360,7 +360,6 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 
 	us_ibdev->ib_dev.query_device = usnic_ib_query_device;
 	us_ibdev->ib_dev.query_port = usnic_ib_query_port;
-	us_ibdev->ib_dev.query_protocol = usnic_ib_query_protocol;
 	us_ibdev->ib_dev.query_pkey = usnic_ib_query_pkey;
 	us_ibdev->ib_dev.query_gid = usnic_ib_query_gid;
 	us_ibdev->ib_dev.get_link_layer = usnic_ib_port_link_layer;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 732b5c5..83c61ef 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -344,16 +344,11 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 	props->max_msg_sz = us_ibdev->ufdev->mtu;
 	props->max_vl_num = 1;
 	mutex_unlock(&us_ibdev->usdev_lock);
+	props->core_cap_flags = RDMA_CORE_CAP_PROT_USNIC_UDP;
 
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
index 4de2758..dcaee4f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1529,8 +1529,6 @@ struct ib_device {
 	int		           (*query_port)(struct ib_device *device,
 						 u8 port_num,
 						 struct ib_port_attr *port_attr);
-	enum rdma_protocol_type    (*query_protocol)(struct ib_device *device,
-						     u8 port_num);
 	enum rdma_link_layer	   (*get_link_layer)(struct ib_device *device,
 						     u8 port_num);
 	int		           (*query_gid)(struct ib_device *device,
@@ -1776,24 +1774,25 @@ enum rdma_link_layer rdma_port_get_link_layer(struct ib_device *device,
 
 static inline int rdma_protocol_ib(struct ib_device *device, u8 port_num)
 {
-	return device->query_protocol(device, port_num) == RDMA_PROTOCOL_IB;
+	return !!(device->core_cap_flags[port_num] & RDMA_CORE_CAP_PROT_IB);
 }
 
 static inline int rdma_protocol_iboe(struct ib_device *device, u8 port_num)
 {
-	return device->query_protocol(device, port_num) == RDMA_PROTOCOL_IBOE;
+	return !!(device->core_cap_flags[port_num] & RDMA_CORE_CAP_PROT_IBOE);
 }
 
 static inline int rdma_protocol_iwarp(struct ib_device *device, u8 port_num)
 {
-	return device->query_protocol(device, port_num) == RDMA_PROTOCOL_IWARP;
+	return !!(device->core_cap_flags[port_num] & RDMA_CORE_CAP_PROT_IWARP);
 }
 
 static inline int rdma_ib_or_iboe(struct ib_device *device, u8 port_num)
 {
-	enum rdma_protocol_type pt = device->query_protocol(device, port_num);
+	u64 flags = device->core_cap_flags[port_num];
 
-	return (pt == RDMA_PROTOCOL_IB || pt == RDMA_PROTOCOL_IBOE);
+	return (!!(flags & RDMA_CORE_CAP_PROT_IB) ||
+		!!(flags & RDMA_CORE_CAP_PROT_IBOE));
 }
 
 /**
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
