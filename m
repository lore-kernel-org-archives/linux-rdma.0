From: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
Subject: [PATCH] ib: Init subsystems if compiled to vmlinuz-core
Date: Wed, 29 Nov 2017 09:09:49 +0000
Message-ID: <20171129090949.27602-1-dmonakhov@openvz.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Once infiniband was compiled as core component it's subsystems must be
enabled before device initialization. Otherwise this result NULL pointer
dereference during mlx4_core init, calltrace:
->device_add
  if (dev->class) {
     deref  dev->class->p =>NULLPTR

#Config
CONFIG_NET_DEVLINK=y
CONFIG_MAY_USE_DEVLINK=y
CONFIG_MLX4_EN=y

Signed-off-by: Dmitry Monakhov <dmonakhov-GEFAQzZX7r8dnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/cm.c        | 2 +-
 drivers/infiniband/core/device.c    | 2 +-
 drivers/infiniband/ulp/srp/ib_srp.c | 2 +-
 3 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/infiniband/core/cm.c b/drivers/infiniband/core/cm.c
index 4c4b465..1012fd8 100644
--- a/drivers/infiniband/core/cm.c
+++ b/drivers/infiniband/core/cm.c
@@ -4370,6 +4370,6 @@ static void __exit ib_cm_cleanup(void)
 	idr_destroy(&cm.local_id_table);
 }
 
-module_init(ib_cm_init);
+subsys_initcall(ib_cm_init);
 module_exit(ib_cm_cleanup);
 
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 84fc32a..5e1be49 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -1253,5 +1253,5 @@ static void __exit ib_core_cleanup(void)
 
 MODULE_ALIAS_RDMA_NETLINK(RDMA_NL_LS, 4);
 
-module_init(ib_core_init);
+subsys_initcall(ib_core_init);
 module_exit(ib_core_cleanup);
diff --git a/drivers/infiniband/ulp/srp/ib_srp.c b/drivers/infiniband/ulp/srp/ib_srp.c
index fa5ccdb..0c21a71 100644
--- a/drivers/infiniband/ulp/srp/ib_srp.c
+++ b/drivers/infiniband/ulp/srp/ib_srp.c
@@ -3785,5 +3785,5 @@ static void __exit srp_cleanup_module(void)
 	destroy_workqueue(srp_remove_wq);
 }
 
-module_init(srp_init_module);
+subsys_initcall(srp_init_module);
 module_exit(srp_cleanup_module);
-- 
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
