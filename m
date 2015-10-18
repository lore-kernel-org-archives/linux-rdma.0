From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH v2 2/2] staging: IB/ipath: remove sched.h header
Date: Sun, 18 Oct 2015 21:57:09 +0800
Message-ID: <7653f784da256d3424c84d2c743d660219d66499.1445175749.git.geliangtang@163.com>
References: <a1a9b6edcb6bbdc079476c99a4add4b21b4414ba.1445175749.git.geliangtang@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <a1a9b6edcb6bbdc079476c99a4add4b21b4414ba.1445175749.git.geliangtang@163.com>
In-Reply-To: <a1a9b6edcb6bbdc079476c99a4add4b21b4414ba.1445175749.git.geliangtang@163.com>
References: <a1a9b6edcb6bbdc079476c99a4add4b21b4414ba.1445175749.git.geliangtang@163.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, Mike Marciniszyn <infinipath@intel.com>, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, Geliang Tang <geliangtang@163.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>
List-Id: linux-rdma@vger.kernel.org

sched.h header in ipath_*.c is now unnecessary, since I have added
sched.h in ipath_kernel.h. So remove it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
Changes in v2:
 - split it into two patches.
---
 drivers/staging/rdma/ipath/ipath_driver.c      | 1 -
 drivers/staging/rdma/ipath/ipath_intr.c        | 1 -
 drivers/staging/rdma/ipath/ipath_qp.c          | 1 -
 drivers/staging/rdma/ipath/ipath_ruc.c         | 1 -
 drivers/staging/rdma/ipath/ipath_ud.c          | 1 -
 drivers/staging/rdma/ipath/ipath_user_pages.c  | 1 -
 drivers/staging/rdma/ipath/ipath_user_sdma.c   | 1 -
 drivers/staging/rdma/ipath/ipath_verbs_mcast.c | 1 -
 8 files changed, 8 deletions(-)

diff --git a/drivers/staging/rdma/ipath/ipath_driver.c b/drivers/staging/rdma/ipath/ipath_driver.c
index 46d9898..dfcfaa5 100644
--- a/drivers/staging/rdma/ipath/ipath_driver.c
+++ b/drivers/staging/rdma/ipath/ipath_driver.c
@@ -33,7 +33,6 @@
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
-#include <linux/sched.h>
 #include <linux/spinlock.h>
 #include <linux/idr.h>
 #include <linux/pci.h>
diff --git a/drivers/staging/rdma/ipath/ipath_intr.c b/drivers/staging/rdma/ipath/ipath_intr.c
index e568971..0403fa2 100644
--- a/drivers/staging/rdma/ipath/ipath_intr.c
+++ b/drivers/staging/rdma/ipath/ipath_intr.c
@@ -33,7 +33,6 @@
 
 #include <linux/pci.h>
 #include <linux/delay.h>
-#include <linux/sched.h>
 
 #include "ipath_kernel.h"
 #include "ipath_verbs.h"
diff --git a/drivers/staging/rdma/ipath/ipath_qp.c b/drivers/staging/rdma/ipath/ipath_qp.c
index b2c6766..280cd2d 100644
--- a/drivers/staging/rdma/ipath/ipath_qp.c
+++ b/drivers/staging/rdma/ipath/ipath_qp.c
@@ -32,7 +32,6 @@
  */
 
 #include <linux/err.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/vmalloc.h>
 
diff --git a/drivers/staging/rdma/ipath/ipath_ruc.c b/drivers/staging/rdma/ipath/ipath_ruc.c
index 1f95bba..2296832 100644
--- a/drivers/staging/rdma/ipath/ipath_ruc.c
+++ b/drivers/staging/rdma/ipath/ipath_ruc.c
@@ -31,7 +31,6 @@
  * SOFTWARE.
  */
 
-#include <linux/sched.h>
 #include <linux/spinlock.h>
 
 #include "ipath_verbs.h"
diff --git a/drivers/staging/rdma/ipath/ipath_ud.c b/drivers/staging/rdma/ipath/ipath_ud.c
index e8a2a91..33fcfe2 100644
--- a/drivers/staging/rdma/ipath/ipath_ud.c
+++ b/drivers/staging/rdma/ipath/ipath_ud.c
@@ -31,7 +31,6 @@
  * SOFTWARE.
  */
 
-#include <linux/sched.h>
 #include <rdma/ib_smi.h>
 
 #include "ipath_verbs.h"
diff --git a/drivers/staging/rdma/ipath/ipath_user_pages.c b/drivers/staging/rdma/ipath/ipath_user_pages.c
index 1da1252..d29b4da 100644
--- a/drivers/staging/rdma/ipath/ipath_user_pages.c
+++ b/drivers/staging/rdma/ipath/ipath_user_pages.c
@@ -34,7 +34,6 @@
 #include <linux/mm.h>
 #include <linux/device.h>
 #include <linux/slab.h>
-#include <linux/sched.h>
 
 #include "ipath_kernel.h"
 
diff --git a/drivers/staging/rdma/ipath/ipath_user_sdma.c b/drivers/staging/rdma/ipath/ipath_user_sdma.c
index e82b3ee..8c12e3c 100644
--- a/drivers/staging/rdma/ipath/ipath_user_sdma.c
+++ b/drivers/staging/rdma/ipath/ipath_user_sdma.c
@@ -33,7 +33,6 @@
 #include <linux/types.h>
 #include <linux/device.h>
 #include <linux/dmapool.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 #include <linux/list.h>
 #include <linux/highmem.h>
diff --git a/drivers/staging/rdma/ipath/ipath_verbs_mcast.c b/drivers/staging/rdma/ipath/ipath_verbs_mcast.c
index 6216ea9..72d476f 100644
--- a/drivers/staging/rdma/ipath/ipath_verbs_mcast.c
+++ b/drivers/staging/rdma/ipath/ipath_verbs_mcast.c
@@ -32,7 +32,6 @@
  */
 
 #include <linux/rculist.h>
-#include <linux/sched.h>
 #include <linux/slab.h>
 
 #include "ipath_verbs.h"
-- 
2.5.0
