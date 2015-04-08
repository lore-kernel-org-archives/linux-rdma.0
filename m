From: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Subject: [PATCH RESEND 2/2] IB/core: don't disallow registering region starting at 0x0
Date: Wed,  8 Apr 2015 22:02:10 +0200
Message-ID: <33b83b870b5e9322a71fb530af3b4e9f927c4c7b.1428523125.git.ydroneaud@opteya.com>
References: <cover.1428523125.git.ydroneaud@opteya.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <cover.1428523125.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
In-Reply-To: <cover.1428523125.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
References: <cover.1428523125.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <roland-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
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

Link: http://mid.gmane.org/cover.1428523125.git.ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org
Cc: <stable-u79uwXL29TY76Z2rM5mHXA@public.gmane.org> # 8494057ab5e4 ("IB/uverbs: Prevent integer overflow in ib_umem_get address arithmetic")
Cc: Shachar Raindel <raindel-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jack Morgenstein <jackm-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Or Gerlitz <ogerlitz-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Yann Droneaud <ydroneaud-RlY5vtjFyJ3QT0dZR+AlfA@public.gmane.org>
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

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
