From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 4/4] IB/hfi1: Use EPROM platform configuration read
Date: Sun, 25 Sep 2016 07:49:49 -0700
Message-ID: <20160925144947.13602.11632.stgit@scvm10.sc.intel.com>
References: <20160925144724.13602.38549.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160925144724.13602.38549.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The driver will now try to read directly from the EPROM as its
first choice for the platform configuration file.

Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/chip.c     |    9 +++++----
 drivers/infiniband/hw/hfi1/platform.c |   32 +++++++++++++++++++++-----------
 2 files changed, 26 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/chip.c b/drivers/infiniband/hw/hfi1/chip.c
index 88394cd..9bf5f23 100644
--- a/drivers/infiniband/hw/hfi1/chip.c
+++ b/drivers/infiniband/hw/hfi1/chip.c
@@ -14566,6 +14566,11 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	if (ret)
 		goto bail_cleanup;
 
+	/* call before get_platform_config(), after init_chip_resources() */
+	ret = eprom_init(dd);
+	if (ret)
+		goto bail_free_rcverr;
+
 	/* Needs to be called before hfi1_firmware_init */
 	get_platform_config(dd);
 
@@ -14686,10 +14691,6 @@ struct hfi1_devdata *hfi1_init_dd(struct pci_dev *pdev,
 	if (ret)
 		goto bail_free_cntrs;
 
-	ret = eprom_init(dd);
-	if (ret)
-		goto bail_free_rcverr;
-
 	goto bail;
 
 bail_free_rcverr:
diff --git a/drivers/infiniband/hw/hfi1/platform.c b/drivers/infiniband/hw/hfi1/platform.c
index 965c8ae..2024331 100644
--- a/drivers/infiniband/hw/hfi1/platform.c
+++ b/drivers/infiniband/hw/hfi1/platform.c
@@ -47,29 +47,39 @@
 
 #include "hfi.h"
 #include "efivar.h"
+#include "eprom.h"
 
 void get_platform_config(struct hfi1_devdata *dd)
 {
 	int ret = 0;
 	unsigned long size = 0;
 	u8 *temp_platform_config = NULL;
+	u32 esize;
+
+	ret = eprom_read_platform_config(dd, (void **)&temp_platform_config,
+					 &esize);
+	if (!ret) {
+		/* success */
+		size = esize;
+		goto success;
+	}
+	/* fail, try EFI variable */
 
 	ret = read_hfi1_efi_var(dd, "configuration", &size,
 				(void **)&temp_platform_config);
-	if (ret) {
-		dd_dev_info(dd,
-			    "%s: Failed to get platform config from UEFI, falling back to request firmware\n",
-			    __func__);
-		/* fall back to request firmware */
-		platform_config_load = 1;
-		goto bail;
-	}
+	if (!ret)
+		goto success;
+
+	dd_dev_info(dd,
+		    "%s: Failed to get platform config from UEFI, falling back to request firmware\n",
+		    __func__);
+	/* fall back to request firmware */
+	platform_config_load = 1;
+	return;
 
+success:
 	dd->platform_config.data = temp_platform_config;
 	dd->platform_config.size = size;
-
-bail:
-	/* exit */;
 }
 
 void free_platform_config(struct hfi1_devdata *dd)

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
