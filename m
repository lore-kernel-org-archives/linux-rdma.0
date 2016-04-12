From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 06/12] IB/hfi1: Don't remove list entries if they are not in
 a list
Date: Tue, 12 Apr 2016 10:46:23 -0700
Message-ID: <20160412174621.19295.7133.stgit@scvm10.sc.intel.com>
References: <20160412173504.19295.7241.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160412173504.19295.7241.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

The SDMA cache logic maintains an eviction list which is ordered
by most recently used user buffers. Upon errors or buffer freeing,
the list nodes were unconditionally being deleted. This would lead
to list corruption warnings if the nodes were never inserted in the
eviction list to begin with.

This commit prevents this by checking that the nodes are already
part of the eviction list.

Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_sdma.c |    6 ++++--
 1 files changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index d53a659..032949b 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -1135,7 +1135,8 @@ retry:
 		ret = hfi1_mmu_rb_insert(&req->pq->sdma_rb_root, &node->rb);
 		if (ret) {
 			spin_lock(&pq->evict_lock);
-			list_del(&node->list);
+			if (!list_empty(&node->list))
+				list_del(&node->list);
 			pq->n_locked -= node->npages;
 			spin_unlock(&pq->evict_lock);
 			ret = 0;
@@ -1558,7 +1559,8 @@ static void sdma_rb_remove(struct rb_root *root, struct mmu_rb_node *mnode,
 		container_of(mnode, struct sdma_mmu_node, rb);
 
 	spin_lock(&node->pq->evict_lock);
-	list_del(&node->list);
+	if (!list_empty(&node->list))
+		list_del(&node->list);
 	node->pq->n_locked -= node->npages;
 	spin_unlock(&node->pq->evict_lock);
 

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
