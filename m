From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH V1 05/13] IB/mlx4: Support device FW version string
Date: Wed, 15 Jun 2016 02:22:00 -0400
Message-ID: <1465971728-24104-6-git-send-email-ira.weiny@intel.com>
References: <1465971728-24104-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465971728-24104-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

And remove the sysfs in favor of common core version.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mlx4/main.c | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 0eb09e104542..1cbd075ce7e4 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -2022,16 +2022,6 @@ static ssize_t show_hca(struct device *device, struct device_attribute *attr,
 	return sprintf(buf, "MT%d\n", dev->dev->persist->pdev->device);
 }
 
-static ssize_t show_fw_ver(struct device *device, struct device_attribute *attr,
-			   char *buf)
-{
-	struct mlx4_ib_dev *dev =
-		container_of(device, struct mlx4_ib_dev, ib_dev.dev);
-	return sprintf(buf, "%d.%d.%d\n", (int) (dev->dev->caps.fw_ver >> 32),
-		       (int) (dev->dev->caps.fw_ver >> 16) & 0xffff,
-		       (int) dev->dev->caps.fw_ver & 0xffff);
-}
-
 static ssize_t show_rev(struct device *device, struct device_attribute *attr,
 			char *buf)
 {
@@ -2050,13 +2040,11 @@ static ssize_t show_board(struct device *device, struct device_attribute *attr,
 }
 
 static DEVICE_ATTR(hw_rev,   S_IRUGO, show_rev,    NULL);
-static DEVICE_ATTR(fw_ver,   S_IRUGO, show_fw_ver, NULL);
 static DEVICE_ATTR(hca_type, S_IRUGO, show_hca,    NULL);
 static DEVICE_ATTR(board_id, S_IRUGO, show_board,  NULL);
 
 static struct device_attribute *mlx4_class_attributes[] = {
 	&dev_attr_hw_rev,
-	&dev_attr_fw_ver,
 	&dev_attr_hca_type,
 	&dev_attr_board_id
 };
@@ -2277,6 +2265,17 @@ static int mlx4_port_immutable(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }
 
+static void get_fw_ver_str(struct ib_device *device, char *str,
+			   size_t str_len)
+{
+	struct mlx4_ib_dev *dev =
+		container_of(device, struct mlx4_ib_dev, ib_dev);
+	snprintf(str, str_len, "%d.%d.%d",
+		 (int) (dev->dev->caps.fw_ver >> 32),
+		 (int) (dev->dev->caps.fw_ver >> 16) & 0xffff,
+		 (int) dev->dev->caps.fw_ver & 0xffff);
+}
+
 static void *mlx4_ib_add(struct mlx4_dev *dev)
 {
 	struct mlx4_ib_dev *ibdev;
@@ -2410,6 +2409,7 @@ static void *mlx4_ib_add(struct mlx4_dev *dev)
 	ibdev->ib_dev.detach_mcast	= mlx4_ib_mcg_detach;
 	ibdev->ib_dev.process_mad	= mlx4_ib_process_mad;
 	ibdev->ib_dev.get_port_immutable = mlx4_port_immutable;
+	ibdev->ib_dev.get_dev_fw_str    = get_fw_ver_str;
 	ibdev->ib_dev.disassociate_ucontext = mlx4_ib_disassociate_ucontext;
 
 	if (!mlx4_is_slave(ibdev->dev)) {
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
