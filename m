From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/3] read_config: ignore directory entry with backup suffix (~)
Date: Mon, 20 May 2013 23:43:04 +0200
Message-ID: <efd912bd0a555c60c10a2160318f8048fdcd60b4.1369085762.git.ydroneaud@opteya.com>
References: <cover.1369085762.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1369085762.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Try to protect libibverbs from hand modified configuration files.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/src/init.c b/src/init.c
index c880b68..1981da7 100644
--- a/src/init.c
+++ b/src/init.c
@@ -311,6 +311,9 @@ static void read_config(void)
 		if (dent->d_name[0] == '.')
 			continue;
 
+		if (dent->d_name[0] == '\0' || dent->d_name[strlen(dent->d_name) - 1] == '~')
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
