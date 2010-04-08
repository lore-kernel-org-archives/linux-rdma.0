From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 3/4] opensm: dump PRs after every heavy sweep and after
	reroute
Date: Thu, 08 Apr 2010 16:30:12 +0300
Message-ID: <4BBDDA64.1060603@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schut <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_dump.c      |    3 +++
 opensm/opensm/osm_state_mgr.c |    2 ++
 2 files changed, 5 insertions(+), 0 deletions(-)

diff --git a/opensm/opensm/osm_dump.c b/opensm/opensm/osm_dump.c
index 86e9c00..cedff24 100644
--- a/opensm/opensm/osm_dump.c
+++ b/opensm/opensm/osm_dump.c
@@ -634,6 +634,9 @@ void osm_dump_all(osm_opensm_t * osm)
 	osm_dump_qmap_to_file(osm, "opensm-subnet.lst",
 			      &osm->subn.node_guid_tbl, dump_topology_node,
 			      osm);
+	if (osm->subn.opt.path_rec_dump)
+		osm_sa_path_records_file_dump(osm);
+
 	if (osm_log_is_active(&osm->log, OSM_LOG_VERBOSE))
 		print_report(osm, stdout);
 }
diff --git a/opensm/opensm/osm_state_mgr.c b/opensm/opensm/osm_state_mgr.c
index e43463f..e32ff18 100644
--- a/opensm/opensm/osm_state_mgr.c
+++ b/opensm/opensm/osm_state_mgr.c
@@ -1149,6 +1149,8 @@ static void do_sweep(osm_sm_t * sm)
 			return;

 		if (!sm->p_subn->subnet_initialization_error) {
+			if (sm->p_subn->opt.path_rec_dump)
+				osm_sa_path_records_file_dump(sm->p_subn->p_osm);
 			OSM_LOG_MSG_BOX(sm->p_log, OSM_LOG_VERBOSE,
 					"REROUTE COMPLETE");
 			return;
-- 
1.5.1.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
