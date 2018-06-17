From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 07/20] IB/uverbs: Add a macro to define a type with no kernel known size
Date: Sun, 17 Jun 2018 12:59:53 +0300
Message-ID: <20180617100006.30663-8-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Matan Barak <matanb@mellanox.com>

Sometimes the uverbs uAPI  doesn't really care about the structure it gets
from user-space. All it wants to do is to allocate enough space and send
it to the hardware/provider driver. Adding a UVERBS_ATTR_MIN_SIZE that
could be used for this scenarios. We use USHRT_MAX as the kernel known
size to bypass any zero validations.

Signed-off-by: Matan Barak <matanb@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 drivers/infiniband/core/uverbs_std_types.c | 4 ++--
 include/rdma/uverbs_ioctl.h                | 2 ++
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/uverbs_std_types.c b/drivers/infiniband/core/uverbs_std_types.c
index b570acbd94af..0df0ac9c1de3 100644
--- a/drivers/infiniband/core/uverbs_std_types.c
+++ b/drivers/infiniband/core/uverbs_std_types.c
@@ -207,10 +207,10 @@ int uverbs_destroy_def_handler(struct ib_device *ib_dev,
  * spec.
  */
 const struct uverbs_attr_def uverbs_uhw_compat_in =
-	UVERBS_ATTR_PTR_IN_SZ(UVERBS_ATTR_UHW_IN, UVERBS_ATTR_SIZE(0, USHRT_MAX),
+	UVERBS_ATTR_PTR_IN_SZ(UVERBS_ATTR_UHW_IN, UVERBS_ATTR_MIN_SIZE(0),
 			      UA_FLAGS(UVERBS_ATTR_SPEC_F_MIN_SZ_OR_ZERO));
 const struct uverbs_attr_def uverbs_uhw_compat_out =
-	UVERBS_ATTR_PTR_OUT_SZ(UVERBS_ATTR_UHW_OUT, UVERBS_ATTR_SIZE(0, USHRT_MAX),
+	UVERBS_ATTR_PTR_OUT_SZ(UVERBS_ATTR_UHW_OUT, UVERBS_ATTR_MIN_SIZE(0),
 			       UA_FLAGS(UVERBS_ATTR_SPEC_F_MIN_SZ_OR_ZERO));
 
 void create_udata(struct uverbs_attr_bundle *ctx, struct ib_udata *udata)
diff --git a/include/rdma/uverbs_ioctl.h b/include/rdma/uverbs_ioctl.h
index 0e6f782727bd..a57b58a0a59c 100644
--- a/include/rdma/uverbs_ioctl.h
+++ b/include/rdma/uverbs_ioctl.h
@@ -213,6 +213,8 @@ struct uverbs_object_tree_def {
 	.min_len = ((uintptr_t)(&((_type *)0)->_last + 1)), .len = sizeof(_type)
 #define UVERBS_ATTR_SIZE(_min_len, _len)			\
 	.min_len = _min_len, .len = _len
+#define UVERBS_ATTR_MIN_SIZE(_min_len)				\
+	UVERBS_ATTR_SIZE(_min_len, USHRT_MAX)
 
 /*
  * In new compiler, UVERBS_ATTR could be simplified by declaring it as
-- 
2.14.4
