From: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
Subject: [PATCH 02/32] libibumad: create sysfs.h instead of using extern declarations in umad.c
Date: Thu, 13 Oct 2016 19:51:05 +0200
Message-ID: <1476381095-20041-3-git-send-email-hch@lst.de>
References: <1476381095-20041-1-git-send-email-hch@lst.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1476381095-20041-1-git-send-email-hch-jcswGhMUV9g@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

So that we have the prototypes available in the implementation file
and do get proper type checking for them.

Signed-off-by: Christoph Hellwig <hch-jcswGhMUV9g@public.gmane.org>
---
 libibumad/sysfs.c |  1 +
 libibumad/sysfs.h | 10 ++++++++++
 libibumad/umad.c  |  7 +------
 3 files changed, 12 insertions(+), 6 deletions(-)
 create mode 100644 libibumad/sysfs.h

diff --git a/libibumad/sysfs.c b/libibumad/sysfs.c
index 011e411..83f89b4 100644
--- a/libibumad/sysfs.c
+++ b/libibumad/sysfs.c
@@ -44,6 +44,7 @@
 #include <byteswap.h>
 #include <netinet/in.h>
 #include <infiniband/arch.h>
+#include "sysfs.h"
 
 static int ret_code(void)
 {
diff --git a/libibumad/sysfs.h b/libibumad/sysfs.h
new file mode 100644
index 0000000..7f8cbfe
--- /dev/null
+++ b/libibumad/sysfs.h
@@ -0,0 +1,10 @@
+#ifndef _UMAD_SYSFS_H
+#define _UMAD_SYSFS_H
+
+extern int sys_read_string(const char *dir_name, const char *file_name, char *str, int len);
+extern int sys_read_guid(const char *dir_name, const char *file_name, uint64_t * net_guid);
+extern int sys_read_gid(const char *dir_name, const char *file_name, uint8_t * gid);
+extern int sys_read_uint64(const char *dir_name, const char *file_name, uint64_t * u);
+extern int sys_read_uint(const char *dir_name, const char *file_name, unsigned *u);
+
+#endif /* _UMAD_SYSFS_H */
diff --git a/libibumad/umad.c b/libibumad/umad.c
index 0c969f1..8860b99 100644
--- a/libibumad/umad.c
+++ b/libibumad/umad.c
@@ -53,6 +53,7 @@
 #define IB_OPENIB_OUI                 (0x001405)
 
 #include <valgrind/memcheck.h>
+#include "sysfs.h"
 
 typedef struct ib_user_mad_reg_req {
 	uint32_t id;
@@ -77,12 +78,6 @@ struct ib_user_mad_reg_req2 {
 	uint8_t  reserved[3];
 };
 
-extern int sys_read_string(const char *dir_name, const char *file_name, char *str, int len);
-extern int sys_read_guid(const char *dir_name, const char *file_name, uint64_t * net_guid);
-extern int sys_read_gid(const char *dir_name, const char *file_name, uint8_t * gid);
-extern int sys_read_uint64(const char *dir_name, const char *file_name, uint64_t * u);
-extern int sys_read_uint(const char *dir_name, const char *file_name, unsigned *u);
-
 #define IBWARN(fmt, args...) fprintf(stderr, "ibwarn: [%d] %s: " fmt "\n", getpid(), __func__, ## args)
 
 #define TRACE	if (umaddebug)	IBWARN
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
