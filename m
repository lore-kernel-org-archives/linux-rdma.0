From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 12/13] IB/core: Export a common fw_ver sysfs entry
Date: Thu,  9 Jun 2016 17:54:07 -0400
Message-ID: <1465509248-11324-13-git-send-email-ira.weiny@intel.com>
References: <1465509248-11324-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465509248-11324-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, dgoodell-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, devesh.sharma-1wcpHE2jlwO1Z/+hSey0Gg@public.gmane.org, faisal.latif-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, swise-ut6Up61K2wZBDgjK7y7TUQ@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Now that all the devices have stopped exporting their own sysfs
entry points we can have the core export this on their behalf.

Eventually this may be removed but this provides for backwards
compatibility.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/core/sysfs.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/sysfs.c b/drivers/infiniband/core/sysfs.c
index 5e573bb18660..462dbb64d71d 100644
--- a/drivers/infiniband/core/sysfs.c
+++ b/drivers/infiniband/core/sysfs.c
@@ -38,6 +38,7 @@
 #include <linux/stat.h>
 #include <linux/string.h>
 #include <linux/netdevice.h>
+#include <linux/ethtool.h>
 
 #include <rdma/ib_mad.h>
 #include <rdma/ib_pma.h>
@@ -1188,16 +1189,29 @@ static ssize_t set_node_desc(struct device *device,
 	return count;
 }
 
+static ssize_t show_fw_ver(struct device *device, struct device_attribute *attr,
+			   char *buf)
+{
+	char tmp[ETHTOOL_FWVERS_LEN];
+	struct ib_device *dev = container_of(device, struct ib_device, dev);
+
+	ib_get_device_fw_str(dev, tmp, sizeof(tmp));
+
+	return scnprintf(buf, PAGE_SIZE, "%s\n", tmp);
+}
+
 static DEVICE_ATTR(node_type, S_IRUGO, show_node_type, NULL);
 static DEVICE_ATTR(sys_image_guid, S_IRUGO, show_sys_image_guid, NULL);
 static DEVICE_ATTR(node_guid, S_IRUGO, show_node_guid, NULL);
 static DEVICE_ATTR(node_desc, S_IRUGO | S_IWUSR, show_node_desc, set_node_desc);
+static DEVICE_ATTR(fw_ver, S_IRUGO, show_fw_ver, NULL);
 
 static struct device_attribute *ib_class_attributes[] = {
 	&dev_attr_node_type,
 	&dev_attr_sys_image_guid,
 	&dev_attr_node_guid,
-	&dev_attr_node_desc
+	&dev_attr_node_desc,
+	&dev_attr_fw_ver
 };
 
 static void free_port_list_attributes(struct ib_device *device)
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
