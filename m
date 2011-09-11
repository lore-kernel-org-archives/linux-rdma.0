From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1/1] fixed deprecated conversion from string constant to
 char* warning
Date: Sun, 11 Sep 2011 11:01:46 +0300
Message-ID: <20110911080146.GA2256@calypso.mtl.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Tamir Ronen <tamirr-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/opensm/osm_perfmgr.h |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/include/opensm/osm_perfmgr.h b/include/opensm/osm_perfmgr.h
index 67c0ce4..86066a7 100644
--- a/include/opensm/osm_perfmgr.h
+++ b/include/opensm/osm_perfmgr.h
@@ -179,7 +179,7 @@ inline static osm_perfmgr_state_t osm_perfmgr_get_state(osm_perfmgr_t * perfmgr)
 	return perfmgr->state;
 }
 
-inline static char *osm_perfmgr_get_state_str(osm_perfmgr_t * p_perfmgr)
+inline static const char *osm_perfmgr_get_state_str(osm_perfmgr_t * p_perfmgr)
 {
 	switch (p_perfmgr->state) {
 	case PERFMGR_STATE_DISABLE:
@@ -195,7 +195,7 @@ inline static char *osm_perfmgr_get_state_str(osm_perfmgr_t * p_perfmgr)
 	return "UNKNOWN";
 }
 
-inline static char *osm_perfmgr_get_sweep_state_str(osm_perfmgr_t * perfmgr)
+inline static const char *osm_perfmgr_get_sweep_state_str(osm_perfmgr_t * perfmgr)
 {
 	switch (perfmgr->sweep_state) {
 	case PERFMGR_SWEEP_SLEEP:
-- 
1.7.6

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
