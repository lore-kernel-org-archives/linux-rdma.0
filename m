From: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH 21/24] ibnbd: server: sysfs interface functions
Date: Fri,  2 Feb 2018 15:09:01 +0100
Message-ID: <20180202140904.2017-22-roman.penyaev@profitbricks.com>
References: <20180202140904.2017-1-roman.penyaev@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20180202140904.2017-1-roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Jens Axboe <axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org>, Christoph Hellwig <hch-wEGCiKHe2LqWVfeAwA7xHQ@public.gmane.org>, Sagi Grimberg <sagi-NQWnxTmZq1alnMjI0IkVqw@public.gmane.org>, Bart Van Assche <bart.vanassche-XdAiOPVOjttBDgjK7y7TUQ@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This is the sysfs interface to IBNBD mapped devices on server side:

  /sys/kernel/ibnbd_server/devices/<device_name>/
    |- block_dev
    |  *** link pointing to the corresponding block device sysfs entry
    |
    |- sessions/<session-name>/
    |  *** sessions directory
       |
       |- read_only
       |  *** is devices mapped as read only
       |
       |- mapping_path
          *** relative device path provided by the client during mapping

Signed-off-by: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Cc: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/block/ibnbd/ibnbd-srv-sysfs.c | 264 ++++++++++++++++++++++++++++++++++
 1 file changed, 264 insertions(+)

