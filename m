From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH RESEND 1/2] IB/core: disallow registering 0-sized memory region
Date: Wed,  8 Apr 2015 22:02:09 +0200
Message-ID: <53b68d76c2359fe426b3c593b24e5eb02e37d61f.1428523125.git.ydroneaud@opteya.com>
References: <cover.1428523125.git.ydroneaud@opteya.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <cover.1428523125.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1428523125.git.ydroneaud@opteya.com>
References: <cover.1428523125.git.ydroneaud@opteya.com>
Sender: stable-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: linux-rdma@vger.kernel.org, Shachar Raindel <raindel@mellanox.com>, Jack Morgenstein <jackm@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, stable@vger.kernel.org, Yann Droneaud <ydroneaud@opteya.com>
List-Id: linux-rdma@vger.kernel.org

If ib_umem_get() is called with a size equal to 0 and an
non-page aligned address, one page will be pinned and a
0-sized umem will be returned to the caller.

This should not be allowed: it's not expected for a memory
region to have a size equal to 0.

This patch adds a check to explicitly refuse to register
a 0-sized region.

Additionally, it updates check added in commit 8494057ab5e4
("IB/uverbs: Prevent integer overflow in ib_umem_get
address arithmetic") to not care about 0-sized region:
it would had catched 0-sized region only if address was
already page aligned.

Link: http://mid.gmane.org/cover.1428523125.git.ydroneaud@opteya.com
Cc: <stable@vger.kernel.org> # 8494057ab5e4 ("IB/uverbs: Prevent integer overflow in ib_umem_get address arithmetic")
Cc: Shachar Raindel <raindel@mellanox.com>
Cc: Jack Morgenstein <jackm@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 drivers/infiniband/core/umem.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index 8c014b5dab4c..cbe361645c1b 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -99,12 +99,15 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	if (dmasync)
 		dma_set_attr(DMA_ATTR_WRITE_BARRIER, &attrs);
 
+	if (!size)
+		return ERR_PTR(-EINVAL);
+
 	/*
 	 * If the combination of the addr and size requested for this memory
 	 * region causes an integer overflow, return error.
 	 */
 	if ((PAGE_ALIGN(addr + size) <= size) ||
-	    (PAGE_ALIGN(addr + size) <= addr))
+	    (PAGE_ALIGN(addr + size) < addr))
 		return ERR_PTR(-EINVAL);
 
 	if (!can_do_mlock())
-- 
2.1.0
