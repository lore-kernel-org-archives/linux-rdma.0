From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 03/15] RDMA/ocrdma: Adding hca_type and fixing fw_version string in device atrributes
Date: Wed, 4 Jun 2014 23:49:03 +0530
Message-ID: <1b4b12fc-bdae-4b98-a1a7-58e5f7773956@CMEXHTCAS1.ad.emulex.com>
References: <1401905955-28117-1-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-2-git-send-email-selvin.xavier@emulex.com>
 <1401905955-28117-3-git-send-email-selvin.xavier@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1401905955-28117-3-git-send-email-selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |   14 ++++++++++++--
 1 files changed, 12 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index 9368d52..227a542 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -353,15 +353,25 @@ static ssize_t show_fw_ver(struct device *device, struct device_attribute *attr,
 {
 	struct ocrdma_dev *dev = dev_get_drvdata(device);
 
-	return scnprintf(buf, PAGE_SIZE, "%s", &dev->attr.fw_ver[0]);
+	return scnprintf(buf, PAGE_SIZE, "%s\n", &dev->attr.fw_ver[0]);
+}
+
+static ssize_t show_hca_type(struct device *device,
+			     struct device_attribute *attr, char *buf)
+{
+	struct ocrdma_dev *dev = dev_get_drvdata(device);
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n", &dev->model_number[0]);
 }
 
 static DEVICE_ATTR(hw_rev, S_IRUGO, show_rev, NULL);
 static DEVICE_ATTR(fw_ver, S_IRUGO, show_fw_ver, NULL);
+static DEVICE_ATTR(hca_type, S_IRUGO, show_hca_type, NULL);
 
 static struct device_attribute *ocrdma_attributes[] = {
 	&dev_attr_hw_rev,
-	&dev_attr_fw_ver
+	&dev_attr_fw_ver,
+	&dev_attr_hca_type
 };
 
 static void ocrdma_remove_sysfiles(struct ocrdma_dev *dev)
-- 
1.6.0.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
