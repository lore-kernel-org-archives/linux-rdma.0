From: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: RDMA: Check for NULL mode in .devnode methods
Date: Mon,  4 Jul 2011 09:26:57 -0700
Message-ID: <1309796817-25293-1-git-send-email-roland@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Linus Torvalds <torvalds-de/tnXTf+JLsfHDXvbKv3WD2FQJk+8+b@public.gmane.org>
Cc: linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>

Commits 71c29bd5c235 ("IB/uverbs: Add devnode method to set
path/mode") and c3af0980ce01 ("IB: Add devnode methods to cm_class and
umad_class") added devnode methods that set the mode.  However, these
methods don't check for a NULL mode, and so we get a crash when
unloading modules because devtmpfs_delete_node() calls
device_get_devnode() with mode == NULL.

Add the missing checks.

Signed-off-by: Goldwyn Rodrigues <rgoldwyn-l3A5Bk7waGM@public.gmane.org>

[ Also fix cm.c.  - Roland ]

Signed-off-by: Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
---
Linus, please apply -- this fixes a regression introduced in 3.0-rc1.

 drivers/infiniband/core/cm.c          |    3 ++-
 drivers/infiniband/core/uverbs_main.c |    3 ++-
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index f62f52f..fc0f2bd 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -3641,7 +3641,8 @@ static struct kobj_type cm_port_obj_type = {
 
 static char *cm_devnode(struct device *dev, mode_t *mode)
 {
-	*mode = 0666;
+	if (mode)
+		*mode = 0666;
 	return kasprintf(GFP_KERNEL, "infiniband/%s", dev_name(dev));
 }
 
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index e49a85f..56898b6 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -826,7 +826,8 @@ static void ib_uverbs_remove_one(struct ib_device *device)
 
 static char *uverbs_devnode(struct device *dev, mode_t *mode)
 {
-	*mode = 0666;
+	if (mode)
+		*mode = 0666;
 	return kasprintf(GFP_KERNEL, "infiniband/%s", dev_name(dev));
 }
 
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
