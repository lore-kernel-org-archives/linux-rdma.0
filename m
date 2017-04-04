From: Tobias Regnery <tobias.regnery-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] IB/hns: include linux/of.h to fix build failure
Date: Tue,  4 Apr 2017 15:36:37 +0200
Message-ID: <20170404133637.18643-1-tobias.regnery@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Tobias Regnery <tobias.regnery-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

I see the following build error in an arm64 randconfig build:

drivers/infiniband/hw/hns/hns_roce_hw_v1.c: In function 'hns_roce_v1_reset':
drivers/infiniband/hw/hns/hns_roce_hw_v1.c:1384:15: error: implicit declaration of function 'of_parse_phandle' [-Werror=implicit-function-declaration]

Fix this by including linux/of.h directly.

Signed-off-by: Tobias Regnery <tobias.regnery-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
This is against next-20170404

 drivers/infiniband/hw/hns/hns_roce_hw_v1.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
index ec68f56e8ee5..0f7e85c7b70b 100644
--- a/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
+++ b/drivers/infiniband/hw/hns/hns_roce_hw_v1.c
@@ -33,6 +33,7 @@
 #include <linux/platform_device.h>
 #include <linux/acpi.h>
 #include <linux/etherdevice.h>
+#include <linux/of.h>
 #include <rdma/ib_umem.h>
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
-- 
2.11.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
