From: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH] IB/hns: Explicitly include linux/interrupt.h
Date: Fri, 28 Jul 2017 11:51:12 +0100
Message-ID: <20170728105112.7577-1-broonie@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Wei Hu <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

This file uses interrupt APIs but doesn't explicitly include
linux/interrupt.h meaning that changes in other header files could cause
build breakage as happened in next-20170728 for arm64.  Add an explicit
include to avoid such problems.

Signed-off-by: Mark Brown <broonie-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_eq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_eq.c b/drivers/infiniband/hw/hns/hns_roce_eq.c
index 50f864935a0e..e1e4c16ca3d5 100644
--- a/drivers/infiniband/hw/hns/hns_roce_eq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_eq.c
@@ -30,6 +30,7 @@
  * SOFTWARE.
  */
 
+#include <linux/interrupt.h>
 #include <linux/platform_device.h>
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
-- 
2.13.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
