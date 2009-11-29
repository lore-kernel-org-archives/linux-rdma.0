From: Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] libibverbs: Undo changes in memory range tree when madvise()
 fails
Date: Sun, 29 Nov 2009 18:51:05 +0200
Message-ID: <4B12A679.3000800@gmail.com>
Reply-To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


ibv_madvise_range() doesn't cleanup if madvise() fails.
This patch comes to handle madvise() failure:

1. ibv_madvise_range() first manages (splits or mergs) memory ranges in the tree
and only then calls madvise().If madvise() fails, the tree's memory range
may contain incorrectly split or merged ranges.
The patch undoes the split and merge operations performed on the node
which caused the madvise() failure as well as on that node's neighbors.

2. ibv_madvise_range() first updates memory range reference counter
and only then calls to madvise(). If madvise() fails, the reference counter
of the failed node is incorrect. This issue is fixed by updating node's
reference counter only after a successful call to madvise() or if no call to
madvise() was need since it was done in the past.

3. When madvise() fails on a memory range portion out of the whole range which
user requested to modify and ibv_madvise_range() successfully modified a few
tree nodes up to the problematical portion sub-ranges (this can happen if
there is an overlap between user's range and range's which where previously
added to the memory tree) then it is not enough to undo the split and merge
operation performed on the current node, which caused the failure, but the
functions needed to undo all the changes made on all the previous ranges from
start pointer to current location.
The patch revertes all the changes by re-running it self from start pointer to
current location with toggled inc value.

Signed-off-by: Alex Vaynman <alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 src/memory.c |  185 ++++++++++++++++++++++++++++++++++++++++++++--------------
 1 files changed, 142 insertions(+), 43 deletions(-)

diff --git a/src/memory.c b/src/memory.c
index 53d86b7..550015a 100644
--- a/src/memory.c
+++ b/src/memory.c
@@ -446,12 +446,121 @@ static struct ibv_mem_node *__mm_find_start(uintptr_t start, uintptr_t end)
 	return node;
 }
 
