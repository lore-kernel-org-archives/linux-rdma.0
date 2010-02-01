From: Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 1/4] libibverbs: Undo changes in memory range tree when
 madvise() fails
Date: Mon, 01 Feb 2010 07:58:04 +0200
Message-ID: <4B666D6C.9010004@gmail.com>
Reply-To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This patch cleanup some code in ibv_madvise_range().

The patch adds the following functions:
	1. merge_ranges()
	2. split_range()
	3. get_start_node()
These functions are added in order to:
	-remove code duplications.
	-allow better code reuse.
	-make the code more clear and readable.

Signed-off-by: Alex Vainman <alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 src/memory.c |   87 +++++++++++++++++++++++++++++++++------------------------
 1 files changed, 50 insertions(+), 37 deletions(-)

diff --git a/src/memory.c b/src/memory.c
index 53d86b7..51839e2 100644
--- a/src/memory.c
+++ b/src/memory.c
@@ -446,6 +446,49 @@ static struct ibv_mem_node *__mm_find_start(uintptr_t start, uintptr_t end)
 	return node;
 }
 
+static struct ibv_mem_node *merge_ranges(struct ibv_mem_node *node,
+					 struct ibv_mem_node *prev)
+{
+	prev->end = node->end;
+	prev->refcnt = node->refcnt;
+	__mm_remove(node);
+
+	return prev;
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
+	else {
+		tmp = __mm_prev(node);
+		if (tmp && tmp->refcnt == node->refcnt + inc)
+			node = merge_ranges(node, tmp);
+	}
+	return node;
+}
+
 static int ibv_madvise_range(void *base, size_t size, int advice)
 {
 	uintptr_t start, end;
@@ -464,46 +507,18 @@ static int ibv_madvise_range(void *base, size_t size, int advice)
 
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
 
 		node->refcnt += inc;
@@ -537,10 +552,8 @@ static int ibv_madvise_range(void *base, size_t size, int advice)
 
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
-- 
1.6.5.3


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
