From: Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 4/4] libibverbs: Undo changes in memory range tree when
 madvise() fails
Date: Mon, 01 Feb 2010 07:57:42 +0200
Message-ID: <4B666D56.4090708@gmail.com>
Reply-To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ibv_madvise_range() doesn't cleanup if madvise() fails.
This patch comes to roll back the changes, made in memory tree,
which preceded the madvise() failure:

When madvise() fails on a memory range portion out of the whole range which
user requested to modify and ibv_madvise_range() successfully modified a few
tree nodes up to the problematical portion sub-ranges (this can happen if
there is an overlap between user's range and range's which where previously
added to the memory tree) then it is not enough to undo the split and merge
operation performed on the current node, which caused the failure, but the
functions needed to undo all the changes made on all the previous ranges from
start pointer to current location.
The patch revertes all the changes by re-running it self from start pointer to
current location with toggled inc value.

Signed-off-by: Alex Vainman <alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 src/memory.c |   39 ++++++++++++++++++++++++++++++++++++++-
 1 files changed, 38 insertions(+), 1 deletions(-)

diff --git a/src/memory.c b/src/memory.c
index 4dd9bdd..876dced 100644
--- a/src/memory.c
+++ b/src/memory.c
@@ -522,12 +522,43 @@ static struct ibv_mem_node *undo_node(struct ibv_mem_node *node,
 	return node;
 }
 
+/*
+ * This function is being called if madvise() fails.
+ * The node which caused madvise() to fail may contain
+ * just a sub range of [start-end].
+ * So we need to undo all the successful changes (if any)
+ * already performed on a range [start - (node->prev)->end].
+ * This function finds the node to begin rescanning from,
+ * finds the end of the range to rescan and invert
+ * the operation type.
+ */
+static struct ibv_mem_node *prepare_to_roll_back(struct ibv_mem_node *node,
+						 uintptr_t start,
+						 uintptr_t *end,
+						 int *inc,
+						 int *advice)
+{
+	struct ibv_mem_node *tmp = NULL;
+
+	*inc *= -1;
+	*advice = *inc == 1 ? MADV_DONTFORK : MADV_DOFORK;
+	tmp = __mm_prev(node);
+	node = NULL;
+	if (tmp) {
+		*end = tmp->end;
+		if (start <= *end)
+			node = get_start_node(start, *end, *inc);
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
@@ -576,7 +607,13 @@ static int ibv_madvise_range(void *base, size_t size, int advice)
 					      advice);
 			if (ret) {
 				node = undo_node(node, start, inc);
-				goto out;
+				if (rolling_back || !node)
+					goto out;
+
+				node = prepare_to_roll_back(node, start, &end,
+							    &inc, &advice);
+				rolling_back = 1;
+				continue;
 			}
 		}
 
-- 
1.6.5.3


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
