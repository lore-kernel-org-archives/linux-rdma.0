From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH] infiniband-diags: rdma-ndd: remove udev logging when not supported
Date: Sat, 19 Sep 2015 17:52:13 -0400
Message-ID: <1442699533-28262-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

udev_set_log_* functions are deprecated on newer versions of libudev
Conditionally compile out the use of these functions.

Signed-off-by: Ira Weiny <iweiny-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 configure.ac   | 8 ++++++++
 src/rdma-ndd.c | 4 ++++
 2 files changed, 12 insertions(+)

diff --git a/configure.ac b/configure.ac
index 090b6ecf7683..4c9b08fcd3ad 100644
--- a/configure.ac
+++ b/configure.ac
@@ -215,6 +215,14 @@ AS_IF([test x$rdmandd = xyes], [
     AC_CONFIG_FILES([doc/man/rdma-ndd.8 etc/rdma-ndd.init])
     AC_SUBST([UDEV_CFLAGS])
     AC_SUBST([UDEV_LIBS])
+    if test "$with_udev" = "yes"; then
+	PKG_CHECK_EXISTS(libudev >= 218, [with_dev_logging=no],
+			[with_udev_logging=yes])
+	if test "$with_udev_logging" = "yes"; then
+		AC_DEFINE_UNQUOTED([HAVE_UDEV_LOGGING], 1,
+				[whether libudev logging can be used])
+	fi
+    fi
 ])
 
 dnl Generate doc/man/*.in files if possible
diff --git a/src/rdma-ndd.c b/src/rdma-ndd.c
index 94eb3d72a354..986082457a61 100644
--- a/src/rdma-ndd.c
+++ b/src/rdma-ndd.c
@@ -232,6 +232,7 @@ static int process_opts(void *context, int ch, char *optarg)
 	return 0;
 }
 
+#if HAVE_UDEV_LOGGING
 #define MSG_MAX 2048
 static void udev_log_fn(struct udev *ud, int priority, const char *file, int line,
 		const char *fn, const char *format, va_list args)
@@ -244,6 +245,7 @@ static void udev_log_fn(struct udev *ud, int priority, const char *file, int lin
 		vsnprintf(msg+off, MSG_MAX-off, format, args);
 	syslog(LOG_ERR, "%s", msg);
 }
+#endif
 
 static void setup_udev(void)
 {
@@ -253,8 +255,10 @@ static void setup_udev(void)
 		return;
 	}
 
+#if HAVE_UDEV_LOGGING
 	udev_set_log_fn(udev, udev_log_fn);
 	udev_set_log_priority(udev, LOG_INFO);
+#endif
 }
 
 static int get_udev_fd(void)
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
