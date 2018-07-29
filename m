From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 22/27] IB/uverbs: Add IDRs array attribute type to ioctl() interface
Date: Sun, 29 Jul 2018 15:59:00 +0300
Message-ID: <20180729125905.31989-23-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Guy Levi <guyle@mellanox.com>

Methods sometimes need to get a flexible set of idrs and not a strict
set as can be achieved today by the conventional idr attribute. This is
an idrs-array-like behavior.
Since this may be popular used, we add a new IDRS_ARRAY attribute to the
generic uverbs ioctl layer.

This attribute is embedded in methods, like any other attributes we
currently have. IDRS_ARRAY points to array of idrs of the same object
type and same access rights (only write and read are supported). It
is defined with minimum and maximum length to be enforced and can be
defined as mandatory attribute.

Signed-off-by: Guy Levi <guyle@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_ioctl.c   | 94 +++++++++++++++++++++++++++++++-
 include/rdma/uverbs_ioctl.h              | 68 ++++++++++++++++++++++-
 include/uapi/rdma/rdma_user_ioctl_cmds.h |  2 +-
 3 files changed, 160 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index 3ad3b69e32ab..ce40f97dbbf2 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -46,6 +46,79 @@ static bool uverbs_is_attr_cleared(const struct ib_uverbs_attr *uattr,
 			   0, uattr->len - len);
 }
 
