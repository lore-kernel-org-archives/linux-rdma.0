From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 06/13] IB/core: Initialize uverbs types specification
Date: Wed,  7 Jun 2017 15:22:45 +0300
Message-ID: <1496838172-39671-7-git-send-email-matanb@mellanox.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496838172-39671-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to accelerate the validation and parsing process, we
calculate the number of attributes of all groups in an action
and the mandatory attributes bitmask in advance.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/uverbs.h       |  3 ++
 drivers/infiniband/core/uverbs_ioctl.c | 58 ++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uverbs_main.c  |  3 ++
 3 files changed, 64 insertions(+)

diff --git a/drivers/infiniband/core/uverbs.h b/drivers/infiniband/core/uverbs.h
index 64d494a..6bb1302 100644
--- a/drivers/infiniband/core/uverbs.h
+++ b/drivers/infiniband/core/uverbs.h
@@ -191,7 +191,10 @@ struct ib_ucq_object {
 	u32			async_events_reported;
 };
 
+struct uverbs_type_group;
+
 extern const struct file_operations uverbs_event_fops;
+void uverbs_initialize_type_group(const struct uverbs_type_group *type_group);
 void ib_uverbs_init_event_queue(struct ib_uverbs_event_queue *ev_queue);
 struct file *ib_uverbs_alloc_async_event_file(struct ib_uverbs_file *uverbs_file,
 					      struct ib_device *ib_dev);
diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index a375a7b..4f7491e 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -358,3 +358,61 @@ long ib_uverbs_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
 
 	return err;
 }
+
+static void uverbs_initialize_action(struct uverbs_action *action)
+{
+	size_t attr_group_idx;
+
+	for (attr_group_idx = 0; attr_group_idx < action->num_groups;
+	     attr_group_idx++) {
+		struct uverbs_attr_spec_group *attr_group =
+			action->attr_groups[attr_group_idx];
+		size_t attr_idx;
+
+		if (!attr_group)
+			continue;
+		action->num_child_attrs += attr_group->num_attrs;
+		for (attr_idx = 0; attr_idx < attr_group->num_attrs;
+		     attr_idx++) {
+			struct uverbs_attr_spec *attr =
+				&attr_group->attrs[attr_idx];
+
+			if (attr->flags & UVERBS_ATTR_SPEC_F_MANDATORY)
+				set_bit(attr_idx,
+					attr_group->mandatory_attrs_bitmask);
+		}
+	}
+}
+
+void uverbs_initialize_type_group(const struct uverbs_type_group *type_group)
+{
+	size_t type_idx;
+
+	for (type_idx = 0; type_idx < type_group->num_types; type_idx++) {
+		const struct uverbs_type *type = type_group->types[type_idx];
+		size_t action_group_idx;
+
+		if (!type)
+			continue;
+		for (action_group_idx = 0;
+		     action_group_idx < type->num_groups;
+		     action_group_idx++) {
+			const struct uverbs_action_group *action_group =
+				type->action_groups[action_group_idx];
+			size_t action_idx;
+
+			if (!action_group)
+				continue;
+			for (action_idx = 0;
+			     action_idx < action_group->num_actions;
+			     action_idx++) {
+				struct uverbs_action *action =
+					action_group->actions[action_idx];
+
+				if (!action)
+					continue;
+				uverbs_initialize_action(action);
+			}
+		}
+	}
+}
diff --git a/drivers/infiniband/core/uverbs_main.c b/drivers/infiniband/core/uverbs_main.c
index 3d26096..1836a36 100644
--- a/drivers/infiniband/core/uverbs_main.c
+++ b/drivers/infiniband/core/uverbs_main.c
@@ -45,6 +45,7 @@
 #include <linux/cdev.h>
 #include <linux/anon_inodes.h>
 #include <linux/slab.h>
+#include <rdma/uverbs_std_types.h>
 
 #include <linux/uaccess.h>
 
@@ -1254,6 +1255,8 @@ static int __init ib_uverbs_init(void)
 {
 	int ret;
 
+	uverbs_initialize_type_group(&uverbs_common_types);
+
 	ret = register_chrdev_region(IB_UVERBS_BASE_DEV, IB_UVERBS_MAX_DEVICES,
 				     "infiniband_verbs");
 	if (ret) {
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
