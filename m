From: Arvind Yadav <arvind.yadav.cs@gmail.com>
Subject: [PATCH] IB/rxe: constify vm_operations_struct
Date: Mon, 28 Aug 2017 10:00:13 +0530
Message-ID: <86676f86a57d743545a0ff0ba477902ed676aa6b.1503894343.git.arvind.yadav.cs@gmail.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: monis@mellanox.com, dledford@redhat.com, sean.hefty@intel.com, hal.rosenstock@gmail.com
Cc: linux-kernel@vger.kernel.org, linux-rdma@vger.kernel.org
List-Id: linux-rdma@vger.kernel.org

vm_operations_struct are not supposed to change at runtime.
vm_area_struct structure working with const vm_operations_struct.
So mark the non-const vm_operations_struct structs as const.

Signed-off-by: Arvind Yadav <arvind.yadav.cs@gmail.com>
---
 drivers/infiniband/sw/rxe/rxe_mmap.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mmap.c b/drivers/infiniband/sw/rxe/rxe_mmap.c
index bd812e0..d22431e 100644
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
1.9.1
