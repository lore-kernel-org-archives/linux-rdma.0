From: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [patch v3 08/18] IB/iser: Remove redundant assignments in iser_reg_page_vec
Date: Tue, 14 Apr 2015 18:08:18 +0300
Message-ID: <1429024108-7221-9-git-send-email-sagig@mellanox.com>
References: <1429024108-7221-1-git-send-email-sagig@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1429024108-7221-1-git-send-email-sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Buffer length was assigned twice, and no reason to set va to
io_addr and then add the offset, just set va to io_addr + offset.

This patch does not change any functionality.

Signed-off-by: Sagi Grimberg <sagig-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Adir Lev <adirl-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 drivers/infiniband/ulp/iser/iser_memory.c |    7 ++-----
 1 files changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/ulp/iser/iser_memory.c b/drivers/infiniband/ulp/iser/iser_memory.c
index 4e0cbbb..cb30865 100644
--- a/drivers/infiniband/ulp/iser/iser_memory.c
+++ b/drivers/infiniband/ulp/iser/iser_memory.c
@@ -392,12 +392,9 @@ int iser_reg_page_vec(struct ib_conn *ib_conn,
 
 	mem_reg->lkey  = mem->fmr->lkey;
 	mem_reg->rkey  = mem->fmr->rkey;
-	mem_reg->len   = page_vec->length * SIZE_4K;
-	mem_reg->va    = io_addr;
-	mem_reg->mem_h = (void *)mem;
-
-	mem_reg->va   += page_vec->offset;
 	mem_reg->len   = page_vec->data_size;
+	mem_reg->va    = io_addr + page_vec->offset;
+	mem_reg->mem_h = (void *)mem;
 
 	iser_dbg("PHYSICAL Mem.register, [PHYS p_array: 0x%p, sz: %d, "
 		 "entry[0]: (0x%08lx,%ld)] -> "
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