+static struct ibv_mem_node *merge_ranges(struct ibv_mem_node *node,
+					 struct ibv_mem_node *prev)
+{
+	struct ibv_mem_node *new_node = NULL;
+
+	prev->end = node->end;
+	prev->refcnt = node->refcnt;
+	__mm_remove(node);
+	new_node = prev;
+
+	return new_node;
+}
+
+static struct ibv_mem_node *split_range(struct ibv_mem_node *node,
+					uintptr_t cut_line)
+{
+	struct ibv_mem_node *new_node = NULL;
+
+	new_node = malloc(sizeof *new_node);
+	if (!new_node)
+		return NULL;
+	new_node->start  = cut_line;
+	new_node->end    = node->end;
+	new_node->refcnt = node->refcnt;
+	node->end  = cut_line - 1;
+	__mm_add(new_node);
+
+	return new_node;
+}
+
+static struct ibv_mem_node *get_start_node(uintptr_t start, uintptr_t end,
+					   int inc)
+{
+	struct ibv_mem_node *node, *tmp = NULL;
+
+	node = __mm_find_start(start, end);
+	if (node->start < start)
+		node = split_range(node, start);
+	else{
+		tmp = __mm_prev(node);
+		if (tmp && tmp->refcnt == node->refcnt + inc)
+			node = merge_ranges(node, tmp);
+	}
+	return node;
+}
+
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
+	 * This condition can be true only if we merged node which begins at start
+	 * and ends at node->end with previous node which begins at node->start
+	 * and ends at start - 1
+	 */
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
+/*
+ * This function is being called if madvise() fails.
+ * The node which caused madvise() to fail may contain just a sub range of [start-end]
+ * so we need to undo all the successful changes (if any) already performed on a range
+ * [start - (node->prev)->end].
+ * Function finds the node to begin rescanning from, find the end of the
+ * range to rescan and invert the operation type.
+ */
+static struct ibv_mem_node *prepare_to_roll_back(struct ibv_mem_node *node,
+						 uintptr_t start,
+						 uintptr_t *p_end,
+						 int *p_inc,
+						 int *p_advice)
+{
+	struct ibv_mem_node *tmp = NULL;
+
+	*p_inc *= -1;
+	*p_advice = *p_inc == 1 ? MADV_DONTFORK : MADV_DOFORK;
+	tmp = __mm_prev(node);
+	node = NULL;
+	if (tmp) {
+		*p_end = tmp->end;
+		if (start <= *p_end)
+			node = get_start_node(start, *p_end, *p_inc);
+	}
+	return node;
+}
+
 static int ibv_madvise_range(void *base, size_t size, int advice)
 {
 	uintptr_t start, end;
 	struct ibv_mem_node *node, *tmp;
 	int inc;
 	int ret = 0;
+	int rolling_back = 0;
 
 	if (!size)
 		return 0;
@@ -464,52 +573,21 @@ static int ibv_madvise_range(void *base, size_t size, int advice)
 
 	pthread_mutex_lock(&mm_mutex);
 
-	node = __mm_find_start(start, end);
-
-	if (node->start < start) {
-		tmp = malloc(sizeof *tmp);
-		if (!tmp) {
-			ret = -1;
-			goto out;
-		}
-
-		tmp->start  = start;
-		tmp->end    = node->end;
-		tmp->refcnt = node->refcnt;
-		node->end   = start - 1;
-
-		__mm_add(tmp);
-		node = tmp;
-	} else {
-		tmp = __mm_prev(node);
-		if (tmp && tmp->refcnt == node->refcnt + inc) {
-			tmp->end = node->end;
-			tmp->refcnt = node->refcnt;
-			__mm_remove(node);
-			node = tmp;
-		}
+	node = get_start_node(start, end, inc);
+	if (!node) {
+		ret = -1;
+		goto out;
 	}
-
 	while (node && node->start <= end) {
 		if (node->end > end) {
-			tmp = malloc(sizeof *tmp);
-			if (!tmp) {
+			if (!split_range(node, end + 1)) {
 				ret = -1;
 				goto out;
 			}
-
-			tmp->start  = end + 1;
-			tmp->end    = node->end;
-			tmp->refcnt = node->refcnt;
-			node->end   = end;
-
-			__mm_add(tmp);
 		}
 
-		node->refcnt += inc;
-
-		if ((inc == -1 && node->refcnt == 0) ||
-		    (inc ==  1 && node->refcnt == 1)) {
+		if ((inc == -1 && node->refcnt == 1) ||
+		    (inc ==  1 && node->refcnt == 0)) {
 			/*
 			 * If this is the first time through the loop,
 			 * and we merged this node with the previous
@@ -528,22 +606,41 @@ static int ibv_madvise_range(void *base, size_t size, int advice)
 				ret = madvise((void *) node->start,
 					      node->end - node->start + 1,
 					      advice);
-			if (ret)
+			if (ret) {
+				/*
+				 * undo merging/splitting operations performed on the node
+				 */
+				node = undo_node(node, start, inc);
+				if (!rolling_back) {
+					/*
+					 *if we already successfully modified sub ranges of [start-end]:
+					 *from start till node->start - 1 we need to rescan this range
+					 *and to undo all the changes.
+					 */
+					if (node)
+						node = prepare_to_roll_back(node, start, &end, &inc, &advice);
+					if (node) {
+						rolling_back = 1;
+						continue;
+					}
+				}
 				goto out;
+			}
 		}
 
+		node->refcnt += inc;
 		node = __mm_next(node);
 	}
 
 	if (node) {
 		tmp = __mm_prev(node);
-		if (tmp && node->refcnt == tmp->refcnt) {
-			tmp->end = node->end;
-			__mm_remove(node);
-		}
+		if (tmp && node->refcnt == tmp->refcnt)
+			node = merge_ranges(node, tmp);
 	}
 
 out:
+	if (rolling_back)
+		ret = -1;
 	pthread_mutex_unlock(&mm_mutex);
 
 	return ret;
@@ -568,3 +665,5 @@ int ibv_dofork_range(void *base, size_t size)
 		return 0;
 	}
 }
+
+
-- 
1.5.5


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
