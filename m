From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm SA DB: dump only if modified
Date: Mon, 11 Jan 2010 10:47:47 +0200
Message-ID: <4B4AE5B3.10504@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Currently, if dumping SA DB is enabled, the file is dumped
at every sweep. This patch adds "dirty" flag that denotes
whether the SA DB needs to be dumped or not.

SA DB contains 3 types of data:
 - informinfo records
 - service records
 - mcmember records

So the flag must be set in 6 places:
 - add/remove informinfo record
 - add/remove service records
 - add/remove mcmember records

Another possible place for setting this flag is mcgroup
create/delete (this is sometimes duplicated by the add/remove
mcmember records), but I think that this is not needed:

The mcgroups w/o mcmembers can be created in two ways:

1. By creating well-known mcgroup for a partition.
   In this case when new instance of OSM is launched,
   the same mcgroup should be creted anyway from the
   partition configuration, so no need to force its
   duplication in the SA DB file.

2. By loading mcgroup from SA DB file.
   In this case it's either mcgroup w/o members, which
   is what's handled by (1), or it's mcgroup with members,
   butthe members just weren't loaded yet.

So in both cases, no need to force SA DB dump.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/opensm/osm_sa.h |    5 +++++
 opensm/opensm/osm_inform.c     |    2 ++
 opensm/opensm/osm_multicast.c  |    3 +++
 opensm/opensm/osm_sa.c         |   11 ++++++++++-
 opensm/opensm/osm_service.c    |    3 +++
 5 files changed, 23 insertions(+), 1 deletions(-)

diff --git a/opensm/include/opensm/osm_sa.h b/opensm/include/opensm/osm_sa.h
index c3484f9..9229d1a 100644
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
index acbaf38..8108213 100644
--- a/opensm/opensm/osm_inform.c
+++ b/opensm/opensm/osm_inform.c
@@ -248,6 +248,7 @@ void osm_infr_insert_to_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
 #endif

 	cl_qlist_insert_head(&p_subn->sa_infr_list, &p_infr->list_item);
+	p_subn->p_osm->sa.dirty = TRUE;

 	OSM_LOG(p_log, OSM_LOG_DEBUG, "Dump after insertion (size %d)\n",
 		cl_qlist_count(&p_subn->sa_infr_list));
@@ -271,6 +272,7 @@ void osm_infr_remove_from_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
 			     OSM_LOG_DEBUG);

 	cl_qlist_remove_item(&p_subn->sa_infr_list, &p_infr->list_item);
+	p_subn->p_osm->sa.dirty = TRUE;

 	osm_infr_delete(p_infr);

diff --git a/opensm/opensm/osm_multicast.c b/opensm/opensm/osm_multicast.c
index 89f4b28..843b6ce 100644
--- a/opensm/opensm/osm_multicast.c
+++ b/opensm/opensm/osm_multicast.c
@@ -243,6 +243,7 @@ osm_mcm_port_t *osm_mgrp_add_port(IN osm_subn_t * subn, osm_log_t * log,
 	    ++mgrp->full_members == 1)
 		mgrp_send_notice(subn, log, mgrp, 66);

+	subn->p_osm->sa.dirty = TRUE;
 	return mcm_port;
 }

@@ -297,6 +298,8 @@ void osm_mgrp_remove_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
 		mgrp_send_notice(subn, log, mgrp, 67);
 		osm_mgrp_cleanup(subn, mgrp);
 	}
+
+	subn->p_osm->sa.dirty = TRUE;
 }

 void osm_mgrp_delete_port(osm_subn_t * subn, osm_log_t * log, osm_mgrp_t * mgrp,
diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index 6fbea8d..0d203ad 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -704,7 +704,13 @@ static void sa_dump_all_sa(osm_opensm_t * p_osm, FILE * file)

 int osm_sa_db_file_dump(osm_opensm_t * p_osm)
 {
-	return opensm_dump_to_file(p_osm, "opensm-sa.dump", sa_dump_all_sa);
+	int res = 0;
+	if (p_osm->sa.dirty) {
+		res = opensm_dump_to_file(
+			p_osm, "opensm-sa.dump", sa_dump_all_sa);
+		p_osm->sa.dirty = FALSE;
+	}
+	return res;
 }

 /*
@@ -1110,6 +1116,9 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 	if (rereg_clients)
 		p_osm->subn.opt.no_clients_rereg = FALSE;

+	/* We've just finished loading SA DB file - clear the "dirty" flag */
+	p_osm->sa.dirty = FALSE;
+
 _error:
 	fclose(file);
 	return ret;
diff --git a/opensm/opensm/osm_service.c b/opensm/opensm/osm_service.c
index ceb8aad..91715e6 100644
--- a/opensm/opensm/osm_service.c
+++ b/opensm/opensm/osm_service.c
@@ -46,6 +46,7 @@
 #include <complib/cl_debug.h>
 #include <complib/cl_timer.h>
 #include <opensm/osm_service.h>
+#include <opensm/osm_opensm.h>

 void osm_svcr_delete(IN osm_svcr_t * p_svcr)
 {
@@ -122,6 +123,7 @@ void osm_svcr_insert_to_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
 		"Inserting new Service Record into Database\n");

 	cl_qlist_insert_head(&p_subn->sa_sr_list, &p_svcr->list_item);
+	p_subn->p_osm->sa.dirty = TRUE;

 	OSM_LOG_EXIT(p_log);
 }
@@ -137,6 +139,7 @@ void osm_svcr_remove_from_db(IN osm_subn_t * p_subn, IN osm_log_t * p_log,
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
