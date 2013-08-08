From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v2 07/11] read_config(): check opened directory
Date: Thu,  8 Aug 2013 21:40:50 +0200
Message-ID: <056f86d1d21882e330c4035a8c5618e1d4fea381.1375952089.git.ydroneaud@opteya.com>
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

After opening the directory, call fstat() on directory file
descriptor so that its parameters can be checked later.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/src/init.c b/src/init.c
index 150adcf..0e3cdf0 100644
--- a/src/init.c
+++ b/src/init.c
@@ -323,6 +323,7 @@ static void read_config(void)
 	int conf_dirfd;
 	DIR *conf_dir;
 	struct dirent *dent;
+	struct stat buf;
 
 	conf_dirfd = open(IBV_CONFIG_DIR, O_RDONLY | O_CLOEXEC);
 	if (conf_dirfd == -1) {
@@ -331,12 +332,23 @@ static void read_config(void)
 		return;
 	}
 
+	if (fstat(conf_dirfd, &buf)) {
+		fprintf(stderr, PFX "Warning: couldn't stat config directory '%s'.\n",
+			IBV_CONFIG_DIR);
+		goto out;
+	}
+
+	if (!S_ISDIR(buf.st_mode)) {
+		fprintf(stderr, PFX "Warning: invalid config directory '%s'.\n",
+			IBV_CONFIG_DIR);
+		goto out;
+	}
+
 	conf_dir = fdopendir(conf_dirfd);
 	if (!conf_dir) {
 		fprintf(stderr, PFX "Warning: couldn't open config directory '%s'.\n",
 			IBV_CONFIG_DIR);
-		close(conf_dirfd);
-		return;
+		goto out;
 	}
 
 	while ((dent = readdir(conf_dir))) {
@@ -351,6 +363,11 @@ static void read_config(void)
 	}
 
 	closedir(conf_dir);
+
+	return;
+
+out:
+	close(conf_dirfd);
 }
 
 static struct ibv_device *try_driver(struct ibv_driver *driver,
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
