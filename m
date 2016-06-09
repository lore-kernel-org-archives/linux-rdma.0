From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 10/13] IB/usnic: Support device FW version string
Date: Thu,  9 Jun 2016 17:54:05 -0400
Message-ID: <1465509248-11324-11-git-send-email-ira.weiny@intel.com>
References: <1465509248-11324-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465509248-11324-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

And remove sysfs file in favor of the common core.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_ib_main.c  | 16 ++++++++++++++++
 drivers/infiniband/hw/usnic/usnic_ib_sysfs.c | 17 -----------------
 2 files changed, 16 insertions(+), 17 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_ib_main.c b/drivers/infiniband/hw/usnic/usnic_ib_main.c
index 565c881a44ba..c229b9f4a52d 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_main.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_main.c
@@ -331,6 +331,21 @@ static int usnic_port_immutable(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }
 
+static void usnic_get_dev_fw_str(struct ib_device *device,
+				 char *str,
+				 size_t str_len)
+{
+	struct usnic_ib_dev *us_ibdev =
+		container_of(device, struct usnic_ib_dev, ib_dev);
+	struct ethtool_drvinfo info;
+
+	mutex_lock(&us_ibdev->usdev_lock);
+	us_ibdev->netdev->ethtool_ops->get_drvinfo(us_ibdev->netdev, &info);
+	mutex_unlock(&us_ibdev->usdev_lock);
+
+	snprintf(str, str_len, "%s", info.fw_version);
+}
+
 /* Start of PF discovery section */
 static void *usnic_ib_device_add(struct pci_dev *dev)
 {
@@ -414,6 +429,7 @@ static void *usnic_ib_device_add(struct pci_dev *dev)
 	us_ibdev->ib_dev.req_notify_cq = usnic_ib_req_notify_cq;
 	us_ibdev->ib_dev.get_dma_mr = usnic_ib_get_dma_mr;
 	us_ibdev->ib_dev.get_port_immutable = usnic_port_immutable;
+	us_ibdev->ib_dev.get_dev_fw_str     = usnic_get_dev_fw_str;
 
 
 	if (ib_register_device(&us_ibdev->ib_dev, NULL))
diff --git a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
index 3412ea06116e..80ef3f8998c8 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
+++ b/drivers/infiniband/hw/usnic/usnic_ib_sysfs.c
@@ -45,21 +45,6 @@
 #include "usnic_ib_verbs.h"
 #include "usnic_log.h"
 
-static ssize_t usnic_ib_show_fw_ver(struct device *device,
-					struct device_attribute *attr,
-					char *buf)
-{
-	struct usnic_ib_dev *us_ibdev =
-		container_of(device, struct usnic_ib_dev, ib_dev.dev);
-	struct ethtool_drvinfo info;
-
-	mutex_lock(&us_ibdev->usdev_lock);
-	us_ibdev->netdev->ethtool_ops->get_drvinfo(us_ibdev->netdev, &info);
-	mutex_unlock(&us_ibdev->usdev_lock);
-
-	return scnprintf(buf, PAGE_SIZE, "%s\n", info.fw_version);
-}
-
 static ssize_t usnic_ib_show_board(struct device *device,
 					struct device_attribute *attr,
 					char *buf)
@@ -192,7 +177,6 @@ usnic_ib_show_cq_per_vf(struct device *device, struct device_attribute *attr,
 			us_ibdev->vf_res_cnt[USNIC_VNIC_RES_TYPE_CQ]);
 }
 
-static DEVICE_ATTR(fw_ver, S_IRUGO, usnic_ib_show_fw_ver, NULL);
 static DEVICE_ATTR(board_id, S_IRUGO, usnic_ib_show_board, NULL);
 static DEVICE_ATTR(config, S_IRUGO, usnic_ib_show_config, NULL);
 static DEVICE_ATTR(iface, S_IRUGO, usnic_ib_show_iface, NULL);
@@ -201,7 +185,6 @@ static DEVICE_ATTR(qp_per_vf, S_IRUGO, usnic_ib_show_qp_per_vf, NULL);
 static DEVICE_ATTR(cq_per_vf, S_IRUGO, usnic_ib_show_cq_per_vf, NULL);
 
 static struct device_attribute *usnic_class_attributes[] = {
-	&dev_attr_fw_ver,
 	&dev_attr_board_id,
 	&dev_attr_config,
 	&dev_attr_iface,
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
