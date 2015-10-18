From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH v2 1/2] staging: IB/ipath: use TASK_COMM_LEN in ipath_portdata
Date: Sun, 18 Oct 2015 21:57:08 +0800
Message-ID: <a1a9b6edcb6bbdc079476c99a4add4b21b4414ba.1445175749.git.geliangtang@163.com>
References: <20151018050509.GA2703@kroah.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <20151018050509.GA2703@kroah.com>
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

Use comm[TASK_COMM_LEN] instead of comm[16] in ipath_kernel.h.
And add sched.h header in it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
Changes in v2:
 - split it into two patches.
---
 drivers/staging/rdma/ipath/ipath_kernel.h | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

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
-- 
2.5.0
