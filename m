From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH 3/4] staging: rdma: ipath: Use setup_timer
Date: Sat, 24 Oct 2015 07:52:41 +0530
Message-ID: <1445653361-3012-1-git-send-email-falakreyaz@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Muhammad Falak R Wani <falakreyaz@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Use the timer API function setup_timer instead of init_timer, removing
the structure field assignments.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 drivers/staging/rdma/ipath/ipath_sdma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/ipath/ipath_sdma.c b/drivers/staging/rdma/ipath/ipath_sdma.c
index 17a5177..1ffc06a 100644
--- a/drivers/staging/rdma/ipath/ipath_sdma.c
+++ b/drivers/staging/rdma/ipath/ipath_sdma.c
@@ -400,9 +400,9 @@ static int alloc_sdma(struct ipath_devdata *dd)
 	}
 	dd->ipath_sdma_head_dma[0] = 0;
 
-	init_timer(&dd->ipath_sdma_vl15_timer);
-	dd->ipath_sdma_vl15_timer.function = vl15_watchdog_timeout;
-	dd->ipath_sdma_vl15_timer.data = (unsigned long)dd;
+	setup_timer(&dd->ipath_sdma_vl15_timer, vl15_watchdog_timeout,
+			(unsigned long)dd);
+
 	atomic_set(&dd->ipath_sdma_vl15_count, 0);
 
 	goto done;
-- 
1.9.1
