From: Arnd Bergmann <arnd@arndb.de>
Subject: [PATCH] infiniband: add MMU dependency for user_mem
Date: Fri,  6 Oct 2017 09:13:46 +0200
Message-ID: <20171006071410.732275-1-arnd@arndb.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Yuval Shaia <yuval.shaia@oracle.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

The infiniband subsystem causes a link failure when the umem
driver is built on MMU-less systems:

mm/mmu_notifier.o: In function `do_mmu_notifier_register':
mmu_notifier.c:(.text+0x32): undefined reference to `mm_take_all_locks'
drivers/infiniband/core/umem.o: In function `ib_umem_get':
umem.c:(.text+0x132): undefined reference to `can_do_mlock'
drivers/infiniband/core/umem_odp.o: In function `ib_umem_odp_map_dma_pages':
umem_odp.c:(.text+0x766): undefined reference to `get_user_pages_remote'

This bug has existed for a while but only become apparent in ARM
randconfig builds when the dependency on PCI was lifted, as none
of the ARM-NOMMU targets support PCI at the moment.

We could probably get the umem driver to build by providing an
alternative implementation 'can_do_mlock()' that returns false
on NOMMU-systems, but then we'd still have a problem with the
mmu-notifiers required by CONFIG_INFINIBAND_ON_DEMAND_PAGING,
so simply forbidding umem with NOMMU seems like the simplest
workaround.

Fixes: 931bc0d91639 ("IB: Move PCI dependency from root KConfig to HW's KConfigs")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
---
 drivers/infiniband/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/Kconfig b/drivers/infiniband/Kconfig
index b62b3b1e09cd..98ac46ed7214 100644
--- a/drivers/infiniband/Kconfig
+++ b/drivers/infiniband/Kconfig
@@ -45,6 +45,7 @@ config INFINIBAND_EXP_USER_ACCESS
 config INFINIBAND_USER_MEM
 	bool
 	depends on INFINIBAND_USER_ACCESS != n
+	depends on MMU
 	default y
 
 config INFINIBAND_ON_DEMAND_PAGING
-- 
2.9.0
