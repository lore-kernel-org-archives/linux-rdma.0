From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 2/3] opensm/osm_perfmgr.c: Add log message when perfmgr
	sweep is skipped
Date: Fri, 27 Jun 2014 10:55:33 -0700
Message-ID: <1403891733.30332.420.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_perfmgr.c |    3 +++
 1 files changed, 3 insertions(+), 0 deletions(-)

diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 2b7ea6a..bfa63dc 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -1017,6 +1017,9 @@ void osm_perfmgr_process(osm_perfmgr_t * pm)
 	if (pm->sweep_state == PERFMGR_SWEEP_ACTIVE ||
 	    pm->sweep_state == PERFMGR_SWEEP_SUSPENDED) {
 		cl_spinlock_release(&pm->lock);
+		OSM_LOG(pm->log, OSM_LOG_INFO,
+			"PM sweep state %d, skipping sweep\n",
+			pm->sweep_state);
 		return;
 	}
 
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
