From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v2 06/11] read_config_file(): check opened file
Date: Thu,  8 Aug 2013 21:40:49 +0200
Message-ID: <bf328dc9243fd70a41942c1ad101c065783319cf.1375952089.git.ydroneaud@opteya.com>
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

Use fstat() to check the parameters of the opened file instead
of checking the path. This is basic Time-Of-Check / Time-Of-Use
(TOCTOU) issue.

Weakness addressed:

- CWE-363: Race Condition Enabling Link Following
<http://cwe.mitre.org/data/definitions/363.html>

- CWE-367: Time-of-check Time-of-use (TOCTOU) Race Condition
<http://cwe.mitre.org/data/definitions/367.html>

Secure coding:

- FIO01-C. Be careful using functions that use file names for identification
<https://www.securecoding.cert.org/confluence/display/seccode/FIO01-C.+Be+careful+using+functions+that+use+file+names+for+identification>

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/src/init.c b/src/init.c
index c260628..150adcf 100644
--- a/src/init.c
+++ b/src/init.c
@@ -246,23 +246,23 @@ static void read_config_file(int conf_dirfd, const char *name)
 	ssize_t len;
 	struct stat buf;
 
-	if (fstatat(conf_dirfd, name, &buf, 0)) {
-		fprintf(stderr, PFX "Warning: couldn't stat config file '%s/%s'.\n",
+	fd = openat(conf_dirfd, name, O_RDONLY | O_CLOEXEC);
+	if (fd == -1) {
+		fprintf(stderr, PFX "Warning: couldn't read config file '%s/%s'.\n",
 			IBV_CONFIG_DIR, name);
 		return;
 	}
 
-	if (!S_ISREG(buf.st_mode)) {
-		fprintf(stderr, PFX "Warning: invalid config file '%s/%s'.\n",
+	if (fstat(fd, &buf)) {
+		fprintf(stderr, PFX "Warning: couldn't stat config file '%s/%s'.\n",
 			IBV_CONFIG_DIR, name);
-		return;
+		goto out;
 	}
 
-	fd = openat(conf_dirfd, name, O_RDONLY | O_CLOEXEC);
-	if (fd == -1) {
-		fprintf(stderr, PFX "Warning: couldn't read config file '%s/%s'.\n",
+	if (!S_ISREG(buf.st_mode)) {
+		fprintf(stderr, PFX "Warning: invalid config file '%s/%s'.\n",
 			IBV_CONFIG_DIR, name);
-		return;
+		goto out;
 	}
 
 	conf = fdopen(fd, "r" STREAM_CLOEXEC);
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
