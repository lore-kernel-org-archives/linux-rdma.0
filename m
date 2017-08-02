From: Jonathan Toppins <jtoppins@redhat.com>
Subject: [PATCH] mm: ratelimit PFNs busy info message
Date: Wed,  2 Aug 2017 13:44:57 -0400
Message-ID: <499c0f6cc10d6eb829a67f2a4d75b4228a9b356e.1501695897.git.jtoppins@redhat.com>
Return-path: <owner-linux-mm@kvack.org>
Sender: owner-linux-mm@kvack.org
To: linux-mm@kvack.org
Cc: linux-rdma@vger.kernel.org, dledford@redhat.com, Andrew Morton <akpm@linux-foundation.org>, Michal Hocko <mhocko@suse.com>, Vlastimil Babka <vbabka@suse.cz>, Mel Gorman <mgorman@techsingularity.net>, Hillf Danton <hillf.zj@alibaba-inc.com>, open list <linux-kernel@vger.kernel.org>
List-Id: linux-rdma@vger.kernel.org

The RDMA subsystem can generate several thousand of these messages per
second eventually leading to a kernel crash. Ratelimit these messages
to prevent this crash.

Signed-off-by: Jonathan Toppins <jtoppins@redhat.com>
Reviewed-by: Doug Ledford <dledford@redhat.com>
Tested-by: Doug Ledford <dledford@redhat.com>
---
 mm/page_alloc.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 6d30e914afb6..07b7d3060b21 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -7666,7 +7666,7 @@ int alloc_contig_range(unsigned long start, unsigned long end,
 
 	/* Make sure the range is really isolated. */
 	if (test_pages_isolated(outer_start, end, false)) {
-		pr_info("%s: [%lx, %lx) PFNs busy\n",
+		pr_info_ratelimited("%s: [%lx, %lx) PFNs busy\n",
 			__func__, outer_start, end);
 		ret = -EBUSY;
 		goto done;
-- 
2.10.2

--
To unsubscribe, send a message with 'unsubscribe linux-mm' in
the body to majordomo@kvack.org.  For more info on Linux MM,
see: http://www.linux-mm.org/ .
Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
