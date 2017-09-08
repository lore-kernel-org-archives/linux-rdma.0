From: Colin King <colin.king@canonical.com>
Subject: [PATCH] IB/rxe: check for allocation failure on elem
Date: Fri,  8 Sep 2017 15:37:45 +0100
Message-ID: <20170908143745.2445-1-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Return-path: <kernel-janitors-owner@vger.kernel.org>
Sender: kernel-janitors-owner@vger.kernel.org
To: Moni Shoua <monis@mellanox.com>, Doug Ledford <dledford@redhat.com>, Sean Hefty <sean.hefty@intel.com>, Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org
Cc: kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

From: Colin Ian King <colin.king@canonical.com>

The allocation for elem may fail (especially because we're using
GFP_ATOMIC) so best to check for a null return.  This fixes a potential
null pointer dereference when assigning elem->pool.

Detected by CoverityScan CID#1357507 ("Dereference null return value")

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Signed-off-by: Colin Ian King <colin.king@canonical.com>
---
 drivers/infiniband/sw/rxe/rxe_pool.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/infiniband/sw/rxe/rxe_pool.c b/drivers/infiniband/sw/rxe/rxe_pool.c
index c1b5f38f31a5..3b4916680018 100644
--- a/drivers/infiniband/sw/rxe/rxe_pool.c
+++ b/drivers/infiniband/sw/rxe/rxe_pool.c
@@ -404,6 +404,8 @@ void *rxe_alloc(struct rxe_pool *pool)
 	elem = kmem_cache_zalloc(pool_cache(pool),
 				 (pool->flags & RXE_POOL_ATOMIC) ?
 				 GFP_ATOMIC : GFP_KERNEL);
+	if (!elem)
+		return NULL;
 
 	elem->pool = pool;
 	kref_init(&elem->ref_cnt);
-- 
2.14.1

