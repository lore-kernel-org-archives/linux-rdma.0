From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH v2] opensm: minor improvement in loading SA DB
Date: Wed, 03 Feb 2010 11:13:13 +0200
Message-ID: <4B693E29.8030309@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Check whether the loading is needed in the state mgr.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---

Changes since v1:
	stupid copy-paste artifact - failed compilation

 opensm/opensm/osm_sa.c        |    6 ------
 opensm/opensm/osm_state_mgr.c |   11 +++++++----
 2 files changed, 7 insertions(+), 10 deletions(-)

diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index 3473e4c..d950248 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -907,12 +907,6 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 	unsigned rereg_clients = 0;
 	unsigned lineno;

-	if (!p_osm->subn.first_time_master_sweep) {
-		OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
-			"Not first sweep - skip SA DB restore\n");
-		return 0;
-	}
-
 	file_name = p_osm->subn.opt.sa_db_file;
 	if (!file_name) {
 		OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index e43463f..2cddc57 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1261,10 +1261,13 @@ repeat_discovery:

 	osm_qos_setup(sm->p_subn->p_osm);

-	/* try to restore SA DB (this should be before lid_mgr
-	   because we may want to disable clients reregistration
-	   when SA DB is restored) */
-	osm_sa_db_file_load(sm->p_subn->p_osm);
+	/*
+	 * If it's the first master sweep, try to restore SA DB
+	 * (this should be before lid_mgr because we may want to
+	 * disable clients reregistration when SA DB is restored)
+	 */
+	if (sm->p_subn->first_time_master_sweep)
+		osm_sa_db_file_load(sm->p_subn->p_osm);

 	if (wait_for_pending_transactions(&sm->p_subn->p_osm->stats))
 		return;
-- 
1.5.1.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
