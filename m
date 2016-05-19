From: Leon Romanovsky <leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [rdma-next,V2 2/6] IB/MAD: Integrate ib_mad module into ib_core module
Date: Thu, 19 May 2016 17:12:32 +0300
Message-ID: <1463667156-6518-3-git-send-email-leonro@mellanox.com>
References: <1463667156-6518-1-git-send-email-leonro@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1463667156-6518-1-git-send-email-leonro-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org, ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Consolidate ib_mad into ib_core, this commit eliminates
ib_mad.ko and makes it part of ib_core.ko

Signed-off-by: Mark Bloch <markb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/Makefile    |  7 +++----
 drivers/infiniband/core/core_priv.h |  3 +++
 drivers/infiniband/core/device.c    |  9 +++++++++
 drivers/infiniband/core/mad.c       | 13 +++----------
 4 files changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/infiniband/core/Makefile b/drivers/infiniband/core/Makefile
index 209838d..cc0a604 100644
--- a/drivers/infiniband/core/Makefile
+++ b/drivers/infiniband/core/Makefile
@@ -1,7 +1,7 @@
 infiniband-$(CONFIG_INFINIBAND_ADDR_TRANS)	:= rdma_cm.o
 user_access-$(CONFIG_INFINIBAND_ADDR_TRANS)	:= rdma_ucm.o
 
-obj-$(CONFIG_INFINIBAND) +=		ib_core.o ib_mad.o ib_sa.o \
+obj-$(CONFIG_INFINIBAND) +=		ib_core.o ib_sa.o \
 					ib_cm.o iw_cm.o \
 					$(infiniband-y)
 obj-$(CONFIG_INFINIBAND_USER_MAD) +=	ib_umad.o
@@ -10,12 +10,11 @@ obj-$(CONFIG_INFINIBAND_USER_ACCESS) +=	ib_uverbs.o ib_ucm.o \
 
 ib_core-y :=			packer.o ud_header.o verbs.o cq.o rw.o sysfs.o \
 				device.o fmr_pool.o cache.o netlink.o \
-				roce_gid_mgmt.o mr_pool.o addr.o
+				roce_gid_mgmt.o mr_pool.o addr.o \
+				mad.o smi.o agent.o mad_rmpp.o
 ib_core-$(CONFIG_INFINIBAND_USER_MEM) += umem.o
 ib_core-$(CONFIG_INFINIBAND_ON_DEMAND_PAGING) += umem_odp.o umem_rbtree.o
 
-ib_mad-y :=			mad.o smi.o agent.o mad_rmpp.o
-
 ib_sa-y :=			sa_query.o multicast.o
 
 ib_cm-y :=			cm.o
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index 589f16a..d43b2fa 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -140,4 +140,7 @@ static inline bool rdma_is_upper_dev_rcu(struct net_device *dev,
 int addr_init(void);
 void addr_cleanup(void);
 
+int ib_mad_init(void);
+void ib_mad_cleanup(void);
+
 #endif /* _CORE_PRIV_H */
diff --git a/drivers/infiniband/core/device.c b/drivers/infiniband/core/device.c
index 805d72d..f80549f 100644
--- a/drivers/infiniband/core/device.c
+++ b/drivers/infiniband/core/device.c
@@ -989,10 +989,18 @@ static int __init ib_core_init(void)
 		goto err_ibnl;
 	}
 
+	ret = ib_mad_init();
+	if (ret) {
+		pr_warn("Couldn't init IB MAD\n");
+		goto err_addr;
+	}
+
 	ib_cache_setup();
 
 	return 0;
 
+err_addr:
+	addr_cleanup();
 err_ibnl:
 	ibnl_cleanup();
 err_sysfs:
@@ -1007,6 +1015,7 @@ err:
 static void __exit ib_core_cleanup(void)
 {
 	ib_cache_cleanup();
+	ib_mad_cleanup();
 	addr_cleanup();
 	ibnl_cleanup();
 	class_unregister(&ib_class);
diff --git a/drivers/infiniband/core/mad.c b/drivers/infiniband/core/mad.c
index 9fa5bf3..82fb511 100644
--- a/drivers/infiniband/core/mad.c
+++ b/drivers/infiniband/core/mad.c
@@ -47,11 +47,7 @@
 #include "smi.h"
 #include "opa_smi.h"
 #include "agent.h"
-
-MODULE_LICENSE("Dual BSD/GPL");
-MODULE_DESCRIPTION("kernel IB MAD API");
-MODULE_AUTHOR("Hal Rosenstock");
-MODULE_AUTHOR("Sean Hefty");
+#include "core_priv.h"
 
 static int mad_sendq_size = IB_MAD_QP_SEND_SIZE;
 static int mad_recvq_size = IB_MAD_QP_RECV_SIZE;
@@ -3316,7 +3312,7 @@ static struct ib_client mad_client = {
 	.remove = ib_mad_remove_device
 };
 
-static int __init ib_mad_init_module(void)
+int ib_mad_init(void)
 {
 	mad_recvq_size = min(mad_recvq_size, IB_MAD_QP_MAX_SIZE);
 	mad_recvq_size = max(mad_recvq_size, IB_MAD_QP_MIN_SIZE);
@@ -3334,10 +3330,7 @@ static int __init ib_mad_init_module(void)
 	return 0;
 }
 
-static void __exit ib_mad_cleanup_module(void)
+void ib_mad_cleanup(void)
 {
 	ib_unregister_client(&mad_client);
 }
-
-module_init(ib_mad_init_module);
-module_exit(ib_mad_cleanup_module);
-- 
1.8.4.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
