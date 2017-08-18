From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 1/3] RDMA/vmw_pvrdma: Add RoCEv2 support
Date: Fri, 18 Aug 2017 09:44:47 -0700
Message-ID: <2fc08a51ef95d5d56e243238e9821d4d977a3659.1503073950.git.aditr@vmware.com>
References: <cover.1503073950.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1503073950.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>

The driver version is bumped for compatibility purposes. Also, send correct
GID type during register to device.

Acked-by: Jorgen Hansen <jhansen-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Acked-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h         |  2 ++
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h |  9 +++++++-
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c    | 25 ++++++++++++++---------
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c    | 14 +++++++++++++
 4 files changed, 39 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
index 8e2f0a1..513a182 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -444,6 +444,8 @@ void pvrdma_ah_attr_to_rdma(struct rdma_ah_attr *dst,
 			    const struct pvrdma_ah_attr *src);
 void rdma_ah_attr_to_pvrdma(struct pvrdma_ah_attr *dst,
 			    const struct rdma_ah_attr *src);
+enum ib_gid_type pvrdma_gid_type_to_ib(u8 gid_type);
+u8 ib_gid_type_to_pvrdma(enum ib_gid_type gid_type);
 
 int pvrdma_uar_table_init(struct pvrdma_dev *dev);
 void pvrdma_uar_table_cleanup(struct pvrdma_dev *dev);
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
index 09078cc..71df5d1 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
@@ -50,7 +50,7 @@
 
 #include "pvrdma_verbs.h"
 
-#define PVRDMA_VERSION			17
+#define PVRDMA_VERSION			18
 #define PVRDMA_BOARD_ID			1
 #define PVRDMA_REV_ID			1
 
@@ -123,6 +123,13 @@
 #define PVRDMA_GID_TYPE_FLAG_ROCE_V1	BIT(0)
 #define PVRDMA_GID_TYPE_FLAG_ROCE_V2	BIT(1)
 
+/*
+ * PVRDMA version macros. Some new features require updates to PVRDMA_VERSION.
+ * These macros allow us to check for different features if necessary.
+ */
+
+#define PVRDMA_VERSION_ROCEV2_SUPPORT	18
+
 enum pvrdma_pci_resource {
 	PVRDMA_PCI_RESOURCE_MSIX,	/* BAR0: MSI-X, MMIO. */
 	PVRDMA_PCI_RESOURCE_REG,	/* BAR1: Registers, MMIO. */
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 7f29e4d..6fd5828 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -128,10 +128,14 @@ static int pvrdma_init_device(struct pvrdma_dev *dev)
 static int pvrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
 				 struct ib_port_immutable *immutable)
 {
+	struct pvrdma_dev *dev = to_vdev(ibdev);
 	struct ib_port_attr attr;
 	int err;
 
-	immutable->core_cap_flags = RDMA_CORE_PORT_IBA_ROCE;
+	if (dev->dsr->caps.gid_types == PVRDMA_GID_TYPE_FLAG_ROCE_V1)
+		immutable->core_cap_flags |= RDMA_CORE_PORT_IBA_ROCE;
+	else if (dev->dsr->caps.gid_types == PVRDMA_GID_TYPE_FLAG_ROCE_V2)
+		immutable->core_cap_flags |= RDMA_CORE_PORT_IBA_ROCE_UDP_ENCAP;
 
 	err = ib_query_port(ibdev, port_num, &attr);
 	if (err)
@@ -569,6 +573,7 @@ static void pvrdma_free_slots(struct pvrdma_dev *dev)
 
 static int pvrdma_add_gid_at_index(struct pvrdma_dev *dev,
 				   const union ib_gid *gid,
+				   u8 gid_type,
 				   int index)
 {
 	int ret;
@@ -586,7 +591,7 @@ static int pvrdma_add_gid_at_index(struct pvrdma_dev *dev,
 	cmd_bind->mtu = ib_mtu_enum_to_int(IB_MTU_1024);
 	cmd_bind->vlan = 0xfff;
 	cmd_bind->index = index;
-	cmd_bind->gid_type = PVRDMA_GID_TYPE_FLAG_ROCE_V1;
+	cmd_bind->gid_type = gid_type;
 
 	ret = pvrdma_cmd_post(dev, &req, NULL, 0);
 	if (ret < 0) {
@@ -607,7 +612,9 @@ static int pvrdma_add_gid(struct ib_device *ibdev,
 {
 	struct pvrdma_dev *dev = to_vdev(ibdev);
 
-	return pvrdma_add_gid_at_index(dev, gid, index);
+	return pvrdma_add_gid_at_index(dev, gid,
+				       ib_gid_type_to_pvrdma(attr->gid_type),
+				       index);
 }
 
 static int pvrdma_del_gid_at_index(struct pvrdma_dev *dev, int index)
@@ -822,10 +829,6 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	version = pvrdma_read_reg(dev, PVRDMA_REG_VERSION);
 	dev_info(&pdev->dev, "device version %d, driver version %d\n",
 		 version, PVRDMA_VERSION);
-	if (version < PVRDMA_VERSION) {
-		dev_err(&pdev->dev, "incompatible device version\n");
-		goto err_uar_unmap;
-	}
 
 	dev->dsr = dma_alloc_coherent(&pdev->dev, sizeof(*dev->dsr),
 				      &dev->dsrbase, GFP_KERNEL);
@@ -904,9 +907,11 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 		goto err_free_cq_ring;
 	}
 
-	/* Currently, the driver only supports RoCE V1. */
-	if (!(dev->dsr->caps.gid_types & PVRDMA_GID_TYPE_FLAG_ROCE_V1)) {
-		dev_err(&pdev->dev, "driver needs RoCE v1 support\n");
+	/* PVRDMA supports RoCE V1 or V2. */
+	if (version >= PVRDMA_VERSION_ROCEV2_SUPPORT &&
+	    !((dev->dsr->caps.gid_types & PVRDMA_GID_TYPE_FLAG_ROCE_V1) ||
+	      (dev->dsr->caps.gid_types & PVRDMA_GID_TYPE_FLAG_ROCE_V2))) {
+		dev_err(&pdev->dev, "driver needs RoCE v1 or v2 support\n");
 		ret = -EFAULT;
 		goto err_free_cq_ring;
 	}
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
index ec6a4ca..0861e28 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_misc.c
@@ -303,3 +303,17 @@ void rdma_ah_attr_to_pvrdma(struct pvrdma_ah_attr *dst,
 	dst->port_num = rdma_ah_get_port_num(src);
 	memcpy(&dst->dmac, src->roce.dmac, sizeof(dst->dmac));
 }
+
+enum ib_gid_type pvrdma_gid_type_to_ib(u8 gid_type)
+{
+	return (gid_type == PVRDMA_GID_TYPE_FLAG_ROCE_V2) ?
+		IB_GID_TYPE_ROCE_UDP_ENCAP :
+		IB_GID_TYPE_ROCE;
+}
+
+u8 ib_gid_type_to_pvrdma(enum ib_gid_type gid_type)
+{
+	return (gid_type == IB_GID_TYPE_ROCE_UDP_ENCAP) ?
+		PVRDMA_GID_TYPE_FLAG_ROCE_V2 :
+		PVRDMA_GID_TYPE_FLAG_ROCE_V1;
+}
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
