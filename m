From: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/hfi1: Remove some sysfs files
Date: Fri, 07 Aug 2015 09:36:10 -0400
Message-ID: <20150807133610.12421.73468.stgit@phlsvslse11.ph.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Removed "version" and "localbus_info" files from
the sysfs directory.

Change-Id: I128b2e4ceb9440fed9b73a822dd39c44df17e5a5
Reviewed-by: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Sadanand Warrier <sadanand.warrier-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/hfi1/TODO    |    1 -
 drivers/staging/hfi1/sysfs.c |   22 ----------------------
 2 files changed, 23 deletions(-)

diff --git a/drivers/staging/hfi1/TODO b/drivers/staging/hfi1/TODO
index 2529149..dc2f56a 100644
--- a/drivers/staging/hfi1/TODO
+++ b/drivers/staging/hfi1/TODO
@@ -1,6 +1,5 @@
 July, 2015
 
-- Remove unneeded file entries in sysfs
 - Remove software processing of IB protocol and place in library for use
   by qib, ipath (if still present), hfi1, and eventually soft-roce
 - Clean up comments in code around CNP opcode
diff --git a/drivers/staging/hfi1/sysfs.c b/drivers/staging/hfi1/sysfs.c
index b10e857..b78c728 100644
--- a/drivers/staging/hfi1/sysfs.c
+++ b/drivers/staging/hfi1/sysfs.c
@@ -466,13 +466,6 @@ static ssize_t show_hfi(struct device *device, struct device_attribute *attr,
 	return ret;
 }
 
-static ssize_t show_version(struct device *device,
-			    struct device_attribute *attr, char *buf)
-{
-	/* The string printed here is already newline-terminated. */
-	return scnprintf(buf, PAGE_SIZE, "%s", (char *)ib_hfi1_version);
-}
-
 static ssize_t show_boardversion(struct device *device,
 				 struct device_attribute *attr, char *buf)
 {
@@ -485,17 +478,6 @@ static ssize_t show_boardversion(struct device *device,
 }
 
 
-static ssize_t show_localbus_info(struct device *device,
-				  struct device_attribute *attr, char *buf)
-{
-	struct hfi1_ibdev *dev =
-		container_of(device, struct hfi1_ibdev, ibdev.dev);
-	struct hfi1_devdata *dd = dd_from_dev(dev);
-
-	return scnprintf(buf, PAGE_SIZE, "%s\n", dd->lbus_info);
-}
-
-
 static ssize_t show_nctxts(struct device *device,
 			   struct device_attribute *attr, char *buf)
 {
@@ -599,25 +581,21 @@ static ssize_t show_tempsense(struct device *device,
 /* start of per-unit file structures and support code */
 static DEVICE_ATTR(hw_rev, S_IRUGO, show_rev, NULL);
 static DEVICE_ATTR(board_id, S_IRUGO, show_hfi, NULL);
-static DEVICE_ATTR(version, S_IRUGO, show_version, NULL);
 static DEVICE_ATTR(nctxts, S_IRUGO, show_nctxts, NULL);
 static DEVICE_ATTR(nfreectxts, S_IRUGO, show_nfreectxts, NULL);
 static DEVICE_ATTR(serial, S_IRUGO, show_serial, NULL);
 static DEVICE_ATTR(boardversion, S_IRUGO, show_boardversion, NULL);
 static DEVICE_ATTR(tempsense, S_IRUGO, show_tempsense, NULL);
-static DEVICE_ATTR(localbus_info, S_IRUGO, show_localbus_info, NULL);
 static DEVICE_ATTR(chip_reset, S_IWUSR, NULL, store_chip_reset);
 
 static struct device_attribute *hfi1_attributes[] = {
 	&dev_attr_hw_rev,
 	&dev_attr_board_id,
-	&dev_attr_version,
 	&dev_attr_nctxts,
 	&dev_attr_nfreectxts,
 	&dev_attr_serial,
 	&dev_attr_boardversion,
 	&dev_attr_tempsense,
-	&dev_attr_localbus_info,
 	&dev_attr_chip_reset,
 };
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
