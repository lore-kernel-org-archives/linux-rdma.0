From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] IB/hfi1: use kvfree() in sdma.c
Date: Mon, 21 Sep 2015 04:43:05 -0700
Message-ID: <9ab0afd682cc1b3919ef926aa9086eb09c9f90e9.1442864311.git.geliangtang@163.com>
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
To: Mike Marciniszyn <infinipath@intel.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-rdma@vger.kernel.org, Geliang Tang <geliangtang@163.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Use kvfree() instead of open-coding it.

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/staging/rdma/hfi1/sdma.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/sdma.c b/drivers/staging/rdma/hfi1/sdma.c
index aecd1a7..9c02a3d 100644
--- a/drivers/staging/rdma/hfi1/sdma.c
+++ b/drivers/staging/rdma/hfi1/sdma.c
@@ -966,10 +966,7 @@ static void sdma_clean(struct hfi1_devdata *dd, size_t num_engines)
 			sde->descq = NULL;
 			sde->descq_phys = 0;
 		}
-		if (is_vmalloc_addr(sde->tx_ring))
-			vfree(sde->tx_ring);
-		else
-			kfree(sde->tx_ring);
+		kvfree(sde->tx_ring);
 		sde->tx_ring = NULL;
 	}
 	spin_lock_irq(&dd->sde_map_lock);
-- 
1.9.1
