From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/3] read_config: skip file/directory with unsecure permissions
Date: Mon, 20 May 2013 23:43:05 +0200
Message-ID: <0a6888edc9d7899fe3b4af249c4f25088e196422.1369085762.git.ydroneaud@opteya.com>
References: <cover.1369085762.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1369085762.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

libibverbs must refuse to load arbitrary shared objects.

This patch check the configuration directory and files for
- being owned by root;
- not being writable by others.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c | 23 +++++++++++++++++++++--
 1 file changed, 21 insertions(+), 2 deletions(-)

diff --git a/src/init.c b/src/init.c
index 1981da7..a37b57d 100644
--- a/src/init.c
+++ b/src/init.c
@@ -294,10 +294,24 @@ static void read_config_file(const char *path)
 
 static void read_config(void)
 {
+	struct stat buf;
 	DIR *conf_dir;
 	struct dirent *dent;
 	char *path;
 
+	if (stat(IBV_CONFIG_DIR, &buf) || !S_ISDIR(buf.st_mode)) {
+		fprintf(stderr, PFX "Warning: couldn't stat config directory '%s'.\n",
+			IBV_CONFIG_DIR);
+		return;
+	}
+
+	if (buf.st_uid != 0 || buf.st_gid != 0 ||
+	    (buf.st_mode & S_IWOTH) != 0) {
+		fprintf(stderr, PFX "Warning: unsecure config directory '%s'.\n",
+			IBV_CONFIG_DIR);
+		return;
+	}
+
 	conf_dir = opendir(IBV_CONFIG_DIR);
 	if (!conf_dir) {
 		fprintf(stderr, PFX "Warning: couldn't open config directory '%s'.\n",
@@ -306,8 +320,6 @@ static void read_config(void)
 	}
 
 	while ((dent = readdir(conf_dir))) {
-		struct stat buf;
-
 		if (dent->d_name[0] == '.')
 			continue;
 
@@ -329,6 +341,13 @@ static void read_config(void)
 		if (!S_ISREG(buf.st_mode))
 			goto next;
 
+		if (buf.st_uid != 0 || buf.st_gid != 0 ||
+		    (buf.st_mode & S_IWOTH) != 0) {
+			fprintf(stderr, PFX "Warning: unsecure config file '%s'.\n",
+				path);
+			goto next;
+		}
+
 		read_config_file(path);
 next:
 		free(path);
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
