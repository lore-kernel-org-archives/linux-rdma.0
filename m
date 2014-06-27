From: Albert Chu <chu11-i2BcT+NCU+M@public.gmane.org>
Subject: [PATCH 1/3] opensm/osm_perfmgr.c: Remove unnecessary perfmgr log
	message
Date: Fri, 27 Jun 2014 10:55:19 -0700
Message-ID: <1403891719.30332.419.camel@auk59.llnl.gov>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

The "PM state %d was NOT Suspended???" log message is unnecessary.
It is not an error, and in fact is quite normal, for the sweep_state
to be not suspended.

Multiple threads can enter perfmgr_send_mad() and sit on the
conditional wait.  The first one to be signaled will obtain the
perfmgr lock and set the sweep_state to ACTIVE.  Every other thread
sitting on the conditional wait that is signaled afterwards has a
very high chance of seeing the sweep_state in ACTIVE instead of SUSPENDED.

Signed-off-by: Albert L. Chu <chu11-i2BcT+NCU+M@public.gmane.org>
---
 opensm/osm_perfmgr.c |    7 +------
 1 files changed, 1 insertions(+), 6 deletions(-)

diff --git a/opensm/osm_perfmgr.c b/opensm/osm_perfmgr.c
index 1c0ed46..2b7ea6a 100644
--- a/opensm/osm_perfmgr.c
+++ b/opensm/osm_perfmgr.c
@@ -448,13 +448,8 @@ wait:
 				goto wait;
 
 			cl_spinlock_acquire(&perfmgr->lock);
-			if (perfmgr->sweep_state == PERFMGR_SWEEP_SUSPENDED) {
+			if (perfmgr->sweep_state == PERFMGR_SWEEP_SUSPENDED)
 				perfmgr->sweep_state = PERFMGR_SWEEP_ACTIVE;
-			} else {
-				OSM_LOG(perfmgr->log, OSM_LOG_ERROR, "ERR 54FF: "
-					"PM state %d was NOT Suspended???\n",
-					perfmgr->sweep_state);
-			}
 			cl_spinlock_release(&perfmgr->lock);
 		}
 	}
-- 
1.7.1



--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
