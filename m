From: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
Subject: [PATCH] infiniband-diags/dump_fts: fix block calculation for LFT's
Date: Thu, 28 Mar 2013 08:48:38 -0700
Message-ID: <20130328084838.a898ff3b7d90b8cdd23c4c44@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org


This fix was found by Dan Ben Yosef in ibroute.  ibroute and dump_fts should
share this code but for now fix the bug in dump_fts.

Signed-off-by: Ira Weiny <ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org>
---
 src/dump_fts.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/src/dump_fts.c b/src/dump_fts.c
index 6cf51f1..89f0dce 100644
--- a/src/dump_fts.c
+++ b/src/dump_fts.c
@@ -343,7 +343,7 @@ void dump_unicast_tables(ibnd_node_t * node, int startlid, int endlid,
 	printf("       Port     Info \n");
 	startblock = startlid / IB_SMP_DATA_SIZE;
 	endblock = ALIGN(endlid, IB_SMP_DATA_SIZE) / IB_SMP_DATA_SIZE;
-	for (block = startblock; block <= endblock; block++) {
+	for (block = startblock; block < endblock; block++) {
 		int status;
 		DEBUG("reading block %d", block);
 		if (!smp_query_status_via(lft, portid, IB_ATTR_LINEARFORWTBL, block,
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
