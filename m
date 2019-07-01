From: Ajay Kaher <akaher@vmware.com>
Subject: [PATCH v5 2/3][v4.9.y] infiniband: fix race condition between infiniband mlx4, mlx5  driver and core dumping
Date: Tue, 2 Jul 2019 00:02:06 +0530
Message-ID: <1562005928-1929-2-git-send-email-akaher@vmware.com>
References: <1562005928-1929-1-git-send-email-akaher@vmware.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1562005928-1929-1-git-send-email-akaher@vmware.com>
Sender: stable-owner@vger.kernel.org
To: aarcange@redhat.com, jannh@google.com, oleg@redhat.com, peterx@redhat.com, rppt@linux.ibm.com, jgg@mellanox.com, mhocko@suse.com
Cc: jglisse@redhat.com, akpm@linux-foundation.org, mike.kravetz@oracle.com, viro@zeniv.linux.org.uk, riandrews@android.com, arve@android.com, yishaih@mellanox.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com, matanb@mellanox.com, leonro@mellanox.com, gregkh@linuxfoundation.org, torvalds@linux-foundation.org, linux-fsdevel@vger.kernel.org, linux-mm@kvack.org, devel@driverdev.osuosl.org, linux-rdma@vger.kernel.org, linux-kernel@vger.kernel.org, stable@vger.kernel.org, akaher@vmware.com, srivatsab@vmware.com, amakhalov@vmware.com
List-Id: linux-rdma@vger.kernel.org

This patch is the extension of following upstream commit to fix
the race condition between get_task_mm() and core dumping
for IB->mlx4 and IB->mlx5 drivers:

commit 04f5866e41fb ("coredump: fix race condition between
mmget_not_zero()/get_task_mm() and core dumping")'

Thanks to Jason for pointing this.

Signed-off-by: Ajay Kaher <akaher@vmware.com>
Reviewed-by: Jason Gunthorpe <jgg@mellanox.com>
---
 drivers/infiniband/hw/mlx4/main.c | 4 +++-
 drivers/infiniband/hw/mlx5/main.c | 3 +++
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx4/main.c b/drivers/infiniband/hw/mlx4/main.c
index 8d59a59..7ccf722 100644
--- a/drivers/infiniband/hw/mlx4/main.c
+++ b/drivers/infiniband/hw/mlx4/main.c
@@ -1172,6 +1172,8 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 	 * mlx4_ib_vma_close().
 	 */
 	down_write(&owning_mm->mmap_sem);
+	if (!mmget_still_valid(owning_mm))
+		goto skip_mm;
 	for (i = 0; i < HW_BAR_COUNT; i++) {
 		vma = context->hw_bar_info[i].vma;
 		if (!vma)
@@ -1190,7 +1192,7 @@ static void mlx4_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 		/* context going to be destroyed, should not access ops any more */
 		context->hw_bar_info[i].vma->vm_ops = NULL;
 	}
-
+skip_mm:
 	up_write(&owning_mm->mmap_sem);
 	mmput(owning_mm);
 	put_task_struct(owning_process);
diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index b1daf5c..f94df0e 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -1307,6 +1307,8 @@ static void mlx5_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 	 * mlx5_ib_vma_close.
 	 */
 	down_write(&owning_mm->mmap_sem);
+	if (!mmget_still_valid(owning_mm))
+		goto skip_mm;
 	list_for_each_entry_safe(vma_private, n, &context->vma_private_list,
 				 list) {
 		vma = vma_private->vma;
@@ -1321,6 +1323,7 @@ static void mlx5_ib_disassociate_ucontext(struct ib_ucontext *ibcontext)
 		list_del(&vma_private->list);
 		kfree(vma_private);
 	}
+skip_mm:
 	up_write(&owning_mm->mmap_sem);
 	mmput(owning_mm);
 	put_task_struct(owning_process);
-- 
2.7.4