+static int uverbs_process_idrs_arr_attr(struct ib_uverbs_file *ufile,
+					struct uverbs_objs_arr_attr *attr,
+					const struct ib_uverbs_attr *uattr,
+					const struct uverbs_attr_spec *spec)
+{
+	const struct uverbs_object_spec *object;
+	int err;
+	int i = 0; /* Initialization for error flow */
+
+	if (!ufile->ucontext || uattr->attr_data.reserved)
+		return -EINVAL;
+
+	if (uattr->len % sizeof(u32))
+		return -EINVAL;
+
+	attr->len = uattr->len / sizeof(u32);
+
+	if (attr->len < spec->u2.objs_arr.min_len ||
+	    attr->len > spec->u2.objs_arr.max_len)
+		return -EINVAL;
+
+	attr->uobjects = kvmalloc_array(attr->len, sizeof(*attr->uobjects),
+					GFP_KERNEL);
+	if (!attr->uobjects)
+		return -ENOMEM;
+
+	/* Since idr is 4B and *uobjects is >= 4B, we can use
+	 * attr->uobjects to store idrs array and avoid additional memory
+	 * allocation. The idrs array is offset to the end of the uobjects
+	 * array so we will be able to read a 4B idr and replace with a
+	 * 8B pointer.
+	 */
+	if (uattr->len > sizeof(uattr->data)) {
+		err = copy_from_user((u8 *)attr->uobjects + uattr->len,
+				     u64_to_user_ptr(uattr->data),
+				     uattr->len);
+		if (err) {
+			err = -EFAULT;
+			goto err_objs_arr;
+		}
+	} else {
+		memcpy((u8 *)attr->uobjects + uattr->len, &uattr->data,
+		       uattr->len);
+	}
+
+	object = uverbs_get_object(ufile, spec->u2.objs_arr.obj_type);
+	if (!object) {
+		err = -EINVAL;
+		goto err_objs_arr;
+	}
+
+	for (i = 0; i < attr->len; i++) {
+		attr->uobjects[i] =
+			uverbs_get_uobject_from_file(object->type_attrs, ufile,
+						     spec->u2.objs_arr.access,
+						     ((u32 *)attr->uobjects)[attr->len + i]);
+		if (IS_ERR(attr->uobjects[i])) {
+			err = PTR_ERR(attr->uobjects[i]);
+			goto err_objs_arr;
+		}
+	}
+
+	return 0;
+
+err_objs_arr:
+	while (i > 0)
+		uverbs_finalize_object(attr->uobjects[--i],
+				       spec->u2.objs_arr.access, false);
+
+	kvfree(attr->uobjects);
+	return err;
+}
+
 static int uverbs_process_attr(struct ib_uverbs_file *ufile,
 			       const struct ib_uverbs_attr *uattr,
 			       u16 attr_id,
@@ -59,6 +132,7 @@ static int uverbs_process_attr(struct ib_uverbs_file *ufile,
 	const struct uverbs_object_spec *object;
 	struct uverbs_obj_attr *o_attr;
 	struct uverbs_attr *elements = attr_bundle_h->attrs;
+	int err;
 
 	if (attr_id >= attr_spec_bucket->num_attrs) {
 		if (uattr->flags & UVERBS_ATTR_F_MANDATORY)
@@ -176,6 +250,14 @@ static int uverbs_process_attr(struct ib_uverbs_file *ufile,
 		}
 
 		break;
+
+	case UVERBS_ATTR_TYPE_IDRS_ARRAY:
+		err = uverbs_process_idrs_arr_attr(ufile, &e->objs_arr_attr,
+						   uattr, spec);
+		if (err)
+			return err;
+
+		break;
 	default:
 		return -EOPNOTSUPP;
 	}
@@ -204,6 +286,7 @@ static int uverbs_finalize_attrs(struct uverbs_attr_bundle *attrs_bundle,
 		for (j = 0; j < curr_bundle->num_attrs; j++) {
 			struct uverbs_attr *attr;
 			const struct uverbs_attr_spec *spec;
+			int current_ret;
 
 			if (!uverbs_attr_is_valid_in_hash(curr_bundle, j))
 				continue;
@@ -213,8 +296,6 @@ static int uverbs_finalize_attrs(struct uverbs_attr_bundle *attrs_bundle,
 
 			if (spec->type == UVERBS_ATTR_TYPE_IDR ||
 			    spec->type == UVERBS_ATTR_TYPE_FD) {
-				int current_ret;
-
 				current_ret = uverbs_finalize_object(
 					attr->obj_attr.uobject,
 					spec->u.obj.access, commit);
@@ -224,6 +305,15 @@ static int uverbs_finalize_attrs(struct uverbs_attr_bundle *attrs_bundle,
 				   spec->alloc_and_copy &&
 				   !uverbs_attr_ptr_is_inline(attr)) {
 				kvfree(attr->ptr_attr.ptr);
+			} else if (spec->type == UVERBS_ATTR_TYPE_IDRS_ARRAY) {
+				for (i = 0; i < attr->objs_arr_attr.len; i++) {
+					current_ret =
+						uverbs_finalize_object(attr->objs_arr_attr.uobjects[i],
+								       spec->u2.objs_arr.access, commit);
+					if (!ret)
+						ret = current_ret;
+				}
+				kvfree(attr->objs_arr_attr.uobjects);
 			}
 		}
 	}
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index f703c8ebbb02..6ab75235940b 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -52,6 +52,7 @@ enum uverbs_attr_type {
 	UVERBS_ATTR_TYPE_IDR,
 	UVERBS_ATTR_TYPE_FD,
 	UVERBS_ATTR_TYPE_ENUM_IN,
+	UVERBS_ATTR_TYPE_IDRS_ARRAY,
 };
 
 enum uverbs_obj_access {
@@ -101,7 +102,7 @@ struct uverbs_attr_spec {
 		} enum_def;
 	} u;
 
-	/* This weird split of the enum lets us remove some padding */
+	/* This weird split lets us remove some padding */
 	union {
 		struct {
 			/*
@@ -111,6 +112,17 @@ struct uverbs_attr_spec {
 			 */
 			const struct uverbs_attr_spec *ids;
 		} enum_def;
+
+		struct {
+			/*
+			 * higher bits mean the namespace and lower bits mean
+			 * the type id within the namespace.
+			 */
+			u16				obj_type;
+			u16				min_len;
+			u16				max_len;
+			u8				access;
+		} objs_arr;
 	} u2;
 };
 
@@ -226,6 +238,27 @@ struct uverbs_object_tree_def {
 #define UA_MANDATORY .mandatory = 1
 #define UA_OPTIONAL .mandatory = 0
 
+/* min_len must be bigger than 0 and _max_len must be smaller than 4095.
+ * Only READ\WRITE accesses are supported.
+ */
+#define UVERBS_ATTR_IDRS_ARR(_attr_id, _idr_type, _access, _min_len, _max_len, \
+			     ...)                                              \
+	(&(const struct uverbs_attr_def){                                      \
+		.id = (_attr_id) +                                             \
+		      BUILD_BUG_ON_ZERO((_min_len) == 0 ||                     \
+					(_max_len) > 4095 ||                   \
+					(_min_len) > (_max_len) ||             \
+					(_access) == UVERBS_ACCESS_NEW ||      \
+					(_access) == UVERBS_ACCESS_DESTROY),   \
+		.attr = {                                                      \
+			.type = UVERBS_ATTR_TYPE_IDRS_ARRAY,                   \
+			.u2.objs_arr.obj_type = _idr_type,                     \
+			.u2.objs_arr.access = _access,                         \
+			.u2.objs_arr.min_len = _min_len,                       \
+			.u2.objs_arr.max_len = _max_len,                       \
+			__VA_ARGS__                                            \
+		} })
+
 #define UVERBS_ATTR_IDR(_attr_id, _idr_type, _access, ...)                     \
 	(&(const struct uverbs_attr_def){                                      \
 		.id = _attr_id,                                                \
@@ -341,6 +374,11 @@ struct uverbs_obj_attr {
 	struct ib_uobject		*uobject;
 };
 
+struct uverbs_objs_arr_attr {
+	struct ib_uobject	**uobjects;
+	u16			len;
+};
+
 struct uverbs_attr {
 	/*
 	 * pointer to the user-space given attribute, in order to write the
@@ -350,6 +388,7 @@ struct uverbs_attr {
 	union {
 		struct uverbs_ptr_attr	ptr_attr;
 		struct uverbs_obj_attr	obj_attr;
+		struct uverbs_objs_arr_attr	objs_arr_attr;
 	};
 };
 
@@ -445,6 +484,33 @@ uverbs_attr_get_len(const struct uverbs_attr_bundle *attrs_bundle, u16 idx)
 	return attr->ptr_attr.len;
 }
 
+/*
+ * uverbs_attr_get_uobjs_arr - Provides array's properties for attribute for
+ * UVERBS_ATTR_TYPE_IDRS_ARRAY.
+ * @***arr: Returned pointer to array of pointers for uobjects or NULL if
+ * attribute isn't provided.
+ *
+ * Returns:
+ * If attribute isn't provided - return 0. Otherwise, return the array
+ * length.
+ */
+static inline int uverbs_attr_get_uobjs_arr(const struct uverbs_attr_bundle *attrs_bundle,
+					    u16 attr_idx,
+					    struct ib_uobject ***arr)
+{
+	const struct uverbs_attr *attr =
+			uverbs_attr_get(attrs_bundle, attr_idx);
+
+	if (IS_ERR(attr)) {
+		*arr = NULL;
+		return 0;
+	}
+
+	*arr = attr->objs_arr_attr.uobjects;
+
+	return attr->objs_arr_attr.len;
+}
+
 static inline int uverbs_copy_to(const struct uverbs_attr_bundle *attrs_bundle,
 				 size_t idx, const void *from, size_t size)
 {
diff --git a/include/uapi/rdma/rdma_user_ioctl_cmds.h b/include/uapi/rdma/rdma_user_ioctl_cmds.h
index 24800c6c1f32..95762b04a72d 100644
--- a/include/uapi/rdma/rdma_user_ioctl_cmds.h
+++ b/include/uapi/rdma/rdma_user_ioctl_cmds.h
@@ -53,7 +53,7 @@ enum {
 
 struct ib_uverbs_attr {
 	__u16 attr_id;		/* command specific type attribute */
-	__u16 len;		/* only for pointers */
+	__u16 len;		/* only for pointers and IDRs array */
 	__u16 flags;		/* combination of UVERBS_ATTR_F_XXXX */
 	union {
 		struct {
-- 
2.14.4
