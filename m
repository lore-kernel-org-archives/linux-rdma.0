From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2] opensm/osm_dump.c: Dump SL2VL tables if routing engine
 might have modified them
Date: Tue, 18 Oct 2011 09:17:38 -0400
Message-ID: <4E9D7C72.3070904@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>, "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_dump.c |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index 0108365..cc0f20b 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -718,7 +718,9 @@ void osm_dump_all(osm_opensm_t * osm)
 				      &osm->subn.sw_guid_tbl,
 				      dump_mcast_routes, osm);
 		/* SL2VL tables */
-		if (osm->subn.opt.qos)
+		if (osm->subn.opt.qos ||
+		    (osm->routing_engine_used &&
+		     osm->routing_engine_used->update_sl2vl))
 			osm_dump_qmap_to_file(osm, "opensm-sl2vl.dump",
 					      &osm->subn.port_guid_tbl,
 					      dump_sl2vl_tbl, osm);
-- 
1.7.6.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
