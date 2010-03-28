From: Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v3 4/4] libibverbs: Undo changes in memory range tree when
 madvise() fails
Date: Sun, 28 Mar 2010 20:06:16 +0300
Message-ID: <4BAF8C88.80909@gmail.com>
Reply-To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
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
 src/memory.c |   21 ++++++++++++++++++---
 1 files changed, 18 insertions(+), 3 deletions(-)

diff --git a/src/memory.c b/src/memory.c
index 03f49c8..14f5bc5 100644
--- a/src/memory.c
+++ b/src/memory.c
@@ -527,18 +527,19 @@ static int ibv_madvise_range(void *base, size_t size, int advice)
 	uintptr_t start, end;
 	struct ibv_mem_node *node, *tmp;
 	int inc;
+	int rolling_back = 0;
 	int ret = 0;
 
 	if (!size)
 		return 0;
 
-	inc = advice == MADV_DONTFORK ? 1 : -1;
-
 	start = (uintptr_t) base & ~(page_size - 1);
 	end   = ((uintptr_t) (base + size + page_size - 1) &
 		 ~(page_size - 1)) - 1;
 
 	pthread_mutex_lock(&mm_mutex);
+again:
+	inc = advice == MADV_DONTFORK ? 1 : -1;
 
 	node = get_start_node(start, end, inc);
 	if (!node) {
@@ -576,7 +577,19 @@ static int ibv_madvise_range(void *base, size_t size, int advice)
 					      advice);
 			if (ret) {
 				node = undo_node(node, start, inc);
-				goto out;
+
+				if (rolling_back || !node)
+					goto out;
+
+				/* madvise failed, roll back previous changes */
+				rolling_back = 1;
+				advice = advice == MADV_DONTFORK ? MADV_DOFORK :
+								   MADV_DONTFORK;
+				tmp = __mm_prev(node);
+				if (!tmp || start > tmp->end)
+					goto out;
+				end = tmp->end;
+				goto again;
 			}
 		}
 
@@ -591,6 +604,8 @@ static int ibv_madvise_range(void *base, size_t size, int advice)
 	}
 
 out:
+	if (rolling_back)
+		ret = -1;
 	pthread_mutex_unlock(&mm_mutex);
 
 	return ret;
-- 
1.6.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
