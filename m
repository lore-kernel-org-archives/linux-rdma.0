From: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
Subject: [PATCH] IB/pvrdma: Remove unused function
Date: Fri, 11 Aug 2017 00:12:11 +0300
Message-ID: <20170810211211.11135-1-yuval.shaia@oracle.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: aditr-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, pv-drivers-pghWNbHTmq7QT0dZR+AlfA@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The function pvrdma_idx_ring_is_valid_idx is not in used so let's remove
it.

Signed-off-by: Yuval Shaia <yuval.shaia-QHcLZuEGTsvQT0dZR+AlfA@public.gmane.org>
---
 drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h | 17 -----------------
 1 file changed, 17 deletions(-)

diff --git a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
index ed9022a91a1d..8b558ae234c8 100644
--- a/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
+++ b/drivers/infiniband/hw/vmw_pvrdma/pvrdma_ring.h
@@ -111,21 +111,4 @@ static inline __s32 pvrdma_idx_ring_has_data(const struct pvrdma_ring *r,
 	return PVRDMA_INVALID_IDX;
 }
 
-static inline bool pvrdma_idx_ring_is_valid_idx(const struct pvrdma_ring *r,
-						__u32 max_elems, __u32 *idx)
-{
-	const __u32 tail = atomic_read(&r->prod_tail);
-	const __u32 head = atomic_read(&r->cons_head);
-
-	if (pvrdma_idx_valid(tail, max_elems) &&
-	    pvrdma_idx_valid(head, max_elems) &&
-	    pvrdma_idx_valid(*idx, max_elems)) {
-		if (tail > head && (*idx < tail && *idx >= head))
-			return true;
-		else if (head > tail && (*idx >= head || *idx < tail))
-			return true;
-	}
-	return false;
-}
-
 #endif /* __PVRDMA_RING_H__ */
-- 
2.13.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
