From: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] change thread-unsafe readdir to thread-safe readdir_r calls
Date: Wed,  7 Jul 2010 15:14:33 -0700
Message-ID: <1278540873-3857-1-git-send-email-sdake@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Steven Dake <sdake-AqqL/iNfm4CbU/LNMs03Rw@public.gmane.org>, Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Steven Dake <sdake-AqqL/iNfm4CbU/LNMs03Rw@public.gmane.org>

The readdir POSIX api is not thread safe.  This presents problems in
multithreaded programs that use the libibverbs APIs.  This patch has been
tested with a libibverbs application (http://www.corosync.org) on
Mellanox MT26428 cards.

This updated version uses alloca instead of malloc.

Signed-off-by: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/init.c |   12 ++++++++++--
 1 files changed, 10 insertions(+), 2 deletions(-)

diff --git a/src/init.c b/src/init.c
index 4f0130e..11b8415 100644
--- a/src/init.c
+++ b/src/init.c
@@ -35,6 +35,9 @@
 #  include <config.h>
 #endif /* HAVE_CONFIG_H */
 
+#if HAVE_ALLOCA_H
+#include <alloca.h>
+#endif
 #include <stdlib.h>
 #include <string.h>
 #include <glob.h>
@@ -46,6 +49,7 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <dirent.h>
+#include <stddef.h>
 #include <errno.h>
 
 #include "ibverbs.h"
@@ -85,6 +89,7 @@ static int find_sysfs_devs(void)
 	struct ibv_sysfs_dev *sysfs_dev = NULL;
 	char value[8];
 	int ret = 0;
+	struct dirent *buf;
 
 	snprintf(class_path, sizeof class_path, "%s/class/infiniband_verbs",
 		 ibv_get_sysfs_path());
@@ -93,7 +98,8 @@ static int find_sysfs_devs(void)
 	if (!class_dir)
 		return ENOSYS;
 
-	while ((dent = readdir(class_dir))) {
+	buf = alloca(offsetof(struct dirent, d_name) + NAME_MAX + 1);
+	while (readdir_r(class_dir, buf, &dent) == 0 && dent) {
 		struct stat buf;
 
 		if (dent->d_name[0] == '.')
@@ -294,6 +300,7 @@ static void read_config(void)
 {
 	DIR *conf_dir;
 	struct dirent *dent;
+	struct dirent *buf;
 	char *path;
 
 	conf_dir = opendir(IBV_CONFIG_DIR);
@@ -303,7 +310,8 @@ static void read_config(void)
 		return;
 	}
 
-	while ((dent = readdir(conf_dir))) {
+	buf = alloca(offsetof(struct dirent, d_name) + NAME_MAX + 1);
+	while (readdir_r(conf_dir, buf, &dent) == 0 && dent) {
 		struct stat buf;
 
 		if (asprintf(&path, "%s/%s", IBV_CONFIG_DIR, dent->d_name) < 0) {
-- 
1.6.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
