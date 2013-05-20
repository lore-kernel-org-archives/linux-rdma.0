From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] open files with close on exec flag
Date: Tue, 21 May 2013 00:33:08 +0200
Message-ID: <1369089188-23148-1-git-send-email-ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

File opened by libibverbs are not supposed to be inherited
across exec*(), most of the files are of no use for another program,
and others cannot be used without the associated memory mapping.

This patch changes open() and fopen() to always set close on exec flag.

This patch also add checks to configure to guess if fopen() supports "e"
flag. If O_CLOEXEC and SOCK_CLOEXEC are supported, fopen() should support
"e". If not supported, its discarded according to POSIX. Many operating systems
have support for fopen("e").

You might find more information about close on exec in the following articles:

- "Excuse me son, but your code is leaking !!!" by Dan Walsh
http://danwalsh.livejournal.com/53603.html

- "Secure File Descriptor Handling" by Ulrich Drepper
http://udrepper.livejournal.com/20407.html

Note: this patch won't set close on exec flag on file descriptors
created by the kernel for completion channel and such. This should
be addressed by a kernel patch.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 configure.ac | 21 +++++++++++++++++++++
 src/device.c |  2 +-
 src/init.c   |  2 +-
 src/memory.c |  2 +-
 src/sysfs.c  |  2 +-
 5 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/configure.ac b/configure.ac
index efdc5ac..8f79891 100644
--- a/configure.ac
+++ b/configure.ac
@@ -44,9 +44,30 @@ AC_CHECK_HEADER(valgrind/memcheck.h,
     [if test $want_valgrind = yes; then
         AC_MSG_ERROR([Valgrind memcheck support requested, but <valgrind/memcheck.h> not found.])
     fi])
+AC_CHECK_HEADERS([fcntl.h sys/socket.h])
 
 dnl Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
+AC_CHECK_DECLS([O_CLOEXEC],,[AC_DEFINE([O_CLOEXEC],[0], [Defined to 0 if not provided])],
+[[
+#ifdef HAVE_FCNTL_H
+# include <fcntl.h>
+#endif
+]])
+AC_CHECK_DECLS([SOCK_CLOEXEC],,[AC_DEFINE([SOCK_CLOEXEC],[0],[Defined to 0 if not provided])],
+[[
+#ifdef HAVE_SYS_SOCKET_H
+# include <sys/socket.h>
+#endif
+]])
+
+AC_CACHE_CHECK(for close on exec modifier for fopen(), ac_cv_feature_stream_cloexec_flag,
+   [if test $ac_cv_have_decl_O_CLOEXEC = yes ; then
+        if test $ac_cv_have_decl_SOCK_CLOEXEC = yes ; then
+            ac_cv_feature_stream_cloexec_flag="e"
+        fi
+    fi])
+AC_DEFINE_UNQUOTED([STREAM_CLOEXEC], "$ac_cv_feature_stream_cloexec_flag", [fopen() modifier for setting close on exec flag])
 
 AC_CACHE_CHECK(whether ld accepts --version-script, ac_cv_version_script,
     [if test -n "`$LD --help < /dev/null 2>/dev/null | grep version-script`"; then
diff --git a/src/device.c b/src/device.c
index 5798895..1923fa5 100644
--- a/src/device.c
+++ b/src/device.c
@@ -135,7 +135,7 @@ struct ibv_context *__ibv_open_device(struct ibv_device *device)
 	 * We'll only be doing writes, but we need O_RDWR in case the
 	 * provider needs to mmap() the file.
 	 */
-	cmd_fd = open(devpath, O_RDWR);
+	cmd_fd = open(devpath, O_RDWR | O_CLOEXEC);
 	free(devpath);
 
 	if (cmd_fd < 0)
diff --git a/src/init.c b/src/init.c
index 8d6786e..8e93f3f 100644
--- a/src/init.c
+++ b/src/init.c
@@ -243,7 +243,7 @@ static void read_config_file(const char *path)
 	size_t buflen = 0;
 	ssize_t len;
 
-	conf = fopen(path, "r");
+	conf = fopen(path, "r" STREAM_CLOEXEC);
 	if (!conf) {
 		fprintf(stderr, PFX "Warning: couldn't read config file %s.\n",
 			path);
diff --git a/src/memory.c b/src/memory.c
index 7d97e55..e9d1eec 100644
--- a/src/memory.c
+++ b/src/memory.c
@@ -109,7 +109,7 @@ static unsigned long get_page_size(void *base)
 	pid = getpid();
 	snprintf(buf, sizeof(buf), "/proc/%d/smaps", pid);
 
-	file = fopen(buf, "r");
+	file = fopen(buf, "r" STREAM_CLOEXEC);
 	if (!file)
 		goto out;
 
diff --git a/src/sysfs.c b/src/sysfs.c
index 85aee39..e031631 100644
--- a/src/sysfs.c
+++ b/src/sysfs.c
@@ -85,7 +85,7 @@ int ibv_read_sysfs_file(const char *dir, const char *file,
 	if (asprintf(&path, "%s/%s", dir, file) < 0)
 		return -1;
 
-	fd = open(path, O_RDONLY);
+	fd = open(path, O_RDONLY | O_CLOEXEC);
 	if (fd < 0) {
 		free(path);
 		return -1;
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
