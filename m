From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/3] read_config: ignore files beginning with '.'
Date: Mon, 20 May 2013 23:43:03 +0200
Message-ID: <669b29839e890998b68f85355f2feb8943c90c6e.1369085762.git.ydroneaud@opteya.com>
References: <cover.1369085762.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1369085762.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Files beginning with a dot are mostly current and parent directories or,
by convention, hidden files.

Those path are skipped in find_sysfs_dev().

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/init.c b/src/init.c
index 96ecf04..c880b68 100644
--- a/src/init.c
+++ b/src/init.c
@@ -308,6 +308,9 @@ static void read_config(void)
 	while ((dent = readdir(conf_dir))) {
 		struct stat buf;
 
+		if (dent->d_name[0] == '.')
+			continue;
+
 		if (asprintf(&path, "%s/%s", IBV_CONFIG_DIR, dent->d_name) < 0) {
 			fprintf(stderr, PFX "Warning: couldn't read config file %s/%s.\n",
 				IBV_CONFIG_DIR, dent->d_name);
-- 
1.7.11.7

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
