From: ira.weiny@intel.com
Subject: [PATCH v3 16/23] staging/rdma/hfi1: Increase SDMA descriptor queue
 size
Date: Mon, 26 Oct 2015 10:28:42 -0400
Message-ID: <1445869729-7507-17-git-send-email-ira.weiny@intel.com>
References: <1445869729-7507-1-git-send-email-ira.weiny@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <driverdev-devel-bounces@linuxdriverproject.org>
In-Reply-To: <1445869729-7507-1-git-send-email-ira.weiny@intel.com>
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
Cc: linux-rdma@vger.kernel.org, dennis.dalessandro@intel.com, Ignacio Hernandez <ignacio.hernandez@intel.com>, dledford@redhat.com
List-Id: linux-rdma@vger.kernel.org

From: Ignacio Hernandez <ignacio.hernandez@intel.com>

A value of 2048 increased PSM performance while not impacting verbs
performance.

Reviewed-by: Mike Marciniszyn <mike.marciniszyn@intel.com>
Reviewed-by: Mitko Haralanov <mitko.haralanov@intel.com>
Signed-off-by: Ignacio Hernandez <ignacio.hernandez@intel.com>
Signed-off-by: Ira Weiny <ira.weiny@intel.com>
---
 drivers/staging/rdma/hfi1/sdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index 77800df1d3b8..a82588200bdb 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -65,7 +65,7 @@
 #include "trace.h"
 
 /* must be a power of 2 >= 64 <= 32768 */
-#define SDMA_DESCQ_CNT 1024
+#define SDMA_DESCQ_CNT 2048
 #define SDMA_DESC_INTR 64
 #define INVALID_TAIL 0xffff
 
-- 
1.8.2
