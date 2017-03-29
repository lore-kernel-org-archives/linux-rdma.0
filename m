From: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Subject: [PATCH rdma-next 4/4] IB/mlx5: Change vma from shared to private
Date: Wed, 29 Mar 2017 06:03:03 +0300
Message-ID: <20170329030303.4942-4-leon@kernel.org>
References: <20170329030303.4942-1-leon@kernel.org>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20170329030303.4942-1-leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Anonymous VMA (->vm_ops == NULL) cannot be shared, otherwise
it would lead to SIGBUS.

Remove the shared flags from the vma after we change it to be
anonymous.

This is easily reproduced by doing modprobe -r while running a
user-space application such as raw_ethernet_bw.

Fixes: 7c2344c3bbf97 ('IB/mlx5: Implements disassociate_ucontext API')
Signed-off-by: Maor Gottlieb <maorg-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Leon Romanovsky <leon-DgEjT+Ai2ygdnm+yROfE0A@public.gmane.org>
---
 drivers/infiniband/hw/mlx5/main.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 88070a7cde48..3ecb3c3f6ed2 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1488,6 +1488,7 @@ static void mlx5_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 		/* context going to be destroyed, should
 		 * not access ops any more.
 		 */
+		vma->vm_flags &= ~(VM_SHARED | VM_MAYSHARE);
 		vma->vm_ops = NULL;
 		list_del(&vma_private->list);
 		kfree(vma_private);
-- 
2.12.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
