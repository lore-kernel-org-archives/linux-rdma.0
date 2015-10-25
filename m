From: Muhammad Falak R Wani <falakreyaz@gmail.com>
Subject: [PATCH 4/4 v2] staging: ipath: ipath_verbs: Use setup_timer
Date: Sun, 25 Oct 2015 15:47:33 +0530
Message-ID: <1445768253-16107-4-git-send-email-falakreyaz@gmail.com>
References: <1445768253-16107-1-git-send-email-falakreyaz@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1445768253-16107-1-git-send-email-falakreyaz@gmail.com>
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

Signed-off-by: Muhammad Falak R Wani <falakreyaz@gmail.com>
---
v2 changes:
	-> Change the subject line to a be more specific

mfrw

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
