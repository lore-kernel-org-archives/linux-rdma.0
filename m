From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH opensm] osm_ucast_mgr.c: Fix duplicated error codes
Date: Sun, 13 Apr 2014 20:33:06 -0400
Message-ID: <534B2CC2.4080008@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Date: Thu, 10 Apr 2014 11:33:03 +0300

3A05 is used 3 times, changed two of them.

Signed-off-by: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_ucast_mgr.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_ucast_mgr.c b/opensm/osm_ucast_mgr.c
index 2329ea6..bb874de 100644
--- a/opensm/osm_ucast_mgr.c
+++ b/opensm/osm_ucast_mgr.c
@@ -700,7 +700,7 @@ static int ucast_mgr_setup_all_switches(osm_subn_t * p_subn)
 			p_subn->opt.port_search_ordering_file);
 		if (parse_node_map(p_subn->opt.port_search_ordering_file,
 				   set_search_ordering_ports, p_subn)) {
-			OSM_LOG(&p_subn->p_osm->log, OSM_LOG_ERROR, "ERR 3A05: "
+			OSM_LOG(&p_subn->p_osm->log, OSM_LOG_ERROR, "ERR 3A0F: "
 				"cannot parse port_search_ordering_file \'%s\'\n",
 				p_subn->opt.port_search_ordering_file);
 		}
@@ -1021,7 +1021,7 @@ static int set_lft_block(IN osm_switch_t *p_sw, IN osm_ucast_mgr_t *p_mgr,
 			     CL_DISP_MSGID_NONE, &context);
 
 	if (status != IB_SUCCESS) {
-		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR, "ERR 3A05: "
+		OSM_LOG(p_mgr->p_log, OSM_LOG_ERROR, "ERR 3A10: "
 			"Sending linear fwd. tbl. block failed (%s)\n",
 			ib_get_err_str(status));
 		return -1;
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
