From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v2 04/11] read_config(): move file type check in
 read_config_file()
Date: Thu,  8 Aug 2013 21:40:47 +0200
Message-ID: <22fb4f5dcc4e545dfcc9168429e50c11bd3611ab.1375952089.git.ydroneaud@opteya.com>
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

Check the configuration file inside the function
parsing it.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c | 25 ++++++++++++++-----------
 1 file changed, 14 insertions(+), 11 deletions(-)

diff --git a/src/init.c b/src/init.c
index 34150b5..953ed9f 100644
--- a/src/init.c
+++ b/src/init.c
@@ -243,6 +243,19 @@ static void read_config_file(const char *path)
 	char *field;
 	size_t buflen = 0;
 	ssize_t len;
+	struct stat buf;
+
+	if (stat(path, &buf)) {
+		fprintf(stderr, PFX "Warning: couldn't stat config file '%s'.\n",
+			path);
+		return;
+	}
+
+	if (!S_ISREG(buf.st_mode)) {
+		fprintf(stderr, PFX "Warning: invalid config file '%s'.\n",
+			path);
+		return;
+	}
 
 	conf = fopen(path, "r" STREAM_CLOEXEC);
 	if (!conf) {
@@ -314,7 +327,6 @@ static void read_config(void)
 	}
 
 	while ((dent = readdir(conf_dir))) {
-		struct stat buf;
 
 		if (dent->d_name[0] == '.')
 			continue;
@@ -328,17 +340,8 @@ static void read_config(void)
 			goto out;
 		}
 
-		if (stat(path, &buf)) {
-			fprintf(stderr, PFX "Warning: couldn't stat config file '%s'.\n",
-				path);
-			goto next;
-		}
-
-		if (!S_ISREG(buf.st_mode))
-			goto next;
-
 		read_config_file(path);
-next:
+
 		free(path);
 	}
 
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
