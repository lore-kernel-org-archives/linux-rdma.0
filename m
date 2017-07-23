From: Paul Gortmaker <paul.gortmaker@windriver.com>
Subject: [PATCH-next] IB/hns: fix implicit irq include causing build fails in roce_eq
Date: Sun, 23 Jul 2017 09:53:45 -0400
Message-ID: <20170723135345.14467-1-paul.gortmaker@windriver.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-next-owner@vger.kernel.org>
Sender: linux-next-owner@vger.kernel.org
To: linux-kernel@vger.kernel.org
Cc: linux-next@vger.kernel.org, Paul Gortmaker <paul.gortmaker@windriver.com>, Lijun Ou <oulijun@huawei.com>, "Wei Hu(Xavier)" <xavier.huwei@huawei.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

To fix:

drivers/infiniband/hw/hns/hns_roce_eq.c:477:1: error: unknown type name ‘irqreturn_t’
 static irqreturn_t hns_roce_msi_x_interrupt(int irq, void *eq_ptr)
 ^
drivers/infiniband/hw/hns/hns_roce_eq.c: In function ‘hns_roce_msi_x_interrupt’:
drivers/infiniband/hw/hns/hns_roce_eq.c:485:2: error: implicit declaration of function ‘IRQ_RETVAL’ [-Werror=implicit-function-declaration]
  return IRQ_RETVAL(int_work);
  ^
drivers/infiniband/hw/hns/hns_roce_eq.c: In function ‘hns_roce_init_eq_table’:
drivers/infiniband/hw/hns/hns_roce_eq.c:711:3: error: implicit declaration of function ‘request_irq’ [-Werror=implicit-function-declaration]
   ret = request_irq(eq_table->eq[j].irq, hns_roce_msi_x_interrupt,
   ^
drivers/infiniband/hw/hns/hns_roce_eq.c:726:3: error: implicit declaration of function ‘free_irq’ [-Werror=implicit-function-declaration]
   free_irq(eq_table->eq[j].irq, eq_table->eq + j);
   ^

as seen on arm64 allmodconfig builds.

Cc: Lijun Ou <oulijun@huawei.com>
Cc: "Wei Hu(Xavier)" <xavier.huwei@huawei.com>
Cc: Doug Ledford <dledford@redhat.com>
Cc: Sean Hefty <sean.hefty@intel.com>
Cc: Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: linux-rdma@vger.kernel.org
Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
---

[ Seen on current linux-next tree. ]

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
2.11.0
