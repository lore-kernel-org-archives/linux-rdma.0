From: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-next V1 1/6] net/mlx4_core: Change bitmap allocator to work in round-robin fashion
Date: Thu, 10 May 2012 23:28:04 +0300
Message-ID: <1336681689-16668-2-git-send-email-ogerlitz@mellanox.com>
References: <1336681689-16668-1-git-send-email-ogerlitz@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1336681689-16668-1-git-send-email-ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>

Under most circumstances, the bitmap allocator does not allocate the
same full 24-bit qp-number immediately after a qp is destroyed.

This operates by using the upper bits of a 24-bit qp number, beyond the
number of QPs that are actually available in the low level driver.
For example, say that the HCA is willing to allocate a maximum of 64K qps.
We use the bits 23..16 as a "counter" which is incremented by 1 at each
allocation so that even if the same physical QP is re-allocated, it will
not receive the same 24-bit QP number.

However, we have seen the following scenario:
1. Allocate, say, 255 QPs in succession.  This will cause a wrap of the "counter".
2. Destroy the first QP allocated, then allocate a new QP.  The new QP,
   because of the counter wraparound, will get the same FULL QP number as
   the QP just destroyed!

This is a problem, because packets in transit can be erroneously delivered to
the new QP when they were meant for the old (destroyed) QP, because the full QP
number of the new QP is identical to the destroyed QP. (The "counter" mechanism
is meant to prevent this by having the full 24-bit QP numbers differ even if
the physical QP on the HCA is the same. As we see above, however, this mechanism
does not always work).

The best fix for this problem is to allocate QPs in round-robin mode,
so that the physical QP numbers are not immediately re-used.

Per feedback from Roland Dreier, deleted the bitmap->top update as well from
mlx4_bitmap_free_range. He pointed out that the "top" update was unnecessary if
bitmap->last only increases until the bitmap wraparound (so there is no chance of
immediately re-allocating a just-released resource).

Found-by:  Matthew Finlay <matt-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Jack Morgenstein <jackm-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---

changes from V0:

Applied the feedback from Roland to delete the bitmap->top update as well from
mlx4_bitmap_free_range. 

 drivers/net/ethernet/mellanox/mlx4/alloc.c |    3 ---
 1 files changed, 0 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx4/alloc.c b/drivers/net/ethernet/mellanox/mlx4/alloc.c
index 8be20e7..06fef5b 100644
--- a/drivers/net/ethernet/mellanox/mlx4/alloc.c
+++ b/drivers/net/ethernet/mellanox/mlx4/alloc.c
@@ -124,9 +124,6 @@ void mlx4_bitmap_free_range(struct mlx4_bitmap *bitmap, u32 obj, int cnt)
 
 	spin_lock(&bitmap->lock);
 	bitmap_clear(bitmap->table, obj, cnt);
-	bitmap->last = min(bitmap->last, obj);
-	bitmap->top = (bitmap->top + bitmap->max + bitmap->reserved_top)
-			& bitmap->mask;
 	bitmap->avail += cnt;
 	spin_unlock(&bitmap->lock);
 }
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
