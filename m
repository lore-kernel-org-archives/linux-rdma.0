From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH 1/4] staging: rdma: ipath: Use setup_timer
Date: Sat, 24 Oct 2015 07:49:28 +0530
Message-ID: <1445653168-2883-1-git-send-email-falakreyaz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Cc: Muhammad Falak R Wani <falakreyaz@gmail.com>
List-Id: linux-rdma@vger.kernel.org

Use the timer API function setup_timer instead of init_timer, removing
the structure field assignments.

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
 drivers/staging/rdma/ipath/ipath_driver.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/ipath/ipath_driver.c b/drivers/staging/rdma/ipath/ipath_driver.c
index 46d9898..577704a 100644
--- a/drivers/staging/rdma/ipath/ipath_driver.c
+++ b/drivers/staging/rdma/ipath/ipath_driver.c
@@ -2307,10 +2307,9 @@ void ipath_set_led_override(struct ipath_devdata *dd, unsigned int val)
 	 */
 	if (atomic_inc_return(&dd->ipath_led_override_timer_active) == 1) {
 		/* Need to start timer */
-		init_timer(&dd->ipath_led_override_timer);
-		dd->ipath_led_override_timer.function =
-						 ipath_run_led_override;
-		dd->ipath_led_override_timer.data = (unsigned long) dd;
+		setup_timer(&dd->ipath_led_override_timer,
+				ipath_run_led_override, (unsigned long)dd);
+
 		dd->ipath_led_override_timer.expires = jiffies + 1;
 		add_timer(&dd->ipath_led_override_timer);
 	} else
-- 
1.9.1
