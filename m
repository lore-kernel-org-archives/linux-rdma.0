From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 4/8] nvme: add fabrics sysfs attributes
Date: Mon, 13 Jun 2016 16:45:24 +0200
Message-ID: <1465829128-22993-5-git-send-email-hch@lst.de>
References: <1465829128-22993-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1465829128-22993-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, keith.busch-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-nvme-IAPFreCvJWM7uuMidbF8XUB+6BGkLq7r@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>

- delete_controller: This attribute allows to delete a controller.
  A driver is not obligated to support it (pci doesn't) so it is
  created only if the driver supports it. The new fabrics drivers
  will support it (essentialy a disconnect operation).

  Usage:
  echo > /sys/class/nvme/nvme0/delete_controller

- subsysnqn: This attribute shows the subsystem nqn of the configured
  device. If a driver does not implement the get_subsysnqn method, the
  file will not appear in sysfs.

- transport: This attribute shows the transport name. Added a "name"
  field to struct nvme_ctrl_ops.

  For loop,
  cat /sys/class/nvme/nvme0/transport
  loop

  For RDMA,
  cat /sys/class/nvme/nvme0/transport
  rdma

  For PCIe,
  cat /sys/class/nvme/nvme0/transport
  pcie

- address: This attributes shows the controller address. The fabrics
  drivers that will implement get_address can show the address of the
  connected controller.

  example:
  cat /sys/class/nvme/nvme0/address
  traddr=192.168.2.2,trsvcid=1023

Signed-off-by: Ming Lin <ming.l-Vzezgt5dB6uUEJcrhfAQsw@public.gmane.org>
Reviewed-by: Jay Freyensee <james.p.freyensee-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>
Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 drivers/nvme/host/core.c | 76 ++++++++++++++++++++++++++++++++++++++++++++++--
 drivers/nvme/host/nvme.h |  4 +++
 drivers/nvme/host/pci.c  |  1 +
 3 files changed, 78 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/core.c b/drivers/nvme/host/core.c
index bd04ec6..f5676c6 100644
--- a/drivers/nvme/host/core.c
+++ b/drivers/nvme/host/core.c
@@ -1362,7 +1362,7 @@ static struct attribute *nvme_ns_attrs[] = {
 	NULL,
 };
 
-static umode_t nvme_attrs_are_visible(struct kobject *kobj,
+static umode_t nvme_ns_attrs_are_visible(struct kobject *kobj,
 		struct attribute *a, int n)
 {
 	struct device *dev = container_of(kobj, struct device, kobj);
@@ -1381,7 +1381,7 @@ static umode_t nvme_attrs_are_visible(struct kobject *kobj,
 
 static const struct attribute_group nvme_ns_attr_group = {
 	.attrs		= nvme_ns_attrs,
-	.is_visible	= nvme_attrs_are_visible,
+	.is_visible	= nvme_ns_attrs_are_visible,
 };
 
 #define nvme_show_str_function(field)						\
@@ -1407,6 +1407,49 @@ nvme_show_str_function(serial);
 nvme_show_str_function(firmware_rev);
 nvme_show_int_function(cntlid);
 
+static ssize_t nvme_sysfs_delete(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t count)
+{
+	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
+
+	if (device_remove_file_self(dev, attr))
+		ctrl->ops->delete_ctrl(ctrl);
+	return count;
+}
+static DEVICE_ATTR(delete_controller, S_IWUSR, NULL, nvme_sysfs_delete);
+
+static ssize_t nvme_sysfs_show_transport(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%s\n", ctrl->ops->name);
+}
+static DEVICE_ATTR(transport, S_IRUGO, nvme_sysfs_show_transport, NULL);
+
+static ssize_t nvme_sysfs_show_subsysnqn(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
+
+	return snprintf(buf, PAGE_SIZE, "%s\n",
+			ctrl->ops->get_subsysnqn(ctrl));
+}
+static DEVICE_ATTR(subsysnqn, S_IRUGO, nvme_sysfs_show_subsysnqn, NULL);
+
+static ssize_t nvme_sysfs_show_address(struct device *dev,
+					 struct device_attribute *attr,
+					 char *buf)
+{
+	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
+
+	return ctrl->ops->get_address(ctrl, buf, PAGE_SIZE);
+}
+static DEVICE_ATTR(address, S_IRUGO, nvme_sysfs_show_address, NULL);
+
 static struct attribute *nvme_dev_attrs[] = {
 	&dev_attr_reset_controller.attr,
 	&dev_attr_rescan_controller.attr,
@@ -1414,11 +1457,38 @@ static struct attribute *nvme_dev_attrs[] = {
 	&dev_attr_serial.attr,
 	&dev_attr_firmware_rev.attr,
 	&dev_attr_cntlid.attr,
+	&dev_attr_delete_controller.attr,
+	&dev_attr_transport.attr,
+	&dev_attr_subsysnqn.attr,
+	&dev_attr_address.attr,
 	NULL
 };
 
+#define CHECK_ATTR(ctrl, a, name)		\
+	if ((a) == &dev_attr_##name.attr &&	\
+	    !(ctrl)->ops->get_##name)		\
+		return 0
+
+static umode_t nvme_dev_attrs_are_visible(struct kobject *kobj,
+		struct attribute *a, int n)
+{
+	struct device *dev = container_of(kobj, struct device, kobj);
+	struct nvme_ctrl *ctrl = dev_get_drvdata(dev);
+
+	if (a == &dev_attr_delete_controller.attr) {
+		if (!ctrl->ops->delete_ctrl)
+			return 0;
+	}
+
+	CHECK_ATTR(ctrl, a, subsysnqn);
+	CHECK_ATTR(ctrl, a, address);
+
+	return a->mode;
+}
+
 static struct attribute_group nvme_dev_attrs_group = {
-	.attrs = nvme_dev_attrs,
+	.attrs		= nvme_dev_attrs,
+	.is_visible	= nvme_dev_attrs_are_visible,
 };
 
 static const struct attribute_group *nvme_dev_attr_groups[] = {
diff --git a/drivers/nvme/host/nvme.h b/drivers/nvme/host/nvme.h
index 68a67ac..c99acb0 100644
--- a/drivers/nvme/host/nvme.h
+++ b/drivers/nvme/host/nvme.h
@@ -144,6 +144,7 @@ struct nvme_ns {
 };
 
 struct nvme_ctrl_ops {
+	const char *name;
 	struct module *module;
 	int (*reg_read32)(struct nvme_ctrl *ctrl, u32 off, u32 *val);
 	int (*reg_write32)(struct nvme_ctrl *ctrl, u32 off, u32 val);
@@ -152,6 +153,9 @@ struct nvme_ctrl_ops {
 	void (*free_ctrl)(struct nvme_ctrl *ctrl);
 	void (*post_scan)(struct nvme_ctrl *ctrl);
 	void (*submit_async_event)(struct nvme_ctrl *ctrl, int aer_idx);
+	int (*delete_ctrl)(struct nvme_ctrl *ctrl);
+	const char *(*get_subsysnqn)(struct nvme_ctrl *ctrl);
+	int (*get_address)(struct nvme_ctrl *ctrl, char *buf, int size);
 };
 
 static inline bool nvme_ctrl_ready(struct nvme_ctrl *ctrl)
diff --git a/drivers/nvme/host/pci.c b/drivers/nvme/host/pci.c
index db6fdee..de222ed 100644
--- a/drivers/nvme/host/pci.c
+++ b/drivers/nvme/host/pci.c
@@ -1873,6 +1873,7 @@ static int nvme_pci_reset_ctrl(struct nvme_ctrl *ctrl)
 }
 
 static const struct nvme_ctrl_ops nvme_pci_ctrl_ops = {
+	.name			= "pcie",
 	.module			= THIS_MODULE,
 	.reg_read32		= nvme_pci_reg_read32,
 	.reg_write32		= nvme_pci_reg_write32,
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
