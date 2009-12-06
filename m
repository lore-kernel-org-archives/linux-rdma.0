From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2 v3] opensm SA DB dump/restore: load SA DB only once
Date: Sun, 06 Dec 2009 16:40:40 +0200
Message-ID: <4B1BC268.5030605@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Load SA DB only once, at first master heavy sweep.
If loading succeeded, do whatever 'no_clients_rereg'
option says. If loading failed at some point, turn off
the 'no_clients_rereg' option (turn on re-registartion
requests).

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---

Changes since V2:
  - No 'sa_db_load_once' option
  - Combine 'no_clients_rereg' option meaning with
    loading SA DB result

 opensm/opensm/osm_sa.c |   19 +++++++++++++++++--
 1 files changed, 17 insertions(+), 2 deletions(-)

diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index bf794f0..4cfd18c 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -908,6 +908,12 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 		return 0;
 	}

+	if (!p_osm->subn.first_time_master_sweep) {
+		OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
+			"Not first sweep - skip SA DB restore\n");
+		return 0;
+	}
+
 	file = fopen(file_name, "r");
 	if (!file) {
 		OSM_LOG(&p_osm->log, OSM_LOG_ERROR | OSM_LOG_SYS, "ERR 4C02: "
@@ -916,6 +922,10 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 		return -1;
 	}

+	OSM_LOG(&p_osm->log, OSM_LOG_VERBOSE,
+		"Restoring SA DB from file \'%s\'\n",
+		file_name);
+
 	lineno = 0;

 	while (fgets(line, sizeof(line) - 1, file) != NULL) {
@@ -1092,8 +1102,13 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 		}
 	}

-	if (!rereg_clients)
-		p_osm->subn.opt.no_clients_rereg = TRUE;
+	/*
+	 * If loading succeeded, do whatever 'no_clients_rereg' says.
+	 * If loading failed at some point, turn off the 'no_clients_rereg'
+	 * option (turn on re-registartion requests).
+	 */
+	if (rereg_clients)
+		p_osm->subn.opt.no_clients_rereg = FALSE;

 _error:
 	fclose(file);
-- 
1.5.1.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
