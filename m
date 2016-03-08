From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 10/16] IB/hfi1: Add filter callback
Date: Tue, 08 Mar 2016 11:15:10 -0800
Message-ID: <20160308191509.30542.25970.stgit@scvm10.sc.intel.com>
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

This commit adds a filter callback, which can be used to filter
out interval RB nodes matching a certain interval down to a
single one.

This is needed for the upcoming SDMA-side caching where buffers
will need to be filtered by their virtual address.

Reviewed-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Jubin John <jubin.john-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/infiniband/hw/hfi1/mmu_rb.c |   19 ++++++++++++++-----
 drivers/infiniband/hw/hfi1/mmu_rb.h |    1 +
 2 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.c b/drivers/infiniband/hw/hfi1/mmu_rb.c
index 5d27fee..6edd5f0 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.c
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.c
@@ -181,13 +181,22 @@ static struct mmu_rb_node *__mmu_rb_search(struct mmu_rb_handler *handler,
 					   unsigned long addr,
 					   unsigned long len)
 {
-	struct mmu_rb_node *node;
+	struct mmu_rb_node *node = NULL;
 
 	hfi1_cdbg(MMU, "Searching for addr 0x%llx, len %u", addr, len);
-	node = __mmu_int_rb_iter_first(handler->root, addr, len);
-	if (node)
-		hfi1_cdbg(MMU, "Found node addr 0x%llx, len %u", node->addr,
-			  node->len);
+	if (!handler->ops->filter) {
+		node = __mmu_int_rb_iter_first(handler->root, addr,
+					       (addr + len) - 1);
+	} else {
+		for (node = __mmu_int_rb_iter_first(handler->root, addr,
+						    (addr + len) - 1);
+		     node;
+		     node = __mmu_int_rb_iter_next(node, addr,
+						   (addr + len) - 1)) {
+			if (handler->ops->filter(node, addr, len))
+				return node;
+		}
+	}
 	return node;
 }
 
diff --git a/drivers/infiniband/hw/hfi1/mmu_rb.h b/drivers/infiniband/hw/hfi1/mmu_rb.h
index 9c26009..f8523fd 100644
--- a/drivers/infiniband/hw/hfi1/mmu_rb.h
+++ b/drivers/infiniband/hw/hfi1/mmu_rb.h
@@ -57,6 +57,7 @@ struct mmu_rb_node {
 };
 
 struct mmu_rb_ops {
+	bool (*filter)(struct mmu_rb_node *, unsigned long, unsigned long);
 	int (*insert)(struct rb_root *, struct mmu_rb_node *);
 	void (*remove)(struct rb_root *, struct mmu_rb_node *, bool);
 	int (*invalidate)(struct rb_root *, struct mmu_rb_node *);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
