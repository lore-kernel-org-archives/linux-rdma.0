From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: [PATCH 2/2] IB/core: Restore I/O MMU, s390 and powerpc support
Date: Mon, 6 Mar 2017 16:35:49 -0800
Message-ID: <20170307003549.3872-3-bart.vanassche@sandisk.com>
References: <20170307003549.3872-1-bart.vanassche@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20170307003549.3872-1-bart.vanassche@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Sebastian Ott <sebott@linux.vnet.ibm.com>, Parav Pandit <parav@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Bart Van Assche <bart.vanassche@sandisk.com>
List-Id: linux-rdma@vger.kernel.org

Avoid that the following error message is reported on the console
while loading an RDMA driver with I/O MMU support enabled:

DMAR: Allocating domain for mlx5_0 failed

Ensure that DMA mapping operations that use to_pci_dev() to
access to struct pci_dev see the correct PCI device. E.g. the s390
and powerpc DMA mapping operations use to_pci_dev() even with I/O
MMU support disabled.

Reported-by: Sebastian Ott <sebott@linux.vnet.ibm.com>
Reported-by: Parav Pandit <parav@mellanox.com>
Fixes: commit 99db9494035f ("IB/core: Remove ib_device.dma_device")
Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
---
 drivers/infiniband/core/device.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 593d2ce6ec7c..93c23e873841 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -39,6 +39,7 @@
 #include <linux/init.h>
 #include <linux/mutex.h>
 #include <linux/netdevice.h>
+#include <linux/pci.h>
 #include <rdma/rdma_netlink.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_cache.h>
@@ -325,6 +326,10 @@ EXPORT_SYMBOL(ib_get_device_fw_str);
  * devices with the IB core.  All registered clients will receive a
  * callback for each device that is added. @device must be allocated
  * with ib_alloc_device().
+ *
+ * Unless requested otherwise by the caller, this function makes sure that DMA
+ * mapping operations on &device->dev behave identical to DMA mapping
+ * operations on the parent device (device->dev.parent).
  */
 int ib_register_device(struct ib_device *device,
 		       int (*port_callback)(struct ib_device *,
@@ -336,8 +341,11 @@ int ib_register_device(struct ib_device *device,
 	struct device *parent = device->dev.parent;
 
 	WARN_ON_ONCE(!parent);
-	if (!device->dev.dma_ops)
+	if (!device->dev.dma_ops) {
 		device->dev.dma_ops = parent->dma_ops;
+		device->dev.pci_dev = to_pci_dev(parent);
+		device->dev.archdata = parent->archdata;
+	}
 	if (!device->dev.dma_mask)
 		device->dev.dma_mask = parent->dma_mask;
 	if (!device->dev.coherent_dma_mask)
-- 
2.12.0
