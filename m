From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-core V1] Remove unused HIDDEN gcc attribute
Date: Thu,  6 Oct 2016 12:33:05 +0300
Message-ID: <1475746385-540-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The attribute HIDDEN was declared in almost every provider, but it wasn't
used, except in libibverbs. This attribute is configured by linker map
now and can be safely removed.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Reviewed-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
Changelog v0->v1:
 * Add Jason's RB tag
 * Remove hidden parameter from libibverbs too
 * Improve commit message
---
 libhfi1verbs/src/hfiverbs.h    | 2 --
 libi40iw/src/i40iw_umain.h     | 2 --
 libibverbs/src/ibverbs.h       | 6 ++----
 libibverbs/src/init.c          | 4 ++--
 libipathverbs/src/ipathverbs.h | 2 --
 libmlx4/src/mlx4.h             | 2 --
 libmlx5/src/mlx5.h             | 2 --
 libmthca/src/mthca.h           | 2 --
 libnes/src/nes_umain.h         | 2 --
 9 files changed, 4 insertions(+), 20 deletions(-)

diff --git a/libhfi1verbs/src/hfiverbs.h b/libhfi1verbs/src/hfiverbs.h
index deebc65..e82ba2b 100644
--- a/libhfi1verbs/src/hfiverbs.h
+++ b/libhfi1verbs/src/hfiverbs.h
@@ -67,8 +67,6 @@
 #include <infiniband/arch.h>
 #include <infiniband/verbs.h>

-#define HIDDEN		__attribute__((visibility ("hidden")))
-
 #define PFX		"hfi1: "

 struct hfi1_device {
diff --git a/libi40iw/src/i40iw_umain.h b/libi40iw/src/i40iw_umain.h
index 13d3da8..719aefc 100644
--- a/libi40iw/src/i40iw_umain.h
+++ b/libi40iw/src/i40iw_umain.h
@@ -54,8 +54,6 @@
 #define unlikely(x) __builtin_expect((x), 0)
 #endif

-#define HIDDEN __attribute__((visibility("hidden")))
-
 #define PFX "libi40iw-"

 #define  I40IW_BASE_PUSH_PAGE	1
diff --git a/libibverbs/src/ibverbs.h b/libibverbs/src/ibverbs.h
index a01dff2..dd2dacf 100644
--- a/libibverbs/src/ibverbs.h
+++ b/libibverbs/src/ibverbs.h
@@ -40,8 +40,6 @@

 #include <valgrind/memcheck.h>

-#define HIDDEN		__attribute__((visibility ("hidden")))
-
 #define INIT		__attribute__((constructor))
 #define FINI		__attribute__((destructor))

@@ -58,9 +56,9 @@ struct ibv_abi_compat_v2 {
 	pthread_mutex_t		in_use;
 };

-extern HIDDEN int abi_ver;
+extern int abi_ver;

-HIDDEN int ibverbs_init(struct ibv_device ***list);
+int ibverbs_init(struct ibv_device ***list);

 struct verbs_ex_private {
 	struct ibv_cq_ex *(*create_cq_ex)(struct ibv_context *context,
diff --git a/libibverbs/src/init.c b/libibverbs/src/init.c
index 7797569..03f3c42 100644
--- a/libibverbs/src/init.c
+++ b/libibverbs/src/init.c
@@ -48,7 +48,7 @@

 #include "ibverbs.h"

-HIDDEN int abi_ver;
+int abi_ver;

 struct ibv_sysfs_dev {
 	char		        sysfs_name[IBV_SYSFS_NAME_MAX];
@@ -498,7 +498,7 @@ static void add_device(struct ibv_device *dev,
 	(*dev_list)[(*num_devices)++] = dev;
 }

-HIDDEN int ibverbs_init(struct ibv_device ***list)
+int ibverbs_init(struct ibv_device ***list)
 {
 	const char *sysfs_path;
 	struct ibv_sysfs_dev *sysfs_dev, *next_dev;
diff --git a/libipathverbs/src/ipathverbs.h b/libipathverbs/src/ipathverbs.h
index 05e1c71..ff25854 100644
--- a/libipathverbs/src/ipathverbs.h
+++ b/libipathverbs/src/ipathverbs.h
@@ -47,8 +47,6 @@
 #include <infiniband/arch.h>
 #include <infiniband/verbs.h>

-#define HIDDEN		__attribute__((visibility ("hidden")))
-
 #define PFX		"ipath: "

 struct ipath_device {
diff --git a/libmlx4/src/mlx4.h b/libmlx4/src/mlx4.h
index 1855cfb..95a6521 100644
--- a/libmlx4/src/mlx4.h
+++ b/libmlx4/src/mlx4.h
@@ -49,8 +49,6 @@

 #include <valgrind/memcheck.h>

-#define HIDDEN		__attribute__((visibility ("hidden")))
-
 #define PFX		"mlx4: "

 enum {
diff --git a/libmlx5/src/mlx5.h b/libmlx5/src/mlx5.h
index c209a79..f8674c7 100644
--- a/libmlx5/src/mlx5.h
+++ b/libmlx5/src/mlx5.h
@@ -54,8 +54,6 @@

 #include <valgrind/memcheck.h>

-#define HIDDEN		__attribute__((visibility("hidden")))
-
 #ifdef HAVE_FUNC_ATTRIBUTE_ALWAYS_INLINE
 #define ALWAYS_INLINE __attribute__((always_inline))
 #else
diff --git a/libmthca/src/mthca.h b/libmthca/src/mthca.h
index da53010..b4b0b6a 100644
--- a/libmthca/src/mthca.h
+++ b/libmthca/src/mthca.h
@@ -41,8 +41,6 @@

 #include <valgrind/memcheck.h>

-#define HIDDEN		__attribute__((visibility ("hidden")))
-
 #define PFX		"mthca: "

 enum mthca_hca_type {
diff --git a/libnes/src/nes_umain.h b/libnes/src/nes_umain.h
index 9129982..f3cc348 100644
--- a/libnes/src/nes_umain.h
+++ b/libnes/src/nes_umain.h
@@ -48,8 +48,6 @@
 #define unlikely(x) __builtin_expect((x),0)
 #endif

-#define HIDDEN __attribute__((visibility ("hidden")))
-
 #define PFX	"libnes: "

 #define  NES_QP_MMAP		1
--
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
