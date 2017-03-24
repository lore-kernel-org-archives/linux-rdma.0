From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Subject: [PATCH 25/28] ibnbd_srv: add sysfs interface
Date: Fri, 24 Mar 2017 11:45:40 +0100
Message-ID: <1490352343-20075-26-git-send-email-jinpu.wangl@profitbricks.com>
References: <1490352343-20075-1-git-send-email-jinpu.wangl@profitbricks.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1490352343-20075-1-git-send-email-jinpu.wangl-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-block-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, axboe-tSWWG44O7X1aa/9Udqfwiw@public.gmane.org, hch-jcswGhMUV9g@public.gmane.org, mail-99BIx50xQYGELgA04lAiVw@public.gmane.org, Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, yun.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org, Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Kleber Souza <kleber.souza-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>, Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>

Signed-off-by: Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Kleber Souza <kleber.souza-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
Signed-off-by: Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
---
 drivers/block/ibnbd_server/ibnbd_srv_sysfs.c | 317 +++++++++++++++++++++++++++
 drivers/block/ibnbd_server/ibnbd_srv_sysfs.h |  64 ++++++
 2 files changed, 381 insertions(+)
 create mode 100644 drivers/block/ibnbd_server/ibnbd_srv_sysfs.c
 create mode 100644 drivers/block/ibnbd_server/ibnbd_srv_sysfs.h

