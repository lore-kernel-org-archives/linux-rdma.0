From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v2 08/11] read_config(): refuse to open
 IBV_CONFIG_DIR if it's not a directory
Date: Thu,  8 Aug 2013 21:40:51 +0200
Message-ID: <64fd9c35244a9d3ed56f77b049accb00b9ec95e9.1375952089.git.ydroneaud@opteya.com>
References: <cover.1375952089.git.ydroneaud@opteya.com>
Mime-Version: 1.0
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1375952089.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1375952089.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1375952089.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

O_DIRECTORY is an option to open() to ensure the given path
is a directory. If IBV_CONFIG_DIR path is not pointing
to a directory, open() will failed.

Note: if IBV_CONFIG_DIR is a symlink, it will be followed.
O_DIRECTORY doesn't disable path resolution.

See open()[1][2] for more information.

Links:

- [1] open
<http://pubs.opengroup.org/onlinepubs/9699919799/functions/open.html>

- [2] open(2)
<http://man7.org/linux/man-pages/man2/open.2.html>

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 configure.ac | 6 ++++++
 src/init.c   | 2 +-
 2 files changed, 7 insertions(+), 1 deletion(-)

diff --git a/configure.ac b/configure.ac
index b8d4cea..9544726 100644
--- a/configure.ac
+++ b/configure.ac
@@ -46,6 +46,12 @@ AC_CHECK_HEADERS([fcntl.h sys/socket.h])
 
 dnl Checks for typedefs, structures, and compiler characteristics.
 AC_C_CONST
+AC_CHECK_DECLS([O_DIRECTORY],,[AC_DEFINE([O_DIRECTORY],[0], [Defined to 0 if not provided])],
+[[
+#ifdef HAVE_FCNTL_H
+# include <fcntl.h>
+#endif
+]])
 AC_CHECK_DECLS([O_CLOEXEC],,[AC_DEFINE([O_CLOEXEC],[0], [Defined to 0 if not provided])],
 [[
 #ifdef HAVE_FCNTL_H
diff --git a/src/init.c b/src/init.c
index 0e3cdf0..c2e7bfb 100644
--- a/src/init.c
+++ b/src/init.c
@@ -325,7 +325,7 @@ static void read_config(void)
 	struct dirent *dent;
 	struct stat buf;
 
-	conf_dirfd = open(IBV_CONFIG_DIR, O_RDONLY | O_CLOEXEC);
+	conf_dirfd = open(IBV_CONFIG_DIR, O_RDONLY | O_DIRECTORY | O_CLOEXEC);
 	if (conf_dirfd == -1) {
 		fprintf(stderr, PFX "Warning: couldn't open config directory '%s'.\n",
 			IBV_CONFIG_DIR);
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
