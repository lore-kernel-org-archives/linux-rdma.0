From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 07/13] IB/core: Add macros for declaring actions and attributes
Date: Wed,  7 Jun 2017 15:22:46 +0300
Message-ID: <1496838172-39671-8-git-send-email-matanb@mellanox.com>
References: <1496838172-39671-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1496838172-39671-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This patch adds macros for declaring action groups, actions,
attribute groups and attributes. These definitions are later
used by downstream patches to declare some of the common types.

In addition, we add some helper inline functions to copy_{from,to}
user-space buffers and check if an attribute is valid.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/uverbs_ioctl.h | 113 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 112 insertions(+), 1 deletion(-)

diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index ca636a2..4a03659 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -34,6 +34,11 @@
 #define _UVERBS_IOCTL_
 
 #include <rdma/uverbs_types.h>
+#include <linux/uaccess.h>
+#include <rdma/rdma_user_ioctl.h>
+
+struct uverbs_object_type;
+struct uverbs_uobject_type;
 
 /*
  * =======================================
@@ -131,9 +136,75 @@ struct uverbs_spec_root {
 	size_t					num_groups;
 };
 
-#define DECLARE_UVERBS_TYPE(name, _type_attrs)			\
+#define UA_FLAGS(_flags)  .flags = _flags
+#define UVERBS_ATTR(_id, _len, _type, ...)				\
+	[_id] = {.len = _len, .type = _type, ##__VA_ARGS__}
+#define UVERBS_ATTR_PTR_IN_SZ(_id, _len, ...)				\
+	UVERBS_ATTR(_id, _len, UVERBS_ATTR_TYPE_PTR_IN, ##__VA_ARGS__)
+/* If sizeof(_type) <= sizeof(u64), this will be inlined rather than a pointer */
+#define UVERBS_ATTR_PTR_IN(_id, _type, ...)				\
+	UVERBS_ATTR_PTR_IN_SZ(_id, sizeof(_type), ##__VA_ARGS__)
+#define UVERBS_ATTR_PTR_OUT_SZ(_id, _len, ...)				\
+	UVERBS_ATTR(_id, _len, UVERBS_ATTR_TYPE_PTR_OUT, ##__VA_ARGS__)
+#define UVERBS_ATTR_PTR_OUT(_id, _type, ...)				\
+	UVERBS_ATTR_PTR_OUT_SZ(_id, sizeof(_type), ##__VA_ARGS__)
+#define UVERBS_ATTR_IDR(_id, _idr_type, _access, ...)			\
+	[_id] = {.type = UVERBS_ATTR_TYPE_IDR,				\
+		 .obj = {.obj_type = _idr_type,				\
+			 .access = _access				\
+		 }, ##__VA_ARGS__ }
+#define UVERBS_ATTR_FD(_id, _fd_type, _access, ...)			\
+	[_id] = {.type = UVERBS_ATTR_TYPE_FD,				\
+		 .obj = {.obj_type = _fd_type,				\
+			 .access = (_access) + BUILD_BUG_ON_ZERO(	\
+				(_access) != UVERBS_ACCESS_NEW &&	\
+				(_access) != UVERBS_ACCESS_READ)	\
+		 }, ##__VA_ARGS__ }
+#define _UVERBS_ATTR_SPEC_SZ(...)					\
+	(sizeof((struct uverbs_attr_spec[]){__VA_ARGS__}) /	\
+	 sizeof(struct uverbs_attr_spec))
+#define UVERBS_ATTR_SPEC(...)					\
+	((struct uverbs_attr_spec_group)				\
+	 {.attrs = (struct uverbs_attr_spec[]){__VA_ARGS__},		\
+	  .num_attrs = _UVERBS_ATTR_SPEC_SZ(__VA_ARGS__),		\
+	 .mandatory_attrs_bitmask =					\
+		((unsigned long[BITS_TO_LONGS(_UVERBS_ATTR_SPEC_SZ(__VA_ARGS__))]) {})})
+#define DECLARE_UVERBS_ATTR_SPEC(name, ...)			\
+	struct uverbs_attr_spec_group name =			\
+		UVERBS_ATTR_SPEC(__VA_ARGS__)
+#define _UVERBS_ATTR_ACTION_SPEC_SZ(...)				  \
+	(sizeof((struct uverbs_attr_spec_group *[]){__VA_ARGS__}) /	  \
+	 sizeof(struct uverbs_attr_spec_group *))
+#define _UVERBS_ACTION(_handler, _flags, ...)				       \
+	((struct uverbs_action) {					       \
+		.flags = _flags,					       \
+		.handler = _handler,					       \
+		.num_groups =	_UVERBS_ATTR_ACTION_SPEC_SZ(__VA_ARGS__),      \
+		.attr_groups = (struct uverbs_attr_spec_group *[]){__VA_ARGS__} })
+#define UVERBS_ACTION(_handler, ...)			\
+	_UVERBS_ACTION(_handler, 0, __VA_ARGS__)
+#define UVERBS_CTX_ACTION(_handler, ...)			\
+	_UVERBS_ACTION(_handler, UVERBS_ACTION_FLAG_CREATE_ROOT, __VA_ARGS__)
+#define _UVERBS_ACTIONS_SZ(...)					\
+	(sizeof((struct uverbs_action *[]){__VA_ARGS__}) /	\
+	 sizeof(struct uverbs_action *))
+#define ADD_UVERBS_ACTION(action_idx, _handler,  ...)		\
+	[action_idx] = &UVERBS_ACTION(_handler, __VA_ARGS__)
+#define ADD_UVERBS_CTX_ACTION(action_idx, _handler,  ...)	\
+	[action_idx] = &UVERBS_CTX_ACTION(_handler, __VA_ARGS__)
+#define UVERBS_ACTIONS(...)						\
+	((const struct uverbs_action_group)			\
+	  {.num_actions = _UVERBS_ACTIONS_SZ(__VA_ARGS__),		\
+	   .actions = (struct uverbs_action *[]){__VA_ARGS__} })
+#define _UVERBS_ACTIONS_GROUP_SZ(...)					\
+	(sizeof((const struct uverbs_action_group*[]){__VA_ARGS__}) / \
+	 sizeof(const struct uverbs_action_group *))
+
+#define DECLARE_UVERBS_TYPE(name, _type_attrs, ...)			\
 	const struct uverbs_type name = {				\
 		.type_attrs = _type_attrs,				\
+		.num_groups = _UVERBS_ACTIONS_GROUP_SZ(__VA_ARGS__),	\
+		.action_groups = (const struct uverbs_action_group *[]){__VA_ARGS__} \
 	}
 #define _UVERBS_TYPE_SZ(...)						\
 	(sizeof((const struct uverbs_type *[]){__VA_ARGS__}) /	\
@@ -146,6 +217,17 @@ struct uverbs_spec_root {
 #define DECLARE_UVERBS_TYPES(name, ...)				\
 	const struct uverbs_type_group name = UVERBS_TYPES(__VA_ARGS__)
 
+#define _UVERBS_TYPES_SZ(...)						\
+	(sizeof((const struct uverbs_type_group *[]){__VA_ARGS__}) /	\
+	 sizeof(const struct uverbs_type_group *))
+
+#define UVERBS_TYPES_GROUP(...)						\
+	((const struct uverbs_spec_root){				\
+		.type_groups = (const struct uverbs_type_group *[]){__VA_ARGS__},\
+		.num_groups = _UVERBS_TYPES_SZ(__VA_ARGS__)})
+#define DECLARE_UVERBS_TYPES_GROUP(name, ...)		\
+	const struct uverbs_spec_root name = UVERBS_TYPES_GROUP(__VA_ARGS__)
+
 /* =================================================
  *              Parsing infrastructure
  * =================================================
@@ -193,5 +275,34 @@ static inline bool uverbs_is_valid(const struct uverbs_attr_array *attr_array,
 	return test_bit(idx, attr_array->valid_bitmap);
 }
 
+static inline int uverbs_copy_to(struct uverbs_attr_array *attr_array,
+				 size_t idx, const void *from)
+{
+	if (!uverbs_is_valid(attr_array, idx))
+		return -ENOENT;
+
+	return copy_to_user(attr_array->attrs[idx].ptr_attr.ptr, from,
+			    attr_array->attrs[idx].ptr_attr.len) ? -EFAULT : 0;
+}
+
+#define uverbs_copy_from(to, attr_array, idx)				\
+	(uverbs_is_valid((attr_array), idx) ?				\
+	 (sizeof(*(to)) <= sizeof(((struct ib_uverbs_attr *)0)->data) ? \
+	  (memcpy((to), &(attr_array)->attrs[idx].ptr_attr.ptr,		\
+		 (attr_array)->attrs[idx].ptr_attr.len), 0) :		\
+	  (copy_from_user((to), (attr_array)->attrs[idx].ptr_attr.ptr,	\
+			 (attr_array)->attrs[idx].ptr_attr.len) ?	\
+	   -EFAULT : 0)) : -ENOENT)
+#define uverbs_get_attr(to, attr_array, idx)				\
+	(uverbs_is_valid((attr_array), idx) ?				\
+	 (sizeof(to) <= sizeof(((struct ib_uverbs_attr *)0)->data) ? \
+	  (sizeof(to) == sizeof((&(to))[0]) ?				\
+	   ((to) = *(typeof(to) *)&(attr_array)->attrs[idx].ptr_attr.ptr, 0) :\
+	   (memcpy(&(to), &(attr_array)->attrs[idx].ptr_attr.ptr,	\
+		 (attr_array)->attrs[idx].ptr_attr.len), 0)) :		\
+	  (copy_from_user(&(to), (attr_array)->attrs[idx].ptr_attr.ptr,	\
+			 (attr_array)->attrs[idx].ptr_attr.len) ?	\
+	   -EFAULT : 0)) : -ENOENT)
+
 #endif
 
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
