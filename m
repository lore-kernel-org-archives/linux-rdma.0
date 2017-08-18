From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 2/3] RDMA/vmw_pvrdma: Update device query parameters
Date: Fri, 18 Aug 2017 09:44:48 -0700
Message-ID: <6eb31ebec69c1d28b83cb44e84cdb01ebdec3827.1503073950.git.aditr@vmware.com>
References: <cover.1503073950.git.aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1503073950.git.aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Added support for two device caps - max_sge_rd, max_fast_reg_page_list_len.
Simplified some of the RoCEv2 versioning code and added 2 more device cap
flags.

Acked-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Acked-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma.h         |  1 +
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h | 19 ++++++++++---------
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c    |  7 +++----
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c   |  9 +++++++++
 4 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
index 513a182..ea10155 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma.h
@@ -194,6 +194,7 @@ struct pvrdma_dev {
 	void *resp_slot;
 	unsigned long flags;
 	struct list_head device_link;
+	unsigned int dsr_version;
 
 	/* Locking and interrupt information. */
 	spinlock_t cmd_lock; /* Command lock. */
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
index 71df5d1..d947557 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_dev_api.h
@@ -50,7 +50,15 @@
 
 #include "pvrdma_verbs.h"
 
-#define PVRDMA_VERSION			18
+/*
+ * PVRDMA version macros. Some new features require updates to PVRDMA_VERSION.
+ * These macros allow us to check for different features if necessary.
+ */
+
+#define PVRDMA_ROCEV1_VERSION		17
+#define PVRDMA_ROCEV2_VERSION		18
+#define PVRDMA_VERSION			PVRDMA_ROCEV2_VERSION
+
 #define PVRDMA_BOARD_ID			1
 #define PVRDMA_REV_ID			1
 
@@ -123,13 +131,6 @@
 #define PVRDMA_GID_TYPE_FLAG_ROCE_V1	BIT(0)
 #define PVRDMA_GID_TYPE_FLAG_ROCE_V2	BIT(1)
 
-/*
- * PVRDMA version macros. Some new features require updates to PVRDMA_VERSION.
- * These macros allow us to check for different features if necessary.
- */
-
-#define PVRDMA_VERSION_ROCEV2_SUPPORT	18
-
 enum pvrdma_pci_resource {
 	PVRDMA_PCI_RESOURCE_MSIX,	/* BAR0: MSI-X, MMIO. */
 	PVRDMA_PCI_RESOURCE_REG,	/* BAR1: Registers, MMIO. */
@@ -232,7 +233,7 @@ struct pvrdma_device_caps {
 	u8  atomic_ops;				/* PVRDMA_ATOMIC_OP_* bits */
 	u8  bmme_flags;				/* FRWR Mem Mgmt Extensions */
 	u8  gid_types;				/* PVRDMA_GID_TYPE_FLAG_ */
-	u8  reserved[4];
+	u32 max_fast_reg_page_list_len;
 };
 
 struct pvrdma_ring_page_info {
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
index 6fd5828..ae536a4 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_main.c
@@ -729,7 +729,6 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	int ret;
 	unsigned long start;
 	unsigned long len;
-	unsigned int version;
 	dma_addr_t slot_dma = 0;
 
 	dev_dbg(&pdev->dev, "initializing driver %s\n", pci_name(pdev));
@@ -826,9 +825,9 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 		goto err_unmap_regs;
 	}
 
-	version = pvrdma_read_reg(dev, PVRDMA_REG_VERSION);
+	dev->dsr_version = pvrdma_read_reg(dev, PVRDMA_REG_VERSION);
 	dev_info(&pdev->dev, "device version %d, driver version %d\n",
-		 version, PVRDMA_VERSION);
+		 dev->dsr_version, PVRDMA_VERSION);
 
 	dev->dsr = dma_alloc_coherent(&pdev->dev, sizeof(*dev->dsr),
 				      &dev->dsrbase, GFP_KERNEL);
@@ -908,7 +907,7 @@ static int pvrdma_pci_probe(struct pci_dev *pdev,
 	}
 
 	/* PVRDMA supports RoCE V1 or V2. */
-	if (version >= PVRDMA_VERSION_ROCEV2_SUPPORT &&
+	if (dev->dsr_version >= PVRDMA_ROCEV2_VERSION &&
 	    !((dev->dsr->caps.gid_types & PVRDMA_GID_TYPE_FLAG_ROCE_V1) ||
 	      (dev->dsr->caps.gid_types & PVRDMA_GID_TYPE_FLAG_ROCE_V2))) {
 		dev_err(&pdev->dev, "driver needs RoCE v1 or v2 support\n");
diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
index 2851704..0b19d1a 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_verbs.c
@@ -83,6 +83,8 @@ int pvrdma_query_device(struct ib_device *ibdev,
 	props->max_qp_wr = dev->dsr->caps.max_qp_wr;
 	props->device_cap_flags = dev->dsr->caps.device_cap_flags;
 	props->max_sge = dev->dsr->caps.max_sge;
+	props->max_sge_rd = (dev->dsr_version >= PVRDMA_ROCEV2_VERSION) ?
+			     dev->dsr->caps.max_sge_rd : dev->dsr->caps.max_sge;
 	props->max_cq = dev->dsr->caps.max_cq;
 	props->max_cqe = dev->dsr->caps.max_cqe;
 	props->max_mr = dev->dsr->caps.max_mr;
@@ -100,9 +102,16 @@ int pvrdma_query_device(struct ib_device *ibdev,
 	if ((dev->dsr->caps.bmme_flags & PVRDMA_BMME_FLAG_LOCAL_INV) &&
 	    (dev->dsr->caps.bmme_flags & PVRDMA_BMME_FLAG_REMOTE_INV) &&
 	    (dev->dsr->caps.bmme_flags & PVRDMA_BMME_FLAG_FAST_REG_WR)) {
+		props->max_fast_reg_page_list_len =
+		(dev->dsr_version >= PVRDMA_ROCEV2_VERSION) ?
+		 dev->dsr->caps.max_fast_reg_page_list_len :
+		 PVRDMA_MAX_FAST_REG_PAGES;
 		props->device_cap_flags |= IB_DEVICE_MEM_MGT_EXTENSIONS;
 	}
 
+	props->device_cap_flags |= IB_DEVICE_PORT_ACTIVE_EVENT |
+				   IB_DEVICE_RC_RNR_NAK_GEN;
+
 	return 0;
 }
 
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
