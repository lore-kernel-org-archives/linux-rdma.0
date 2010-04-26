From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm/osm_lid_mgr: use 'first_time_master_sweep' flag
Date: Mon, 26 Apr 2010 13:48:38 +0300
Message-ID: <20100426104838.GS23994@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Use 'first_time_master_sweep' as initial sweep indication instead of
'coming_out_of_standby'. The last flag will be set only when OpenSM
previously was in standby state, this doesn't cover some other cases
such as temporary SM port disconnection.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_lid_mgr.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/opensm/osm_lid_mgr.c b/opensm/opensm/osm_lid_mgr.c
index 0fd3b20..84f3508 100644
--- a/opensm/opensm/osm_lid_mgr.c
+++ b/opensm/opensm/osm_lid_mgr.c
@@ -304,7 +304,7 @@ static int lid_mgr_init_sweep(IN osm_lid_mgr_t * p_mgr)
 	   info we might have.
 	   Do this only if the honor_guid2lid_file option is FALSE. If not, then
 	   need to honor this file. */
-	if (p_mgr->p_subn->coming_out_of_standby == TRUE) {
+	if (p_mgr->p_subn->first_time_master_sweep == TRUE) {
 		osm_db_clear(p_mgr->p_g2l);
 		if (p_mgr->p_subn->opt.honor_guid2lid_file == FALSE) {
 			OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
