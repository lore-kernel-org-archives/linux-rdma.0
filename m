From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v2 03/11] read_config(): open configuration
 directory with open()
Date: Thu,  8 Aug 2013 21:40:46 +0200
Message-ID: <1481ee18014b5df0f80cf2d5196e1b6c3465600e.1375952089.git.ydroneaud@opteya.com>
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

Get a file descriptor pointing to the IBV_CONFIG_DIR,
so that it could be used with fstatat() and openat() later.

Use fdopendir()[1][2] after open()'ing the directory instead
of opendir().

Compatibility note:

- According to Gnulib, fdopendir() is not available on older systems.
<http://www.gnu.org/software/gnulib/manual/html_node/fdopendir.html>

Links:

- [1] fdopendir
<http://pubs.opengroup.org/onlinepubs/9699919799/functions/fdopendir.html>

- [2] fdopendir(3)
<http://man7.org/linux/man-pages/man3/fdopendir.3.html>

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c | 12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/src/init.c b/src/init.c
index e67469e..34150b5 100644
--- a/src/init.c
+++ b/src/init.c
@@ -45,6 +45,7 @@
 #include <sys/types.h>
 #include <sys/time.h>
 #include <sys/resource.h>
+#include <fcntl.h>
 #include <dirent.h>
 #include <errno.h>
 
@@ -292,14 +293,23 @@ static void read_config_file(const char *path)
 
 static void read_config(void)
 {
+	int conf_dirfd;
 	DIR *conf_dir;
 	struct dirent *dent;
 	char *path;
 
-	conf_dir = opendir(IBV_CONFIG_DIR);
+	conf_dirfd = open(IBV_CONFIG_DIR, O_RDONLY | O_CLOEXEC);
+	if (conf_dirfd == -1) {
+		fprintf(stderr, PFX "Warning: couldn't open config directory '%s'.\n",
+			IBV_CONFIG_DIR);
+		return;
+	}
+
+	conf_dir = fdopendir(conf_dirfd);
 	if (!conf_dir) {
 		fprintf(stderr, PFX "Warning: couldn't open config directory '%s'.\n",
 			IBV_CONFIG_DIR);
+		close(conf_dirfd);
 		return;
 	}
 
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
