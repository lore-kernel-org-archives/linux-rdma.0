From: Michael Wang <yun.wang@profitbricks.com>
Subject: [PATCH v8 01/23] IB/Verbs: Implement new callback query_protocol()
Date: Tue,  5 May 2015 14:50:18 +0200
Message-ID: <1430830240-32389-2-git-send-email-yun.wang@profitbricks.com>
References: <1430830240-32389-1-git-send-email-yun.wang@profitbricks.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1430830240-32389-1-git-send-email-yun.wang@profitbricks.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal@dev.mellanox.co.il>, Doug Ledford <dledford@redhat.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Michael Wang <yun.wang@profitbricks.com>, Tom Tucker <tom@opengridcomputing.com>, Steve Wise <swise@opengridcomputing.com>, Hoang-Nam Nguyen <hnguyen@de.ibm.com>, Christoph Raisch <raisch@de.ibm.com>, Mike Marciniszyn <infinipath@intel.com>, Eli Cohen <eli@mellanox.com>, Faisal Latif <faisal.latif@intel.com>, Jack Morgenstein <jackm@dev.mellanox.co.il>, Or Gerlitz <ogerlitz@mellanox.com>, Haggai Eran <haggaie@mellanox.com>, Ira Weiny <ira.weiny@intel.com>, Tom Talpey <tom@talpey.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Devesh Sharma <Devesh.Sharma@Emulex.Com>, Liran Liss <liranl@mellanox.com>, Dave Goodell <dgoodell@cisco.com>
List-Id: linux-rdma@vger.kernel.org

Add new callback query_protocol() and implement for each HW.

Mapping List:
		node-type	link-layer	transport	protocol
nes		RNIC		ETH		IWARP		IWARP
amso1100	RNIC		ETH		IWARP		IWARP
cxgb3   	RNIC		ETH		IWARP		IWARP
cxgb4   	RNIC		ETH		IWARP		IWARP
usnic   	USNIC_UDP	ETH		USNIC_UDP	USNIC_UDP
ocrdma  	IB_CA		ETH		IB		IBOE
mlx4    	IB_CA		IB/ETH		IB		IB/IBOE
mlx5    	IB_CA		IB		IB		IB
ehca    	IB_CA		IB		IB		IB
ipath   	IB_CA		IB		IB		IB
mthca   	IB_CA		IB		IB		IB
qib     	IB_CA		IB		IB		IB

