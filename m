From: Alex Vainman <alexonlists-Re5JQEeQqe8AvxtiuMwx3w@public.gmane.org>
Subject: [PATCH v2 2/4] libibverbs: Undo changes in memory range tree when
 madvise() fails
Date: Mon, 01 Feb 2010 07:58:00 +0200
Message-ID: <4B666D68.8010103@gmail.com>
Reply-To: alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1255
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: roland <rolandd-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, Roland Dreier <rdreier-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, alexr-smomgflXvOZWk0Htik3J/w@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

ibv_madvise_range() doesn't cleanup if madvise() fails.
This patch comes to handle reference counter update on madvise() failure:

ibv_madvise_range() first updates memory range reference counter
and only then calls to madvise(). If madvise() fails, the reference counter
of the failed node is incorrect. This issue is fixed by updating node's
reference counter only after a successful call to madvise() or if no call to
madvise() was need since it was done in the past.

Signed-off-by: Alex Vainman <alexv-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 src/memory.c |    7 +++----
 1 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/src/memory.c b/src/memory.c
index 51839e2..6a3305f 100644
--- a/src/memory.c
+++ b/src/memory.c
@@ -521,10 +521,8 @@ static int ibv_madvise_range(void *base, size_t size, int advice)
 			}
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
@@ -547,6 +545,7 @@ static int ibv_madvise_range(void *base, size_t size, int advice)
 				goto out;
 		}
 
+		node->refcnt += inc;
 		node = __mm_next(node);
 	}
 
-- 
1.6.5.3


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
