From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V2 3/8] RDMA/core: Add support for custom types
Date: Tue, 19 Jul 2016 18:23:27 +0300
Message-ID: <1468941812-32286-4-git-send-email-matanb@mellanox.com>
References: <1468941812-32286-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1468941812-32286-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The new ioctl infrastructure supports vendor specific objects.
This is implemented by having a list of uverbs_uobject_type in the
ib_device. Each element of this list corresponds to a specific type
and specifies its free function, vendor's type_id, etc.
The order of elements dictates the order to object's destruction.
The whole type_list should be initialized before any ucontext was
created.

When a ucontext is created, a new list is created in this ib_ucontext.
This list corresponds to the ib_device's type list, as any element
in the ib_dev's type list has a corresponding element in this list.
Each element in the ucontext's list points to its respective
corresponding element in the ib_dev's type list.
In addition, it has a data structure (currently implemented by a list,
but should probably move to using a hash) that maps all ib_uobjects
of the same ib_ucontext and the respective type.

+-------------------------------------------------------------------+
|    ib_device                                                      |
|   +--------------+      +--------------+      +----------------+  |
|   |uobject_type  |      |              |      |                |  |
|   |free_fn       |      |              |      |                |  |
|   |              +----->+              +----->+                |  |
|   |              |      |              |      |                |  |
|   +----^---------+      +--------------+      +----------------+  |
| +------|                                                          |
+-------------------------------------------------------------------+
  |
  |
  |
+-------------------------------------------------------------------+
| |  ib_ucontext                                                    |
| | +--------------+      +--------------+      +----------------+  |
| | |uobject_list  |      |              |      |                |  |
| +-+type          |      |              |      |                |  |
|   |list+         +----->+              +----->+                |  |
|   |    |         |      |              |      |                |  |
|   +--------------+      +--------------+      +----------------+  |
|        |                                                          |
+-------------------------------------------------------------------+
         |
         |
         |
         |
         |  +-----------+        +------------+
         |  | ib_uobject|        |ib_uobject  |
         +-->           +------> |            |
            |           |        |            |
            +-----------+        +------------+

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile    |   3 +-
 drivers/infiniband/core/device.c    |   1 +
 drivers/infiniband/core/rdma_core.c | 102 ++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/rdma_core.h |  69 ++++++++++++++++++++++++
 include/rdma/ib_verbs.h             |   5 ++
 5 files changed, 179 insertions(+), 1 deletion(-)
 create mode 100644 drivers/infiniband/core/rdma_core.c
 create mode 100644 drivers/infiniband/core/rdma_core.h

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index edaae9f..1819623 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -28,4 +28,5 @@ ib_umad-y :=			user_mad.o
 
 ib_ucm-y :=			ucm.o
 
-ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o
+ib_uverbs-y :=			uverbs_main.o uverbs_cmd.o uverbs_marshall.o \
+				rdma_core.o
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index b0135c2..5f09c40 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -243,6 +243,7 @@ struct ib_device *ib_alloc_device(size_t size)
 	spin_lock_init(&device->client_data_lock);
 	INIT_LIST_HEAD(&device->client_data_list);
 	INIT_LIST_HEAD(&device->port_list);
+	INIT_LIST_HEAD(&device->type_list);
 
 	return device;
 }
diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
new file mode 100644
index 0000000..672ce82
--- /dev/null
+++ b/drivers/infiniband/core/rdma_core.c
@@ -0,0 +1,102 @@
+/*
+ * Copyright (c) 2016, Mellanox Technologies inc.  All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#include <rdma/ib_verbs.h>
+#include "uverbs.h"
+#include "rdma_core.h"
+
+/*
+ * lockless - the list shouldn't change. If disassociate is carrie out during
+ * this, we'll wait until all current executing commands are finished.
+ */
+struct uverbs_uobject_type *uverbs_get_type(struct ib_device *ibdev,
+					    uint16_t type)
+{
+	struct uverbs_uobject_type *uobj_type;
+
+	list_for_each_entry(uobj_type, &ibdev->type_list, type_list) {
+		if (uobj_type->obj_type == type)
+			return uobj_type;
+	}
+
+	return NULL;
+}
+
+int ib_uverbs_uobject_type_add(struct list_head	*head,
+			       void (*free)(struct uverbs_uobject_type *uobject_type,
+					    struct ib_uobject *uobject,
+					    struct ib_ucontext *ucontext),
+			       uint16_t	obj_type)
+{
+	/*
+	 * Allocate a new object type for the vendor, this should be done when a
+	 * vendor is initialized.
+	 */
+	struct uverbs_uobject_type *uobject_type;
+
+	uobject_type = kzalloc(sizeof(*uobject_type), GFP_KERNEL);
+	if (!uobject_type)
+		return -ENOMEM;
+
+	uobject_type->free = free;
+	uobject_type->obj_type = obj_type;
+	list_add_tail(&uobject_type->type_list, head);
+	return 0;
+}
+EXPORT_SYMBOL(ib_uverbs_uobject_type_add);
+
+/* Should only be called when device is destroyed (remove_one?) */
+static void ib_uverbs_uobject_type_remove(struct uverbs_uobject_type *uobject_type)
+{
+	/*
+	 * Allocate a new object type for the vendor, this should be done when a
+	 * vendor is initialized.
+	 */
+	WARN_ON(list_empty(&uobject_type->type_list));
+	list_del(&uobject_type->type_list);
+	kfree(uobject_type);
+}
+EXPORT_SYMBOL(ib_uverbs_uobject_type_remove);
+
+/*
+ * Done when device is destroyed. No one should touch the list or use its
+ * elements here.
+ */
+void ib_uverbs_uobject_types_remove(struct ib_device *ib_dev)
+{
+	struct uverbs_uobject_type *iter, *temp;
+
+	list_for_each_entry_safe(iter, temp, &ib_dev->type_list, type_list)
+		ib_uverbs_uobject_type_remove(iter);
+}
+EXPORT_SYMBOL(ib_uverbs_uobject_types_remove);
+
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
new file mode 100644
index 0000000..c734a76
--- /dev/null
+++ b/drivers/infiniband/core/rdma_core.h
@@ -0,0 +1,69 @@
+/*
+ * Copyright (c) 2005 Topspin Communications.  All rights reserved.
+ * Copyright (c) 2005, 2006 Cisco Systems.  All rights reserved.
+ * Copyright (c) 2005-2016 Mellanox Technologies. All rights reserved.
+ * Copyright (c) 2005 Voltaire, Inc. All rights reserved.
+ * Copyright (c) 2005 PathScale, Inc. All rights reserved.
+ *
+ * This software is available to you under a choice of one of two
+ * licenses.  You may choose to be licensed under the terms of the GNU
+ * General Public License (GPL) Version 2, available from the file
+ * COPYING in the main directory of this source tree, or the
+ * OpenIB.org BSD license below:
+ *
+ *     Redistribution and use in source and binary forms, with or
+ *     without modification, are permitted provided that the following
+ *     conditions are met:
+ *
+ *      - Redistributions of source code must retain the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer.
+ *
+ *      - Redistributions in binary form must reproduce the above
+ *        copyright notice, this list of conditions and the following
+ *        disclaimer in the documentation and/or other materials
+ *        provided with the distribution.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
+ * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
+ * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
+ * NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS
+ * BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN
+ * ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN
+ * CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
+ * SOFTWARE.
+ */
+
+#ifndef UOBJECT_H
+#define UOBJECT_H
+
+#include <rdma/ib_verbs.h>
+#include <linux/mutex.h>
+
+struct uverbs_uobject_type *uverbs_get_type(struct ib_device *ibdev,
+					    uint16_t type);
+int ib_uverbs_uobject_type_add(struct list_head	*head,
+			       void (*free)(struct uverbs_uobject_type *uobject_type,
+					    struct ib_uobject *uobject,
+					    struct ib_ucontext *ucontext),
+			       uint16_t	obj_type);
+
+struct uverbs_uobject_type {
+	struct list_head	type_list;
+	void (*free)(struct uverbs_uobject_type *uobject_type,
+		     struct ib_uobject *uobject,
+		     struct ib_ucontext *ucontext);
+	u16			obj_type;
+	size_t			obj_size;
+};
+
+/* embed in ucontext per type */
+struct uverbs_uobject_list {
+	struct uverbs_uobject_type	*type;
+	/* lock of the uobject data type */
+	struct mutex			uobj_lock;
+	struct list_head		list;
+	struct list_head		type_list;
+};
+
+#endif /* UIDR_H */
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 14bfe3b..6d7964f 100644
--- a/include/rdma/ib_verbs.h
+++ b/include/rdma/ib_verbs.h
@@ -1325,6 +1325,8 @@ struct ib_ucontext {
 	struct list_head	rule_list;
 	int			closing;
 
+	struct list_head	uobjects_lists;
+
 	struct pid             *tgid;
 #ifdef CONFIG_INFINIBAND_ON_DEMAND_PAGING
 	struct rb_root      umem_tree;
@@ -1960,6 +1962,9 @@ struct ib_device {
 	 * in fast paths.
 	 */
 	int (*get_port_immutable)(struct ib_device *, u8, struct ib_port_immutable *);
+	struct list_head type_list;
+
+	const struct uverbs_types	*types;
 };
 
 struct ib_client {
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
