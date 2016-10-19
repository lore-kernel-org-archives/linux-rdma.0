From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] IB/hns: Move HNS RoCE user vendor structures
Date: Wed, 19 Oct 2016 20:13:07 +0300
Message-ID: <1476897187-15991-1-git-send-email-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch moves HNS vendor's specific structures to
common UAPI folder which will be visible to all consumers.

Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_cq.c                          | 2 +-
 drivers/infiniband/hw/hns/hns_roce_main.c                        | 2 +-
 drivers/infiniband/hw/hns/hns_roce_qp.c                          | 2 +-
 include/uapi/rdma/Kbuild                                         | 1 +
 .../hw/hns/hns_roce_user.h => include/uapi/rdma/hns-abi.h        | 9 +++++----
 5 files changed, 9 insertions(+), 7 deletions(-)
 rename drivers/infiniband/hw/hns/hns_roce_user.h => include/uapi/rdma/hns-abi.h (94%)

diff --git a/drivers/infiniband/hw/hns/hns_roce_cq.c b/drivers/infiniband/hw/hns/hns_roce_cq.c
index 0973659..d8a1764 100644
--- a/drivers/infiniband/hw/hns/hns_roce_cq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_cq.c
@@ -35,7 +35,7 @@
 #include "hns_roce_device.h"
 #include "hns_roce_cmd.h"
 #include "hns_roce_hem.h"
-#include "hns_roce_user.h"
+#include <rdma/hns-abi.h>
 #include "hns_roce_common.h"
 
 static void hns_roce_ib_cq_comp(struct hns_roce_cq *hr_cq)
diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 764e35a..354f100 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -37,7 +37,7 @@
 #include <rdma/ib_user_verbs.h>
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
-#include "hns_roce_user.h"
+#include <rdma/hns-abi.h>
 #include "hns_roce_hem.h"
 
 /**
diff --git a/drivers/infiniband/hw/hns/hns_roce_qp.c b/drivers/infiniband/hw/hns/hns_roce_qp.c
index e86dd8d..5d13b6b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_qp.c
+++ b/drivers/infiniband/hw/hns/hns_roce_qp.c
@@ -37,7 +37,7 @@
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include "hns_roce_hem.h"
-#include "hns_roce_user.h"
+#include <rdma/hns-abi.h>
 
 #define SQP_NUM				(2 * HNS_ROCE_MAX_PORTS)
 
diff --git a/include/uapi/rdma/Kbuild b/include/uapi/rdma/Kbuild
index f14ab7f..b54f10d 100644
--- a/include/uapi/rdma/Kbuild
+++ b/include/uapi/rdma/Kbuild
@@ -14,3 +14,4 @@ header-y += mlx5-abi.h
 header-y += mthca-abi.h
 header-y += nes-abi.h
 header-y += ocrdma-abi.h
+header-y += hns-abi.h
diff --git a/drivers/infiniband/hw/hns/hns_roce_user.h b/include/uapi/rdma/hns-abi.h
similarity index 94%
rename from drivers/infiniband/hw/hns/hns_roce_user.h
rename to include/uapi/rdma/hns-abi.h
index a28f761..5d74019 100644
--- a/drivers/infiniband/hw/hns/hns_roce_user.h
+++ b/include/uapi/rdma/hns-abi.h
@@ -30,8 +30,10 @@
  * SOFTWARE.
  */
 
-#ifndef _HNS_ROCE_USER_H
-#define _HNS_ROCE_USER_H
+#ifndef HNS_ABI_USER_H
+#define HNS_ABI_USER_H
+
+#include <linux/types.h>
 
 struct hns_roce_ib_create_cq {
 	__u64   buf_addr;
@@ -49,5 +51,4 @@ struct hns_roce_ib_create_qp {
 struct hns_roce_ib_alloc_ucontext_resp {
 	__u32	qp_tab_size;
 };
-
-#endif /*_HNS_ROCE_USER_H */
+#endif /* HNS_ABI_USER_H */
-- 
2.7.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
