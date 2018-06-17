From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 06/20] IB/uverbs: Add PTR_IN attributes that are allocated/copied automatically
Date: Sun, 17 Jun 2018 12:59:52 +0300
Message-ID: <20180617100006.30663-7-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb@mellanox.com>

Adding UVERBS_ATTR_SPEC_F_ALLOC_AND_COPY flag to PTR_IN attributes.
By using this flag, the parse automatically allocates and copies the
user-space data. This data is accessible by using uverbs_attr_get_len
and uverbs_attr_get_alloced_ptr inline accessor functions from the
handler.

Signed-off-by: Matan Barak <matanb@mellanox.com>
Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_ioctl.c | 25 ++++++++++++++++++++++++-
 include/rdma/uverbs_ioctl.h            | 25 +++++++++++++++++++++++++
 2 files changed, 49 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index 8cc3e8dad9b5..ee15c9ca788b 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -114,7 +114,26 @@ static int uverbs_process_attr(struct ib_device *ibdev,
 		    uattr->attr_data.reserved)
 			return -EINVAL;
 
-		e->ptr_attr.data = uattr->data;
+		if (val_spec->flags & UVERBS_ATTR_SPEC_F_ALLOC_AND_COPY &&
+		    uattr->len > sizeof(((struct ib_uverbs_attr *)0)->data)) {
+			int ret;
+			void *p;
+
+			p = kvmalloc(uattr->len, GFP_KERNEL);
+			if (!p)
+				return -ENOMEM;
+
+			e->ptr_attr.data = ptr_to_u64(p);
+
+			ret = copy_from_user(p, u64_to_user_ptr(uattr->data),
+					     uattr->len);
+			if (ret) {
+				kvfree(p);
+				return -EFAULT;
+			}
+		} else {
+			e->ptr_attr.data = uattr->data;
+		}
 		e->ptr_attr.len = uattr->len;
 		e->ptr_attr.flags = uattr->flags;
 		break;
@@ -201,6 +220,10 @@ static int uverbs_finalize_attrs(struct uverbs_attr_bundle *attrs_bundle,
 								     commit);
 				if (!ret)
 					ret = current_ret;
+			} else if (spec->type == UVERBS_ATTR_TYPE_PTR_IN &&
+				   spec->flags & UVERBS_ATTR_SPEC_F_ALLOC_AND_COPY &&
+				   !uverbs_attr_ptr_is_inline(attr)) {
+				kvfree(u64_to_ptr(void, attr->ptr_attr.data));
 			}
 		}
 	}
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index bd6bba3a6e04..0e6f782727bd 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -65,6 +65,8 @@ enum {
 	UVERBS_ATTR_SPEC_F_MANDATORY	= 1U << 0,
 	/* Support extending attributes by length, validate all unknown size == zero  */
 	UVERBS_ATTR_SPEC_F_MIN_SZ_OR_ZERO = 1U << 1,
+	/* Valid only for PTR_IN. Allocate and copy the data inside the parser */
+	UVERBS_ATTR_SPEC_F_ALLOC_AND_COPY = 1U << 2,
 };
 
 /* Specification of a single attribute inside the ioctl message */
@@ -431,6 +433,17 @@ static inline struct ib_uobject *uverbs_attr_get_uobject(const struct uverbs_att
 	return attr->obj_attr.uobject;
 }
 
+static inline int uverbs_attr_get_len(const struct uverbs_attr_bundle *attrs_bundle,
+				      u16 idx)
+{
+	const struct uverbs_attr *attr = uverbs_attr_get(attrs_bundle, idx);
+
+	if (IS_ERR(attr))
+		return PTR_ERR(attr);
+
+	return attr->ptr_attr.len;
+}
+
 static inline int uverbs_copy_to(const struct uverbs_attr_bundle *attrs_bundle,
 				 size_t idx, const void *from, size_t size)
 {
@@ -457,6 +470,18 @@ static inline bool uverbs_attr_ptr_is_inline(const struct uverbs_attr *attr)
 	return attr->ptr_attr.len <= sizeof(attr->ptr_attr.data);
 }
 
+static inline void *uverbs_attr_get_alloced_ptr(const struct uverbs_attr_bundle *attrs_bundle,
+						u16 idx)
+{
+	const struct uverbs_attr *attr = uverbs_attr_get(attrs_bundle, idx);
+
+	if (IS_ERR(attr))
+		return (void *)attr;
+
+	return uverbs_attr_ptr_is_inline(attr) ? u64_to_ptr(void *, attr->ptr_attr.data) :
+		u64_to_ptr(void, attr->ptr_attr.data);
+}
+
 static inline int _uverbs_copy_from(void *to,
 				    const struct uverbs_attr_bundle *attrs_bundle,
 				    size_t idx,
-- 
2.14.4
