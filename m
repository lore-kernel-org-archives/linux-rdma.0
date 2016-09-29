From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH 3/9] Remove HAVE_IBV_*
Date: Thu, 29 Sep 2016 14:47:50 -0600
Message-ID: <1475182076-5411-4-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1475182076-5411-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1475182076-5411-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Mike Marciniszyn <mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Yishai Hadas <yishaih-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Vladimir Sokolovsky <vlad-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Moni Shoua <monis-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, "open list:HF1 USERSPACE PROVIDER for hf1.ko" <intel-opa-y27Ovi1pjclAfugRpC6u6w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

These were used to support building provider plugins against old
versions of libibverbs. Since libibverbs is now included together
with the provider that is no longer possible or supported.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 buildlib/config.h.in           |  6 -----
 libhfi1verbs/src/hfiverbs.c    | 18 -------------
 libipathverbs/src/ipathverbs.c | 18 -------------
 libmlx5/src/buf.c              | 19 --------------
 libmlx5/src/mlx5.c             |  4 ---
 libmlx5/src/verbs.c            |  2 --
 libmthca/src/buf.c             | 19 --------------
 libmthca/src/mthca.c           | 58 ------------------------------------------
 librxe/src/rxe.c               | 14 ----------
 9 files changed, 158 deletions(-)

diff --git a/buildlib/config.h.in b/buildlib/config.h.in
index a02be9cfb0f7..3b94ea3e4f51 100644
--- a/buildlib/config.h.in
+++ b/buildlib/config.h.in
@@ -1,12 +1,6 @@
 #ifndef CONFIG_H_IN
 #define CONFIG_H_IN
 
-// FIXME: Remove this, ibverbs is included so we don't need to detect
-#define HAVE_IBV_DOFORK_RANGE 1
-#define HAVE_IBV_DONTFORK_RANGE 1
-#define HAVE_IBV_REGISTER_DRIVER 1
-#define HAVE_IBV_READ_SYSFS_FILE 1
-
 #define HAVE_STATEMENT_EXPR 1
 #define HAVE_BUILTIN_TYPES_COMPATIBLE_P 1
 #define HAVE_TYPEOF 1
diff --git a/libhfi1verbs/src/hfiverbs.c b/libhfi1verbs/src/hfiverbs.c
index d2b7dd450992..e28afc7fcc89 100644
--- a/libhfi1verbs/src/hfiverbs.c
+++ b/libhfi1verbs/src/hfiverbs.c
@@ -217,25 +217,7 @@ found:
 	return &dev->ibv_dev;
 }
 
-#ifdef HAVE_IBV_REGISTER_DRIVER
 static __attribute__((constructor)) void hfi1_register_driver(void)
 {
 	ibv_register_driver("hfi1verbs", hfi1_driver_init);
 }
-#else
-/*
- * Export the old libsysfs sysfs_class_device-based driver entry point
- * if libibverbs does not export an ibv_register_driver() function.
- */
-struct ibv_device *openib_driver_init(struct sysfs_class_device *sysdev)
-{
-        int abi_ver = 0;
-        char value[8];
-
-        if (ibv_read_sysfs_file(sysdev->path, "abi_version",
-                                value, sizeof value) > 0)
-                abi_ver = strtol(value, NULL, 10);
-
-        return hfi1_driver_init(sysdev->path, abi_ver);
-}
-#endif /* HAVE_IBV_REGISTER_DRIVER */
diff --git a/libipathverbs/src/ipathverbs.c b/libipathverbs/src/ipathverbs.c
index 9a19d0ab98ae..4b945f6c58ec 100644
--- a/libipathverbs/src/ipathverbs.c
+++ b/libipathverbs/src/ipathverbs.c
@@ -216,25 +216,7 @@ found:
 	return &dev->ibv_dev;
 }
 
-#ifdef HAVE_IBV_REGISTER_DRIVER
 static __attribute__((constructor)) void ipath_register_driver(void)
 {
 	ibv_register_driver("ipathverbs", ipath_driver_init);
 }
