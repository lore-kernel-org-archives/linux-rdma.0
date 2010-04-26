From: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Subject: [PATCH v2] opensm/osm_lid_mgr: fix couple of duplicate LIDs bugs
Date: Mon, 26 Apr 2010 16:02:25 +0300
Message-ID: <20100426130225.GY23994@me>
References: <20100426104838.GS23994@me>
 <20100426121647.GU23994@me>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <20100426121647.GU23994@me>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Eli Dorfman <elid-smomgflXvOZWk0Htik3J/w@public.gmane.org>, Alex Netes <alexne-smomgflXvOZWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Fix couple of cases where duplicated LID generation is possible:

1) When guid2lid db is reloaded after standby or disconnected SM port
state (discovering) it must be validated, so content of used_lids[]
array (used as reference during LID assignment) will be consistent with
loaded guid2lid db.

2) When port for which LIDs were assigned exists in guid2lid db already
its record should be updated due to possibly changed LIDs, LMC, etc..

There still be more potential cases where LIDs could be duplicated. So
this patch fixes just part of them. I'm continuing an investigation.

Signed-off-by: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
---
 opensm/opensm/osm_lid_mgr.c |   10 +++++-----
 1 files changed, 5 insertions(+), 5 deletions(-)

v2: With guid2lid db reset (osm_db_clear()) clean also user_lids[]
array.

diff --git a/opensm/opensm/osm_lid_mgr.c b/opensm/opensm/osm_lid_mgr.c
index 84f3508..7da4eb0 100644
--- a/opensm/opensm/osm_lid_mgr.c
+++ b/opensm/opensm/osm_lid_mgr.c
@@ -306,11 +306,11 @@ static int lid_mgr_init_sweep(IN osm_lid_mgr_t * p_mgr)
 	   need to honor this file. */
 	if (p_mgr->p_subn->first_time_master_sweep == TRUE) {
 		osm_db_clear(p_mgr->p_g2l);
-		if (p_mgr->p_subn->opt.honor_guid2lid_file == FALSE) {
+		memset(p_mgr->used_lids, 0, sizeof(p_mgr->used_lids));
+		if (p_mgr->p_subn->opt.honor_guid2lid_file == FALSE)
 			OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 				"Ignore guid2lid file when coming out of standby\n");
-			memset(p_mgr->used_lids, 0, sizeof(p_mgr->used_lids));
-		} else {
+		else {
 			OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 				"Honor current guid2lid file when coming out "
 				"of standby\n");
@@ -319,6 +319,7 @@ static int lid_mgr_init_sweep(IN osm_lid_mgr_t * p_mgr)
 					"ERR 0306: "
 					"Error restoring Guid-to-Lid "
 					"persistent database. Ignoring it\n");
+			lid_mgr_validate_db(p_mgr);
 		}
 	}
 
@@ -710,7 +711,7 @@ static int lid_mgr_get_port_lid(IN osm_lid_mgr_t * p_mgr,
 			/* we still need to send the setting to the target port */
 			lid_changed = 1;
 		}
-		goto Exit;
+		goto NewLidSet;
 	} else
 		OSM_LOG(p_mgr->p_log, OSM_LOG_DEBUG,
 			"0x%016" PRIx64 " has no persistent lid assigned\n",
@@ -764,7 +765,6 @@ NewLidSet:
 	for (lid = *p_min_lid; lid <= *p_max_lid; lid++)
 		p_mgr->used_lids[lid] = 1;
 
-Exit:
 	/* make sure the assigned lids are marked in port_lid_tbl */
 	for (lid = *p_min_lid; lid <= *p_max_lid; lid++)
 		cl_ptr_vector_set(&p_mgr->p_subn->port_lid_tbl, lid, p_port);
-- 
1.7.0.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
