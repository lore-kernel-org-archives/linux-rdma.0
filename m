From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: [patch] IB/hfi1: fix a locking bug
Date: Wed, 16 Sep 2015 09:22:51 +0300
Message-ID: <20150916062251.GD21542@mwanda>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
Content-Disposition: inline
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Mike Marciniszyn <infinipath@intel.com>
Cc: devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, kernel-janitors@vger.kernel.org, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

mutex_trylock() returns zero on failure, not EBUSY.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

diff --git a/drivers/staging/rdma/hfi1/chip.c b/drivers/staging/rdma/hfi1/chip.c
index 654eafe..aa58e59 100644
--- a/drivers/staging/rdma/hfi1/chip.c
+++ b/drivers/staging/rdma/hfi1/chip.c
@@ -2710,7 +2710,7 @@ int acquire_lcb_access(struct hfi1_devdata *dd, int sleep_ok)
 	if (sleep_ok) {
 		mutex_lock(&ppd->hls_lock);
 	} else {
-		while (mutex_trylock(&ppd->hls_lock) == EBUSY)
+		while (!mutex_trylock(&ppd->hls_lock))
 			udelay(1);
 	}
 
@@ -2758,7 +2758,7 @@ int release_lcb_access(struct hfi1_devdata *dd, int sleep_ok)
 	if (sleep_ok) {
 		mutex_lock(&dd->pport->hls_lock);
 	} else {
-		while (mutex_trylock(&dd->pport->hls_lock) == EBUSY)
+		while (!mutex_trylock(&dd->pport->hls_lock))
 			udelay(1);
 	}
