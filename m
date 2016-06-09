From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 08/13] IB/nes: Support device FW version string
Date: Thu,  9 Jun 2016 17:54:03 -0400
Message-ID: <1465509248-11324-9-git-send-email-ira.weiny@intel.com>
References: <1465509248-11324-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465509248-11324-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

And remove the sysfs in favor of the core version.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/nes/nes_verbs.c | 33 ++++++++++++++-------------------
 1 file changed, 14 insertions(+), 19 deletions(-)

diff --git a/drivers/infiniband/hw/nes/nes_verbs.c b/drivers/infiniband/hw/nes/nes_verbs.c
index 464d6da5fe91..bd69125731c1 100644
--- a/drivers/infiniband/hw/nes/nes_verbs.c
+++ b/drivers/infiniband/hw/nes/nes_verbs.c
@@ -2606,23 +2606,6 @@ static ssize_t show_rev(struct device *dev, struct device_attribute *attr,
 
 
 /**
- * show_fw_ver
- */
-static ssize_t show_fw_ver(struct device *dev, struct device_attribute *attr,
-			   char *buf)
-{
-	struct nes_ib_device *nesibdev =
-			container_of(dev, struct nes_ib_device, ibdev.dev);
-	struct nes_vnic *nesvnic = nesibdev->nesvnic;
-
-	nes_debug(NES_DBG_INIT, "\n");
-	return sprintf(buf, "%u.%u\n",
-		(nesvnic->nesdev->nesadapter->firmware_version >> 16),
-		(nesvnic->nesdev->nesadapter->firmware_version & 0x000000ff));
-}
-
-
-/**
  * show_hca
  */
 static ssize_t show_hca(struct device *dev, struct device_attribute *attr,
@@ -2645,13 +2628,11 @@ static ssize_t show_board(struct device *dev, struct device_attribute *attr,
 
 
 static DEVICE_ATTR(hw_rev, S_IRUGO, show_rev, NULL);
-static DEVICE_ATTR(fw_ver, S_IRUGO, show_fw_ver, NULL);
 static DEVICE_ATTR(hca_type, S_IRUGO, show_hca, NULL);
 static DEVICE_ATTR(board_id, S_IRUGO, show_board, NULL);
 
 static struct device_attribute *nes_dev_attributes[] = {
 	&dev_attr_hw_rev,
-	&dev_attr_fw_ver,
 	&dev_attr_hca_type,
 	&dev_attr_board_id
 };
@@ -3703,6 +3684,19 @@ static int nes_port_immutable(struct ib_device *ibdev, u8 port_num,
 	return 0;
 }
 
+static void get_dev_fw_str(struct ib_device *dev, char *str,
+			   size_t str_len)
+{
+	struct nes_ib_device *nesibdev =
+			container_of(dev, struct nes_ib_device, ibdev);
+	struct nes_vnic *nesvnic = nesibdev->nesvnic;
+
+	nes_debug(NES_DBG_INIT, "\n");
+	snprintf(str, str_len, "%u.%u",
+		 (nesvnic->nesdev->nesadapter->firmware_version >> 16),
+		 (nesvnic->nesdev->nesadapter->firmware_version & 0x000000ff));
+}
+
 /**
  * nes_init_ofa_device
  */
@@ -3802,6 +3796,7 @@ struct nes_ib_device *nes_init_ofa_device(struct net_device *netdev)
 	nesibdev->ibdev.iwcm->create_listen = nes_create_listen;
 	nesibdev->ibdev.iwcm->destroy_listen = nes_destroy_listen;
 	nesibdev->ibdev.get_port_immutable   = nes_port_immutable;
+	nesibdev->ibdev.get_dev_fw_str   = get_dev_fw_str;
 	memcpy(nesibdev->ibdev.iwcm->ifname, netdev->name,
 	       sizeof(nesibdev->ibdev.iwcm->ifname));
 
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