Signed-off-by: Michael Wang <yun.wang@profitbricks.com>
---
 drivers/infiniband/core/device.c             |  1 +
 drivers/infiniband/hw/amso1100/c2_provider.c |  7 +++++++
 drivers/infiniband/hw/cxgb3/iwch_provider.c  |  7 +++++++
 drivers/infiniband/hw/cxgb4/provider.c       |  7 +++++++
 drivers/infiniband/hw/ehca/ehca_hca.c        |  6 ++++++
 drivers/infiniband/hw/ehca/ehca_iverbs.h     |  3 +++
 drivers/infiniband/hw/ehca/ehca_main.c       |  1 +
 drivers/infiniband/hw/ipath/ipath_verbs.c    |  7 +++++++
 drivers/infiniband/hw/mlx4/main.c            | 10 ++++++++++
 drivers/infiniband/hw/mlx5/main.c            |  7 +++++++
 drivers/infiniband/hw/mthca/mthca_provider.c |  7 +++++++
 drivers/infiniband/hw/nes/nes_verbs.c        |  6 ++++++
 drivers/infiniband/hw/ocrdma/ocrdma_main.c   |  1 +
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.c  |  6 ++++++
 drivers/infiniband/hw/ocrdma/ocrdma_verbs.h  |  3 +++
 drivers/infiniband/hw/qib/qib_verbs.c        |  7 +++++++
 drivers/infiniband/hw/usnic/usnic_ib_main.c  |  1 +
 drivers/infiniband/hw/usnic/usnic_ib_verbs.c |  6 ++++++
 drivers/infiniband/hw/usnic/usnic_ib_verbs.h |  2 ++
 include/rdma/ib_verbs.h                      |  9 +++++++++
 20 files changed, 104 insertions(+)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 18c1ece..b360350 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -76,6 +76,7 @@ static int ib_device_check_mandatory(struct ib_device *device)
 	} mandatory_table[] = {
 		IB_MANDATORY_FUNC(query_device),
 		IB_MANDATORY_FUNC(query_port),
+		IB_MANDATORY_FUNC(query_protocol),
 		IB_MANDATORY_FUNC(query_pkey),
 		IB_MANDATORY_FUNC(query_gid),
 		IB_MANDATORY_FUNC(alloc_pd),
diff --git a/drivers/infiniband/hw/amso1100/c2_provider.c b/drivers/infiniband/hw/amso1100/c2_provider.c
index bdf3507..6fe329a 100644
--- a/drivers/infiniband/hw/amso1100/c2_provider.c
+++ b/drivers/infiniband/hw/amso1100/c2_provider.c
@@ -99,6 +99,12 @@ static int c2_query_port(struct ib_device *ibdev,
 	return 0;
 }
 
+static enum rdma_protocol_type
+c2_query_protocol(struct ib_device *device, u8 port_num)
+{
+	return RDMA_PROTOCOL_IWARP;
+}
+
 static int c2_query_pkey(struct ib_device *ibdev,
 			 u8 port, u16 index, u16 * pkey)
 {
@@ -801,6 +807,7 @@ int c2_register_device(struct c2_dev *dev)
 	dev->ibdev.dma_device = &dev->pcidev->dev;
 	dev->ibdev.query_device = c2_query_device;
 	dev->ibdev.query_port = c2_query_port;
+	dev->ibdev.query_protocol = c2_query_protocol;
 	dev->ibdev.query_pkey = c2_query_pkey;
 	dev->ibdev.query_gid = c2_query_gid;
 	dev->ibdev.alloc_ucontext = c2_alloc_ucontext;
diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index 811b24a..298d1ca 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1232,6 +1232,12 @@ static int iwch_query_port(struct ib_device *ibdev,
 	return 0;
 }
 
+static enum rdma_protocol_type
+iwch_query_protocol(struct ib_device *device, u8 port_num)
+{
+	return RDMA_PROTOCOL_IWARP;
+}
+
 static ssize_t show_rev(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
@@ -1385,6 +1391,7 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.dma_device = &(dev->rdev.rnic_info.pdev->dev);
 	dev->ibdev.query_device = iwch_query_device;
 	dev->ibdev.query_port = iwch_query_port;
+	dev->ibdev.query_protocol = iwch_query_protocol;
 	dev->ibdev.query_pkey = iwch_query_pkey;
 	dev->ibdev.query_gid = iwch_query_gid;
 	dev->ibdev.alloc_ucontext = iwch_alloc_ucontext;
diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index 66bd6a2..f52ee63 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -390,6 +390,12 @@ static int c4iw_query_port(struct ib_device *ibdev, u8 port,
 	return 0;
 }
 
+static enum rdma_protocol_type
+c4iw_query_protocol(struct ib_device *device, u8 port_num)
+{
+	return RDMA_PROTOCOL_IWARP;
+}
+
 static ssize_t show_rev(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
@@ -506,6 +512,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.dma_device = &(dev->rdev.lldi.pdev->dev);
 	dev->ibdev.query_device = c4iw_query_device;
 	dev->ibdev.query_port = c4iw_query_port;
+	dev->ibdev.query_protocol = c4iw_query_protocol;
 	dev->ibdev.query_pkey = c4iw_query_pkey;
 	dev->ibdev.query_gid = c4iw_query_gid;
 	dev->ibdev.alloc_ucontext = c4iw_alloc_ucontext;
diff --git a/drivers/infiniband/hw/ehca/ehca_hca.c b/drivers/infiniband/hw/ehca/ehca_hca.c
index 9ed4d25..1f4dc9c 100644
--- a/drivers/infiniband/hw/ehca/ehca_hca.c
+++ b/drivers/infiniband/hw/ehca/ehca_hca.c
@@ -242,6 +242,12 @@ query_port1:
 	return ret;
 }
 
+enum rdma_protocol_type
+ehca_query_protocol(struct ib_device *device, u8 port_num)
+{
+	return RDMA_PROTOCOL_IB;
+}
+
 int ehca_query_sma_attr(struct ehca_shca *shca,
 			u8 port, struct ehca_sma_attr *attr)
 {
diff --git a/drivers/infiniband/hw/ehca/ehca_iverbs.h b/drivers/infiniband/hw/ehca/ehca_iverbs.h
index 22f79af..077185b 100644
--- a/drivers/infiniband/hw/ehca/ehca_iverbs.h
+++ b/drivers/infiniband/hw/ehca/ehca_iverbs.h
@@ -49,6 +49,9 @@ int ehca_query_device(struct ib_device *ibdev, struct ib_device_attr *props);
 int ehca_query_port(struct ib_device *ibdev, u8 port,
 		    struct ib_port_attr *props);
 
+enum rdma_protocol_type
+ehca_query_protocol(struct ib_device *device, u8 port_num);
+
 int ehca_query_sma_attr(struct ehca_shca *shca, u8 port,
 			struct ehca_sma_attr *attr);
 
diff --git a/drivers/infiniband/hw/ehca/ehca_main.c b/drivers/infiniband/hw/ehca/ehca_main.c
index cd8d290..321545b 100644
--- a/drivers/infiniband/hw/ehca/ehca_main.c
+++ b/drivers/infiniband/hw/ehca/ehca_main.c
@@ -467,6 +467,7 @@ static int ehca_init_device(struct ehca_shca *shca)
 	shca->ib_device.dma_device          = &shca->ofdev->dev;
 	shca->ib_device.query_device        = ehca_query_device;
 	shca->ib_device.query_port          = ehca_query_port;
+	shca->ib_device.query_protocol      = ehca_query_protocol;
 	shca->ib_device.query_gid           = ehca_query_gid;
 	shca->ib_device.query_pkey          = ehca_query_pkey;
 	/* shca->in_device.modify_device    = ehca_modify_device    */
diff --git a/drivers/infiniband/hw/ipath/ipath_verbs.c b/drivers/infiniband/hw/ipath/ipath_verbs.c
index 44ea939..34b94c3a 100644
--- a/drivers/infiniband/hw/ipath/ipath_verbs.c
+++ b/drivers/infiniband/hw/ipath/ipath_verbs.c
@@ -1638,6 +1638,12 @@ static int ipath_query_port(struct ib_device *ibdev,
 	return 0;
 }
 
+static enum rdma_protocol_type
+ipath_query_protocol(struct ib_device *device, u8 port_num)
+{
+	return RDMA_PROTOCOL_IB;
+}
+
 static int ipath_modify_device(struct ib_device *device,
 			       int device_modify_mask,
 			       struct ib_device_modify *device_modify)
@@ -2140,6 +2146,7 @@ int ipath_register_ib_device(struct ipath_devdata *dd)
 	dev->query_device = ipath_query_device;
 	dev->modify_device = ipath_modify_device;
 	dev->query_port = ipath_query_port;
+	dev->query_protocol = ipath_query_protocol;
 	dev->modify_port = ipath_modify_port;
 	dev->query_pkey = ipath_query_pkey;
 	dev->query_gid = ipath_query_gid;
diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 57070c5..26678d2 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -420,6 +420,15 @@ static int mlx4_ib_query_port(struct ib_device *ibdev, u8 port,
 	return __mlx4_ib_query_port(ibdev, port, props, 0);
 }
 
+static enum rdma_protocol_type
+mlx4_ib_query_protocol(struct ib_device *device, u8 port_num)
+{
+	struct mlx4_dev *dev = to_mdev(device)->dev;
+
+	return dev->caps.port_mask[port_num] == MLX4_PORT_TYPE_IB ?
+		RDMA_PROTOCOL_IB : RDMA_PROTOCOL_IBOE;
+}
+
 int __mlx4_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 			union ib_gid *gid, int netw_view)
 {
@@ -2202,6 +2211,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 
 	ibdev->ib_dev.query_device	= mlx4_ib_query_device;
 	ibdev->ib_dev.query_port	= mlx4_ib_query_port;
+	ibdev->ib_dev.query_protocol	= mlx4_ib_query_protocol;
 	ibdev->ib_dev.get_link_layer	= mlx4_ib_port_link_layer;
 	ibdev->ib_dev.query_gid		= mlx4_ib_query_gid;
 	ibdev->ib_dev.query_pkey	= mlx4_ib_query_pkey;
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 57c9809..8dec380 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -262,6 +262,12 @@ out:
 	return err;
 }
 
+static enum rdma_protocol_type
+mlx5_ib_query_protocol(struct ib_device *device, u8 port_num)
+{
+	return RDMA_PROTOCOL_IB;
+}
+
 static int mlx5_ib_query_gid(struct ib_device *ibdev, u8 port, int index,
 			     union ib_gid *gid)
 {
@@ -1244,6 +1250,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 
 	dev->ib_dev.query_device	= mlx5_ib_query_device;
 	dev->ib_dev.query_port		= mlx5_ib_query_port;
+	dev->ib_dev.query_protocol	= mlx5_ib_query_protocol;
 	dev->ib_dev.query_gid		= mlx5_ib_query_gid;
 	dev->ib_dev.query_pkey		= mlx5_ib_query_pkey;
 	dev->ib_dev.modify_device	= mlx5_ib_modify_device;
diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 415f8e1..ad1cca3 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -179,6 +179,12 @@ static int mthca_query_port(struct ib_device *ibdev,
 	return err;
 }
 
+static enum rdma_protocol_type
+mthca_query_protocol(struct ib_device *device, u8 port_num)
+{
+	return RDMA_PROTOCOL_IB;
+}
+
 static int mthca_modify_device(struct ib_device *ibdev,
 			       int mask,
 			       struct ib_device_modify *props)
@@ -1281,6 +1287,7 @@ int mthca_register_device(struct mthca_dev *dev)
 	dev->ib_dev.dma_device           = &dev->pdev->dev;
 	dev->ib_dev.query_device         = mthca_query_device;
 	dev->ib_dev.query_port           = mthca_query_port;
+	dev->ib_dev.query_protocol       = mthca_query_protocol;
 	dev->ib_dev.modify_device        = mthca_modify_device;
 	dev->ib_dev.modify_port          = mthca_modify_port;
 	dev->ib_dev.query_pkey           = mthca_query_pkey;
diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index c0d0296..027f6d1 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -606,6 +606,11 @@ static int nes_query_port(struct ib_device *ibdev, u8 port, struct ib_port_attr
 	return 0;
 }
 
+static enum rdma_protocol_type
+nes_query_protocol(struct ib_device *device, u8 port_num)
+{
+	return RDMA_PROTOCOL_IWARP;
+}
 
 /**
  * nes_query_pkey
@@ -3879,6 +3884,7 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	nesibdev->ibdev.dev.parent = &nesdev->pcidev->dev;
 	nesibdev->ibdev.query_device = nes_query_device;
 	nesibdev->ibdev.query_port = nes_query_port;
+	nesibdev->ibdev.query_protocol = nes_query_protocol;
 	nesibdev->ibdev.query_pkey = nes_query_pkey;
 	nesibdev->ibdev.query_gid = nes_query_gid;
 	nesibdev->ibdev.alloc_ucontext = nes_alloc_ucontext;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 7a2b59a..85d99e9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -244,6 +244,7 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 	/* mandatory verbs. */
 	dev->ibdev.query_device = ocrdma_query_device;
 	dev->ibdev.query_port = ocrdma_query_port;
+	dev->ibdev.query_protocol = ocrdma_query_protocol;
 	dev->ibdev.modify_port = ocrdma_modify_port;
 	dev->ibdev.query_gid = ocrdma_query_gid;
 	dev->ibdev.get_link_layer = ocrdma_link_layer;
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
index 8771755..3e98360 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.c
@@ -187,6 +187,12 @@ int ocrdma_query_port(struct ib_device *ibdev,
 	return 0;
 }
 
+enum rdma_protocol_type
+ocrdma_query_protocol(struct ib_device *device, u8 port_num)
+{
+	return RDMA_PROTOCOL_IBOE;
+}
+
 int ocrdma_modify_port(struct ib_device *ibdev, u8 port, int mask,
 		       struct ib_port_modify *props)
 {
diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
index b8f7853..3cdc81e 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_verbs.h
@@ -41,6 +41,9 @@ int ocrdma_query_port(struct ib_device *, u8 port, struct ib_port_attr *props);
 int ocrdma_modify_port(struct ib_device *, u8 port, int mask,
 		       struct ib_port_modify *props);
 
+enum rdma_protocol_type
+ocrdma_query_protocol(struct ib_device *device, u8 port_num);
+
 void ocrdma_get_guid(struct ocrdma_dev *, u8 *guid);
 int ocrdma_query_gid(struct ib_device *, u8 port,
 		     int index, union ib_gid *gid);
diff --git a/drivers/infiniband/hw/qib/qib_verbs.c b/drivers/infiniband/hw/qib/qib_verbs.c
index 4a35998..9fd4b28 100644
--- a/drivers/infiniband/hw/qib/qib_verbs.c
+++ b/drivers/infiniband/hw/qib/qib_verbs.c
@@ -1650,6 +1650,12 @@ static int qib_query_port(struct ib_device *ibdev, u8 port,
 	return 0;
 }
 
+static enum rdma_protocol_type
+qib_query_protocol(struct ib_device *device, u8 port_num)
+{
+	return RDMA_PROTOCOL_IB;
+}
+
 static int qib_modify_device(struct ib_device *device,
 			     int device_modify_mask,
 			     struct ib_device_modify *device_modify)
@@ -2184,6 +2190,7 @@ int qib_register_ib_device(struct qib_devdata *dd)
 	ibdev->query_device = qib_query_device;
 	ibdev->modify_device = qib_modify_device;
 	ibdev->query_port = qib_query_port;
+	ibdev->query_protocol = qib_query_protocol;
 	ibdev->modify_port = qib_modify_port;
 	ibdev->query_pkey = qib_query_pkey;
 	ibdev->query_gid = qib_query_gid;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 0d0f986..bd9f364 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -360,6 +360,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 
 	us_ibdev->ib_dev.query_device = usnic_ib_query_device;
 	us_ibdev->ib_dev.query_port = usnic_ib_query_port;
+	us_ibdev->ib_dev.query_protocol = usnic_ib_query_protocol;
 	us_ibdev->ib_dev.query_pkey = usnic_ib_query_pkey;
 	us_ibdev->ib_dev.query_gid = usnic_ib_query_gid;
 	us_ibdev->ib_dev.get_link_layer = usnic_ib_port_link_layer;
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
index 53bd6a2..732b5c5 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.c
@@ -348,6 +348,12 @@ int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 	return 0;
 }
 
+enum rdma_protocol_type
+usnic_ib_query_protocol(struct ib_device *device, u8 port_num)
+{
+	return RDMA_PROTOCOL_USNIC_UDP;
+}
+
 int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
 				int qp_attr_mask,
 				struct ib_qp_init_attr *qp_init_attr)
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
index bb864f5..57ddba5 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib_verbs.h
@@ -27,6 +27,8 @@ int usnic_ib_query_device(struct ib_device *ibdev,
 				struct ib_device_attr *props);
 int usnic_ib_query_port(struct ib_device *ibdev, u8 port,
 				struct ib_port_attr *props);
+enum rdma_protocol_type
+usnic_ib_query_protocol(struct ib_device *device, u8 port_num);
 int usnic_ib_query_qp(struct ib_qp *qp, struct ib_qp_attr *qp_attr,
 				int qp_attr_mask,
 				struct ib_qp_init_attr *qp_init_attr);
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 65994a1..080f204 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -81,6 +81,13 @@ enum rdma_transport_type {
 	RDMA_TRANSPORT_USNIC_UDP
 };
 
+enum rdma_protocol_type {
+	RDMA_PROTOCOL_IB,
+	RDMA_PROTOCOL_IBOE,
+	RDMA_PROTOCOL_IWARP,
+	RDMA_PROTOCOL_USNIC_UDP
+};
+
 __attribute_const__ enum rdma_transport_type
 rdma_node_get_transport(enum rdma_node_type node_type);
 
@@ -1501,6 +1508,8 @@ struct ib_device {
 	int		           (*query_port)(struct ib_device *device,
 						 u8 port_num,
 						 struct ib_port_attr *port_attr);
+	enum rdma_protocol_type    (*query_protocol)(struct ib_device *device,
+						     u8 port_num);
 	enum rdma_link_layer	   (*get_link_layer)(struct ib_device *device,
 						     u8 port_num);
 	int		           (*query_gid)(struct ib_device *device,
-- 
2.1.0
