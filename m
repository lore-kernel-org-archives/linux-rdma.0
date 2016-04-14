From: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH for-rdma] IB/mlx5: Allow mapping the free running counter on PROT_EXEC
Date: Thu, 14 Apr 2016 16:52:10 +0300
Message-ID: <1460641930-5118-1-git-send-email-matanb@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Doug Ledford <dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Majd Dibbiny <majd-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>, Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

The current mlx5 code disallows mapping the free running counter of
mlx5 based hardwares when PROT_EXEC is set.
Although this behaviour is correct, Linux does add an implicit VM_EXEC
to the vm_flags if the READ_IMPLIES_EXEC bit is set in the process
personality. This happens for example if the process stack is
executable.

This causes libmlx5 to output a warning and prevents the user from
reading the free running clock.
Executing the init segment of the hardware isn't a security risk
(at least no more than executing a process own stack), so we just
prevent writes to there.

Fixes: d69e3bcf7976 ('IB/mlx5: Mmap the HCA's core clock register to
		      user-space')
Signed-off-by: Matan Barak <matanb-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Haggai Eran <haggaie-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---

Hi Doug,

This patch fixes a small issue that occurs when using libmlx5 with
READ_IMPLIES_EXEC. When libmlx5 initializes, it mmaps the free running
counter clock with PROT_READ permissions. Using READ_IMPLIES_EXEC,
PROT_EXEC permission is automatically added and causes mmap to fail.
We allow PROT_EXEC mapping, as we don't see it imposes any security
risk.

Regards,
Matan

 drivers/infiniband/hw/mlx5/main.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 5acf346..d7b114b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1108,7 +1108,7 @@ static int mlx5_ib_mmap(struct ib_ucontext *ibcontext, struct vm_area_struct *vm
 		if (vma->vm_end - vma->vm_start != PAGE_SIZE)
 			return -EINVAL;
 
-		if (vma->vm_flags & (VM_WRITE | VM_EXEC))
+		if (vma->vm_flags & VM_WRITE)
 			return -EPERM;
 
 		/* Don't expose to user-space information it shouldn't have */
-- 
2.5.0

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
