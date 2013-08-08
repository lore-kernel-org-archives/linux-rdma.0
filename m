From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v2 11/11] read_config_file(): refuse to open
 configuration file if it's symlink
Date: Thu,  8 Aug 2013 21:40:54 +0200
Message-ID: <841fe809c4767b67b850c2cce4ea5d66160266c1.1375952089.git.ydroneaud@opteya.com>
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

O_NOFOLLOW is an option to open() that allows application
to not follow symlinks when opening a path.

Using this option, openat() will fail if the configuration file is a symlink.

See open()[1][2] for more information on O_NOFOLLOW.

Weakness addressed:

- CWE-59: Improper Link Resolution Before File Access ('Link Following')
<http://cwe.mitre.org/data/definitions/59.html>

- CWE-61: UNIX Symbolic Link (Symlink) Following
<http://cwe.mitre.org/data/definitions/61.html>

- CWE-363: Race Condition Enabling Link Following
<http://cwe.mitre.org/data/definitions/363.html>

- CWE-367: Time-of-check Time-of-use (TOCTOU) Race Condition
<http://cwe.mitre.org/data/definitions/367.html>

Secure coding:

- POS01-C. Check for the existence of links when dealing with files
<https://www.securecoding.cert.org/confluence/display/seccode/POS01-C.+Check+for+the+existence+of+links+when+dealing+with+files>

- POS35-C. Avoid race conditions while checking for the existence of a symbolic link
<https://www.securecoding.cert.org/confluence/display/seccode/POS35-C.+Avoid+race+conditions+while+checking+for+the+existence+of+a+symbolic+link>

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
index 9544726..7e7bc63 100644
--- a/configure.ac
+++ b/configure.ac
@@ -52,6 +52,12 @@ AC_CHECK_DECLS([O_DIRECTORY],,[AC_DEFINE([O_DIRECTORY],[0], [Defined to 0 if not
 # include <fcntl.h>
 #endif
 ]])
+AC_CHECK_DECLS([O_NOFOLLOW],,[AC_DEFINE([O_NOFOLLOW],[0], [Defined to 0 if not provided])],
+[[
+#ifdef HAVE_FCNTL_H
+# include <fcntl.h>
+#endif
+]])
 AC_CHECK_DECLS([O_CLOEXEC],,[AC_DEFINE([O_CLOEXEC],[0], [Defined to 0 if not provided])],
 [[
 #ifdef HAVE_FCNTL_H
diff --git a/src/init.c b/src/init.c
index 0b46b78..0af6c47 100644
--- a/src/init.c
+++ b/src/init.c
@@ -269,7 +269,7 @@ static void read_config_file(int conf_dirfd, const char *name)
 	ssize_t len;
 	struct stat buf;
 
-	fd = openat(conf_dirfd, name, O_RDONLY | O_CLOEXEC);
+	fd = openat(conf_dirfd, name, O_RDONLY | O_NOFOLLOW | O_CLOEXEC);
 	if (fd == -1) {
 		fprintf(stderr, PFX "Warning: couldn't read config file '%s/%s'.\n",
 			IBV_CONFIG_DIR, name);
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
