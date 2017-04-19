From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH RFC 02/10] IB/core: Add support to finalize objects in one transaction
Date: Wed, 19 Apr 2017 18:20:17 +0300
Message-ID: <1492615225-55118-3-git-send-email-matanb@mellanox.com>
References: <1492615225-55118-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1492615225-55118-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The new ioctl based infrastructure either commits or rollbacks
all objects of the command as one transaction. In order to do
that, we introduce a notion of dealing with a collection of
objects that are related to a specific action.

This also requires adding a notion of an action and attribute.
An action contains a groups of attributes, where each group
contains several attributes.

When declaring these actions and attributes, we actually declare
their specifications. When a command is executed, we actually
allocates some space to hold auxiliary information.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/rdma_core.c | 43 ++++++++++++++++++++++
 drivers/infiniband/core/rdma_core.h | 20 ++++++++++-
 include/rdma/uverbs_ioctl.h         | 72 +++++++++++++++++++++++++++++++++++++
 3 files changed, 134 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/rdma_core.c b/drivers/infiniband/core/rdma_core.c
index 269fa7f..78ffd8c 100644
--- a/drivers/infiniband/core/rdma_core.c
+++ b/drivers/infiniband/core/rdma_core.c
@@ -676,3 +676,46 @@ int uverbs_finalize_object(struct ib_uobject *uobj,
 
 	return ret;
 }
+
+int uverbs_finalize_objects(struct uverbs_attr_array *attr_array,
+			    size_t num,
+			    const struct uverbs_action *action,
+			    bool commit)
+{
+	unsigned int i;
+	int ret = 0;
+
+	for (i = 0; i < num; i++) {
+		struct uverbs_attr_array *attr_spec_array = &attr_array[i];
+		const struct uverbs_attr_spec_group *attr_spec_group =
+			action->attr_groups[i];
+		unsigned int j;
+
+		for (j = 0; j < attr_spec_array->num_attrs; j++) {
+			struct uverbs_attr *attr = &attr_spec_array->attrs[j];
+			struct uverbs_attr_spec *spec = &attr_spec_group->attrs[j];
+
+			if (!uverbs_is_valid(attr_spec_array, j))
+				continue;
+
+			if (spec->type == UVERBS_ATTR_TYPE_IDR ||
+			    spec->type == UVERBS_ATTR_TYPE_FD) {
+				int current_ret;
+
+				/*
+				 * refcounts should be handled at the object
+				 * level and not at the uobject level. Refcounts
+				 * of the objects themselves are done in
+				 * handlers.
+				 */
+				current_ret = uverbs_finalize_object(attr->obj_attr.uobject,
+								     spec->obj.access,
+								     commit);
+				if (!ret)
+					ret = current_ret;
+			}
+		}
+	}
+	return ret;
+}
+
diff --git a/drivers/infiniband/core/rdma_core.h b/drivers/infiniband/core/rdma_core.h
index 5a1da24..0aebc47 100644
--- a/drivers/infiniband/core/rdma_core.h
+++ b/drivers/infiniband/core/rdma_core.h
@@ -81,7 +81,7 @@
  * the object is from the given type. Lock it to the required access.
  * This function could create (access == NEW) or destroy (access == DESTROY)
  * objects if required. The action will be finalized only when
- * uverbs_finalize_object is called.
+ * uverbs_finalize_object or uverbs_finalize_objects is called.
  */
 struct ib_uobject *uverbs_get_uobject_from_context(const struct uverbs_obj_type *type_attrs,
 						   struct ib_ucontext *ucontext,
@@ -90,5 +90,23 @@ struct ib_uobject *uverbs_get_uobject_from_context(const struct uverbs_obj_type
 int uverbs_finalize_object(struct ib_uobject *uobj,
 			   enum uverbs_idr_access access,
 			   bool commit);
+/*
+ * Note that certain finalize stages could return a status:
+ *   (a) alloc_commit could return a failure if the object is committed at the
+ *       same time when the context is destroyed.
+ *   (b) remove_commit could fail if the object wasn't destroyed successfully.
+ * Since multiple objects could be finalized in one transaction, it is very NOT
+ * recommended to have several finalize actions which have side affects.
+ * For example, it's NOT recommended to have a certain action which has both
+ * a commit action and a destroy action or two destroy objects in the same
+ * action. The rule of thumb is to have one destroy or commit action with
+ * multiple lookups.
+ * The first non zero return value of finalize_object is returned from this
+ * function.
+ */
+int uverbs_finalize_objects(struct uverbs_attr_array *attr_array,
+			    size_t num,
+			    const struct uverbs_action *action,
+			    bool success);
 
 #endif /* RDMA_CORE_H */
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index a18468e..1f84f30 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -41,6 +41,12 @@
  * =======================================
  */
 
+enum uverbs_attr_type {
+	UVERBS_ATTR_TYPE_NA,
+	UVERBS_ATTR_TYPE_IDR,
+	UVERBS_ATTR_TYPE_FD,
+};
+
 enum uverbs_idr_access {
 	UVERBS_ACCESS_READ,
 	UVERBS_ACCESS_WRITE,
@@ -48,5 +54,71 @@ enum uverbs_idr_access {
 	UVERBS_ACCESS_DESTROY
 };
 
+struct uverbs_attr_spec {
+	enum uverbs_attr_type		type;
+	union {
+		u16				len;
+		struct {
+			u16			obj_type;
+			u8			access;
+		} obj;
+	};
+};
+
+struct uverbs_attr_spec_group {
+	struct uverbs_attr_spec		*attrs;
+	size_t				num_attrs;
+};
+
+struct uverbs_action {
+	const struct uverbs_attr_spec_group		**attr_groups;
+	size_t						num_groups;
+};
+
+/* =================================================
+ *              Parsing infrastructure
+ * =================================================
+ */
+
+struct uverbs_fd_attr {
+	int		fd;
+};
+
+struct uverbs_uobj_attr {
+	/*  idr handle */
+	u32	idr;
+};
+
+struct uverbs_obj_attr {
+	/* pointer to the kernel descriptor -> type, access, etc */
+	struct ib_uverbs_attr __user	*uattr;
+	const struct uverbs_type_alloc_action	*type;
+	struct ib_uobject		*uobject;
+	union {
+		struct uverbs_fd_attr		fd;
+		struct uverbs_uobj_attr		uobj;
+	};
+};
+
+struct uverbs_attr {
+	union {
+		struct uverbs_obj_attr	obj_attr;
+	};
+};
+
+/* output of one validator */
+struct uverbs_attr_array {
+	unsigned long *valid_bitmap;
+	size_t num_attrs;
+	/* arrays of attrubytes, index is the id i.e SEND_CQ */
+	struct uverbs_attr *attrs;
+};
+
+static inline bool uverbs_is_valid(const struct uverbs_attr_array *attr_array,
+				   unsigned int idx)
+{
+	return test_bit(idx, attr_array->valid_bitmap);
+}
+
 #endif
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
