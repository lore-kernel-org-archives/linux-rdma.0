From: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH rdma-core] vmw_pvrdma: Check vendor and device ID on driver init
Date: Thu, 19 Jan 2017 08:51:36 -0800
Message-ID: <1484844696-11983-1-git-send-email-aditr@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Whenever a new RDMA device appears, the RDMA stack tries to attach each
driver to the new device to see which is the correct driver. We need to
check the vendor ID and device ID to make sure we don't accidentally
attach to another device.

Reviewed-by: Aditya Sarwade <asarwade-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Bryan Tan <bryantan-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
Signed-off-by: Adit Ranadive <aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org>
---
 providers/vmw_pvrdma/pvrdma_main.c | 29 ++++++++++++++++++++++-------
 1 file changed, 22 insertions(+), 7 deletions(-)

diff --git a/providers/vmw_pvrdma/pvrdma_main.c b/providers/vmw_pvrdma/pvrdma_main.c
index 9a7e07b..7190efa 100644
--- a/providers/vmw_pvrdma/pvrdma_main.c
+++ b/providers/vmw_pvrdma/pvrdma_main.c
@@ -45,6 +45,12 @@
 
 #include "pvrdma.h"
 
+/*
+ * VMware PVRDMA vendor id and PCI device id.
+ */
+#define PCI_VENDOR_ID_VMWARE		0x15AD
+#define PCI_DEVICE_ID_VMWARE_PVRDMA	0x0820
+
 static struct ibv_context_ops pvrdma_ctx_ops = {
 	.query_device = pvrdma_query_device,
 	.query_port = pvrdma_query_port,
@@ -166,7 +172,22 @@ static struct pvrdma_device *pvrdma_driver_init_shared(
 						int abi_version)
 {
 	struct pvrdma_device *dev;
-	char name[16];
+	char value[8];
+	unsigned int vendor_id, device_id;
+
+	if (ibv_read_sysfs_file(uverbs_sys_path, "device/vendor",
+				value, sizeof(value)) < 0)
+		return NULL;
+	vendor_id = strtol(value, NULL, 16);
+
+	if (ibv_read_sysfs_file(uverbs_sys_path, "device/device",
+				value, sizeof(value)) < 0)
+		return NULL;
+	device_id = strtol(value, NULL, 16);
+
+	if (vendor_id != PCI_VENDOR_ID_VMWARE ||
+	    device_id != PCI_DEVICE_ID_VMWARE_PVRDMA)
+		return NULL;
 
 	/* We support only a single ABI version for now. */
 	if (abi_version != PVRDMA_UVERBS_ABI_VERSION) {
@@ -177,12 +198,6 @@ static struct pvrdma_device *pvrdma_driver_init_shared(
 		return NULL;
 	}
 
-	if (ibv_read_sysfs_file(uverbs_sys_path,
-				"ibdev", name, sizeof(name)) < 0) {
-		fprintf(stderr, PFX "not ib device\n");
-		return NULL;
-	}
-
 	dev = malloc(sizeof(*dev));
 	if (!dev) {
 		fprintf(stderr, PFX "couldn't allocate device for %s\n",
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
