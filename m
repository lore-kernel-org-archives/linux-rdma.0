From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: Fix Pkey enforcement configuration
Date: Sun, 29 Apr 2012 21:45:26 +0300
Message-ID: <20120429184526.GB3610@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Reported-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_pkey_mgr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_pkey_mgr.c b/opensm/osm_pkey_mgr.c
index 1f3491c..c2a832f 100644
--- a/opensm/osm_pkey_mgr.c
+++ b/opensm/osm_pkey_mgr.c
@@ -211,7 +211,7 @@ pkey_mgr_enforce_partition(IN osm_log_t * p_log, osm_sm_t * sm,
 		enforce_bits = 0x4;
 
 	if ((p_pi->vl_enforce & 0xc) == enforce_bits *
-	    (enforce_type == OSM_PARTITION_ENFORCE_TYPE_OFF)) {
+	    (enforce_type != OSM_PARTITION_ENFORCE_TYPE_OFF)) {
 		OSM_LOG(p_log, OSM_LOG_DEBUG,
 			"No need to update PortInfo for "
 			"node 0x%016" PRIx64 " port %u (%s)\n",
@@ -607,7 +607,7 @@ static int pkey_mgr_update_peer_port(osm_log_t * p_log, osm_sm_t * sm,
 	if (!p_node->sw || !p_node->sw->switch_info.enforce_cap)
 		return 0;
 
-	if (enforce_type != OSM_PARTITION_ENFORCE_TYPE_OFF) {
+	if (enforce_type == OSM_PARTITION_ENFORCE_TYPE_OFF) {
 		pkey_mgr_enforce_partition(p_log, sm, peer, OSM_PARTITION_ENFORCE_TYPE_OFF);
 		return ret;
 	}
-- 
1.7.7.6

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
