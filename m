From: Jason Gunthorpe <jgg@ziepe.ca>
Subject: [PATCH] RDMA/odp: Fix missed unlock in non-blocking invalidate_start
Date: Tue, 11 Jun 2019 13:09:51 -0300
Message-ID: <20190611160951.23135-1-jgg@ziepe.ca>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Return-path: <stable-owner@vger.kernel.org>
Sender: stable-owner@vger.kernel.org
To: linux-rdma@vger.kernel.org, Moni Shoua <monis@mellanox.com>
Cc: Jason Gunthorpe <jgg@mellanox.com>, stable@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Jason Gunthorpe <jgg@mellanox.com>

If invalidate_start returns with EAGAIN then the umem_rwsem needs to be
unlocked as no invalidate_end will be called.

Cc: <stable@vger.kernel.org>
Fixes: ca748c39ea3f ("RDMA/umem: Get rid of per_mm->notifier_count")
Signed-off-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/core/umem_odp.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/core/umem_odp.c b/drivers/infiniband/core/umem_odp.c
index f962b5bbfa40e4..e4b13a32692a97 100644
--- a/drivers/infiniband/core/umem_odp.c
+++ b/drivers/infiniband/core/umem_odp.c
@@ -151,6 +151,7 @@ static int ib_umem_notifier_invalidate_range_start(struct mmu_notifier *mn,
 {
 	struct ib_ucontext_per_mm *per_mm =
 		container_of(mn, struct ib_ucontext_per_mm, mn);
+	int rc;
 
 	if (mmu_notifier_range_blockable(range))
 		down_read(&per_mm->umem_rwsem);
@@ -167,11 +168,14 @@ static int ib_umem_notifier_invalidate_range_start(struct mmu_notifier *mn,
 		return 0;
 	}
 
-	return rbt_ib_umem_for_each_in_range(&per_mm->umem_tree, range->start,
-					     range->end,
-					     invalidate_range_start_trampoline,
-					     mmu_notifier_range_blockable(range),
-					     NULL);
+	rc = rbt_ib_umem_for_each_in_range(&per_mm->umem_tree, range->start,
+					   range->end,
+					   invalidate_range_start_trampoline,
+					   mmu_notifier_range_blockable(range),
+					   NULL);
+	if (rc)
+		up_read(&per_mm->umem_rwsem);
+	return rc;
 }
 
 static int invalidate_range_end_trampoline(struct ib_umem_odp *item, u64 start,
-- 
2.21.0