diff --git a/drivers/block/ibnbd/ibnbd-srv-sysfs.c b/drivers/block/ibnbd/ibnbd-srv-sysfs.c
new file mode 100644
index 000000000000..a0efd6a2accb
--- /dev/null
+++ b/drivers/block/ibnbd/ibnbd-srv-sysfs.c
@@ -0,0 +1,264 @@
+/*
+ * InfiniBand Network Block Driver
+ *
+ * Copyright (c) 2014 - 2017 ProfitBricks GmbH. All rights reserved.
+ * Authors: Fabian Holler <mail-99BIx50xQYGELgA04lAiVw@public.gmane.org>
+ *          Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Kleber Souza <kleber.souza-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Roman Penyaev <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Milind Dumbare <Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ *
+ * Copyright (c) 2017 - 2018 ProfitBricks GmbH. All rights reserved.
+ * Authors: Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Roman Penyaev <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version 2
+ * of the License, or (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program; if not, see <http://www.gnu.org/licenses/>.
+ */
+
+#undef pr_fmt
+#define pr_fmt(fmt) KBUILD_MODNAME " L" __stringify(__LINE__) ": " fmt
+
+#include <uapi/linux/limits.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/stat.h>
+#include <linux/genhd.h>
+#include <linux/list.h>
+#include <linux/moduleparam.h>
+
+#include "ibnbd-srv.h"
+
+static struct kobject *ibnbd_srv_kobj;
+static struct kobject *ibnbd_srv_devices_kobj;
+
+static struct attribute *ibnbd_srv_default_dev_attrs[] = {
+	NULL,
+};
+
+static struct attribute_group ibnbd_srv_default_dev_attr_group = {
+	.attrs = ibnbd_srv_default_dev_attrs,
+};
+
+static ssize_t ibnbd_srv_attr_show(struct kobject *kobj, struct attribute *attr,
+				   char *page)
+{
+	struct kobj_attribute *kattr;
+	int ret = -EIO;
+
+	kattr = container_of(attr, struct kobj_attribute, attr);
+	if (kattr->show)
+		ret = kattr->show(kobj, kattr, page);
+	return ret;
+}
+
+static ssize_t ibnbd_srv_attr_store(struct kobject *kobj,
+				    struct attribute *attr,
+				    const char *page, size_t length)
+{
+	struct kobj_attribute *kattr;
+	int ret = -EIO;
+
+	kattr = container_of(attr, struct kobj_attribute, attr);
+	if (kattr->store)
+		ret = kattr->store(kobj, kattr, page, length);
+	return ret;
+}
+
+static const struct sysfs_ops ibnbd_srv_sysfs_ops = {
+	.show	= ibnbd_srv_attr_show,
+	.store	= ibnbd_srv_attr_store,
+};
+
+static struct kobj_type ibnbd_srv_dev_ktype = {
+	.sysfs_ops	= &ibnbd_srv_sysfs_ops,
+};
+
+static struct kobj_type ibnbd_srv_dev_sessions_ktype = {
+	.sysfs_ops	= &ibnbd_srv_sysfs_ops,
+};
+
+int ibnbd_srv_create_dev_sysfs(struct ibnbd_srv_dev *dev,
+			       struct block_device *bdev,
+			       const char *dir_name)
+{
+	struct kobject *bdev_kobj;
+	int ret;
+
+	ret = kobject_init_and_add(&dev->dev_kobj, &ibnbd_srv_dev_ktype,
+				   ibnbd_srv_devices_kobj, dir_name);
+	if (ret)
+		return ret;
+
+	ret = kobject_init_and_add(&dev->dev_sessions_kobj,
+				   &ibnbd_srv_dev_sessions_ktype,
+				   &dev->dev_kobj, "sessions");
+	if (ret)
+		goto err;
+
+	ret = sysfs_create_group(&dev->dev_kobj,
+				 &ibnbd_srv_default_dev_attr_group);
+	if (ret)
+		goto err2;
+
+	bdev_kobj = &disk_to_dev(bdev->bd_disk)->kobj;
+	ret = sysfs_create_link(&dev->dev_kobj, bdev_kobj, "block_dev");
+	if (ret)
+		goto err3;
+
+	return 0;
+
+err3:
+	sysfs_remove_group(&dev->dev_kobj,
+			   &ibnbd_srv_default_dev_attr_group);
+err2:
+	kobject_del(&dev->dev_sessions_kobj);
+	kobject_put(&dev->dev_sessions_kobj);
+err:
+	kobject_del(&dev->dev_kobj);
+	kobject_put(&dev->dev_kobj);
+	return ret;
+}
+
+void ibnbd_srv_destroy_dev_sysfs(struct ibnbd_srv_dev *dev)
+{
+	sysfs_remove_link(&dev->dev_kobj, "block_dev");
+	sysfs_remove_group(&dev->dev_kobj, &ibnbd_srv_default_dev_attr_group);
+	kobject_del(&dev->dev_sessions_kobj);
+	kobject_put(&dev->dev_sessions_kobj);
+	kobject_del(&dev->dev_kobj);
+	kobject_put(&dev->dev_kobj);
+}
+
+static ssize_t ibnbd_srv_dev_session_ro_show(struct kobject *kobj,
+					     struct kobj_attribute *attr,
+					     char *page)
+{
+	struct ibnbd_srv_sess_dev *sess_dev;
+
+	sess_dev = container_of(kobj, struct ibnbd_srv_sess_dev, kobj);
+
+	return scnprintf(page, PAGE_SIZE, "%s\n",
+			 (sess_dev->open_flags & FMODE_WRITE) ? "0" : "1");
+}
+
+static struct kobj_attribute ibnbd_srv_dev_session_ro_attr =
+	__ATTR(read_only, 0444,
+	       ibnbd_srv_dev_session_ro_show,
+	       NULL);
+
+static ssize_t
+ibnbd_srv_dev_session_mapping_path_show(struct kobject *kobj,
+					struct kobj_attribute *attr, char *page)
+{
+	struct ibnbd_srv_sess_dev *sess_dev;
+
+	sess_dev = container_of(kobj, struct ibnbd_srv_sess_dev, kobj);
+
+	return scnprintf(page, PAGE_SIZE, "%s\n", sess_dev->pathname);
+}
+
+static struct kobj_attribute ibnbd_srv_dev_session_mapping_path_attr =
+	__ATTR(mapping_path, 0444,
+	       ibnbd_srv_dev_session_mapping_path_show,
+	       NULL);
+
+static struct attribute *ibnbd_srv_default_dev_sessions_attrs[] = {
+	&ibnbd_srv_dev_session_ro_attr.attr,
+	&ibnbd_srv_dev_session_mapping_path_attr.attr,
+	NULL,
+};
+
+static struct attribute_group ibnbd_srv_default_dev_session_attr_group = {
+	.attrs = ibnbd_srv_default_dev_sessions_attrs,
+};
+
+void ibnbd_srv_destroy_dev_session_sysfs(struct ibnbd_srv_sess_dev *sess_dev)
+{
+	DECLARE_COMPLETION_ONSTACK(sysfs_compl);
+
+	sysfs_remove_group(&sess_dev->kobj,
+			   &ibnbd_srv_default_dev_session_attr_group);
+
+	sess_dev->sysfs_release_compl = &sysfs_compl;
+	kobject_del(&sess_dev->kobj);
+	kobject_put(&sess_dev->kobj);
+	wait_for_completion(&sysfs_compl);
+}
+
+static void ibnbd_srv_sess_dev_release(struct kobject *kobj)
+{
+	struct ibnbd_srv_sess_dev *sess_dev;
+
+	sess_dev = container_of(kobj, struct ibnbd_srv_sess_dev, kobj);
+	if (sess_dev->sysfs_release_compl)
+		complete_all(sess_dev->sysfs_release_compl);
+}
+
+static struct kobj_type ibnbd_srv_sess_dev_ktype = {
+	.sysfs_ops	= &ibnbd_srv_sysfs_ops,
+	.release	= ibnbd_srv_sess_dev_release,
+};
+
+int ibnbd_srv_create_dev_session_sysfs(struct ibnbd_srv_sess_dev *sess_dev)
+{
+	int ret;
+
+	ret = kobject_init_and_add(&sess_dev->kobj, &ibnbd_srv_sess_dev_ktype,
+				   &sess_dev->dev->dev_sessions_kobj, "%s",
+				   sess_dev->sess->sessname);
+	if (ret)
+		return ret;
+
+	ret = sysfs_create_group(&sess_dev->kobj,
+				 &ibnbd_srv_default_dev_session_attr_group);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	kobject_del(&sess_dev->kobj);
+	kobject_put(&sess_dev->kobj);
+
+	return ret;
+}
+
+int ibnbd_srv_create_sysfs_files(void)
+{
+	int err;
+
+	ibnbd_srv_kobj = kobject_create_and_add(KBUILD_MODNAME, kernel_kobj);
+	if (!ibnbd_srv_kobj)
+		return -ENOMEM;
+
+	ibnbd_srv_devices_kobj = kobject_create_and_add("devices",
+							ibnbd_srv_kobj);
+	if (!ibnbd_srv_devices_kobj) {
+		err = -ENOMEM;
+		goto err;
+	}
+
+	return 0;
+
+err:
+	kobject_put(ibnbd_srv_kobj);
+	return err;
+}
+
+void ibnbd_srv_destroy_sysfs_files(void)
+{
+	kobject_put(ibnbd_srv_devices_kobj);
+	kobject_put(ibnbd_srv_kobj);
+}
-- 
2.13.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
