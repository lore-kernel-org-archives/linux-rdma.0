From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 1/5] load_drivers: reset the list head after releasing items
Date: Thu, 31 Mar 2011 11:29:21 +0200
Message-ID: <aa8c4f59ed5624568a8530b270a8e7fe9f3c2dc6.1301562707.git.ydroneaud@opteya.com>
References: <cover.1301562707.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In some failure cases, load_drivers() could be called multiple times.
Each time, it will try to free item from driver_name_list, but it doesn't
reset the list head.

Spotted using zzuf.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/init.c b/src/init.c
index 4f0130e..9e235e8 100644
--- a/src/init.c
+++ b/src/init.c
@@ -232,6 +232,8 @@ static void load_drivers(void)
 		free(name->name);
 		free(name);
 	}
+
+	driver_name_list = NULL;
 }
 
 static void read_config_file(const char *path)
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
