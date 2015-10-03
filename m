From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] IB/ipath: use offset_in_page macro
Date: Sat,  3 Oct 2015 10:43:11 +0800
Message-ID: <b373adf0d141449f5eb208e8bae46ce72c6e468b.1443840028.git.geliangtang@163.com>
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

Use offset_in_page macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/staging/rdma/ipath/ipath_user_sdma.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/ipath/ipath_user_sdma.c b/drivers/staging/rdma/ipath/ipath_user_sdma.c
index cc04b7b..e82b3ee 100644
--- a/drivers/staging/rdma/ipath/ipath_user_sdma.c
+++ b/drivers/staging/rdma/ipath/ipath_user_sdma.c
@@ -239,7 +239,7 @@ static int ipath_user_sdma_num_pages(const struct iovec *iov)
 /* truncate length to page boundary */
 static int ipath_user_sdma_page_length(unsigned long addr, unsigned long len)
 {
-	const unsigned long offset = addr & ~PAGE_MASK;
+	const unsigned long offset = offset_in_page(addr);
 
 	return ((offset + len) > PAGE_SIZE) ? (PAGE_SIZE - offset) : len;
 }
@@ -298,7 +298,7 @@ static int ipath_user_sdma_pin_pages(const struct ipath_devdata *dd,
 		dma_addr_t dma_addr =
 			dma_map_page(&dd->pcidev->dev,
 				     pages[j], 0, flen, DMA_TO_DEVICE);
-		unsigned long fofs = addr & ~PAGE_MASK;
+		unsigned long fofs = offset_in_page(addr);
 
 		if (dma_mapping_error(&dd->pcidev->dev, dma_addr)) {
 			ret = -ENOMEM;
-- 
2.5.0
