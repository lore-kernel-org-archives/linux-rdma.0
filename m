From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 08/13] IB/hfi1: Remove unused sub-context parameter
Date: Thu, 28 Jul 2016 12:27:32 -0400
Message-ID: <1469723257-27317-9-git-send-email-ira.weiny@intel.com>
References: <1469723257-27317-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469723257-27317-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

subctxt is not used, just remove it.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/user_exp_rcv.c | 9 ++++-----
 1 file changed, 4 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/user_exp_rcv.c b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
index 1b640a35b3fe..f16eb25bfcd2 100644
--- a/drivers/infiniband/hw/hfi1/user_exp_rcv.c
+++ b/drivers/infiniband/hw/hfi1/user_exp_rcv.c
@@ -94,7 +94,7 @@ static int program_rcvarray(struct file *, unsigned long, struct tid_group *,
 			    struct tid_pageset *, unsigned, u16, struct page **,
 			    u32 *, unsigned *, unsigned *);
 static int unprogram_rcvarray(struct file *, u32, struct tid_group **);
-static void clear_tid_node(struct hfi1_filedata *, u16, struct tid_rb_node *);
+static void clear_tid_node(struct hfi1_filedata *, struct tid_rb_node *);
 
 static struct mmu_rb_ops tid_rb_ops = {
 	.insert = mmu_rb_insert,
@@ -911,12 +911,11 @@ static int unprogram_rcvarray(struct file *fp, u32 tidinfo,
 
 	if (grp)
 		*grp = node->grp;
-	clear_tid_node(fd, fd->subctxt, node);
+	clear_tid_node(fd, node);
 	return 0;
 }
 
-static void clear_tid_node(struct hfi1_filedata *fd, u16 subctxt,
-			   struct tid_rb_node *node)
+static void clear_tid_node(struct hfi1_filedata *fd, struct tid_rb_node *node)
 {
 	struct hfi1_ctxtdata *uctxt = fd->uctxt;
 	struct hfi1_devdata *dd = uctxt->dd;
@@ -975,7 +974,7 @@ static void unlock_exp_tids(struct hfi1_ctxtdata *uctxt,
 				else
 					hfi1_mmu_rb_remove(&fd->tid_rb_root,
 							   &node->mmu);
-				clear_tid_node(fd, -1, node);
+				clear_tid_node(fd, node);
 			}
 		}
 	}
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
