From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 07/17] IB/hfi1: Change EPROM handling to use resource
 reservation
Date: Sat, 05 Mar 2016 08:49:55 -0800
Message-ID: <20160305164955.32025.33898.stgit@scvm10.sc.intel.com>
References: <20160305164725.32025.99686.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160305164725.32025.99686.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Change EPROM handling to use the new ASIC resource reservation system.

Reviewed-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Easwar Hariharan <easwar.hariharan-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/eprom.c |   36 +++++++++++++-----------------------
 1 files changed, 13 insertions(+), 23 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/eprom.c b/drivers/infiniband/hw/hfi1/eprom.c
index 87114af..bd87715 100644
--- a/drivers/infiniband/hw/hfi1/eprom.c
+++ b/drivers/infiniband/hw/hfi1/eprom.c
@@ -102,9 +102,11 @@
 #define EPROM_WP_N BIT_ULL(14)	/* EPROM write line */
 
 /*
- * Use the EP mutex to guard against other callers from within the driver.
+ * How long to wait for the EPROM to become available, in ms.
+ * The spec 32 Mb EPROM takes around 40s to erase then write.
+ * Double it for safety.
  */
-static DEFINE_MUTEX(eprom_mutex);
+#define EPROM_TIMEOUT 80000 /* ms */
 
 /*
  * Turn on external enable line that allows writing on the flash.
@@ -371,14 +373,9 @@ int handle_eprom_command(struct file *fp, const struct hfi1_cmd *cmd)
 	if (!dd->eprom_available)
 		return -EOPNOTSUPP;
 
-	/* lock against other callers touching the ASIC block */
-	mutex_lock(&eprom_mutex);
-
-	/* lock against the other HFI on another OS */
-	ret = acquire_hw_mutex(dd);
+	ret = acquire_chip_resource(dd, CR_EPROM, EPROM_TIMEOUT);
 	if (ret) {
-		dd_dev_err(dd,
-			   "%s: unable to acquire hw mutex, no EPROM support\n",
+		dd_dev_err(dd, "%s: unable to acquire EPROM resource\n",
 			   __func__);
 		goto done_asic;
 	}
@@ -428,9 +425,8 @@ int handle_eprom_command(struct file *fp, const struct hfi1_cmd *cmd)
 		break;
 	}
 
-	release_hw_mutex(dd);
+	release_chip_resource(dd, CR_EPROM);
 done_asic:
-	mutex_unlock(&eprom_mutex);
 	return ret;
 }
 
@@ -441,23 +437,18 @@ int eprom_init(struct hfi1_devdata *dd)
 {
 	int ret = 0;
 
-	/* only the discrete chip has an EPROM, nothing to do */
+	/* only the discrete chip has an EPROM */
 	if (dd->pcidev->device != PCI_DEVICE_ID_INTEL0)
 		return 0;
 
-	/* lock against other callers */
-	mutex_lock(&eprom_mutex);
-
 	/*
-	 * Lock against the other HFI on another OS - the mutex above
-	 * would have caught anything in this driver.  It is OK if
-	 * both OSes reset the EPROM - as long as they don't do it at
-	 * the same time.
+	 * It is OK if both HFIs reset the EPROM as long as they don't
+	 * do it at the same time.
 	 */
-	ret = acquire_hw_mutex(dd);
+	ret = acquire_chip_resource(dd, CR_EPROM, EPROM_TIMEOUT);
 	if (ret) {
 		dd_dev_err(dd,
-			   "%s: unable to acquire hw mutex, no EPROM support\n",
+			   "%s: unable to acquire EPROM resource, no EPROM support\n",
 			   __func__);
 		goto done_asic;
 	}
@@ -474,8 +465,7 @@ int eprom_init(struct hfi1_devdata *dd)
 	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_RELEASE_POWERDOWN_NOID);
 
 	dd->eprom_available = true;
-	release_hw_mutex(dd);
+	release_chip_resource(dd, CR_EPROM);
 done_asic:
-	mutex_unlock(&eprom_mutex);
 	return ret;
 }

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
