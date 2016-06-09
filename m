From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 09/13] IB/ocrdma: Support device FW version string
Date: Thu,  9 Jun 2016 17:54:04 -0400
Message-ID: <1465509248-11324-10-git-send-email-ira.weiny@intel.com>
References: <1465509248-11324-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465509248-11324-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

And remove sysfs in favor of the core support.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c | 19 +++++++++----------
 1 file changed, 9 insertions(+), 10 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 3d75f65ce87e..07d0c6c5b046 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -107,6 +107,14 @@ static int ocrdma_port_immutable(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }
 
+static void get_dev_fw_str(struct ib_device *device, char *str,
+			   size_t str_len)
+{
+	struct ocrdma_dev *dev = get_ocrdma_dev(device);
+
+	snprintf(str, str_len, "%s", &dev->attr.fw_ver[0]);
+}
+
 static int ocrdma_register_device(struct ocrdma_dev *dev)
 {
 	strlcpy(dev->ibdev.name, "ocrdma%d", IB_DEVICE_NAME_MAX);
@@ -193,6 +201,7 @@ static int ocrdma_register_device(struct ocrdma_dev *dev)
 
 	dev->ibdev.process_mad = ocrdma_process_mad;
 	dev->ibdev.get_port_immutable = ocrdma_port_immutable;
+	dev->ibdev.get_dev_fw_str     = get_dev_fw_str;
 
 	if (ocrdma_get_asic_type(dev) == OCRDMA_ASIC_GEN_SKH_R) {
 		dev->ibdev.uverbs_cmd_mask |=
@@ -262,14 +271,6 @@ static ssize_t show_rev(struct device *device, struct device_attribute *attr,
 	return scnprintf(buf, PAGE_SIZE, "0x%x\n", dev->nic_info.pdev->vendor);
 }
 
-static ssize_t show_fw_ver(struct device *device, struct device_attribute *attr,
-			char *buf)
-{
-	struct ocrdma_dev *dev = dev_get_drvdata(device);
-
-	return scnprintf(buf, PAGE_SIZE, "%s\n", &dev->attr.fw_ver[0]);
-}
-
 static ssize_t show_hca_type(struct device *device,
 			     struct device_attribute *attr, char *buf)
 {
@@ -279,12 +280,10 @@ static ssize_t show_hca_type(struct device *device,
 }
 
 static DEVICE_ATTR(hw_rev, S_IRUGO, show_rev, NULL);
-static DEVICE_ATTR(fw_ver, S_IRUGO, show_fw_ver, NULL);
 static DEVICE_ATTR(hca_type, S_IRUGO, show_hca_type, NULL);
 
 static struct device_attribute *ocrdma_attributes[] = {
 	&dev_attr_hw_rev,
-	&dev_attr_fw_ver,
 	&dev_attr_hca_type
 };
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
