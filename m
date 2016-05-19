From: Dennis Dalessandro <dennis.dalessandro-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH 1/8] IB/hfi1: Fix an interval RB node reference count leak
Date: Thu, 19 May 2016 05:21:18 -0700
Message-ID: <20160519122116.30706.99917.stgit@scvm10.sc.intel.com>
References: <20160519000433.30706.21093.stgit@scvm10.sc.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <20160519000433.30706.21093.stgit-9QXIwq+3FY+1XWohqUldA0EOCMrvLtNR@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: dledford-H+wXaHxf7aLQT0dZR+AlfA@public.gmane.org
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>, Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>

Commit e88c9271d9f8 ("IB/hfi1: Fix buffer cache corner case which
may cause corruption") introduced a bug which may cause a reference
count of a interval RB node to be leaked in the case where an SDMA
transfer from that node completes at the same time as the node is
being extended.

If a node is being extended, it is first removed from the RB tree
in order to be processed without the risk of an invalidation event
removing the node at the same time.

If a SDMA completion happens during that time, the completion handler
will fail to find the node in the RB tree and, therefore, fail to
correctly decrement its refcount. This leaves the node in the tree and
its pages pinned for the duration of the user process.

To prevent this from happening the io vector adds a reference to the
RB node, which is used during the SDMA completion instead of looking
up the node in the RB tree.

This change adds a performance improvement as a side effect by avoiding
the RB tree lookup.

Fixes: e88c9271d9f8 ("IB/hfi1: Fix buffer cache corner case which may cause corruption")
Reviewed-by: Dean Luick <dean.luick-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Reviewed-by: Harish Chegondi <harish.chegondi-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Signed-off-by: Mitko Haralanov <mitko.haralanov-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 drivers/staging/rdma/hfi1/user_sdma.c |   13 ++++++-------
 1 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/staging/rdma/hfi1/user_sdma.c b/drivers/staging/rdma/hfi1/user_sdma.c
index 0014c9c..aed2878 100644
--- a/drivers/staging/rdma/hfi1/user_sdma.c
+++ b/drivers/staging/rdma/hfi1/user_sdma.c
@@ -166,6 +166,8 @@ static unsigned initial_pkt_count = 8;
 
 #define SDMA_IOWAIT_TIMEOUT 1000 /* in milliseconds */
 
+struct sdma_mmu_node;
+
 struct user_sdma_iovec {
 	struct list_head list;
 	struct iovec iov;
@@ -178,6 +180,7 @@ struct user_sdma_iovec {
 	 * which we last left off.
 	 */
 	u64 offset;
+	struct sdma_mmu_node *node;
 };
 
 #define SDMA_CACHE_NODE_EVICT BIT(0)
@@ -1153,6 +1156,7 @@ retry:
 	}
 	iovec->pages = node->pages;
 	iovec->npages = npages;
+	iovec->node = node;
 
 	ret = hfi1_mmu_rb_insert(&req->pq->sdma_rb_root, &node->rb);
 	if (ret) {
@@ -1519,18 +1523,13 @@ static void user_sdma_free_request(struct user_sdma_request *req, bool unpin)
 	}
 	if (req->data_iovs) {
 		struct sdma_mmu_node *node;
-		struct mmu_rb_node *mnode;
 		int i;
 
 		for (i = 0; i < req->data_iovs; i++) {
-			mnode = hfi1_mmu_rb_search(
-				&req->pq->sdma_rb_root,
-				(unsigned long)req->iovs[i].iov.iov_base,
-				req->iovs[i].iov.iov_len);
-			if (!mnode || IS_ERR(mnode))
+			node = req->iovs[i].node;
+			if (!node)
 				continue;
 
-			node = container_of(mnode, struct sdma_mmu_node, rb);
 			if (unpin)
 				hfi1_mmu_rb_remove(&req->pq->sdma_rb_root,
 						   &node->rb);

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
