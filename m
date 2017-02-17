From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [PATCH] IB/hns: include linux/module.h
Date: Fri, 17 Feb 2017 15:38:26 +0100
Message-ID: <20170217143945.2217431-1-arnd@arndb.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Salil <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Shaobo Xu <xushaobo2-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Wei Yongjun <weiyj.lk-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I ran into a build error on arm64 randconfig testing:

infiniband/hw/hns/hns_roce_main.c:539:1: error: data definition has no type or storage class [-Werror]
infiniband/hw/hns/hns_roce_main.c:539:1: error: type defaults to 'int' in declaration of 'MODULE_DEVICE_TABLE' [-Werror=implicit-int]
infiniband/hw/hns/hns_roce_main.c:539:1: error: parameter names (without types) in function declaration [-Werror]
infiniband/hw/hns/hns_roce_main.c:979:226: error: data definition has no type or storage class [-Werror]
infiniband/hw/hns/hns_roce_main.c:979:226: error: type defaults to 'int' in declaration of 'module_init' [-Werror=implicit-int]
infiniband/hw/hns/hns_roce_main.c:979:1: error: parameter names (without types) in function declaration [-Werror]

Including the module.h makes it build again.

Fixes: 9a4435375cd1 ("IB/hns: Add driver files for hns RoCE driver")
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_main.c b/drivers/infiniband/hw/hns/hns_roce_main.c
index 4953d9cb83a7..cf14679664ca 100644
--- a/drivers/infiniband/hw/hns/hns_roce_main.c
+++ b/drivers/infiniband/hw/hns/hns_roce_main.c
@@ -32,6 +32,7 @@
  */
 #include <linux/acpi.h>
 #include <linux/of_platform.h>
+#include <linux/module.h>
 #include <rdma/ib_addr.h>
 #include <rdma/ib_smi.h>
 #include <rdma/ib_user_verbs.h>
-- 
2.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
