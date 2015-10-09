From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] IB/ipath: use TASK_COMM_LEN in ipath_portdata
Date: Thu,  8 Oct 2015 22:04:27 -0700
Message-ID: <85f5a431a363d505975b2aee477673ef12ea4f63.1444395550.git.geliangtang@163.com>
References: <d18008076bca0bf3f06ebd8c76bc71c0e2019517.1444394307.git.geliangtang@163.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <d18008076bca0bf3f06ebd8c76bc71c0e2019517.1444394307.git.geliangtang@163.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Geliang Tang <geliangtang@163.com>, linux-rdma@vger.kernel.org, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Use comm[TASK_COMM_LEN] instead of comm[16]. Add linux/sched.h
header in ipath_kernel.h, and remove linux/sched.h header from
ipath_*.c which have included ipath_kernel.h.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/staging/rdma/ipath/ipath_driver.c      | 1 -
 drivers/staging/rdma/ipath/ipath_intr.c        | 1 -
 drivers/staging/rdma/ipath/ipath_kernel.h      | 3 ++-
 drivers/staging/rdma/ipath/ipath_qp.c          | 1 -
 drivers/staging/rdma/ipath/ipath_ruc.c         | 1 -
 drivers/staging/rdma/ipath/ipath_ud.c          | 1 -
 drivers/staging/rdma/ipath/ipath_user_pages.c  | 1 -
 drivers/staging/rdma/ipath/ipath_user_sdma.c   | 1 -
 drivers/staging/rdma/ipath/ipath_verbs_mcast.c | 1 -
 9 files changed, 2 insertions(+), 9 deletions(-)

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
diff --git a/drivers/staging/rdma/ipath/ipath_kernel.h b/drivers/staging/rdma/ipath/ipath_kernel.h
index f0f9471..66c934a 100644
--- a/drivers/staging/rdma/ipath/ipath_kernel.h
+++ b/drivers/staging/rdma/ipath/ipath_kernel.h
@@ -44,6 +44,7 @@
 #include <linux/mutex.h>
 #include <linux/list.h>
 #include <linux/scatterlist.h>
+#include <linux/sched.h>
 #include <asm/io.h>
 #include <rdma/ib_verbs.h>
 
@@ -162,7 +163,7 @@ struct ipath_portdata {
 	struct pid *port_pid;
 	struct pid *port_subpid[INFINIPATH_MAX_SUBPORT];
 	/* same size as task_struct .comm[] */
-	char port_comm[16];
+	char port_comm[TASK_COMM_LEN];
 	/* pkeys set by this use of this port */
 	u16 port_pkeys[4];
 	/* so file ops can get at unit */
diff --git a/drivers/staging/rdma/ipath/ipath_qp.c b/drivers/staging/rdma/ipath/ipath_qp.c
index face876..0344327 100644
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
1.9.1
