From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH 4/4] staging: rdma: ipath: Use setup_timer
Date: Sat, 24 Oct 2015 07:53:13 +0530
Message-ID: <1445653393-3060-1-git-send-email-falakreyaz@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Muhammad Falak R Wani <falakreyaz@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Use the timer API function setup_timer instead of init_timer, removing
the structure field assignments.

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
 drivers/staging/rdma/ipath/ipath_verbs.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/ipath/ipath_verbs.c b/drivers/staging/rdma/ipath/ipath_verbs.c
index 40f7f05..fa8d02b 100644
--- a/drivers/staging/rdma/ipath/ipath_verbs.c
+++ b/drivers/staging/rdma/ipath/ipath_verbs.c
@@ -1956,9 +1956,8 @@ static int enable_timer(struct ipath_devdata *dd)
 				 dd->ipath_gpio_mask);
 	}
 
-	init_timer(&dd->verbs_timer);
-	dd->verbs_timer.function = __verbs_timer;
-	dd->verbs_timer.data = (unsigned long)dd;
+	setup_timer(&dd->verbs_timer, __verbs_timer, (unsigned long)dd);
+
 	dd->verbs_timer.expires = jiffies + 1;
 	add_timer(&dd->verbs_timer);
 
-- 
1.9.1
