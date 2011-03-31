From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH 2/5] ibverbs_init: reset the list head after releasing items
Date: Thu, 31 Mar 2011 11:29:22 +0200
Message-ID: <d50403cd01c144591dad2ec51c12a81bfa0d6deb.1301562707.git.ydroneaud@opteya.com>
References: <cover.1301562707.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1301562707.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

In some cases, ibverbs_init() could be called multiple times.
After the first time, find_sysfs_devs() will add sysfs dev entry
to the invalid sysfs_dev_list head.
If you're really unlucky, the last sysfs_dev->next will point to sysfs_dev,
and ibverbs_init() will be stuck in an infinite loop.

Spotted using zzuf.

Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
---
 src/init.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/src/init.c b/src/init.c
index 9e235e8..bdc1634 100644
--- a/src/init.c
+++ b/src/init.c
@@ -539,5 +539,7 @@ out:
 		free(sysfs_dev);
 	}
 
+	sysfs_dev_list = NULL;
+
 	return num_devices;
 }
-- 
1.7.4.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