-#else
-/*
- * Export the old libsysfs sysfs_class_device-based driver entry point
- * if libibverbs does not export an ibv_register_driver() function.
- */
-struct ibv_device *openib_driver_init(struct sysfs_class_device *sysdev)
-{
-        int abi_ver = 0;
-        char value[8];
-
-        if (ibv_read_sysfs_file(sysdev->path, "abi_version",
-                                value, sizeof value) > 0)
-                abi_ver = strtol(value, NULL, 10);
-
-        return ipath_driver_init(sysdev->path, abi_ver);
-}
-#endif /* HAVE_IBV_REGISTER_DRIVER */
diff --git a/libmlx5/src/buf.c b/libmlx5/src/buf.c
index 7e06095d0352..853450ae93b3 100644
--- a/libmlx5/src/buf.c
+++ b/libmlx5/src/buf.c
@@ -42,25 +42,6 @@
 #include "mlx5.h"
 #include "bitmap.h"
 
-#if !(defined(HAVE_IBV_DONTFORK_RANGE) && defined(HAVE_IBV_DOFORK_RANGE))
-
-/*
- * If libibverbs isn't exporting these functions, then there's no
- * point in doing it here, because the rest of libibverbs isn't going
- * to be fork-safe anyway.
- */
-static int ibv_dontfork_range(void *base, size_t size)
-{
-	return 0;
-}
-
-static int ibv_dofork_range(void *base, size_t size)
-{
-	return 0;
-}
-
-#endif /* HAVE_IBV_DONTFORK_RANGE && HAVE_IBV_DOFORK_RANGE */
-
 static int mlx5_bitmap_init(struct mlx5_bitmap *bitmap, uint32_t num,
 			    uint32_t mask)
 {
diff --git a/libmlx5/src/mlx5.c b/libmlx5/src/mlx5.c
index 121a833062f1..f24e5043dfe6 100644
--- a/libmlx5/src/mlx5.c
+++ b/libmlx5/src/mlx5.c
@@ -42,10 +42,6 @@
 #include <sched.h>
 #include <sys/param.h>
 
-#ifndef HAVE_IBV_REGISTER_DRIVER
-#include <sysfs/libsysfs.h>
-#endif
-
 #include "mlx5.h"
 #include "mlx5-abi.h"
 
diff --git a/libmlx5/src/verbs.c b/libmlx5/src/verbs.c
index 58673f4433fd..acbabc814621 100644
--- a/libmlx5/src/verbs.c
+++ b/libmlx5/src/verbs.c
@@ -993,9 +993,7 @@ static const char *qptype2key(enum ibv_qp_type type)
 	case IBV_QPT_RC: return "HUGE_RC";
 	case IBV_QPT_UC: return "HUGE_UC";
 	case IBV_QPT_UD: return "HUGE_UD";
-#ifdef _NOT_EXISTS_IN_OFED_2_0
 	case IBV_QPT_RAW_PACKET: return "HUGE_RAW_ETH";
-#endif
 	default: return "HUGE_NA";
 	}
 }
diff --git a/libmthca/src/buf.c b/libmthca/src/buf.c
index 78e7b89c4db5..c03ee1f9a3e4 100644
--- a/libmthca/src/buf.c
+++ b/libmthca/src/buf.c
@@ -38,25 +38,6 @@
 
 #include "mthca.h"
 
