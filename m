From: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Subject: [PATCH 05/13] IB/hfi1: Add parameter names to callback declarations
Date: Thu, 28 Jul 2016 12:27:29 -0400
Message-ID: <1469723257-27317-6-git-send-email-ira.weiny@intel.com>
References: <1469723257-27317-1-git-send-email-ira.weiny@intel.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1469723257-27317-1-git-send-email-ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

This makes it more clear what these functions are
operating on.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.h | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
index 215c728e52cd..45e7245d813b 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.h
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.h
@@ -57,11 +57,12 @@ struct mmu_rb_node {
 };
 
 struct mmu_rb_ops {
-	bool (*filter)(struct mmu_rb_node *, unsigned long, unsigned long);
-	int (*insert)(struct rb_root *, struct mmu_rb_node *);
-	void (*remove)(struct rb_root *, struct mmu_rb_node *,
-		       struct mm_struct *);
-	int (*invalidate)(struct rb_root *, struct mmu_rb_node *);
+	bool (*filter)(struct mmu_rb_node *node, unsigned long addr,
+		       unsigned long len);
+	int (*insert)(struct rb_root *root, struct mmu_rb_node *mnode);
+	void (*remove)(struct rb_root *root, struct mmu_rb_node *mnode,
+		       struct mm_struct *mm);
+	int (*invalidate)(struct rb_root *root, struct mmu_rb_node *node);
 };
 
 int hfi1_mmu_rb_register(struct rb_root *root, struct mmu_rb_ops *ops);
-- 
1.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
