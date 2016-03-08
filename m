From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 05/16] IB/hfi1: Remove the use of add/remove RB function
 pointers
Date: Tue, 08 Mar 2016 11:14:42 -0800
Message-ID: <20160308191441.30542.14853.stgit@scvm10.sc.intel.com>
References: <20160308191210.30542.91885.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160308191210.30542.91885.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The usage of function pointers for RB node insertion
and removal in the expected receive code path was
meant to be a small performance optimization. However,
maintaining it, especially with the new MMU API, would
become more troublesome as the API is extended.

Since the performance optimization is minor, remove the
function pointers and replace with direct calls.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/hfi.h          |    2 --
 drivers/infiniband/hw/hfi1/user_exp_rcv.c |   25 ++++++++++++++-----------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/hfi.h b/drivers/infiniband/hw/hfi1/hfi.h
index 78c8e24..2107cdc 100644
--- a/drivers/infiniband/hw/hfi1/hfi.h
+++ b/drivers/infiniband/hw/hfi1/hfi.h
@@ -1199,8 +1199,6 @@ struct hfi1_filedata {
 	u32 invalid_tid_idx;
 	/* protect invalid_tids array and invalid_tid_idx */
 	spinlock_t invalid_lock;
-	int (*mmu_rb_insert)(struct rb_root *, struct mmu_rb_node *);
-	void (*mmu_rb_remove)(struct rb_root *, struct mmu_rb_node *);
 };
 
 extern struct list_head hfi1_dev_list;
diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index c9e05dd..b0b193f 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -223,14 +223,6 @@ int hfi1_user_exp_rcv_init(struct file *fp)
 		}
 	}
 
-	if (HFI1_CAP_IS_USET(TID_UNMAP)) {
-		fd->mmu_rb_insert = mmu_rb_insert;
-		fd->mmu_rb_remove = mmu_rb_remove;
-	} else {
-		fd->mmu_rb_insert = hfi1_mmu_rb_insert;
-		fd->mmu_rb_remove = hfi1_mmu_rb_remove;
-	}
-
 	/*
 	 * PSM does not have a good way to separate, count, and
 	 * effectively enforce a limit on RcvArray entries used by
@@ -861,7 +853,10 @@ static int set_rcvarray_entry(struct file *fp, unsigned long vaddr,
 	node->freed = false;
 	memcpy(node->pages, pages, sizeof(struct page *) * npages);
 
-	ret = fd->mmu_rb_insert(root, &node->mmu);
+	if (HFI1_CAP_IS_USET(TID_UNMAP))
+		ret = mmu_rb_insert(root, &node->mmu);
+	else
+		ret = hfi1_mmu_rb_insert(root, &node->mmu);
 
 	if (ret) {
 		hfi1_cdbg(TID, "Failed to insert RB node %u 0x%lx, 0x%lx %d",
@@ -901,7 +896,10 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 	node = fd->entry_to_rb[rcventry];
 	if (!node || node->rcventry != (uctxt->expected_base + rcventry))
 		return -EBADF;
-	fd->mmu_rb_remove(&fd->tid_rb_root, &node->mmu);
+	if (HFI1_CAP_IS_USET(TID_UNMAP))
+		mmu_rb_remove(&fd->tid_rb_root, &node->mmu);
+	else
+		hfi1_mmu_rb_remove(&fd->tid_rb_root, &node->mmu);
 
 	if (grp)
 		*grp = node->grp;
@@ -962,7 +960,12 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 							  uctxt->expected_base];
 				if (!node || node->rcventry != rcventry)
 					continue;
-				fd->mmu_rb_remove(root, &node->mmu);
+				if (HFI1_CAP_IS_USET(TID_UNMAP))
+					mmu_rb_remove(&fd->tid_rb_root,
+						      &node->mmu);
+				else
+					hfi1_mmu_rb_remove(&fd->tid_rb_root,
+							   &node->mmu);
 				clear_tid_node(fd, -1, node);
 			}
 		}

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
