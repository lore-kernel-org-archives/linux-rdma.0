From: Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 3/4] libibverbs: Undo changes in memory range tree when
 madvise() fails
Date: Mon, 01 Feb 2010 07:57:45 +0200
Message-ID: <4B666D59.4000101@gmail.com>
Reply-To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ibv_madvise_range() doesn't cleanup if madvise() fails.
This patch comes to fix incorrect splits/merges in the memory tree,
which are outcome of madvise() failure:

ibv_madvise_range() first manages (splits or mergs) memory ranges in the tree
and only then calls madvise().If madvise() fails, the tree's memory range
may contain incorrectly split or merged ranges.
The patch undoes the split and merge operations performed on the node
which caused the madvise() failure as well as on that node's neighbors.

Signed-off-by: Alex Vainman <alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 src/memory.c |   37 ++++++++++++++++++++++++++++++++++++-
 1 files changed, 36 insertions(+), 1 deletions(-)

diff --git a/src/memory.c b/src/memory.c
index 6a3305f..4dd9bdd 100644
--- a/src/memory.c
+++ b/src/memory.c
@@ -489,6 +489,39 @@ static struct ibv_mem_node *get_start_node(uintptr_t start, uintptr_t end,
 	return node;
 }
 
+/*
+ * This function is being called if madvise() fails and comes to
+ * undo merging/splitting operations performed on the node.
+ */
+static struct ibv_mem_node *undo_node(struct ibv_mem_node *node,
+				      uintptr_t start, int inc)
+{
+	struct ibv_mem_node *tmp = NULL;
+
+	/*
+	 * This condition can be true only if we merged this
+	 * node with the previous one, so we need to split them.
+	*/
+	if (start > node->start) {
+		tmp = split_range(node, start);
+		if (tmp) {
+			node->refcnt += inc;
+			node = tmp;
+		} else
+			return NULL;
+	}
+
+	tmp  =  __mm_prev(node);
+	if (tmp && tmp->refcnt == node->refcnt)
+		node = merge_ranges(node, tmp);
+
+	tmp  =  __mm_next(node);
+	if (tmp && tmp->refcnt == node->refcnt)
+		node = merge_ranges(tmp, node);
+
+	return node;
+}
+
 static int ibv_madvise_range(void *base, size_t size, int advice)
 {
 	uintptr_t start, end;
@@ -541,8 +574,10 @@ static int ibv_madvise_range(void *base, size_t size, int advice)
 				ret = madvise((void *) node->start,
 					      node->end - node->start + 1,
 					      advice);
-			if (ret)
+			if (ret) {
+				node = undo_node(node, start, inc);
 				goto out;
+			}
 		}
 
 		node->refcnt += inc;
-- 
1.6.5.3


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
