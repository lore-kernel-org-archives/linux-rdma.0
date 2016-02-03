From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 48/54] staging/rdma/hfi1: Make EPROM check per device
Date: Wed, 03 Feb 2016 14:37:24 -0800
Message-ID: <20160203223720.5923.30443.stgit@scvm10.sc.intel.com>
References: <20160203222512.5923.30980.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160203222512.5923.30980.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Add a variable eprom_available to each device, replacing the
global of the same name.  This is to allow multiple HFI devices
with different EPROM availability to operate correctly on the
the same system.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/eprom.c |   16 +++++-----------
 drivers/staging/rdma/hfi1/hfi.h   |    1 +
 2 files changed, 6 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/eprom.c b/drivers/staging/rdma/hfi1/eprom.c
index 8104a11..29958aa 100644
--- a/drivers/staging/rdma/hfi1/eprom.c
+++ b/drivers/staging/rdma/hfi1/eprom.c
@@ -106,10 +106,8 @@
 
 /*
  * Use the EP mutex to guard against other callers from within the driver.
- * Also covers usage of eprom_available.
  */
 static DEFINE_MUTEX(eprom_mutex);
-static int eprom_available;	/* default: not available */
 
 /*
  * Turn on external enable line that allows writing on the flash.
@@ -376,15 +374,13 @@ int handle_eprom_command(struct file *fp, const struct hfi1_cmd *cmd)
 		return -EINVAL;
 	}
 
+	/* some devices do not have an EPROM */
+	if (!dd->eprom_available)
+		return -EOPNOTSUPP;
+
 	/* lock against other callers touching the ASIC block */
 	mutex_lock(&eprom_mutex);
 
-	/* some platforms do not have an EPROM */
-	if (!eprom_available) {
-		ret = -ENOSYS;
-		goto done_asic;
-	}
-
 	/* lock against the other HFI on another OS */
 	ret = acquire_hw_mutex(dd);
 	if (ret) {
@@ -458,8 +454,6 @@ int eprom_init(struct hfi1_devdata *dd)
 
 	/* lock against other callers */
 	mutex_lock(&eprom_mutex);
-	if (eprom_available)	/* already initialized */
-		goto done_asic;
 
 	/*
 	 * Lock against the other HFI on another OS - the mutex above
@@ -487,7 +481,7 @@ int eprom_init(struct hfi1_devdata *dd)
 	/* wake the device with command "release powerdown NoID" */
 	write_csr(dd, ASIC_EEP_ADDR_CMD, CMD_RELEASE_POWERDOWN_NOID);
 
-	eprom_available = 1;
+	dd->eprom_available = true;
 	release_hw_mutex(dd);
 done_asic:
 	mutex_unlock(&eprom_mutex);
diff --git a/drivers/staging/rdma/hfi1/hfi.h b/drivers/staging/rdma/hfi1/hfi.h
index 023c504..585485b 100644
--- a/drivers/staging/rdma/hfi1/hfi.h
+++ b/drivers/staging/rdma/hfi1/hfi.h
@@ -1145,6 +1145,7 @@ struct hfi1_devdata {
 	__le64 *rcvhdrtail_dummy_kvaddr;
 	dma_addr_t rcvhdrtail_dummy_physaddr;
 
+	bool eprom_available;	/* true if EPROM is available for this device */
 	bool aspm_supported;	/* Does HW support ASPM */
 	bool aspm_enabled;	/* ASPM state: enabled/disabled */
 	/* Serialize ASPM enable/disable between multiple verbs contexts */

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
