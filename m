From: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH for-next 16/17] RDMA/ocrdma: Display fw version
Date: Tue, 4 Feb 2014 11:57:09 +0530
Message-ID: <d0bdf7cf-ec88-43c4-8e6a-907296b35942@CMEXHTCAS2.ad.emulex.com>
References: <1391495230-28021-1-git-send-email-devesh.sharma@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1391495230-28021-1-git-send-email-devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, selvin.xavier-iH1Dq9VlAzfQT0dZR+AlfA@public.gmane.org, Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>, Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>

Adding a sysfs file for getting the FW version.

Signed-off-by: Selvin Xavier <selvin.xavier-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
Signed-off-by: Devesh Sharma <devesh.sharma-laKkSmNT4hbQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/ocrdma/ocrdma_main.c |   42 +++++++++++++++++++++++++++-
 1 files changed, 41 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/hw/ocrdma/ocrdma_main.c b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
index ccb548a..2dcd2c9 100644
--- a/drivers/infiniband/hw/ocrdma/ocrdma_main.c
+++ b/drivers/infiniband/hw/ocrdma/ocrdma_main.c
@@ -339,9 +339,42 @@ static void ocrdma_free_resources(struct ocrdma_dev *dev)
 	kfree(dev->sgid_tbl);
 }
 
+/* OCRDMA sysfs interface */
+static ssize_t show_rev(struct device *device, struct device_attribute *attr,
+			char *buf)
+{
+	struct ocrdma_dev *dev = dev_get_drvdata(device);
+
+	return scnprintf(buf, PAGE_SIZE, "0x%x\n", dev->nic_info.pdev->vendor);
+}
+
+static ssize_t show_fw_ver(struct device *device, struct device_attribute *attr,
+			char *buf)
+{
+	struct ocrdma_dev *dev = dev_get_drvdata(device);
+
+	return scnprintf(buf, PAGE_SIZE, "%s", &dev->attr.fw_ver[0]);
+}
+
+static DEVICE_ATTR(hw_rev, S_IRUGO, show_rev, NULL);
+static DEVICE_ATTR(fw_ver, S_IRUGO, show_fw_ver, NULL);
+
+static struct device_attribute *ocrdma_attributes[] = {
+	&dev_attr_hw_rev,
+	&dev_attr_fw_ver
+};
+
+static void ocrdma_remove_sysfiles(struct ocrdma_dev *dev)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(ocrdma_attributes); i++)
+		device_remove_file(&dev->ibdev.dev, ocrdma_attributes[i]);
+}
+
 static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 {
-	int status = 0;
+	int status = 0, i;
 	struct ocrdma_dev *dev;
 
 	dev = (struct ocrdma_dev *)ib_alloc_device(sizeof(struct ocrdma_dev));
@@ -370,6 +403,9 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 	if (status)
 		goto alloc_err;
 
+	for (i = 0; i < ARRAY_SIZE(ocrdma_attributes); i++)
+		if (device_create_file(&dev->ibdev.dev, ocrdma_attributes[i]))
+			goto sysfs_err;
 	spin_lock(&ocrdma_devlist_lock);
 	list_add_tail_rcu(&dev->entry, &ocrdma_dev_list);
 	spin_unlock(&ocrdma_devlist_lock);
@@ -384,6 +420,8 @@ static struct ocrdma_dev *ocrdma_add(struct be_dev_info *dev_info)
 		dev_name(&dev->nic_info.pdev->dev), dev->id);
 	return dev;
 
+sysfs_err:
+	ocrdma_remove_sysfiles(dev);
 alloc_err:
 	ocrdma_free_resources(dev);
 	ocrdma_cleanup_hw(dev);
@@ -411,6 +449,8 @@ static void ocrdma_remove(struct ocrdma_dev *dev)
 	 * of the registered clients.
 	 */
 	ocrdma_rem_port_stats(dev);
+	ocrdma_remove_sysfiles(dev);
+
 	ib_unregister_device(&dev->ibdev);
 
 	spin_lock(&ocrdma_devlist_lock);
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
