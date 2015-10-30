From: ira.weiny@intel.com
Subject: [PATCH 3/9] staging/rdma/hfi1: Remove unnecessary include files
Date: Fri, 30 Oct 2015 18:41:52 -0400
Message-ID: <1446244918-12089-4-git-send-email-ira.weiny@intel.com>
References: <1446244918-12089-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1446244918-12089-1-git-send-email-ira.weiny@intel.com>
List-Unsubscribe: <http://driverdev.linuxdriverproject.org/mailman/options/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=unsubscribe>
List-Archive: <http://driverdev.linuxdriverproject.org/pipermail/driverdev-devel/>
List-Post: <mailto:driverdev-devel@linuxdriverproject.org>
List-Help: <mailto:driverdev-devel-request@linuxdriverproject.org?subject=help>
List-Subscribe: <http://driverdev.linuxdriverproject.org/mailman/listinfo/driverdev-devel>,
 <mailto:driverdev-devel-request@linuxdriverproject.org?subject=subscribe>
Errors-To: driverdev-devel-bounces@linuxdriverproject.org
Sender: "devel" <driverdev-devel-bounces@linuxdriverproject.org>
To: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org
Cc: linux-rdma@vger.kernel.org, Mitko Haralanov <mitko.haralanov@intel.com>, dledford@redhat.com, dennis.dalessandro@intel.com
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov@intel.com>

These includes were not used in file_ops.c

Signed-off-by: Mitko Haralanov <mitko.haralanov@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/file_ops.c | 10 ----------
 1 file changed, 10 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/file_ops.c b/drivers/staging/rdma/hfi1/file_ops.c
index f78bcf673252..b8aeef0e0d39 100644
--- a/drivers/staging/rdma/hfi1/file_ops.c
+++ b/drivers/staging/rdma/hfi1/file_ops.c
@@ -47,20 +47,10 @@
  * OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
  *
  */
-#include <linux/pci.h>
 #include <linux/poll.h>
 #include <linux/cdev.h>
-#include <linux/swap.h>
 #include <linux/vmalloc.h>
-#include <linux/highmem.h>
 #include <linux/io.h>
-#include <linux/jiffies.h>
-#include <asm/pgtable.h>
-#include <linux/delay.h>
-#include <linux/export.h>
-#include <linux/module.h>
-#include <linux/cred.h>
-#include <linux/uio.h>
 
 #include "hfi.h"
 #include "pio.h"
-- 
1.8.2
