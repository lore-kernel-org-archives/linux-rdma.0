From: <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/2] RDMA/ocrdma: emulex NIC driver ABI version support
Date: Sat, 14 Dec 2013 11:44:17 +0530
Message-ID: <f387ae39-9085-40ef-8928-9beca8cb8ef8@CMEXHTCAS2.ad.emulex.com>
References: <1387001657-4096-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1387001657-4096-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Emulex NIC driver support for ABI version support in be_roce.c

Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/net/ethernet/emulex/benet/be_roce.c |    6 ++++++
 drivers/net/ethernet/emulex/benet/be_roce.h |    3 +++
 2 files changed, 9 insertions(+), 0 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_roce.c b/drivers/net/ethernet/emulex/benet/be_roce.c
index 9cd5415..aa7f943 100644
--- a/drivers/net/ethernet/emulex/benet/be_roce.c
+++ b/drivers/net/ethernet/emulex/benet/be_roce.c
@@ -35,6 +35,12 @@ static void _be_roce_dev_add(struct be_adapter *adapter)
 
 	if (!ocrdma_drv)
 		return;
+
+	if (ocrdma_drv->be_abi_version != BE_ROCE_ABI_VERSION) {
+		dev_warn(&pdev->dev, "Cannot initialize RoCE due to ocrdma ABI mismatch\n");
+		return;
+	}
+
 	if (pdev->device == OC_DEVICE_ID5) {
 		/* only msix is supported on these devices */
 		if (!msix_enabled(adapter))
diff --git a/drivers/net/ethernet/emulex/benet/be_roce.h b/drivers/net/ethernet/emulex/benet/be_roce.h
index 2cd1129..1bfb161 100644
--- a/drivers/net/ethernet/emulex/benet/be_roce.h
+++ b/drivers/net/ethernet/emulex/benet/be_roce.h
@@ -21,6 +21,8 @@
 #include <linux/pci.h>
 #include <linux/netdevice.h>
 
+#define BE_ROCE_ABI_VERSION	1
+
 struct ocrdma_dev;
 
 enum be_interrupt_mode {
@@ -52,6 +54,7 @@ struct be_dev_info {
 /* ocrdma driver register's the callback functions with nic driver. */
 struct ocrdma_driver {
 	unsigned char name[32];
+	u32 be_abi_version;
 	struct ocrdma_dev *(*add) (struct be_dev_info *dev_info);
 	void (*remove) (struct ocrdma_dev *);
 	void (*state_change_handler) (struct ocrdma_dev *, u32 new_state);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
