From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 3/5] read_config: don't try to open file beginning with '.'
Date: Thu, 31 Mar 2011 11:29:23 +0200
Message-ID: <aa79e6cff5121994d60fb10315ce54e5a2dc63af.1301562707.git.ydroneaud@opteya.com>
References: <cover.1301562707.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Files beginning with a dot are mostly current and parent directories or,
by convention, hidden files.

Those path are skipped in find_sysfs_dev().

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/src/init.c b/src/init.c
index bdc1634..46ff24c 100644
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
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
