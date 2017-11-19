From: Geert Uytterhoeven <geert@linux-m68k.org>
Subject: [PATCH] i40w: Remove garbage at end of INFINIBAND_I40IW Kconfig section
Date: Sun, 19 Nov 2017 19:59:21 +0100
Message-ID: <1511117961-25096-1-git-send-email-geert@linux-m68k.org>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Faisal Latif <faisal.latif@intel.com>, Shiraz Saleem <shiraz.saleem@intel.com>, Doug Ledford <dledford@redhat.com>, Jason Gunthorpe <jgg@ziepe.ca>
Cc: linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Geert Uytterhoeven <geert@linux-m68k.org>
List-Id: linux-rdma@vger.kernel.org

Remove leftover garbage (containing Kconfig dependencies for another
symbol?)

Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
---
 drivers/infiniband/hw/i40iw/Kconfig | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/infiniband/hw/i40iw/Kconfig b/drivers/infiniband/hw/i40iw/Kconfig
index f6d20ba88c03df3c..2962979c06e9ef51 100644
--- a/drivers/infiniband/hw/i40iw/Kconfig
+++ b/drivers/infiniband/hw/i40iw/Kconfig
@@ -5,4 +5,3 @@ config INFINIBAND_I40IW
 	select GENERIC_ALLOCATOR
 	---help---
 	Intel(R) Ethernet X722 iWARP Driver
-	INET && I40IW && INFINIBAND && I40E
-- 
2.7.4
