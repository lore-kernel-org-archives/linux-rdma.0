From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 06/13] IB/mlx5: Support device FW version string
Date: Thu,  9 Jun 2016 17:54:01 -0400
Message-ID: <1465509248-11324-7-git-send-email-ira.weiny@intel.com>
References: <1465509248-11324-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465509248-11324-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

And remove sysfs entry in favor of the common code.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 21 ++++++++++-----------
 1 file changed, 10 insertions(+), 11 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index c72797cd9e4f..792038d019a3 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1793,15 +1793,6 @@ static ssize_t show_hca(struct device *device, struct device_attribute *attr,
 	return sprintf(buf, "MT%d\n", dev->mdev->pdev->device);
 }
 
-static ssize_t show_fw_ver(struct device *device, struct device_attribute *attr,
-			   char *buf)
-{
-	struct mlx5_ib_dev *dev =
-		container_of(device, struct mlx5_ib_dev, ib_dev.dev);
-	return sprintf(buf, "%d.%d.%d\n", fw_rev_maj(dev->mdev),
-		       fw_rev_min(dev->mdev), fw_rev_sub(dev->mdev));
-}
-
 static ssize_t show_rev(struct device *device, struct device_attribute *attr,
 			char *buf)
 {
@@ -1820,7 +1811,6 @@ static ssize_t show_board(struct device *device, struct device_attribute *attr,
 }
 
 static DEVICE_ATTR(hw_rev,   S_IRUGO, show_rev,    NULL);
-static DEVICE_ATTR(fw_ver,   S_IRUGO, show_fw_ver, NULL);
 static DEVICE_ATTR(hca_type, S_IRUGO, show_hca,    NULL);
 static DEVICE_ATTR(board_id, S_IRUGO, show_board,  NULL);
 static DEVICE_ATTR(fw_pages, S_IRUGO, show_fw_pages, NULL);
@@ -1828,7 +1818,6 @@ static DEVICE_ATTR(reg_pages, S_IRUGO, show_reg_pages, NULL);
 
 static struct device_attribute *mlx5_class_attributes[] = {
 	&dev_attr_hw_rev,
-	&dev_attr_fw_ver,
 	&dev_attr_hca_type,
 	&dev_attr_board_id,
 	&dev_attr_fw_pages,
@@ -2267,6 +2256,15 @@ static int mlx5_port_immutable(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }
 
+static void get_dev_fw_str(struct ib_device *ibdev, char *str,
+			   size_t str_len)
+{
+	struct mlx5_ib_dev *dev =
+		container_of(ibdev, struct mlx5_ib_dev, ib_dev);
+	snprintf(str, str_len, "%d.%d.%d", fw_rev_maj(dev->mdev),
+		 fw_rev_min(dev->mdev), fw_rev_sub(dev->mdev));
+}
+
 static int mlx5_enable_roce(struct mlx5_ib_dev *dev)
 {
 	int err;
@@ -2413,6 +2411,7 @@ static void *mlx5_ib_add(struct mlx5_core_dev *mdev)
 	dev->ib_dev.map_mr_sg		= mlx5_ib_map_mr_sg;
 	dev->ib_dev.check_mr_status	= mlx5_ib_check_mr_status;
 	dev->ib_dev.get_port_immutable  = mlx5_port_immutable;
+	dev->ib_dev.get_dev_fw_str      = get_dev_fw_str;
 	if (mlx5_core_is_pf(mdev)) {
 		dev->ib_dev.get_vf_config	= mlx5_ib_get_vf_config;
 		dev->ib_dev.set_vf_link_state	= mlx5_ib_set_vf_link_state;
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