diff --git a/drivers/block/ibnbd_server/ibnbd_srv_sysfs.c b/drivers/block/ibnbd_server/ibnbd_srv_sysfs.c
new file mode 100644
index 0000000..8774abe
--- /dev/null
+++ b/drivers/block/ibnbd_server/ibnbd_srv_sysfs.c
@@ -0,0 +1,317 @@
+/*
+ * InfiniBand Network Block Driver
+ *
+ * Copyright (c) 2014 - 2017 ProfitBricks GmbH. All rights reserved.
+ * Authors: Fabian Holler < mail-99BIx50xQYGELgA04lAiVw@public.gmane.org>
+ *          Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *   	    Kleber Souza <kleber.souza-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ * 	    Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *   	    Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Milind Dumbare <Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ *
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+#include <uapi/linux/limits.h>
+#include <linux/kobject.h>
+#include <linux/sysfs.h>
+#include <linux/stat.h>
+#include <linux/genhd.h>
+#include <linux/list.h>
+
+#include "../ibnbd_inc/ibnbd.h"
+#include "ibnbd_srv.h"
+#include "ibnbd_srv_log.h"
+#include "ibnbd_srv_sysfs.h"
+
+static struct kobject *ibnbd_srv_kobj;
+static struct kobject *ibnbd_srv_devices_kobj;
+#define IBNBD_SYSFS_DIR "ibnbd"
+static char ibnbd_sysfs_dir[64] = IBNBD_SYSFS_DIR;
+
+static ssize_t ibnbd_srv_revalidate_dev_show(struct kobject *kobj,
+					     struct kobj_attribute *attr,
+					     char *page)
+{
+	return scnprintf(page, PAGE_SIZE,
+			 "Usage: echo 1 > %s\n", attr->attr.name);
+}
+
+static ssize_t ibnbd_srv_revalidate_dev_store(struct kobject *kobj,
+					      struct kobj_attribute *attr,
+					      const char *buf, size_t count)
+{
+	int ret;
+	struct ibnbd_srv_dev *dev = container_of(kobj, struct ibnbd_srv_dev,
+						 dev_kobj);
+
+	if (!sysfs_streq(buf, "1")) {
+		ERR_NP("%s: invalid value: '%s'\n", attr->attr.name, buf);
+		return -EINVAL;
+	}
+	ret = ibnbd_srv_revalidate_dev(dev);
+	if (ret)
+		return ret;
+
+	return count;
+}
+
+static struct kobj_attribute ibnbd_srv_revalidate_dev_attr =
+					__ATTR(revalidate,
+					       0644,
+					       ibnbd_srv_revalidate_dev_show,
+					       ibnbd_srv_revalidate_dev_store);
+
+static struct attribute *ibnbd_srv_default_dev_attrs[] = {
+	&ibnbd_srv_revalidate_dev_attr.attr,
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
+static struct kobj_type ibnbd_srv_dev_clients_ktype = {
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
+	ret = kobject_init_and_add(&dev->dev_clients_kobj,
+				   &ibnbd_srv_dev_clients_ktype,
+				   &dev->dev_kobj, "clients");
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
+	kobject_del(&dev->dev_clients_kobj);
+	kobject_put(&dev->dev_clients_kobj);
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
+	kobject_del(&dev->dev_clients_kobj);
+	kobject_put(&dev->dev_clients_kobj);
+	kobject_del(&dev->dev_kobj);
+	kobject_put(&dev->dev_kobj);
+}
+
+static ssize_t ibnbd_srv_dev_client_ro_show(struct kobject *kobj,
+					    struct kobj_attribute *attr,
+					    char *page)
+{
+	struct ibnbd_srv_sess_dev *sess_dev;
+
+	sess_dev = container_of(kobj, struct ibnbd_srv_sess_dev, kobj);
+
+	return scnprintf(page, PAGE_SIZE, "%s\n",
+			 (sess_dev->open_flags & FMODE_WRITE) ? "0" : "1");
+}
+
+static struct kobj_attribute ibnbd_srv_dev_client_ro_attr =
+					__ATTR(read_only, 0444,
+					       ibnbd_srv_dev_client_ro_show,
+					       NULL);
+
+static ssize_t ibnbd_srv_dev_client_mapping_path_show(
+						struct kobject *kobj,
+						struct kobj_attribute *attr,
+						char *page)
+{
+	struct ibnbd_srv_sess_dev *sess_dev;
+
+	sess_dev = container_of(kobj, struct ibnbd_srv_sess_dev, kobj);
+
+	return scnprintf(page, PAGE_SIZE, "%s\n", sess_dev->pathname);
+}
+
+static struct kobj_attribute ibnbd_srv_dev_client_mapping_path_attr =
+				__ATTR(mapping_path, 0444,
+				       ibnbd_srv_dev_client_mapping_path_show,
+				       NULL);
+
+static struct attribute *ibnbd_srv_default_dev_clients_attrs[] = {
+	&ibnbd_srv_dev_client_ro_attr.attr,
+	&ibnbd_srv_dev_client_mapping_path_attr.attr,
+	NULL,
+};
+
+static struct attribute_group ibnbd_srv_default_dev_client_attr_group = {
+	.attrs = ibnbd_srv_default_dev_clients_attrs,
+};
+
+void ibnbd_srv_destroy_dev_client_sysfs(struct ibnbd_srv_sess_dev *sess_dev)
+{
+	struct completion sysfs_compl;
+
+	sysfs_remove_group(&sess_dev->kobj,
+			   &ibnbd_srv_default_dev_client_attr_group);
+
+	init_completion(&sysfs_compl);
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
+int ibnbd_srv_create_dev_client_sysfs(struct ibnbd_srv_sess_dev *sess_dev)
+{
+	int ret;
+
+	ret = kobject_init_and_add(&sess_dev->kobj, &ibnbd_srv_sess_dev_ktype,
+				   &sess_dev->dev->dev_clients_kobj, "%s",
+				   sess_dev->sess->str_addr);
+	if (ret)
+		return ret;
+
+	ret = sysfs_create_group(&sess_dev->kobj,
+				 &ibnbd_srv_default_dev_client_attr_group);
+	if (ret)
+		goto err;
+
+	return 0;
+
+err:
+	kobject_del(&sess_dev->kobj);
+	kobject_put(&sess_dev->kobj);
+	return ret;
+}
+
+int ibnbd_srv_create_sysfs_files(void)
+{
+	int err;
+
+	ibnbd_srv_kobj = kobject_create_and_add(ibnbd_sysfs_dir, kernel_kobj);
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
diff --git a/drivers/block/ibnbd_server/ibnbd_srv_sysfs.h b/drivers/block/ibnbd_server/ibnbd_srv_sysfs.h
new file mode 100644
index 0000000..1df232a
--- /dev/null
+++ b/drivers/block/ibnbd_server/ibnbd_srv_sysfs.h
@@ -0,0 +1,64 @@
+/*
+ * InfiniBand Network Block Driver
+ *
+ * Copyright (c) 2014 - 2017 ProfitBricks GmbH. All rights reserved.
+ * Authors: Fabian Holler < mail-99BIx50xQYGELgA04lAiVw@public.gmane.org>
+ *          Jack Wang <jinpu.wang-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *   	    Kleber Souza <kleber.souza-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ * 	    Danil Kipnis <danil.kipnis-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *   	    Roman Pen <roman.penyaev-EIkl63zCoXaH+58JC4qpiA@public.gmane.org>
+ *          Milind Dumbare <Milind.dumbare-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
+ *
+ *
+ * Redistribution and use in source and binary forms, with or without
+ * modification, are permitted provided that the following conditions
+ * are met:
+ * 1. Redistributions of source code must retain the above copyright
+ *    notice, this list of conditions, and the following disclaimer,
+ *    without modification.
+ * 2. Redistributions in binary form must reproduce at minimum a disclaimer
+ *    substantially similar to the "NO WARRANTY" disclaimer below
+ *    ("Disclaimer") and any redistribution must be conditioned upon
+ *    including a substantially similar Disclaimer requirement for further
+ *    binary redistribution.
+ * 3. Neither the names of the above-listed copyright holders nor the names
+ *    of any contributors may be used to endorse or promote products derived
+ *    from this software without specific prior written permission.
+ *
+ * Alternatively, this software may be distributed under the terms of the
+ * GNU General Public License ("GPL") version 2 as published by the Free
+ * Software Foundation.
+ *
+ * NO WARRANTY
+ * THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS
+ * "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT
+ * LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTIBILITY AND FITNESS FOR
+ * A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT
+ * HOLDERS OR CONTRIBUTORS BE LIABLE FOR SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+ * DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+ * OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+ * HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT,
+ * STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING
+ * IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE
+ * POSSIBILITY OF SUCH DAMAGES.
+ *
+ */
+
+#ifndef _IBNBD_SRV_SYFS_H
+#define _IBNBD_SRV_SYFS_H
+
+int ibnbd_srv_create_dev_sysfs(struct ibnbd_srv_dev *dev,
+			       struct block_device *bdev,
+			       const char *dir_name);
+
+void ibnbd_srv_destroy_dev_sysfs(struct ibnbd_srv_dev *dev);
+
+int ibnbd_srv_create_dev_client_sysfs(struct ibnbd_srv_sess_dev *sess_dev);
+
+void ibnbd_srv_destroy_dev_client_sysfs(struct ibnbd_srv_sess_dev *sess_dev);
+
+int ibnbd_srv_create_sysfs_files(void);
+
+void ibnbd_srv_destroy_sysfs_files(void);
+
+#endif
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
