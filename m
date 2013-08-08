From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH libibverbs v2 01/11] read_config(): ignore files beginning
 with '.'
Date: Thu,  8 Aug 2013 21:40:44 +0200
Message-ID: <51be8e667556fbbed2e68d1041890bd1372325a0.1375952089.git.ydroneaud@opteya.com>
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

Files beginning with a dot '.' are likely the current and parent
directories, or, hidden files ignored by 'ls'.

Those paths are already skipped in find_sysfs_dev()
they should probably be skipped here too.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/init.c b/src/init.c
index 8e93f3f..ce9e1c0 100644
--- a/src/init.c
+++ b/src/init.c
@@ -306,6 +306,9 @@ static void read_config(void)
 	while ((dent = readdir(conf_dir))) {
 		struct stat buf;
 
+		if (dent->d_name[0] == '.')
+			continue;
+
 		if (asprintf(&path, "%s/%s", IBV_CONFIG_DIR, dent->d_name) < 0) {
 			fprintf(stderr, PFX "Warning: couldn't read config file %s/%s.\n",
 				IBV_CONFIG_DIR, dent->d_name);
-- 
1.8.3.1
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
