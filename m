From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH V1 02/13] IB/cxgb3: Support device FW version string
Date: Wed, 15 Jun 2016 02:21:57 -0400
Message-ID: <1465971728-24104-3-git-send-email-ira.weiny@intel.com>
References: <1465971728-24104-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465971728-24104-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Also remove fw_ver sysfs to be replaced by the common core one.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb3/iwch_provider.c | 27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb3/iwch_provider.c b/drivers/infiniband/hw/cxgb3/iwch_provider.c
index bb1a839d4d6d..3edb80644b53 100644
--- a/drivers/infiniband/hw/cxgb3/iwch_provider.c
+++ b/drivers/infiniband/hw/cxgb3/iwch_provider.c
@@ -1183,18 +1183,6 @@ static ssize_t show_rev(struct device *dev, struct device_attribute *attr,
 	return sprintf(buf, "%d\n", iwch_dev->rdev.t3cdev_p->type);
 }
 
-static ssize_t show_fw_ver(struct device *dev, struct device_attribute *attr, char *buf)
-{
-	struct iwch_dev *iwch_dev = container_of(dev, struct iwch_dev,
-						 ibdev.dev);
-	struct ethtool_drvinfo info;
-	struct net_device *lldev = iwch_dev->rdev.t3cdev_p->lldev;
-
-	PDBG("%s dev 0x%p\n", __func__, dev);
-	lldev->ethtool_ops->get_drvinfo(lldev, &info);
-	return sprintf(buf, "%s\n", info.fw_version);
-}
-
 static ssize_t show_hca(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
@@ -1334,13 +1322,11 @@ static int iwch_get_mib(struct ib_device *ibdev, struct rdma_hw_stats *stats,
 }
 
 static DEVICE_ATTR(hw_rev, S_IRUGO, show_rev, NULL);
-static DEVICE_ATTR(fw_ver, S_IRUGO, show_fw_ver, NULL);
 static DEVICE_ATTR(hca_type, S_IRUGO, show_hca, NULL);
 static DEVICE_ATTR(board_id, S_IRUGO, show_board, NULL);
 
 static struct device_attribute *iwch_class_attributes[] = {
 	&dev_attr_hw_rev,
-	&dev_attr_fw_ver,
 	&dev_attr_hca_type,
 	&dev_attr_board_id,
 };
@@ -1362,6 +1348,18 @@ static int iwch_port_immutable(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }
 
+static void get_dev_fw_ver_str(struct ib_device *ibdev, char *str,
+			       size_t str_len)
+{
+	struct iwch_dev *iwch_dev = to_iwch_dev(ibdev);
+	struct ethtool_drvinfo info;
+	struct net_device *lldev = iwch_dev->rdev.t3cdev_p->lldev;
+
+	PDBG("%s dev 0x%p\n", __func__, iwch_dev);
+	lldev->ethtool_ops->get_drvinfo(lldev, &info);
+	snprintf(str, str_len, "%s", info.fw_version);
+}
+
 int iwch_register_device(struct iwch_dev *dev)
 {
 	int ret;
@@ -1437,6 +1435,7 @@ int iwch_register_device(struct iwch_dev *dev)
 	dev->ibdev.get_hw_stats = iwch_get_mib;
 	dev->ibdev.uverbs_abi_ver = IWCH_UVERBS_ABI_VERSION;
 	dev->ibdev.get_port_immutable = iwch_port_immutable;
+	dev->ibdev.get_dev_fw_str = get_dev_fw_ver_str;
 
 	dev->ibdev.iwcm = kmalloc(sizeof(struct iw_cm_verbs), GFP_KERNEL);
 	if (!dev->ibdev.iwcm)
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
