From: Geliang Tang <geliangtang@163.com>
Subject: [PATCH] RDMA/amso1100: use offset_in_page macro
Date: Sat,  3 Oct 2015 11:00:14 +0800
Message-ID: <53f0aa15e8f3df09245cddb23875e16700121550.1443840917.git.geliangtang@163.com>
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
To: Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Steve Wise <swise@opengridcomputing.com>, Ira Weiny <ira.weiny@intel.com>, Matan Barak <matanb@mellanox.com>, Jason Gunthorpe <jgunthorpe@obsidianresearch.com>, Michael Wang <yun.wang@profitbricks.com>, Haggai Eran <haggaie@mellanox.com>
Cc: linux-rdma@vger.kernel.org, Geliang Tang <geliangtang@163.com>, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

Use offset_in_page macro instead of (addr & ~PAGE_MASK).

Signed-off-by: Geliang Tang <geliangtang@163.com>
---
 drivers/staging/rdma/amso1100/c2_alloc.c    | 2 +-
 drivers/staging/rdma/amso1100/c2_provider.c | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/amso1100/c2_alloc.c b/drivers/staging/rdma/amso1100/c2_alloc.c
index 78d247e..039872d 100644
--- a/drivers/staging/rdma/amso1100/c2_alloc.c
+++ b/drivers/staging/rdma/amso1100/c2_alloc.c
@@ -131,7 +131,7 @@ void c2_free_mqsp(__be16 *mqsp)
 	*mqsp = (__force __be16) head->head;
 
 	/* Compute the shared_ptr index */
-	idx = ((unsigned long) mqsp & ~PAGE_MASK) >> 1;
+	idx = (offset_in_page(mqsp)) >> 1;
 	idx -= (unsigned long) &(((struct sp_chunk *) 0)->shared_ptr[0]) >> 1;
 
 	/* Point this index at the head */
diff --git a/drivers/staging/rdma/amso1100/c2_provider.c b/drivers/staging/rdma/amso1100/c2_provider.c
index 25c3f00..956d76b 100644
--- a/drivers/staging/rdma/amso1100/c2_provider.c
+++ b/drivers/staging/rdma/amso1100/c2_provider.c
@@ -359,7 +359,7 @@ static struct ib_mr *c2_reg_phys_mr(struct ib_pd *ib_pd,
 
 	for (i = 0; i < num_phys_buf; i++) {
 
-		if (buffer_list[i].addr & ~PAGE_MASK) {
+		if (offset_in_page(buffer_list[i].addr)) {
 			pr_debug("Unaligned Memory Buffer: 0x%x\n",
 				(unsigned int) buffer_list[i].addr);
 			return ERR_PTR(-EINVAL);
-- 
2.5.0
