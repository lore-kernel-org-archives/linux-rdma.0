From: Yann Droneaud <ydroneaud@opteya.com>
Subject: [PATCH 2/2] IB/core: don't disallow registering region starting at 0x0
Date: Wed,  8 Apr 2015 16:30:01 +0200
Message-ID: <33b83b870b5e9322a71fb530af3b4e9f927c4c7b.1428502843.git.ydroneaud@opteya.com>
References: <cover.1428502843.git.ydroneaud@opteya.com>
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <cover.1428502843.git.ydroneaud@opteya.com>
In-Reply-To: <cover.1428502843.git.ydroneaud@opteya.com>
References: <cover.1428502843.git.ydroneaud@opteya.com>
Sender: stable-owner@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: linux-rdma@vger.kernel.org, Shachar Raindel <raindel@mellanox.com>, Jack Morgenstein <jackm@mellanox.com>, Or Gerlitz <ogerlitz@mellanox.com>, Yann Droneaud <ydroneaud@opteya.com>, "\"IB/uverbs: Prevent integer
	overflow in ib_umem_get address arithmetic\"" <stable@vger.kernel.org.#.8494057ab5e4>
List-Id: linux-rdma@vger.kernel.org

In a call to ib_umem_get(), if address is 0x0 and size is
already page aligned, check added in commit 8494057ab5e4
("IB/uverbs: Prevent integer overflow in ib_umem_get address
arithmetic") will refuse to register a memory region that
could otherwise be valid (provided vm.mmap_min_addr sysctl
and mmap_low_allowed SELinux knobs allow userspace to map
something at address 0x0).

This patch allows back such registration: ib_umem_get()
should probably don't care of the base address provided it
can be pinned with get_user_pages().

Link: http://mid.gmane.org/cover.1428502843.git.ydroneaud@opteya.com
Cc: stable@vger.kernel.org # 8494057ab5e4 ("IB/uverbs: Prevent integer overflow in ib_umem_get address arithmetic")
Cc: Shachar Raindel <raindel@mellanox.com>
Cc: Jack Morgenstein <jackm@mellanox.com>
Cc: Or Gerlitz <ogerlitz@mellanox.com>
Signed-off-by: Yann Droneaud <ydroneaud@opteya.com>
---
 drivers/infiniband/core/umem.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/core/umem.c b/drivers/infiniband/core/umem.c
index cbe361645c1b..a0aadd05ab6d 100644
--- a/drivers/infiniband/core/umem.c
+++ b/drivers/infiniband/core/umem.c
@@ -106,7 +106,7 @@ struct ib_umem *ib_umem_get(struct ib_ucontext *context, unsigned long addr,
 	 * If the combination of the addr and size requested for this memory
 	 * region causes an integer overflow, return error.
 	 */
-	if ((PAGE_ALIGN(addr + size) <= size) ||
+	if ((PAGE_ALIGN(addr + size) < size) ||
 	    (PAGE_ALIGN(addr + size) < addr))
 		return ERR_PTR(-EINVAL);
 
-- 
2.1.0
