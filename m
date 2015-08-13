From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next 6/9] IB/rdma_cm: Add wrapper for cma reference count
Date: Thu, 13 Aug 2015 19:03:11 +0300
Message-ID: <1439481794-27998-7-git-send-email-matanb@mellanox.com>
References: <1439481794-27998-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1439481794-27998-1-git-send-email-matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jason Gunthorpe <jgunthorpe-ePGOBjL8dl3ta4EC/59zMFaTQe2KTcn/@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Somnath Kotur <Somnath.Kotur-idTK6quXuVSLFuii7jzJGg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently, cma users can't increase or decrease the cma reference
count. This is necassary when setting cma attributes (like the
default GID type) in order to avoid use-after-free errors.
Adding cma_ref_dev and cma_deref_dev APIs.

Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/core/cma.c       | 11 +++++++++--
 drivers/infiniband/core/core_priv.h |  4 ++++
 2 files changed, 13 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/core/cma.c b/drivers/infiniband/core/cma.c
index 99e9e3e..22003dd 100644
--- a/drivers/infiniband/core/cma.c
+++ b/drivers/infiniband/core/cma.c
@@ -56,6 +56,8 @@
 #include <rdma/ib_sa.h>
 #include <rdma/iw_cm.h>
 
+#include "core_priv.h"
+
 MODULE_AUTHOR("Sean Hefty");
 MODULE_DESCRIPTION("Generic RDMA CM Agent");
 MODULE_LICENSE("Dual BSD/GPL");
@@ -131,6 +133,11 @@ enum {
 	CMA_OPTION_AFONLY,
 };
 
+void cma_ref_dev(struct cma_device *cma_dev)
+{
+	atomic_inc(&cma_dev->refcount);
+}
+
 /*
  * Device removal can occur at anytime, so we need extra handling to
  * serialize notifying the user of device removal with other callbacks.
@@ -276,7 +283,7 @@ static inline void cma_set_ip_ver(struct cma_hdr *hdr, u8 ip_ver)
 static void cma_attach_to_dev(struct rdma_id_private *id_priv,
 			      struct cma_device *cma_dev)
 {
-	atomic_inc(&cma_dev->refcount);
+	cma_ref_dev(cma_dev);
 	id_priv->cma_dev = cma_dev;
 	id_priv->id.device = cma_dev->device;
 	id_priv->id.route.addr.dev_addr.transport =
@@ -284,7 +291,7 @@ static void cma_attach_to_dev(struct rdma_id_private *id_priv,
 	list_add_tail(&id_priv->list, &cma_dev->id_list);
 }
 
-static inline void cma_deref_dev(struct cma_device *cma_dev)
+void cma_deref_dev(struct cma_device *cma_dev)
 {
 	if (atomic_dec_and_test(&cma_dev->refcount))
 		complete(&cma_dev->comp);
diff --git a/drivers/infiniband/core/core_priv.h b/drivers/infiniband/core/core_priv.h
index f2c5cc9..7fbfea9 100644
--- a/drivers/infiniband/core/core_priv.h
+++ b/drivers/infiniband/core/core_priv.h
@@ -38,6 +38,10 @@
 
 #include <rdma/ib_verbs.h>
 
+struct cma_device;
+void cma_ref_dev(struct cma_device *cma_dev);
+void cma_deref_dev(struct cma_device *cma_dev);
+
 int  ib_device_register_sysfs(struct ib_device *device,
 			      int (*port_callback)(struct ib_device *,
 						   u8, struct kobject *));
-- 
2.1.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
