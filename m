From: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH V2 3/5] IB Core: Run Netlink
Date: Mon, 29 Nov 2010 18:16:37 +0200
Message-ID: <1291047399-430-4-git-send-email-nirm@voltaire.com>
References: <1291047399-430-1-git-send-email-nirm@voltaire.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1291047399-430-1-git-send-email-nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, monis-smomgflXvOZWk0Htik3J/w@public.gmane.org, ogerlitz-smomgflXvOZWk0Htik3J/w@public.gmane.org, nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Include and initialize IB netlink from IB core.

Signed-off-by: Nir Muchtar <nirm-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile |    2 +-
 drivers/infiniband/core/device.c |   11 +++++++++++
 2 files changed, 12 insertions(+), 1 deletions(-)

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index cb1ab3e..c8bbaef 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -8,7 +8,7 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 					$(user_access-y)
 
 ib_core-y :=			packer.o ud_header.o verbs.o sysfs.o \
-				device.o fmr_pool.o cache.o
+				device.o fmr_pool.o cache.o netlink.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 
 ib_mad-y :=			mad.o smi.o agent.o mad_rmpp.o
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 6e06e37..3229102 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -40,6 +40,8 @@
 #include <linux/mutex.h>
 #include <linux/workqueue.h>
 
+#include <net/ib_netlink.h>
+
 #include "core_priv.h"
 
 MODULE_AUTHOR("Roland Dreier");
@@ -730,8 +732,16 @@ static int __init ib_core_init(void)
 		goto err_sysfs;
 	}
 
+	ret = ibnl_init();
+	if (ret) {
+		printk(KERN_WARNING "Couldn't init IB netlink interface\n");
+		goto err_cache;
+	}
+
 	return 0;
 
+err_cache:
+	ib_cache_cleanup();
 err_sysfs:
 	ib_sysfs_cleanup();
 err:
@@ -740,6 +750,7 @@ err:
 
 static void __exit ib_core_cleanup(void)
 {
+	ibnl_cleanup();
 	ib_cache_cleanup();
 	ib_sysfs_cleanup();
 	/* Make sure that any pending umem accounting work is done. */
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
