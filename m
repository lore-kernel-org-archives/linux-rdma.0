From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH 2/4 v2] staging: ipath: ipath_init_chip: Use setup_timer
Date: Sun, 25 Oct 2015 15:47:31 +0530
Message-ID: <1445768253-16107-2-git-send-email-falakreyaz@gmail.com>
References: <1445768253-16107-1-git-send-email-falakreyaz@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1445768253-16107-1-git-send-email-falakreyaz@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Muhammad Falak R Wani <falakreyaz@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Use of the timer API function setup_timer instead of init_timer, removing
the structure field assignments, and make the codeflow more readable.
The simplified sematic patch used is :-
<smpl>

@timer@
expression e1,e2,e3,fn_ptr;
@@
-init_timer(&e1);
+setup_timer(&e1, fn_ptr, e2);
... when != fn_ptr = e3
-e1.function = fn_ptr;
-e1.data = e2;

</smpl>

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
v2 changes:
	-> Change the subject line to a be more specific

mfrw

 drivers/staging/rdma/ipath/ipath_init_chip.c | 18 +++++++-----------
 1 file changed, 7 insertions(+), 11 deletions(-)

diff --git a/drivers/staging/rdma/ipath/ipath_init_chip.c b/drivers/staging/rdma/ipath/ipath_init_chip.c
index 4aea99c..a5eea19 100644
--- a/drivers/staging/rdma/ipath/ipath_init_chip.c
+++ b/drivers/staging/rdma/ipath/ipath_init_chip.c
@@ -950,9 +950,8 @@ int ipath_init_chip(struct ipath_devdata *dd, int reinit)
 		 * set up stats retrieval timer, even if we had errors
 		 * in last portion of setup
 		 */
-		init_timer(&dd->ipath_stats_timer);
-		dd->ipath_stats_timer.function = ipath_get_faststats;
-		dd->ipath_stats_timer.data = (unsigned long) dd;
+		setup_timer(&dd->ipath_stats_timer, ipath_get_faststats,
+				(unsigned long)dd);
 		/* every 5 seconds; */
 		dd->ipath_stats_timer.expires = jiffies + 5 * HZ;
 		/* takes ~16 seconds to overflow at full IB 4x bandwdith */
@@ -965,9 +964,8 @@ int ipath_init_chip(struct ipath_devdata *dd, int reinit)
 		ret = setup_sdma(dd);
 
 	/* Set up HoL state */
-	init_timer(&dd->ipath_hol_timer);
-	dd->ipath_hol_timer.function = ipath_hol_event;
-	dd->ipath_hol_timer.data = (unsigned long)dd;
+	setup_timer(&dd->ipath_hol_timer, ipath_hol_event, (unsigned long)dd);
+
 	dd->ipath_hol_state = IPATH_HOL_UP;
 
 done:
@@ -988,11 +986,9 @@ done:
 			 * to an alternate if necessary and possible
 			 */
 			if (!reinit) {
-				init_timer(&dd->ipath_intrchk_timer);
-				dd->ipath_intrchk_timer.function =
-					verify_interrupt;
-				dd->ipath_intrchk_timer.data =
-					(unsigned long) dd;
+				setup_timer(&dd->ipath_intrchk_timer,
+						verify_interrupt,
+						(unsigned long)dd);
 			}
 			dd->ipath_intrchk_timer.expires = jiffies + HZ/2;
 			add_timer(&dd->ipath_intrchk_timer);
-- 
1.9.1
