From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 03/13] IB/cxgb4: Support device FW version string
Date: Thu,  9 Jun 2016 17:53:58 -0400
Message-ID: <1465509248-11324-4-git-send-email-ira.weiny@intel.com>
References: <1465509248-11324-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465509248-11324-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

And remove sysfs fw_ver in favor of the core.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/cxgb4/provider.c | 31 +++++++++++++++----------------
 1 file changed, 15 insertions(+), 16 deletions(-)

diff --git a/drivers/infiniband/hw/cxgb4/provider.c b/drivers/infiniband/hw/cxgb4/provider.c
index dd8a86b726d2..df127ce6b6ec 100644
--- a/drivers/infiniband/hw/cxgb4/provider.c
+++ b/drivers/infiniband/hw/cxgb4/provider.c
@@ -409,20 +409,6 @@ static ssize_t show_rev(struct device *dev, struct device_attribute *attr,
 		       CHELSIO_CHIP_RELEASE(c4iw_dev->rdev.lldi.adapter_type));
 }
 
-static ssize_t show_fw_ver(struct device *dev, struct device_attribute *attr,
-			   char *buf)
-{
-	struct c4iw_dev *c4iw_dev = container_of(dev, struct c4iw_dev,
-						 ibdev.dev);
-	PDBG("%s dev 0x%p\n", __func__, dev);
-
-	return sprintf(buf, "%u.%u.%u.%u\n",
-			FW_HDR_FW_VER_MAJOR_G(c4iw_dev->rdev.lldi.fw_vers),
-			FW_HDR_FW_VER_MINOR_G(c4iw_dev->rdev.lldi.fw_vers),
-			FW_HDR_FW_VER_MICRO_G(c4iw_dev->rdev.lldi.fw_vers),
-			FW_HDR_FW_VER_BUILD_G(c4iw_dev->rdev.lldi.fw_vers));
-}
-
 static ssize_t show_hca(struct device *dev, struct device_attribute *attr,
 			char *buf)
 {
@@ -502,13 +488,11 @@ static int c4iw_get_mib(struct ib_device *ibdev,
 }
 
 static DEVICE_ATTR(hw_rev, S_IRUGO, show_rev, NULL);
-static DEVICE_ATTR(fw_ver, S_IRUGO, show_fw_ver, NULL);
 static DEVICE_ATTR(hca_type, S_IRUGO, show_hca, NULL);
 static DEVICE_ATTR(board_id, S_IRUGO, show_board, NULL);
 
 static struct device_attribute *c4iw_class_attributes[] = {
 	&dev_attr_hw_rev,
-	&dev_attr_fw_ver,
 	&dev_attr_hca_type,
 	&dev_attr_board_id,
 };
@@ -530,6 +514,20 @@ static int c4iw_port_immutable(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }
 
+static void get_dev_fw_str(struct ib_device *dev, char *str,
+			   size_t str_len)
+{
+	struct c4iw_dev *c4iw_dev = container_of(dev, struct c4iw_dev,
+						 ibdev);
+	PDBG("%s dev 0x%p\n", __func__, dev);
+
+	snprintf(str, str_len, "%u.%u.%u.%u",
+		 FW_HDR_FW_VER_MAJOR_G(c4iw_dev->rdev.lldi.fw_vers),
+		 FW_HDR_FW_VER_MINOR_G(c4iw_dev->rdev.lldi.fw_vers),
+		 FW_HDR_FW_VER_MICRO_G(c4iw_dev->rdev.lldi.fw_vers),
+		 FW_HDR_FW_VER_BUILD_G(c4iw_dev->rdev.lldi.fw_vers));
+}
+
 int c4iw_register_device(struct c4iw_dev *dev)
 {
 	int ret;
@@ -605,6 +603,7 @@ int c4iw_register_device(struct c4iw_dev *dev)
 	dev->ibdev.get_hw_stats = c4iw_get_mib;
 	dev->ibdev.uverbs_abi_ver = C4IW_UVERBS_ABI_VERSION;
 	dev->ibdev.get_port_immutable = c4iw_port_immutable;
+	dev->ibdev.get_dev_fw_str = get_dev_fw_str;
 	dev->ibdev.drain_sq = c4iw_drain_sq;
 	dev->ibdev.drain_rq = c4iw_drain_rq;
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
