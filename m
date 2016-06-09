From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 07/13] IB/mthca: Supprot device FW version string
Date: Thu,  9 Jun 2016 17:54:02 -0400
Message-ID: <1465509248-11324-8-git-send-email-ira.weiny@intel.com>
References: <1465509248-11324-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465509248-11324-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

And remove the sysfs entry in favor of the core support.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mthca/mthca_provider.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mthca/mthca_provider.c b/drivers/infiniband/hw/mthca/mthca_provider.c
index 9866c35cc977..da2335f7f7c3 100644
--- a/drivers/infiniband/hw/mthca/mthca_provider.c
+++ b/drivers/infiniband/hw/mthca/mthca_provider.c
@@ -1081,16 +1081,6 @@ static ssize_t show_rev(struct device *device, struct device_attribute *attr,
 	return sprintf(buf, "%x\n", dev->rev_id);
 }
 
-static ssize_t show_fw_ver(struct device *device, struct device_attribute *attr,
-			   char *buf)
-{
-	struct mthca_dev *dev =
-		container_of(device, struct mthca_dev, ib_dev.dev);
-	return sprintf(buf, "%d.%d.%d\n", (int) (dev->fw_ver >> 32),
-		       (int) (dev->fw_ver >> 16) & 0xffff,
-		       (int) dev->fw_ver & 0xffff);
-}
-
 static ssize_t show_hca(struct device *device, struct device_attribute *attr,
 			char *buf)
 {
@@ -1120,13 +1110,11 @@ static ssize_t show_board(struct device *device, struct device_attribute *attr,
 }
 
 static DEVICE_ATTR(hw_rev,   S_IRUGO, show_rev,    NULL);
-static DEVICE_ATTR(fw_ver,   S_IRUGO, show_fw_ver, NULL);
 static DEVICE_ATTR(hca_type, S_IRUGO, show_hca,    NULL);
 static DEVICE_ATTR(board_id, S_IRUGO, show_board,  NULL);
 
 static struct device_attribute *mthca_dev_attributes[] = {
 	&dev_attr_hw_rev,
-	&dev_attr_fw_ver,
 	&dev_attr_hca_type,
 	&dev_attr_board_id
 };
@@ -1187,6 +1175,17 @@ static int mthca_port_immutable(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }
 
+static void get_dev_fw_str(struct ib_device *device, char *str,
+			   size_t str_len)
+{
+	struct mthca_dev *dev =
+		container_of(device, struct mthca_dev, ib_dev);
+	snprintf(str, str_len, "%d.%d.%d",
+		 (int) (dev->fw_ver >> 32),
+		 (int) (dev->fw_ver >> 16) & 0xffff,
+		 (int) dev->fw_ver & 0xffff);
+}
+
 int mthca_register_device(struct mthca_dev *dev)
 {
 	int ret;
@@ -1266,6 +1265,7 @@ int mthca_register_device(struct mthca_dev *dev)
 	dev->ib_dev.reg_user_mr          = mthca_reg_user_mr;
 	dev->ib_dev.dereg_mr             = mthca_dereg_mr;
 	dev->ib_dev.get_port_immutable   = mthca_port_immutable;
+	dev->ib_dev.get_dev_fw_str       = get_dev_fw_str;
 
 	if (dev->mthca_flags & MTHCA_FLAG_FMR) {
 		dev->ib_dev.alloc_fmr            = mthca_alloc_fmr;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
