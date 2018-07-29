From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next 12/27] RDMA/uverbs: Add UVERBS_ATTR_CONST_IN to the specs language
Date: Sun, 29 Jul 2018 15:58:50 +0300
Message-ID: <20180729125905.31989-13-leon@kernel.org>
References: <20180729125905.31989-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180729125905.31989-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Guy Levi <guyle@mellanox.com>, Mark Bloch <markb@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb@mellanox.com>

This makes it clear and safe to access constants past in from user space.
We define a consistent ABI of u64 for all constants, and verify that
the data passed in can be represented by the type the user supplies.

The expectation is this will always be used with an enum declaring the
constant values, and the user will use the enum type as input to the
accessor.

Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
Signed-off-by: Mark Bloch <markb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_ioctl.c | 21 +++++++++++++++++++++
 include/rdma/uverbs_ioctl.h            | 30 ++++++++++++++++++++++++++++++
 2 files changed, 51 insertions(+)

diff --git a/drivers/infiniband/core/uverbs_ioctl.c b/drivers/infiniband/core/uverbs_ioctl.c
index 23a1777f26e2..3ad3b69e32ab 100644
--- a/drivers/infiniband/core/uverbs_ioctl.c
+++ b/drivers/infiniband/core/uverbs_ioctl.c
@@ -537,3 +537,24 @@ int uverbs_get_flags32(u32 *to, const struct uverbs_attr_bundle *attrs_bundle,
 	return 0;
 }
 EXPORT_SYMBOL(uverbs_get_flags32);
+
+int _uverbs_get_const(s64 *to, const struct uverbs_attr_bundle *attrs_bundle,
+		      size_t idx, s64 lower_bound, u64 upper_bound)
+
+{
+	const struct uverbs_attr *attr;
+
+	attr = uverbs_attr_get(attrs_bundle, idx);
+	if (IS_ERR(attr))
+		return PTR_ERR(attr);
+
+	WARN_ON(attr->ptr_attr.len != 8);
+
+	*to = attr->ptr_attr.data;
+
+	if (*to < lower_bound || *to > upper_bound)
+		return -EINVAL;
+
+	return 0;
+}
+EXPORT_SYMBOL(_uverbs_get_const);
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 19b421d2d82a..f703c8ebbb02 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -268,6 +268,15 @@ struct uverbs_object_tree_def {
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
@@ -536,6 +545,27 @@ int uverbs_get_flags64(u64 *to, const struct uverbs_attr_bundle *attrs_bundle,
 		       size_t idx, u64 allowed_bits);
 int uverbs_get_flags32(u32 *to, const struct uverbs_attr_bundle *attrs_bundle,
 		       size_t idx, u64 allowed_bits);
+#if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
+int _uverbs_get_const(s64 *to, const struct uverbs_attr_bundle *attrs_bundle,
+		      size_t idx, s64 lower_bound, u64 upper_bound);
+#else
+static inline int
+_uverbs_get_const(s64 *to, const struct uverbs_attr_bundle *attrs_bundle,
+		  size_t idx, s64 lower_bound, u64 upper_bound)
+{
+	return -EINVAL;
+}
+#endif
+
+#define uverbs_get_const(_to, _attrs_bundle, _idx)                             \
+	({                                                                     \
+		s64 _val;                                                      \
+		int _ret = _uverbs_get_const(&_val, _attrs_bundle, _idx,       \
+					     type_min(typeof(*_to)),           \
+					     type_max(typeof(*_to)));          \
+		(*_to) = _val;                                                 \
+		_ret;                                                          \
+	})
 
 /* =================================================
  *	 Definitions -> Specs infrastructure
-- 
2.14.4
