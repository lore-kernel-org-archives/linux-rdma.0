From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 5/5] IB/rxe: Constify static rxe_vm_ops
Date: Thu, 15 Jun 2017 11:29:07 +0300
Message-ID: <20170615082907.5658-6-leon@kernel.org>
References: <20170615082907.5658-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170615082907.5658-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Kamal Heib <kamalheib1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>, Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Kamal Heib <kamalheib1-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>

Constify static rxe_vm_ops that is never modified.

Signed-off-by: Kamal Heib <kamalh-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/sw/rxe/rxe_mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mmap.c b/drivers/infiniband/sw/rxe/rxe_mmap.c
index bd812e00988e..d22431e3a908 100644
--- a/drivers/infiniband/sw/rxe/rxe_mmap.c
+++ b/drivers/infiniband/sw/rxe/rxe_mmap.c
@@ -76,7 +76,7 @@ static void rxe_vma_close(struct vm_area_struct *vma)
 	kref_put(&ip->ref, rxe_mmap_release);
 }
 
-static struct vm_operations_struct rxe_vm_ops = {
+static const struct vm_operations_struct rxe_vm_ops = {
 	.open = rxe_vma_open,
 	.close = rxe_vma_close,
 };
-- 
2.12.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