-#if !(defined(HAVE_IBV_DONTFORK_RANGE) && defined(HAVE_IBV_DOFORK_RANGE))
-
-/*
- * If libibverbs isn't exporting these functions, then there's no
- * point in doing it here, because the rest of libibverbs isn't going
- * to be fork-safe anyway.
- */
-static int ibv_dontfork_range(void *base, size_t size)
-{
-	return 0;
-}
-
-static int ibv_dofork_range(void *base, size_t size)
-{
-	return 0;
-}
-
-#endif /* HAVE_IBV_DONTFORK_RANGE && HAVE_IBV_DOFORK_RANGE */
-
 int mthca_alloc_buf(struct mthca_buf *buf, size_t size, int page_size)
 {
 	int ret;
diff --git a/libmthca/src/mthca.c b/libmthca/src/mthca.c
index d6bda2d29d66..d5660ceef7e0 100644
--- a/libmthca/src/mthca.c
+++ b/libmthca/src/mthca.c
@@ -41,16 +41,6 @@
 #include <pthread.h>
 #include <string.h>
 
-#ifndef HAVE_IBV_REGISTER_DRIVER
-#include <sysfs/libsysfs.h>
-#endif
-
-#ifndef HAVE_IBV_READ_SYSFS_FILE
-#include <sys/types.h>
-#include <sys/stat.h>
-#include <fcntl.h>
-#endif
-
 #include "mthca.h"
 #include "mthca-abi.h"
 
@@ -224,36 +214,6 @@ static struct ibv_device_ops mthca_dev_ops = {
 	.free_context  = mthca_free_context
 };
 
-/*
- * Keep a private implementation of HAVE_IBV_READ_SYSFS_FILE to handle
- * old versions of libibverbs that didn't implement it.  This can be
- * removed when libibverbs 1.0.3 or newer is available "everywhere."
- */
-#ifndef HAVE_IBV_READ_SYSFS_FILE
-static int ibv_read_sysfs_file(const char *dir, const char *file,
-			       char *buf, size_t size)
-{
-	char path[256];
-	int fd;
-	int len;
-
-	snprintf(path, sizeof path, "%s/%s", dir, file);
-
-	fd = open(path, O_RDONLY);
-	if (fd < 0)
-		return -1;
-
-	len = read(fd, buf, size);
-
-	close(fd);
-
-	if (len > 0 && buf[len - 1] == '\n')
-		buf[--len] = '\0';
-
-	return len;
-}
-#endif /* HAVE_IBV_READ_SYSFS_FILE */
-
 static struct ibv_device *mthca_driver_init(const char *uverbs_sys_path,
 					    int abi_version)
 {
@@ -300,25 +260,7 @@ found:
 	return &dev->ibv_dev;
 }
 
-#ifdef HAVE_IBV_REGISTER_DRIVER
 static __attribute__((constructor)) void mthca_register_driver(void)
 {
 	ibv_register_driver("mthca", mthca_driver_init);
 }
-#else
-/*
- * Export the old libsysfs sysfs_class_device-based driver entry point
- * if libibverbs does not export an ibv_register_driver() function.
- */
-struct ibv_device *openib_driver_init(struct sysfs_class_device *sysdev)
-{
-	int abi_ver = 0;
-	char value[8];
-
-	if (ibv_read_sysfs_file(sysdev->path, "abi_version",
-				value, sizeof value) > 0)
-		abi_ver = strtol(value, NULL, 10);
-
-	return mthca_driver_init(sysdev->path, abi_ver);
-}
-#endif /* HAVE_IBV_REGISTER_DRIVER */
diff --git a/librxe/src/rxe.c b/librxe/src/rxe.c
index 6bd04d696c41..ef7434e1d506 100644
--- a/librxe/src/rxe.c
+++ b/librxe/src/rxe.c
@@ -935,22 +935,8 @@ static struct ibv_device *rxe_driver_init(const char *uverbs_sys_path,
 	return &dev->ibv_dev;
 }
 
-#ifdef HAVE_IBV_REGISTER_DRIVER
 static __attribute__ ((constructor))
 void rxe_register_driver(void)
 {
 	ibv_register_driver("rxe", rxe_driver_init);
 }
-#else
-struct ibv_device *openib_driver_init(struct sysfs_class_device *sysdev)
-{
-	int abi_ver = 0;
-	char value[8];
-
-	if (ibv_read_sysfs_file(sysdev->path, "abi_version",
-				value, sizeof value) > 0)
-		abi_ver = strtol(value, NULL, 10);
-
-	return rxe_driver_init(sysdev->path, abi_ver);
-}
-#endif /* HAVE_IBV_REGISTER_DRIVER */
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
