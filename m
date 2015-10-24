From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH 2/3] staging: rdma: hfi1: Use setup_timer
Date: Sat, 24 Oct 2015 07:58:55 +0530
Message-ID: <1445653735-3186-1-git-send-email-falakreyaz@gmail.com>
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
 drivers/staging/rdma/hfi1/driver.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/driver.c b/drivers/staging/rdma/hfi1/driver.c
index c0a5900..ef4e0c5 100644
--- a/drivers/staging/rdma/hfi1/driver.c
+++ b/drivers/staging/rdma/hfi1/driver.c
@@ -1062,9 +1062,9 @@ void hfi1_set_led_override(struct hfi1_pportdata *ppd, unsigned int val)
 	 */
 	if (atomic_inc_return(&ppd->led_override_timer_active) == 1) {
 		/* Need to start timer */
-		init_timer(&ppd->led_override_timer);
-		ppd->led_override_timer.function = run_led_override;
-		ppd->led_override_timer.data = (unsigned long) ppd;
+		setup_timer(&ppd->led_override_timer, run_led_override,
+				(unsigned long)ppd);
+
 		ppd->led_override_timer.expires = jiffies + 1;
 		add_timer(&ppd->led_override_timer);
 	} else {
-- 
1.9.1
