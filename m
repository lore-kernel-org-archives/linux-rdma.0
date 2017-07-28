From: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
Subject: [net-next PATCH] IB/hns: include linux/interrupt.h
Date: Fri, 28 Jul 2017 15:35:22 +0200
Message-ID: <20170728133539.516824-1-arnd@arndb.de>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "David S . Miller" <davem-fT/PcQaiUtIeIZ0/mPfg9Q@public.gmane.org>, Lijun Ou <oulijun-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, "Wei Hu(Xavier)" <xavier.huwei-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>, Sean Hefty <sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Hal Rosenstock <hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Cc: Florian Westphal <fw-HFFVJYpyMKqzQB+pC5nmwQ@public.gmane.org>, Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>, Salil <salil.mehta-hv44wF8Li93QT0dZR+AlfA@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

I ran into this build error on linux-next:

drivers/infiniband/hw/hns/hns_roce_eq.c:477:8: error: unknown type name 'irqreturn_t'
 static irqreturn_t hns_roce_msi_x_interrupt(int irq, void *eq_ptr)
        ^~~~~~~~~~~
drivers/infiniband/hw/hns/hns_roce_eq.c: In function 'hns_roce_msi_x_interrupt':
drivers/infiniband/hw/hns/hns_roce_eq.c:485:9: error: implicit declaration of function 'IRQ_RETVAL'; did you mean 'BPF_RVAL'? [-Werror=implicit-function-declaration]
  return IRQ_RETVAL(int_work);

I have bisected this to a seemingly unrelated change that happened
to remove some indirect header inclusions. Simply including the
required header explicitly fixes the build failure.

Fixes: 09c7570480f7 ("xfrm: remove flow cache")
Signed-off-by: Arnd Bergmann <arnd-r2nGTMty4D4@public.gmane.org>
---
 drivers/infiniband/hw/hns/hns_roce_eq.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/hns/hns_roce_eq.c b/drivers/infiniband/hw/hns/hns_roce_eq.c
index 50f864935a0e..b39d14b62355 100644
--- a/drivers/infiniband/hw/hns/hns_roce_eq.c
+++ b/drivers/infiniband/hw/hns/hns_roce_eq.c
@@ -31,6 +31,7 @@
  */
 
 #include <linux/platform_device.h>
+#include <linux/interrupt.h>
 #include "hns_roce_common.h"
 #include "hns_roce_device.h"
 #include "hns_roce_eq.h"
-- 
2.9.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
