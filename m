From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [RFC ABI V6 04/14] IB/core: Add macros for declaring types and type groups.
Date: Sun, 11 Dec 2016 14:57:58 +0200
Message-ID: <1481461088-56355-5-git-send-email-matanb@mellanox.com>
References: <1481461088-56355-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1481461088-56355-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Christoph Lameter <cl-vYTEC60ixJUAvxtiuMwx3w@public.gmane.org>, Liran Liss <liranl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Tal Alon <talal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In order to initialize and destroy types in a generic way, we need to
provide information about the allocation size, release function and
order. This is done through a macro based DSL (domain specific
language). This patch adds macros to initialize a type and a type
group.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/rdma/uverbs_ioctl.h | 50 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 50 insertions(+)

diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 382321b..54f592a 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -147,6 +147,56 @@ struct uverbs_root {
 	size_t					num_groups;
 };
 
+#define _UVERBS_ACTIONS_GROUP_SZ(...)					\
+	(sizeof((const struct uverbs_action_group*[]){__VA_ARGS__}) / \
+	 sizeof(const struct uverbs_action_group *))
+#define UVERBS_TYPE_ALLOC_FD(_order, _obj_size, _free_fn, _fops, _name, _flags)\
+	((const struct uverbs_type_alloc_action)			\
+	 {.type = UVERBS_ATTR_TYPE_FD,					\
+	 .order = _order,						\
+	 .obj_size = _obj_size,						\
+	 .free_fn = _free_fn,						\
+	 .fd = {.fops = _fops,						\
+		.name = _name,						\
+		.flags = _flags} })
+#define UVERBS_TYPE_ALLOC_IDR_SZ(_size, _order, _free_fn)		\
+	((const struct uverbs_type_alloc_action)			\
+	 {.type = UVERBS_ATTR_TYPE_IDR,					\
+	 .order = _order,						\
+	 .free_fn = _free_fn,						\
+	 .obj_size = _size,})
+#define UVERBS_TYPE_ALLOC_IDR(_order, _free_fn)				\
+	 UVERBS_TYPE_ALLOC_IDR_SZ(sizeof(struct ib_uobject), _order, _free_fn)
+#define DECLARE_UVERBS_TYPE(name, _alloc, ...)				\
+	const struct uverbs_type name = {				\
+		.alloc = _alloc,					\
+		.num_groups = _UVERBS_ACTIONS_GROUP_SZ(__VA_ARGS__),	\
+		.action_groups = (const struct uverbs_action_group *[]){__VA_ARGS__} \
+	}
+#define _UVERBS_TYPE_SZ(...)						\
+	(sizeof((const struct uverbs_type *[]){__VA_ARGS__}) /	\
+	 sizeof(const struct uverbs_type *))
+#define ADD_UVERBS_TYPE_ACTIONS(type_idx, ...)				\
+	[type_idx] = &UVERBS_ACTIONS(__VA_ARGS__)
+#define ADD_UVERBS_TYPE(type_idx, type_ptr)				\
+	[type_idx] = ((const struct uverbs_type * const)&type_ptr)
+#define UVERBS_TYPES(...)  ((const struct uverbs_type_group)			\
+	{.num_types = _UVERBS_TYPE_SZ(__VA_ARGS__),			\
+	 .types = (const struct uverbs_type *[]){__VA_ARGS__} })
+#define DECLARE_UVERBS_TYPES(name, ...)				\
+	const struct uverbs_type_group name = UVERBS_TYPES(__VA_ARGS__)
+
+#define _UVERBS_TYPES_SZ(...)						\
+	(sizeof((const struct uverbs_type_group *[]){__VA_ARGS__}) /	\
+	 sizeof(const struct uverbs_type_group *))
+
+#define UVERBS_TYPES_GROUP(...)						\
+	((const struct uverbs_root){				\
+		.type_groups = (const struct uverbs_type_group *[]){__VA_ARGS__},\
+		.num_groups = _UVERBS_TYPES_SZ(__VA_ARGS__)})
+#define DECLARE_UVERBS_TYPES_GROUP(name, ...)		\
+	const struct uverbs_root name = UVERBS_TYPES_GROUP(__VA_ARGS__)
+
 /* =================================================
  *              Parsing infrastructure
  * =================================================
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
