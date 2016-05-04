From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 1/4] IB/netlink: Make ib_netlink a standalone module
Date: Wed,  4 May 2016 18:41:55 +0300
Message-ID: <1462376518-6725-2-git-send-email-leon@kernel.org>
References: <1462376518-6725-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1462376518-6725-1-git-send-email-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

ib_netlink is initialized by ib_core, which means that any module
ib_core depends on (ib_addr for example) can't use ib_netlink.

Let's turn ib_netlink to be standalone module, so it could be
used by any IB component.

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/core/Makefile  | 6 ++++--
 drivers/infiniband/core/device.c  | 9 ---------
 drivers/infiniband/core/netlink.c | 9 ++++++++-
 3 files changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index f818538..73a044b 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -3,13 +3,13 @@ user_access-$(CONFIG_INFINIBAND_ADDR_TRANS)	:= rdma_ucm.o
 
 obj-$(CONFIG_INFINIBAND) +=		ib_core.o ib_mad.o ib_sa.o \
 					ib_cm.o iw_cm.o ib_addr.o \
-					$(infiniband-y)
+					ib_netlink.o $(infiniband-y)
 obj-$(CONFIG_INFINIBAND_USER_MAD) +=	ib_umad.o
 obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 					$(user_access-y)
 
 ib_core-y :=			packer.o ud_header.o verbs.o cq.o sysfs.o \
-				device.o fmr_pool.o cache.o netlink.o \
+				device.o fmr_pool.o cache.o \
 				roce_gid_mgmt.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
@@ -18,6 +18,8 @@ ib_mad-y :=			mad.o smi.o agent.o mad_rmpp.o
 
 ib_sa-y :=			sa_query.o multicast.o
 
+ib_netlink-y :=			netlink.o
+
 ib_cm-y :=			cm.o
 
 iw_cm-y :=			iwcm.o iwpm_util.o iwpm_msg.o
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 1097984..e482164 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -977,18 +977,10 @@ static int __init ib_core_init(void)
 		goto err_comp;
 	}
 
-	ret = ibnl_init();
-	if (ret) {
-		pr_warn("Couldn't init IB netlink interface\n");
-		goto err_sysfs;
-	}
-
 	ib_cache_setup();
 
 	return 0;
 
-err_sysfs:
-	class_unregister(&ib_class);
 err_comp:
 	destroy_workqueue(ib_comp_wq);
 err:
@@ -999,7 +991,6 @@ err:
 static void __exit ib_core_cleanup(void)
 {
 	ib_cache_cleanup();
-	ibnl_cleanup();
 	class_unregister(&ib_class);
 	destroy_workqueue(ib_comp_wq);
 	/* Make sure that any pending umem accounting work is done. */
diff --git a/drivers/infiniband/core/netlink.c b/drivers/infiniband/core/netlink.c
index aa491f7..ff2dcbb 100644
--- a/drivers/infiniband/core/netlink.c
+++ b/drivers/infiniband/core/netlink.c
@@ -38,6 +38,10 @@
 #include <net/sock.h>
 #include <rdma/rdma_netlink.h>
 
+MODULE_AUTHOR("Roland Dreier");
+MODULE_DESCRIPTION("RDMA netlink infrastructure");
+MODULE_LICENSE("Dual BSD/GPL");
+
 struct ibnl_client {
 	struct list_head		list;
 	int				index;
@@ -255,7 +259,7 @@ int __init ibnl_init(void)
 	return 0;
 }
 
-void ibnl_cleanup(void)
+void __exit ibnl_cleanup(void)
 {
 	struct ibnl_client *cur, *next;
 
@@ -268,3 +272,6 @@ void ibnl_cleanup(void)
 
 	netlink_kernel_release(nls);
 }
+
+module_init(ibnl_init);
+module_exit(ibnl_cleanup);
-- 
2.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
