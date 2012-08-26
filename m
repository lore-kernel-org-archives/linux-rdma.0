From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH TRIVIAL] opensm: fix default cc_max_outstanding_mads
 assignment
Date: Sun, 26 Aug 2012 15:19:10 +0300
Message-ID: <20120826121910.GA26159@calypso>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Should be: OSM_CC_DEFAULT_MAX_OUTSTANDING_QUERIES instead of
OSM_PERFMGR_DEFAULT_MAX_OUTSTANDING_QUERIES

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_subnet.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 195adb8..b9a491b 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1520,7 +1520,7 @@ void osm_subn_set_default_opt(IN osm_subn_opt_t * p_opt)
 	p_opt->exit_on_fatal = TRUE;
 	p_opt->congestion_control = FALSE;
 	p_opt->cc_key = OSM_DEFAULT_CC_KEY;
-	p_opt->cc_max_outstanding_mads = OSM_PERFMGR_DEFAULT_MAX_OUTSTANDING_QUERIES;
+	p_opt->cc_max_outstanding_mads = OSM_CC_DEFAULT_MAX_OUTSTANDING_QUERIES;
 	p_opt->enable_quirks = FALSE;
 	p_opt->no_clients_rereg = FALSE;
 	p_opt->prefix_routes_file = strdup(OSM_DEFAULT_PREFIX_ROUTES_FILE);
-- 
1.7.11.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
