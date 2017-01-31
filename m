From: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Subject: [PATCH rdma-core 6/6] Check the return value from snprintf when working with paths
Date: Tue, 31 Jan 2017 14:08:06 -0700
Message-ID: <1485896886-23517-7-git-send-email-jgunthorpe@obsidianresearch.com>
References: <1485896886-23517-1-git-send-email-jgunthorpe@obsidianresearch.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1485896886-23517-1-git-send-email-jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Yishai Hadas <yishaih-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

gcc 7.0.1 remarks:

libibverbs/init.c:109:5: warning: 'snprintf' output may be truncated before the last format character [-Wformat-truncation=]
     "%s/%s", class_path, dent->d_name);
     ^~~~~~~
libibverbs/init.c:108:3: note: 'snprintf' output 2 or more bytes (assuming 257) into a destination of size 256
   snprintf(sysfs_dev->sysfs_path, sizeof sysfs_dev->sysfs_path,
   ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
     "%s/%s", class_path, dent->d_name);

Which is possible filename truncation when processing dents. Detect
truncation and ignore those file names.

Signed-off-by: Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>
---
 ibacm/src/acm.c     |  7 +++++--
 libibverbs/init.c   | 24 +++++++++++++++---------
 util/CMakeLists.txt |  1 +
 util/util.h         | 13 +++++++++++++
 4 files changed, 34 insertions(+), 11 deletions(-)
 create mode 100644 util/util.h

diff --git a/ibacm/src/acm.c b/ibacm/src/acm.c
index 5f4068f619b4a1..fd06a2e81fbe76 100644
--- a/ibacm/src/acm.c
+++ b/ibacm/src/acm.c
@@ -59,6 +59,7 @@
 #include <poll.h>
 #include <inttypes.h>
 #include <ccan/list.h>
+#include <util/util.h>
 #include "acm_mad.h"
 #include "acm_util.h"
 
@@ -2549,8 +2550,10 @@ static int acm_open_providers(void)
 		if (!strstr(dent->d_name, ".so"))
 			continue;
 
-		snprintf(file_name, sizeof(file_name), "%s/%s", prov_lib_path,
-			 dent->d_name);
+		if (!check_snprintf(file_name, sizeof(file_name), "%s/%s",
+				    prov_lib_path, dent->d_name))
+			continue;
+
 		if (lstat(file_name, &buf)) {
 			acm_log(0, "Error - could not stat: %s\n", file_name);
 			continue;
diff --git a/libibverbs/init.c b/libibverbs/init.c
index cce5c6302e0126..0594a1ff1094ad 100644
--- a/libibverbs/init.c
+++ b/libibverbs/init.c
@@ -46,6 +46,7 @@
 #include <dirent.h>
 #include <errno.h>
 
+#include <util/util.h>
 #include "ibverbs.h"
 
 int abi_ver;
@@ -85,8 +86,9 @@ static int find_sysfs_devs(void)
 	char value[8];
 	int ret = 0;
 
-	snprintf(class_path, sizeof class_path, "%s/class/infiniband_verbs",
-		 ibv_get_sysfs_path());
+	if (!check_snprintf(class_path, sizeof(class_path),
+			    "%s/class/infiniband_verbs", ibv_get_sysfs_path()))
+		return ENOMEM;
 
 	class_dir = opendir(class_path);
 	if (!class_dir)
@@ -105,8 +107,9 @@ static int find_sysfs_devs(void)
 			goto out;
 		}
 
-		snprintf(sysfs_dev->sysfs_path, sizeof sysfs_dev->sysfs_path,
-			 "%s/%s", class_path, dent->d_name);
+		if (!check_snprintf(sysfs_dev->sysfs_path, sizeof sysfs_dev->sysfs_path,
+				    "%s/%s", class_path, dent->d_name))
+			continue;
 
 		if (stat(sysfs_dev->sysfs_path, &buf)) {
 			fprintf(stderr, PFX "Warning: couldn't stat '%s'.\n",
@@ -117,8 +120,9 @@ static int find_sysfs_devs(void)
 		if (!S_ISDIR(buf.st_mode))
 			continue;
 
-		snprintf(sysfs_dev->sysfs_name, sizeof sysfs_dev->sysfs_name,
-			"%s", dent->d_name);
+		if (!check_snprintf(sysfs_dev->sysfs_name, sizeof sysfs_dev->sysfs_name,
+				    "%s", dent->d_name))
+			continue;
 
 		if (ibv_read_sysfs_file(sysfs_dev->sysfs_path, "ibdev",
 					sysfs_dev->ibdev_name,
@@ -128,9 +132,11 @@ static int find_sysfs_devs(void)
 			continue;
 		}
 
-		snprintf(sysfs_dev->ibdev_path, sizeof sysfs_dev->ibdev_path,
-			 "%s/class/infiniband/%s", ibv_get_sysfs_path(),
-			 sysfs_dev->ibdev_name);
+		if (!check_snprintf(
+			sysfs_dev->ibdev_path, sizeof(sysfs_dev->ibdev_path),
+			"%s/class/infiniband/%s", ibv_get_sysfs_path(),
+			sysfs_dev->ibdev_name))
+			continue;
 
 		sysfs_dev->next        = sysfs_dev_list;
 		sysfs_dev->have_driver = 0;
diff --git a/util/CMakeLists.txt b/util/CMakeLists.txt
index 1cda8905d8f44d..c0ad5861d189ee 100644
--- a/util/CMakeLists.txt
+++ b/util/CMakeLists.txt
@@ -1,3 +1,4 @@
 publish_internal_headers(util
   compiler.h
+  util.h
   )
diff --git a/util/util.h b/util/util.h
new file mode 100644
index 00000000000000..ed4ffe88573e23
--- /dev/null
+++ b/util/util.h
@@ -0,0 +1,13 @@
+/* GPLv2 or OpenIB.org BSD (MIT) See COPYING file */
+#ifndef UTIL_UTIL_H
+#define UTIL_UTIL_H
+
+/* Return true if the snprintf succeeded, false if there was truncation or
+ * error */
+#define check_snprintf(buf, len, fmt, ...)                                     \
+	({                                                                     \
+		int rc = snprintf(buf, len, fmt, ##__VA_ARGS__);               \
+		(rc < len && rc >= 0);                                         \
+	})
+
+#endif
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
