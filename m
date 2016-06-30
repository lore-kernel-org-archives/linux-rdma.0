From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V1 4/8] RDMA/core: Add support for custom types
Date: Thu, 30 Jun 2016 16:39:27 +0300
Message-ID: <1467293971-25688-5-git-send-email-matanb@mellanox.com>
References: <1467293971-25688-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1467293971-25688-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

The new ioctl infrastructure supports driver specific types.
This is implemented by having a list of uverbs_uobject_type in the
ib_device. Each element of this list corresponds to a specific type
and specifies its free function, driver's type_id, etc.
The order of elements dictates the order of process release.
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
 drivers/infiniband/core/uobject.c | 83 +++++++++++++++++++++++++++++++++++++++
 drivers/infiniband/core/uobject.h | 16 ++++++++
 include/rdma/ib_verbs.h           |  8 ++++
 3 files changed, 107 insertions(+)

diff --git a/drivers/infiniband/core/uobject.c b/drivers/infiniband/core/uobject.c
index 86f6460..bc15be1 100644
--- a/drivers/infiniband/core/uobject.c
+++ b/drivers/infiniband/core/uobject.c
@@ -35,6 +35,89 @@
 #include "uobject.h"
 #include "uidr.h"
 
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
+
+void ib_uverbs_uobject_type_remove(struct uverbs_uobject_type *uobject_type)
+{
+	/*
+	 * Allocate a new object type for the vendor, this should be done when a
+	 * vendor is initialized.
+	 */
+	WARN_ON(list_empty(&uobject_type->type_list));
+	list_del(&uobject_type->type_list);
+	kfree(uobject_type);
+}
+
+void ib_uverbs_uobject_type_cleanup_ucontext(struct ib_ucontext *ucontext)
+{
+	struct uverbs_uobject_list *uobject_list, *next_list;
+
+	list_for_each_entry_safe(uobject_list, next_list,
+				 &ucontext->uobjects_lists, type_list) {
+		struct uverbs_uobject_type *type = uobject_list->type;
+		struct ib_uobject *obj, *next_obj;
+
+		list_for_each_entry_safe(obj, next_obj, &uobject_list->list,
+					 idr_list) {
+			/* TODO */
+			type->free(type, obj, ucontext);
+			list_del(&obj->idr_list);
+		}
+
+		list_del(&uobject_list->type_list);
+	}
+}
+
+int ib_uverbs_uobject_type_initialize_ucontext(struct ib_ucontext *ucontext,
+					       struct list_head *type_list)
+{
+	/* create typed list in ucontext */
+	struct uverbs_uobject_type *type;
+	int err;
+
+	INIT_LIST_HEAD(&ucontext->uobjects_lists);
+
+	list_for_each_entry(type, type_list, type_list) {
+		struct uverbs_uobject_list *cur;
+
+		cur = kzalloc(sizeof(*cur), GFP_KERNEL);
+		if (!cur) {
+			err = -ENOMEM;
+			goto err;
+		}
+
+		cur->type = type;
+		INIT_LIST_HEAD(&cur->list);
+		list_add_tail(&cur->type_list, &ucontext->uobjects_lists);
+	}
+
+	return 0;
+
+err:
+	ib_uverbs_uobject_type_cleanup_ucontext(ucontext);
+	return err;
+}
+
 /*
  * The ib_uobject locking scheme is as follows:
  *
diff --git a/drivers/infiniband/core/uobject.h b/drivers/infiniband/core/uobject.h
index 2958ef7..40f6ff1 100644
--- a/drivers/infiniband/core/uobject.h
+++ b/drivers/infiniband/core/uobject.h
@@ -42,6 +42,22 @@ struct uverbs_lock_class {
 	char			name[16];
 };
 
+struct uverbs_uobject_type {
+	struct list_head	type_list;
+	void (*free)(struct uverbs_uobject_type *uobject_type,
+		     struct ib_uobject *uobject,
+		     struct ib_ucontext *ucontext);
+	u16			obj_type;
+	struct uverbs_lock_class lock_class;
+};
+
+/* embed in ucontext per type */
+struct uverbs_uobject_list {
+	struct uverbs_uobject_type	*type;
+	struct list_head		list;
+	struct list_head		type_list;
+};
+
 void init_uobj(struct ib_uobject *uobj, u64 user_handle,
 	       struct ib_ucontext *context, struct uverbs_lock_class *c);
 
diff --git a/include/rdma/ib_verbs.h b/include/rdma/ib_verbs.h
index 14bfe3b..c18155f 100644
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
@@ -1354,6 +1356,9 @@ struct ib_uobject {
 	struct rw_semaphore	mutex;		/* protects .live */
 	struct rcu_head		rcu;		/* kfree_rcu() overhead */
 	int			live;
+	/* List of object under uverbs_object_type */
+	struct list_head	idr_list;
+	struct uverbs_uobject_list *type;	/* ptr to ucontext type */
 };
 
 struct ib_udata {
@@ -1960,6 +1965,9 @@ struct ib_device {
 	 * in fast paths.
 	 */
 	int (*get_port_immutable)(struct ib_device *, u8, struct ib_port_immutable *);
+	struct list_head type_list;
+
+	const struct uverbs_types	*types;
 };
 
 struct ib_client {
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
