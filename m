From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] OpenSM/osm_prtn_config.c: Fix non-initialized pointer usage
Date: Tue, 10 Apr 2012 11:58:56 +0300
Message-ID: <20120410085856.GA6613@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

If conf wasn't initialized, use p_log pointer to print to the log
directly.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_prtn_config.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_prtn_config.c b/opensm/osm_prtn_config.c
index bc53148..3d5d79e 100644
--- a/opensm/osm_prtn_config.c
+++ b/opensm/osm_prtn_config.c
@@ -727,7 +727,7 @@ int osm_prtn_config_parse_file(osm_log_t * p_log, osm_subn_t * p_subn,
 				break;
 
 			if (!conf && !(conf = new_part_conf(p_log, p_subn))) {
-				OSM_LOG(conf->p_log, OSM_LOG_ERROR,
+				OSM_LOG(p_log, OSM_LOG_ERROR,
 					"PARSE ERROR: line %d: "
 					"internal: cannot create config\n",
 					lineno);
-- 
1.7.7.6

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
