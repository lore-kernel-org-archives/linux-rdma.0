From: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Subject: [infiniband-diags PATCH 1/2] rdma-ndd: never use udev_get_sys_path()
Date: Thu, 25 Jun 2015 16:12:01 +0200
Message-ID: <1435241522-7721-2-git-send-email-mschmidt@redhat.com>
References: <1435241522-7721-1-git-send-email-mschmidt@redhat.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1435241522-7721-1-git-send-email-mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The function was deprecated and later dropped by udev entirely
because it was pointless.
Quoting kernel's Documentation/sysfs-rules.txt:
  sysfs is always at /sys
  Parsing /proc/mounts is a waste of time. Other mount points are
  a system configuration bug you should not try to solve. [...]

Signed-off-by: Michal Schmidt <mschmidt-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
---
 configure.ac   |  1 -
 src/rdma-ndd.c | 19 +++++--------------
 2 files changed, 5 insertions(+), 15 deletions(-)

diff --git a/configure.ac b/configure.ac
index b9b7ad84ee..ece1d530a7 100644
--- a/configure.ac
+++ b/configure.ac
@@ -214,7 +214,6 @@ if test x$rdmandd = xyes; then
     AC_CHECK_HEADER(libudev.h, with_udev="yes", with_udev="no")
     AC_CHECK_LIB(udev, udev_monitor_ref, [], AC_MSG_ERROR(libudev is required for rdma-ndd...))
     AC_CONFIG_FILES([doc/man/rdma-ndd.8 etc/rdma-ndd.init])
-    AC_CHECK_FUNCS_ONCE(udev_get_sys_path)
 fi
 
 dnl Generate doc/man/*.in files if possible
diff --git a/src/rdma-ndd.c b/src/rdma-ndd.c
index 194c2cd865..d40e7567db 100644
--- a/src/rdma-ndd.c
+++ b/src/rdma-ndd.c
@@ -58,9 +58,7 @@ struct udev_monitor *mon;
 #include "ibdiag_common.h"
 
 #define SYS_HOSTNAME "/proc/sys/kernel/hostname"
-#define DEF_SYS_DIR "/sys"
-char *sys_dir = DEF_SYS_DIR;
-#define SYS_INFINIBAND "class/infiniband"
+#define SYS_INFINIBAND "/sys/class/infiniband"
 #define DEFAULT_RETRY_RATE 60
 #define DEFAULT_RETRY_COUNT 0
 #define DEFAULT_ND_FORMAT "%h %d"
@@ -122,8 +120,8 @@ static int update_node_desc(const char *device, const char *hostname, int force)
 	char nd_file[PATH_MAX];
 	FILE *f;
 
-	snprintf(nd_file, sizeof(nd_file), "%s/%s/%s/node_desc",
-			sys_dir, SYS_INFINIBAND, device);
+	snprintf(nd_file, sizeof(nd_file), SYS_INFINIBAND "/%s/node_desc",
+			device);
 	nd_file[sizeof(nd_file)-1] = '\0';
 
 	f = fopen(nd_file, "r+");
@@ -160,14 +158,10 @@ static int set_rdma_node_desc(const char *hostname, int force)
 {
 	DIR *class_dir;
 	struct dirent *dent;
-	char dev_dir[PATH_MAX];
 
-	snprintf(dev_dir, sizeof(dev_dir), "%s/%s", sys_dir, SYS_INFINIBAND);
-	dev_dir[sizeof(dev_dir)-1] = '\0';
-
-	class_dir = opendir(dev_dir);
+	class_dir = opendir(SYS_INFINIBAND);
 	if (!class_dir) {
-		syslog(LOG_INFO, "Failed to open %s", dev_dir);
+		syslog(LOG_INFO, "Failed to open " SYS_INFINIBAND);
 		return -ENOSYS;
 	}
 
@@ -261,9 +255,6 @@ static void setup_udev(void)
 
 	udev_set_log_fn(udev, udev_log_fn);
 	udev_set_log_priority(udev, LOG_INFO);
-#if HAVE_UDEV_GET_SYS_PATH
-	sys_dir = (char *)udev_get_sys_path(udev);
-#endif
 }
 
 static int get_udev_fd(void)
-- 
2.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
