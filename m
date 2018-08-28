From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v1 11/15] RDMA/uverbs: Add UVERBS_ATTR_CONST_IN to the specs language
Date: Tue, 28 Aug 2018 14:18:50 +0300
Message-ID: <20180828111854.14367-12-leon@kernel.org>
References: <20180828111854.14367-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180828111854.14367-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Ariel Levkovich <lariel@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

This makes it clear and safe to access constants passed in from user
space. We define a consistent ABI of u64 for all constants, and verify
that the data passed in can be represented by the type the user supplies.

The expectation is this will always be used with an enum declaring the
constant values, and the user will use the enum type as input to the
accessor.

To retrieve the attribute value we introduce two helper calls - one
standard which may fail if attribute is not valid and one where caller can
provide a default value which will be used in case the attribute is not
valid (useful when attribute is optional).

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Ariel Levkovich <lariel@mellanox.com>
Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_ioctl.c | 23 +++++++++++++++++++
 include/rdma/uverbs_ioctl.h            | 40 ++++++++++++++++++++++++++++++++++
 2 files changed, 63 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index 1a6b229e3db3..4bafd4671de2 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -611,3 +611,26 @@ int uverbs_copy_to(const struct uverbs_attr_bundle *bundle, size_t idx,
 	return 0;
 }
 EXPORT_SYMBOL(uverbs_copy_to);
+
+int _uverbs_get_const(s64 *to, const struct uverbs_attr_bundle *attrs_bundle,
+		      size_t idx, s64 lower_bound, u64 upper_bound,
+		      s64  *def_val)
+{
+	const struct uverbs_attr *attr;
+
+	attr = uverbs_attr_get(attrs_bundle, idx);
+	if (IS_ERR(attr)) {
+		if ((PTR_ERR(attr) != -ENOENT) || !def_val)
+			return PTR_ERR(attr);
+
+		*to = *def_val;
+	} else {
+		*to = attr->ptr_attr.data;
+	}
+
+	if (*to < lower_bound || (*to > 0 && (u64)*to > upper_bound))
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(_uverbs_get_const);
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 9e997c3c2f04..d5f3c101635d 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -365,6 +365,15 @@ struct uverbs_object_tree_def {
 			  __VA_ARGS__ },                                       \
 	})
 
+/* An input value that is a member in the enum _enum_type. */
+#define UVERBS_ATTR_CONST_IN(_attr_id, _enum_type, ...)                        \
+	UVERBS_ATTR_PTR_IN(                                                    \
+		_attr_id,                                                      \
+		UVERBS_ATTR_SIZE(sizeof(u64) + BUILD_BUG_ON_ZERO(              \
+						!sizeof(_enum_type)),          \
+				 sizeof(u64)),                                 \
+		__VA_ARGS__)
+
 /*
  * An input value that is a bitwise combination of values of _enum_type.
  * This permits the flag value to be passed as either a u32 or u64, it must
@@ -603,6 +612,9 @@ static inline __malloc void *uverbs_zalloc(struct uverbs_attr_bundle *bundle,
 {
 	return _uverbs_alloc(bundle, size, GFP_KERNEL | __GFP_ZERO);
 }
+int _uverbs_get_const(s64 *to, const struct uverbs_attr_bundle *attrs_bundle,
+		      size_t idx, s64 lower_bound, u64 upper_bound,
+		      s64 *def_val);
 #else
 static inline int
 uverbs_get_flags64(u64 *to, const struct uverbs_attr_bundle *attrs_bundle,
@@ -631,6 +643,34 @@ static inline __malloc void *uverbs_zalloc(struct uverbs_attr_bundle *bundle,
 {
 	return ERR_PTR(-EINVAL);
 }
+static inline int
+_uverbs_get_const(s64 *to, const struct uverbs_attr_bundle *attrs_bundle,
+		  size_t idx, s64 lower_bound, u64 upper_bound,
+		  s64 *def_val)
+{
+	return -EINVAL;
+}
 #endif
 
+#define uverbs_get_const(_to, _attrs_bundle, _idx)                             \
+	({                                                                     \
+		s64 _val;                                                      \
+		int _ret = _uverbs_get_const(&_val, _attrs_bundle, _idx,       \
+					     type_min(typeof(*_to)),           \
+					     type_max(typeof(*_to)), NULL);    \
+		(*_to) = _val;                                                 \
+		_ret;                                                          \
+	})
+
+#define uverbs_get_const_default(_to, _attrs_bundle, _idx, _default)           \
+	({                                                                     \
+		s64 _val;                                                      \
+		s64 _def_val = _default;                                       \
+		int _ret =                                                     \
+			_uverbs_get_const(&_val, _attrs_bundle, _idx,          \
+					  type_min(typeof(*_to)),              \
+					  type_max(typeof(*_to)), &_def_val);  \
+		(*_to) = _val;                                                 \
+		_ret;                                                          \
+	})
 #endif
-- 
2.14.4
