From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [opensm] [PATCH 4/5] Fix potential memleak
Date: Mon, 14 Nov 2011 14:53:28 -0800
Message-ID: <1321311208.5518.54.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Note that the new config file parsing code, different osm_subn_opt_t
structures do not share pointers to the same strdup'ed memory.
Therefore, this memory must be freed before reallocing to avoid
a memleak.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/main.c |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)

diff --git a/opensm/main.c b/opensm/main.c
index f7a6d83..10cbef5 100644
--- a/opensm/main.c
+++ b/opensm/main.c
@@ -553,6 +553,8 @@ int osm_manager_loop(osm_subn_opt_t * p_opt, osm_opensm_t * p_osm)
 }
 
 #define SET_STR_OPT(opt, val) do { \
+	if (opt) \
+		free(opt); \
 	opt = val ? strdup(val) : NULL ; \
 } while (0)
 
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
