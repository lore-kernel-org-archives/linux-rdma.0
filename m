From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [rdma-next,V1 1/4] IB/core: Integrate IB address resolution module into core
Date: Wed, 18 May 2016 17:57:23 +0300
Message-ID: <1463583446-30027-2-git-send-email-markb@mellanox.com>
References: <1463583446-30027-1-git-send-email-markb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463583446-30027-1-git-send-email-markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

IB address resolution is declared as a module (ib_addr.ko) which loads
itself before IB core module (ib_core.ko).

It causes to the scenario where IB netlink which is initialized by IB
core can't be used by ib_addr.ko.

In order to solve it, we are converting ib_addr.ko to be part of
IB core module.

Signed-off-by: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile |  6 ++----
 drivers/infiniband/core/addr.c   | 11 ++---------
 drivers/infiniband/core/device.c |  9 +++++++++
 include/rdma/ib_addr.h           |  3 +++
 4 files changed, 16 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 26987d9..209838d 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -2,7 +2,7 @@ infiniband-$(CONFIG_INFINIBAND_ADDR_TRANS)	:= rdma_cm.o
 user_access-$(CONFIG_INFINIBAND_ADDR_TRANS)	:= rdma_ucm.o
 
 obj-$(CONFIG_INFINIBAND) +=		ib_core.o ib_mad.o ib_sa.o \
-					ib_cm.o iw_cm.o ib_addr.o \
+					ib_cm.o iw_cm.o \
 					$(infiniband-y)
 obj-$(CONFIG_INFINIBAND_USER_MAD) +=	ib_umad.o
 obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
@@ -10,7 +10,7 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 
 ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o \
-				roce_gid_mgmt.o mr_pool.o
+				roce_gid_mgmt.o mr_pool.o addr.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
 
@@ -28,8 +28,6 @@ rdma_cm-$(CONFIG_INFINIBAND_ADDR_TRANS_CONFIGFS) += cma_configfs.o
 
 rdma_ucm-y :=			ucma.o
 
-ib_addr-y :=			addr.o
-
 ib_umad-y :=			user_mad.o
 
 ib_ucm-y :=			ucm.o
diff --git a/drivers/infiniband/core/addr.c b/drivers/infiniband/core/addr.c
index 337353d..3a203ee 100644
--- a/drivers/infiniband/core/addr.c
+++ b/drivers/infiniband/core/addr.c
@@ -47,10 +47,6 @@
 #include <rdma/ib_addr.h>
 #include <rdma/ib.h>
 
-MODULE_AUTHOR("Sean Hefty");
-MODULE_DESCRIPTION("IB Address Translation");
-MODULE_LICENSE("Dual BSD/GPL");
-
 struct addr_req {
 	struct list_head list;
 	struct sockaddr_storage src_addr;
@@ -634,7 +630,7 @@ static struct notifier_block nb = {
 	.notifier_call = netevent_callback
 };
 
-static int __init addr_init(void)
+int addr_init(void)
 {
 	addr_wq = create_singlethread_workqueue("ib_addr");
 	if (!addr_wq)
@@ -645,12 +641,9 @@ static int __init addr_init(void)
 	return 0;
 }
 
-static void __exit addr_cleanup(void)
+void addr_cleanup(void)
 {
 	rdma_addr_unregister_client(&self);
 	unregister_netevent_notifier(&nb);
 	destroy_workqueue(addr_wq);
 }
-
-module_init(addr_init);
-module_exit(addr_cleanup);
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 1097984..805d72d 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -983,10 +983,18 @@ static int __init ib_core_init(void)
 		goto err_sysfs;
 	}
 
+	ret = addr_init();
+	if (ret) {
+		pr_warn("Could't init IB address resolution\n");
+		goto err_ibnl;
+	}
+
 	ib_cache_setup();
 
 	return 0;
 
+err_ibnl:
+	ibnl_cleanup();
 err_sysfs:
 	class_unregister(&ib_class);
 err_comp:
@@ -999,6 +1007,7 @@ err:
 static void __exit ib_core_cleanup(void)
 {
 	ib_cache_cleanup();
+	addr_cleanup();
 	ibnl_cleanup();
 	class_unregister(&ib_class);
 	destroy_workqueue(ib_comp_wq);
diff --git a/include/rdma/ib_addr.h b/include/rdma/ib_addr.h
index 931a47b..e276a07 100644
--- a/include/rdma/ib_addr.h
+++ b/include/rdma/ib_addr.h
@@ -54,6 +54,9 @@ struct rdma_addr_client {
 	struct completion comp;
 };
 
+int addr_init(void);
+void addr_cleanup(void);
+
 /**
  * rdma_addr_register_client - Register an address client.
  */
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
