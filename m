From: Yuval Shaia <yuval.shaia@oracle.com>
Subject: [RFC 1/3] virtio-net: Move some virtio-net-pci decl to
 include/hw/virtio
Date: Thu, 11 Apr 2019 14:01:55 +0300
Message-ID: <20190411110157.14252-2-yuval.shaia@oracle.com>
References: <20190411110157.14252-1-yuval.shaia@oracle.com>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
In-Reply-To: <20190411110157.14252-1-yuval.shaia@oracle.com>
List-Unsubscribe: <https://lists.nongnu.org/mailman/options/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=unsubscribe>
List-Archive: <http://lists.nongnu.org/archive/html/qemu-devel/>
List-Post: <mailto:qemu-devel@nongnu.org>
List-Help: <mailto:qemu-devel-request@nongnu.org?subject=help>
List-Subscribe: <https://lists.nongnu.org/mailman/listinfo/qemu-devel>,
	<mailto:qemu-devel-request@nongnu.org?subject=subscribe>
Errors-To: qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org
Sender: "Qemu-devel"
	<qemu-devel-bounces+gceq-qemu-devel2=m.gmane.org@nongnu.org>
To: virtualization@lists.linux-foundation.org, qemu-devel@nongnu.org, mst@redhat.com, cohuck@redhat.com, marcel.apfelbaum@gmail.com, linux-rdma@vger.kernel.org, jgg@mellanox.com
Cc: Yuval Shaia <yuval.shaia@oracle.com>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Yuval Shaia <yuval.shaia@oracle.com>
---
 hw/virtio/virtio-net-pci.c         | 18 ++-------------
 include/hw/virtio/virtio-net-pci.h | 35 ++++++++++++++++++++++++++++++
 2 files changed, 37 insertions(+), 16 deletions(-)
 create mode 100644 include/hw/virtio/virtio-net-pci.h

diff --git a/hw/virtio/virtio-net-pci.c b/hw/virtio/virtio-net-pci.c
index db07ab9e21..63617d5550 100644
--- a/hw/virtio/virtio-net-pci.c
+++ b/hw/virtio/virtio-net-pci.c
@@ -17,24 +17,10 @@
 
 #include "qemu/osdep.h"
 
-#include "hw/virtio/virtio-net.h"
+#include "hw/virtio/virtio-net-pci.h"
 #include "virtio-pci.h"
 #include "qapi/error.h"
 
-typedef struct VirtIONetPCI VirtIONetPCI;
-
-/*
- * virtio-net-pci: This extends VirtioPCIProxy.
- */
-#define TYPE_VIRTIO_NET_PCI "virtio-net-pci-base"
-#define VIRTIO_NET_PCI(obj) \
-        OBJECT_CHECK(VirtIONetPCI, (obj), TYPE_VIRTIO_NET_PCI)
-
-struct VirtIONetPCI {
-    VirtIOPCIProxy parent_obj;
-    VirtIONet vdev;
-};
-
 static Property virtio_net_properties[] = {
     DEFINE_PROP_BIT("ioeventfd", VirtIOPCIProxy, flags,
                     VIRTIO_PCI_FLAG_USE_IOEVENTFD_BIT, true),
@@ -82,7 +68,7 @@ static void virtio_net_pci_instance_init(Object *obj)
 
 static const VirtioPCIDeviceTypeInfo virtio_net_pci_info = {
     .base_name             = TYPE_VIRTIO_NET_PCI,
-    .generic_name          = "virtio-net-pci",
+    .generic_name          = TYPE_VIRTIO_NET_PCI_GENERIC,
     .transitional_name     = "virtio-net-pci-transitional",
     .non_transitional_name = "virtio-net-pci-non-transitional",
     .instance_size = sizeof(VirtIONetPCI),
diff --git a/include/hw/virtio/virtio-net-pci.h b/include/hw/virtio/virtio-net-pci.h
new file mode 100644
index 0000000000..f14e6ed992
--- /dev/null
+++ b/include/hw/virtio/virtio-net-pci.h
@@ -0,0 +1,35 @@
+/*
+ * PCI Virtio Network Device
+ *
+ * Copyright IBM, Corp. 2007
+ *
+ * Authors:
+ *  Anthony Liguori   <aliguori@us.ibm.com>
+ *
+ * This work is licensed under the terms of the GNU GPL, version 2.  See
+ * the COPYING file in the top-level directory.
+ *
+ */
+
+#ifndef QEMU_VIRTIO_NET_PCI_H
+#define QEMU_VIRTIO_NET_PCI_H
+
+#include "hw/virtio/virtio-net.h"
+#include "virtio-pci.h"
+
+typedef struct VirtIONetPCI VirtIONetPCI;
+
+/*
+ * virtio-net-pci: This extends VirtioPCIProxy.
+ */
+#define TYPE_VIRTIO_NET_PCI_GENERIC "virtio-net-pci"
+#define TYPE_VIRTIO_NET_PCI "virtio-net-pci-base"
+#define VIRTIO_NET_PCI(obj) \
+        OBJECT_CHECK(VirtIONetPCI, (obj), TYPE_VIRTIO_NET_PCI)
+
+struct VirtIONetPCI {
+    VirtIOPCIProxy parent_obj;
+    VirtIONet vdev;
+};
+
+#endif
-- 
2.20.1
