From: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] change thread-unsafe readdir to thread-safe readdir_r calls
Date: Wed,  7 Jul 2010 11:37:01 -0700
Message-ID: <1278527821-14804-1-git-send-email-sdake@redhat.com>
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

Signed-off-by: Steven Dake <sdake-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 src/init.c |   31 +++++++++++++++++++++++++------
 1 files changed, 25 insertions(+), 6 deletions(-)

diff --git a/src/init.c b/src/init.c
index 4f0130e..ac3efdc 100644
--- a/src/init.c
+++ b/src/init.c
@@ -46,10 +46,12 @@
 #include <sys/time.h>
 #include <sys/resource.h>
 #include <dirent.h>
+#include <stddef.h>
 #include <errno.h>
 
 #include "ibverbs.h"
 
+
 HIDDEN int abi_ver;
 
 struct ibv_sysfs_dev {
@@ -85,6 +87,7 @@ static int find_sysfs_devs(void)
 	struct ibv_sysfs_dev *sysfs_dev = NULL;
 	char value[8];
 	int ret = 0;
+	struct dirent *buf;
 
 	snprintf(class_path, sizeof class_path, "%s/class/infiniband_verbs",
 		 ibv_get_sysfs_path());
@@ -93,7 +96,12 @@ static int find_sysfs_devs(void)
 	if (!class_dir)
 		return ENOSYS;
 
-	while ((dent = readdir(class_dir))) {
+	buf = (struct dirent *)malloc(offsetof(struct dirent, d_name) + NAME_MAX + 1);
+	if (buf == NULL) {
+		goto out_closedir;
+		ret = ENOMEM;
+	}
+	while (readdir_r(class_dir, buf, &dent) == 0 && dent) {
 		struct stat buf;
 
 		if (dent->d_name[0] == '.')
@@ -146,9 +154,11 @@ static int find_sysfs_devs(void)
 	}
 
  out:
+	free (buf);
 	if (sysfs_dev)
 		free(sysfs_dev);
 
+out_closedir:
 	closedir(class_dir);
 	return ret;
 }
@@ -290,26 +300,31 @@ static void read_config_file(const char *path)
 	fclose(conf);
 }
 
-static void read_config(void)
+static int read_config(void)
 {
 	DIR *conf_dir;
 	struct dirent *dent;
+	struct dirent *buf;
 	char *path;
 
 	conf_dir = opendir(IBV_CONFIG_DIR);
 	if (!conf_dir) {
 		fprintf(stderr, PFX "Warning: couldn't open config directory '%s'.\n",
 			IBV_CONFIG_DIR);
-		return;
+		return 0;
 	}
 
-	while ((dent = readdir(conf_dir))) {
+	buf = (struct dirent *)malloc(offsetof(struct dirent, d_name) + NAME_MAX + 1);
+	if (buf == NULL)
+		return ENOMEM;
+
+	while (readdir_r(conf_dir, buf, &dent) == 0 && dent) {
 		struct stat buf;
 
 		if (asprintf(&path, "%s/%s", IBV_CONFIG_DIR, dent->d_name) < 0) {
 			fprintf(stderr, PFX "Warning: couldn't read config file %s/%s.\n",
 				IBV_CONFIG_DIR, dent->d_name);
-			return;
+			return 0;
 		}
 
 		if (stat(path, &buf)) {
@@ -326,7 +341,9 @@ next:
 		free(path);
 	}
 
+	free(buf);
 	closedir(conf_dir);
+	return 0;
 }
 
 static struct ibv_device *try_driver(struct ibv_driver *driver,
@@ -471,7 +488,9 @@ HIDDEN int ibverbs_init(struct ibv_device ***list)
 
 	check_memlock_limit();
 
-	read_config();
+	ret = read_config();
+	if (ret)
+		return -ret;
 
 	ret = find_sysfs_devs();
 	if (ret)
-- 
1.6.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
