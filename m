From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/3] opensm SA DB dump/restore: dump SA DB only if modified
Date: Mon, 02 Nov 2009 12:43:10 +0200
Message-ID: <4AEEB7BE.3010406@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Optimizing SA DB dump - added "dirty" flag to denote
that the SA DB was modified, so that the DB will be
dumped only when the flag is on.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/opensm/osm_sa.h         |    5 +++++
 opensm/opensm/osm_inform.c             |    2 ++
 opensm/opensm/osm_multicast.c          |    3 +++
 opensm/opensm/osm_sa.c                 |    7 ++++++-
 opensm/opensm/osm_sa_mcmember_record.c |    4 ++++
 opensm/opensm/osm_service.c            |    3 +++
 6 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/opensm/include/opensm/osm_sa.h b/opensm/include/opensm/osm_sa.h
index dad3142..35684cc 100644
--- a/opensm/include/opensm/osm_sa.h
+++ b/opensm/include/opensm/osm_sa.h
@@ -125,6 +125,7 @@ typedef struct osm_sa {
 	atomic32_t sa_trans_id;
 	osm_sa_mad_ctrl_t mad_ctrl;
 	cl_timer_t sr_timer;
+	boolean_t dirty;
 	cl_disp_reg_handle_t cpi_disp_h;
 	cl_disp_reg_handle_t nr_disp_h;
 	cl_disp_reg_handle_t pir_disp_h;
@@ -178,6 +179,10 @@ typedef struct osm_sa {
 *	mad_ctrl
 *		Mad Controller
 *
+*	dirty
+*		A flag that denotes that SA DB is dirty and needs
+*		to be written to the dump file (if dumping is enabled)
+*
 * SEE ALSO
 *	SM object
 *********/
diff --git a/opensm/opensm/osm_inform.c b/opensm/opensm/osm_inform.c
index c69ef7a..9155297 100644
--- a/opensm/opensm/osm_inform.c
+++ b/opensm/opensm/osm_inform.c
@@ -258,6 +258,7 @@ void osm_infr_insert_to_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
 #endif

 	cl_qlist_insert_head(&p_subn->sa_infr_list, &p_infr->list_item);
+	p_subn->p_osm->sa.dirty = TRUE;

 	OSM_LOG(p_log, OSM_LOG_DEBUG, "Dump after insertion (size %d)\n",
 		cl_qlist_count(&p_subn->sa_infr_list));
@@ -283,6 +284,7 @@ void osm_infr_remove_from_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
 			     OSM_LOG_DEBUG);

 	cl_qlist_remove_item(&p_subn->sa_infr_list, &p_infr->list_item);
+	p_subn->p_osm->sa.dirty = TRUE;

 	osm_infr_delete(p_infr);

diff --git a/opensm/opensm/osm_multicast.c b/opensm/opensm/osm_multicast.c
index 7b7f1e0..b44e77a 100644
--- a/opensm/opensm/osm_multicast.c
+++ b/opensm/opensm/osm_multicast.c
@@ -205,6 +205,7 @@ osm_mcm_port_t *osm_mgrp_add_port(IN osm_subn_t * subn, osm_log_t * log,
 	    ++mgrp->full_members == 1)
 		mgrp_send_notice(subn, log, mgrp, 66);

+	subn->p_osm->sa.dirty = TRUE;
 	return mcm_port;
 }

@@ -259,6 +260,8 @@ void osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
 		mgrp_send_notice(subn, log, mgrp, 67);
 		osm_mgrp_cleanup(subn, mgrp);
 	}
+
+	subn->p_osm->sa.dirty = TRUE;
 }

 void osm_mgrp_delete_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index a5eb796..849b734 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -719,7 +719,12 @@ static void sa_dump_all_sa(osm_opensm_t * p_osm, FILE * file)

 int osm_sa_db_file_dump(osm_opensm_t * p_osm)
 {
-	return opensm_dump_to_file(p_osm, "opensm-sa.dump", sa_dump_all_sa);
+	int res = 0;
+	if (p_osm->sa.dirty) {
+		res = opensm_dump_to_file(p_osm, "opensm-sa.dump", sa_dump_all_sa);
+		p_osm->sa.dirty = FALSE;
+	}
+	return res;
 }

 /*
diff --git a/opensm/opensm/osm_sa_mcmember_record.c b/opensm/opensm/osm_sa_mcmember_record.c
index c3e105f..575cbea 100644
--- a/opensm/opensm/osm_sa_mcmember_record.c
+++ b/opensm/opensm/osm_sa_mcmember_record.c
@@ -832,6 +832,7 @@ static ib_api_status_t mcmr_rcv_create_new_mgrp(IN osm_sa_t * sa,
 		       &(*pp_mgrp)->mcmember_rec.mgid, &(*pp_mgrp)->map_item);
 	sa->p_subn->mgroups[cl_ntoh16(mlid) - IB_LID_MCAST_START_HO] = *pp_mgrp;

+	sa->dirty = TRUE;
 Exit:
 	OSM_LOG_EXIT(sa->p_log);
 	return status;
@@ -958,6 +959,7 @@ static void mcmr_rcv_leave_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	/* remove port and/or update join state */
 	osm_mgrp_remove_port(sa->p_subn, sa->p_log, p_mgrp, p_mcm_port,
 			     &mcmember_rec);
+	sa->dirty = TRUE;
 	CL_PLOCK_RELEASE(sa->p_lock);

 	mcmr_rcv_respond(sa, p_madw, &mcmember_rec);
@@ -1171,6 +1173,7 @@ static void mcmr_rcv_join_mgrp(IN osm_sa_t * sa, IN osm_madw_t * p_madw)
 	if (osm_log_is_active(sa->p_log, OSM_LOG_DEBUG))
 		osm_dump_mc_record(sa->p_log, &mcmember_rec, OSM_LOG_DEBUG);

+	sa->dirty = TRUE;
 	mcmr_rcv_respond(sa, p_madw, &mcmember_rec);

 Exit:
@@ -1203,6 +1206,7 @@ static ib_api_status_t mcmr_rcv_new_mcmr(IN osm_sa_t * sa,
 	   State, Port Guid, and Proxy */
 	p_rec_item->rec = *p_rcvd_rec;
 	cl_qlist_insert_tail(p_list, &p_rec_item->list_item);
+	sa->dirty = TRUE;

 Exit:
 	OSM_LOG_EXIT(sa->p_log);
diff --git a/opensm/opensm/osm_service.c b/opensm/opensm/osm_service.c
index a38171d..39541c9 100644
--- a/opensm/opensm/osm_service.c
+++ b/opensm/opensm/osm_service.c
@@ -46,6 +46,7 @@
 #include <complib/cl_debug.h>
 #include <complib/cl_timer.h>
 #include <opensm/osm_service.h>
+#include <opensm/osm_opensm.h>

 /**********************************************************************
  **********************************************************************/
@@ -134,6 +135,7 @@ void osm_svcr_insert_to_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
 		"Inserting new Service Record into Database\n");

 	cl_qlist_insert_head(&p_subn->sa_sr_list, &p_svcr->list_item);
+	p_subn->p_osm->sa.dirty = TRUE;

 	OSM_LOG_EXIT(p_log);
 }
@@ -149,6 +151,7 @@ void osm_svcr_remove_from_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
 		p_svcr->service_record.service_id);

 	cl_qlist_remove_item(&p_subn->sa_sr_list, &p_svcr->list_item);
+	p_subn->p_osm->sa.dirty = TRUE;

 	OSM_LOG_EXIT(p_log);
 }
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
