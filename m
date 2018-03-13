From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] 40iw: include linux/irq.h
Date: Tue, 13 Mar 2018 13:06:20 +0100
Message-ID: <20180313120644.2619889-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: Arnd Bergmann <arnd@arndb.de>, Artemy Kovalyov <artemyko@mellanox.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

We get a build failure on ARM unless the header is included explicitly:

drivers/infiniband/hw/i40iw/i40iw_verbs.c: In function 'i40iw_get_vector_affinity':
drivers/infiniband/hw/i40iw/i40iw_verbs.c:2747:9: error: implicit declaration of function 'irq_get_affinity_mask'; did you mean 'irq_create_affinity_masks'? [-Werror=implicit-function-declaration]
  return irq_get_affinity_mask(msix_vec->irq);
         ^~~~~~~~~~~~~~~~~~~~~
         irq_create_affinity_masks
drivers/infiniband/hw/i40iw/i40iw_verbs.c:2747:9: error: returning 'int' from a function with return type 'const struct cpumask *' makes pointer from integer without a cast [-Werror=int-conversion]
  return irq_get_affinity_mask(msix_vec->irq);

Fixes: 7e952b19eb63 ("i40iw: Implement get_vector_affinity API")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/infiniband/hw/i40iw/i40iw_verbs.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/i40iw/i40iw_verbs.c b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
index a51798578f27..f3af952402e9 100644
--- a/drivers/infiniband/hw/i40iw/i40iw_verbs.c
+++ b/drivers/infiniband/hw/i40iw/i40iw_verbs.c
@@ -38,6 +38,7 @@
 #include <linux/highmem.h>
 #include <linux/time.h>
 #include <linux/hugetlb.h>
+#include <linux/irq.h>
 #include <asm/byteorder.h>
 #include <net/ip.h>
 #include <rdma/ib_verbs.h>
-- 
2.9.0
