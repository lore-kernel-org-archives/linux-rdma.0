From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 5/5] read_config_file: ignore driver line without driver name
Date: Thu, 31 Mar 2011 11:29:25 +0200
Message-ID: <d6d3d428fcea4a4f78287204c00bd40bc7d7a7c5.1301562707.git.ydroneaud@opteya.com>
References: <cover.1301562707.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

If there's no driver name, strsep() will set config to NULL and later
process of driver name will segfault.

Spotted with zzuf.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/init.c b/src/init.c
index dd6fb00..4d3d081 100644
--- a/src/init.c
+++ b/src/init.c
@@ -259,7 +259,7 @@ static void read_config_file(const char *path)
 
 		field = strsep(&config, "\n\t ");
 
-		if (strcmp(field, "driver") == 0) {
+		if (strcmp(field, "driver") == 0 && config != NULL) {
 			struct ibv_driver_name *driver_name;
 
 			config += strspn(config, "\t ");
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
