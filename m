From: Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH -next] IB/usnic: remove unused including <linux/version.h>
Date: Sat, 21 Dec 2013 17:25:35 +0800
Message-ID: <CAPgLHd-aF7n+OSTiq7EuorPeZsmWk0Q9Hgz9tSdB+xxiaakg8g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: umalhi-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org, roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org
Cc: yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

From: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>

Remove including <linux/version.h> that don't need it.

Signed-off-by: Wei Yongjun <yongjun_wei-zrsr2BFq86L20UzCJQGyNP8+0UxHXcjY@public.gmane.org>
---
 drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h | 1 -
 drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c | 1 -
 drivers/infiniband/hw/usnic/usnic_ib.h                 | 1 -
 3 files changed, 3 deletions(-)

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
index 030ba6e..d4f752e 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
+++ b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.h
@@ -19,7 +19,6 @@
 #ifndef USNIC_UIOM_INTERVAL_TREE_H_
 #define USNIC_UIOM_INTERVAL_TREE_H_
 
-#include <linux/version.h>
 #include <linux/rbtree.h>
 
 struct usnic_uiom_interval_node {

diff --git a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
index b6e3a6b..0a9c526 100644
--- a/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
+++ b/drivers/infiniband/hw/usnic/usnic_uiom_interval_tree.c
@@ -2,7 +2,6 @@
 #include <linux/list.h>
 #include <linux/slab.h>
 #include <linux/list_sort.h>
-#include <linux/version.h>
 
 #include <linux/interval_tree_generic.h>
 #include "usnic_uiom_interval_tree.h"

diff --git a/drivers/infiniband/hw/usnic/usnic_ib.h b/drivers/infiniband/hw/usnic/usnic_ib.h
index 3511c85..64f7502 100644
--- a/drivers/infiniband/hw/usnic/usnic_ib.h
+++ b/drivers/infiniband/hw/usnic/usnic_ib.h
@@ -21,7 +21,6 @@
 
 #include <linux/iommu.h>
 #include <linux/netdevice.h>
-#include <linux/version.h>
 
 #include <rdma/ib_verbs.h>
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
