From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [rdma-next,V2 3/6] IB/SA: Integrate ib_sa module into ib_core module
Date: Thu, 19 May 2016 17:12:33 +0300
Message-ID: <1463667156-6518-4-git-send-email-leonro@mellanox.com>
References: <1463667156-6518-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463667156-6518-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Consolidate ib_sa into ib_core, this commit eliminates
ib_sa.ko and makes it part of ib_core.ko

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile    |  9 +++------
 drivers/infiniband/core/core_priv.h |  3 +++
 drivers/infiniband/core/device.c    |  9 +++++++++
 drivers/infiniband/core/sa_query.c  | 11 ++---------
 4 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index cc0a604..edaae9f 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -1,8 +1,7 @@
 infiniband-$(CONFIG_INFINIBAND_ADDR_TRANS)	:= rdma_cm.o
 user_access-$(CONFIG_INFINIBAND_ADDR_TRANS)	:= rdma_ucm.o
 
-obj-$(CONFIG_INFINIBAND) +=		ib_core.o ib_sa.o \
-					ib_cm.o iw_cm.o \
+obj-$(CONFIG_INFINIBAND) +=		ib_core.o ib_cm.o iw_cm.o \
 					$(infiniband-y)
 obj-$(CONFIG_INFINIBAND_USER_MAD) +=	ib_umad.o
 obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
@@ -10,13 +9,11 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 
 ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o \
-				roce_gid_mgmt.o mr_pool.o addr.o \
-				mad.o smi.o agent.o mad_rmpp.o
+				roce_gid_mgmt.o mr_pool.o addr.o sa_query.o \
+				multicast.o mad.o smi.o agent.o mad_rmpp.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
 
-ib_sa-y :=			sa_query.o multicast.o
-
 ib_cm-y :=			cm.o
 
 iw_cm-y :=			iwcm.o iwpm_util.o iwpm_msg.o
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index d43b2fa..c78a7fa 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -143,4 +143,7 @@ void addr_cleanup(void);
 int ib_mad_init(void);
 void ib_mad_cleanup(void);
 
+int ib_sa_init(void);
+void ib_sa_cleanup(void);
+
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index f80549f..300b92c 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -995,10 +995,18 @@ static int __init ib_core_init(void)
 		goto err_addr;
 	}
 
+	ret = ib_sa_init();
+	if (ret) {
+		pr_warn("Couldn't init SA\n");
+		goto err_mad;
+	}
+
 	ib_cache_setup();
 
 	return 0;
 
+err_mad:
+	ib_mad_cleanup();
 err_addr:
 	addr_cleanup();
 err_ibnl:
@@ -1016,6 +1024,7 @@ static void __exit ib_core_cleanup(void)
 {
 	ib_cache_cleanup();
 	ib_mad_cleanup();
+	ib_sa_cleanup();
 	addr_cleanup();
 	ibnl_cleanup();
 	class_unregister(&ib_class);
diff --git a/drivers/infiniband/core/sa_query.c b/drivers/infiniband/core/sa_query.c
index 3ebd108..db3c92d 100644
--- a/drivers/infiniband/core/sa_query.c
+++ b/drivers/infiniband/core/sa_query.c
@@ -53,10 +53,6 @@
 #include "sa.h"
 #include "core_priv.h"
 
-MODULE_AUTHOR("Roland Dreier");
-MODULE_DESCRIPTION("InfiniBand subnet administration query support");
-MODULE_LICENSE("Dual BSD/GPL");
-
 #define IB_SA_LOCAL_SVC_TIMEOUT_MIN		100
 #define IB_SA_LOCAL_SVC_TIMEOUT_DEFAULT		2000
 #define IB_SA_LOCAL_SVC_TIMEOUT_MAX		200000
@@ -1794,7 +1790,7 @@ static void ib_sa_remove_one(struct ib_device *device, void *client_data)
 	kfree(sa_dev);
 }
 
-static int __init ib_sa_init(void)
+int ib_sa_init(void)
 {
 	int ret;
 
@@ -1839,7 +1835,7 @@ err1:
 	return ret;
 }
 
-static void __exit ib_sa_cleanup(void)
+void ib_sa_cleanup(void)
 {
 	ibnl_remove_client(RDMA_NL_LS);
 	cancel_delayed_work(&ib_nl_timed_work);
@@ -1849,6 +1845,3 @@ static void __exit ib_sa_cleanup(void)
 	ib_unregister_client(&sa_client);
 	idr_destroy(&query_idr);
 }
-
-module_init(ib_sa_init);
-module_exit(ib_sa_cleanup);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
