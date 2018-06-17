From: Leon Romanovsky <leon@kernel.org>
Subject: [PATCH rdma-next v2 12/20] IB/core: Introduce DECLARE_UVERBS_GLOBAL_METHODS
Date: Sun, 17 Jun 2018 12:59:58 +0300
Message-ID: <20180617100006.30663-13-leon@kernel.org>
References: <20180617100006.30663-1-leon@kernel.org>
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180617100006.30663-1-leon@kernel.org>
Sender: netdev-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@mellanox.com>
Cc: Leon Romanovsky <leonro@mellanox.com>, RDMA mailing list <linux-rdma@vger.kernel.org>, Joonas Lahtinen <joonas.lahtinen@linux.intel.com>, Matan Barak <matanb@mellanox.com>, Yishai Hadas <yishaih@mellanox.com>, Saeed Mahameed <saeedm@mellanox.com>, linux-netdev <netdev@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

From: Yishai Hadas <yishaih@mellanox.com>

Introduce a new macro to be used for global methods on a singleton
object.

This macros sets internally the type_attrs to be NULL as such an object
can't be created.

Downstream patches from this series will use this macro.

Signed-off-by: Yishai Hadas <yishaih@mellanox.com>
Signed-off-by: Leon Romanovsky <leonro@mellanox.com>
---
 include/rdma/uverbs_named_ioctl.h | 4 ++++
 include/rdma/uverbs_std_types.h   | 2 --
 2 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/include/rdma/uverbs_named_ioctl.h b/include/rdma/uverbs_named_ioctl.h
index c5bb4ebdb0b0..228421f2a427 100644
--- a/include/rdma/uverbs_named_ioctl.h
+++ b/include/rdma/uverbs_named_ioctl.h
@@ -43,6 +43,7 @@
 #define _UVERBS_NAME(x, y)	_UVERBS_PASTE(x, y)
 #define UVERBS_METHOD(id)	_UVERBS_NAME(UVERBS_MODULE_NAME, _method_##id)
 #define UVERBS_HANDLER(id)	_UVERBS_NAME(UVERBS_MODULE_NAME, _handler_##id)
+#define UVERBS_OBJECT(id)	_UVERBS_NAME(UVERBS_MOUDLE_NAME, _object_##id)
 
 #define DECLARE_UVERBS_NAMED_METHOD(id, ...)	\
 	DECLARE_UVERBS_METHOD(UVERBS_METHOD(id), id, UVERBS_HANDLER(id), ##__VA_ARGS__)
@@ -56,6 +57,9 @@
 #define DECLARE_UVERBS_NAMED_OBJECT(id, ...)	\
 	DECLARE_UVERBS_OBJECT(UVERBS_OBJECT(id), id, ##__VA_ARGS__)
 
+#define DECLARE_UVERBS_GLOBAL_METHODS(_name, ...)	\
+	DECLARE_UVERBS_NAMED_OBJECT(_name, NULL, ##__VA_ARGS__)
+
 #define _UVERBS_COMP_NAME(x, y, z) _UVERBS_NAME(_UVERBS_NAME(x, y), z)
 
 #define UVERBS_NO_OVERRIDE	NULL
diff --git a/include/rdma/uverbs_std_types.h b/include/rdma/uverbs_std_types.h
index 9d56cdb84655..4c151b67fb6d 100644
--- a/include/rdma/uverbs_std_types.h
+++ b/include/rdma/uverbs_std_types.h
@@ -37,8 +37,6 @@
 #include <rdma/uverbs_ioctl.h>
 #include <rdma/ib_user_ioctl_verbs.h>
 
-#define UVERBS_OBJECT(id)	uverbs_object_##id
-
 #if IS_ENABLED(CONFIG_INFINIBAND_USER_ACCESS)
 const struct uverbs_object_tree_def *uverbs_default_get_objects(void);
 #else
-- 
2.14.4
