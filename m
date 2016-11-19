From: Bhumika Goyal <bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband: hw: hfi1: constify mmu_notifier_ops structure
Date: Sat, 19 Nov 2016 15:17:48 +0530
Message-ID: <1479548868-13563-1-git-send-email-bhumirks@gmail.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: julia.lawall-L2FTfq7BK8M@public.gmane.org, mike.marciniszyn-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org, sean.hefty-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org, hal.rosenstock-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-kernel-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
Cc: Bhumika Goyal <bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Declare the structure mmu_notifier_ops as const as it is only stored in
the ops field of a mmu_notifier structure. The ops field is of type
const struct mmu_notifier_ops *, so mmu_notifier_ops structures having
this property can be declared as const.
Done using coccinelle:
@r1 disable optional_qualifier @
identifier i;
position p;
@@
static struct mmu_notifier_ops i@p = {...};

@ok1@
identifier r1.i;
position p;
struct mmu_rb_handler handler;
@@
handler.mn.ops=&i@p

@bad@
position p!={r1.p,ok1.p};
identifier r1.i;
@@
i@p

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
static
+const
struct mmu_notifier_ops i={...};

@depends on !bad disable optional_qualifier@
identifier r1.i;
@@
+const
struct mmu_notifier_ops i;

File size before:
   text	   data	    bss	    dec	    hex	filename
   3566	     72	     16	   3654	    e46
drivers/infiniband/hw/hfi1/mmu_rb.o

File size after:
   text	   data	    bss	    dec	    hex	filename
   3658	      0	     16	   3674	    e5a
drivers/infiniband/hw/hfi1/mmu_rb.o

Signed-off-by: Bhumika Goyal <bhumirks-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 7ad3089..ccbf52c 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -81,7 +81,7 @@ static void do_remove(struct mmu_rb_handler *handler,
 		      struct list_head *del_list);
 static void handle_remove(struct work_struct *work);
 
-static struct mmu_notifier_ops mn_opts = {
+static const struct mmu_notifier_ops mn_opts = {
 	.invalidate_page = mmu_notifier_page,
 	.invalidate_range_start = mmu_notifier_range_start,
 };
-- 
1.9.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
