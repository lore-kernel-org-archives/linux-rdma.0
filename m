From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_subnet.c: Improve error messages in subn_validate_neighbor
Date: Mon, 03 Dec 2012 10:25:39 -0500
Message-ID: <50BCC473.3060000@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Foraker <foraker1-i2BcT+NCU+M@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_subnet.c |   22 ++++++++++++++++------
 1 files changed, 16 insertions(+), 6 deletions(-)

diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index a3fc0b5..c716839 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -946,7 +946,8 @@ static void subn_validate_neighbor(osm_subn_t *p_subn)
 		valid_entry = TRUE;
 
 		OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_DEBUG,
-			"Validating neighbor for 0x%016" PRIx64 ", port %d\n",
+			"Validating neighbor for guid:0x%016" PRIx64
+			", port %d\n",
 			p_item->guid, p_item->portnum);
 		if (p_item->guid == 0) {
 			OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
@@ -954,31 +955,40 @@ static void subn_validate_neighbor(osm_subn_t *p_subn)
 			valid_entry = FALSE;
 		} else if (p_item->portnum == 0) {
 			OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
-				"ERR 7514: found invalid zero port\n");
+				"ERR 7514: found invalid zero port for "
+				"guid: 0x%016" PRIx64 "\n",
+				p_item->guid);
 			valid_entry = FALSE;
 		} else if (osm_db_neighbor_get(p_subn->p_neighbor,
 					       p_item->guid, p_item->portnum,
 					       &guid, &port)) {
 			OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
 				"ERR 7515: could not find neighbor for "
-				"guid: 0x%016" PRIx64 "\n", p_item->guid);
+				"guid: 0x%016" PRIx64 ", port %d\n",
+				p_item->guid, p_item->portnum);
 			valid_entry = FALSE;
 		} else if (guid == 0) {
 			OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
 				"ERR 7516: found invalid neighbor "
-				"zero guid");
+				"zero guid for guid: 0x%016" PRIx64
+				", port %d\n",
+				p_item->guid, p_item->portnum);
 			valid_entry = FALSE;
 		} else if (port == 0) {
 			OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
 				"ERR 7517: found invalid neighbor "
-				"zero port\n");
+				"zero port for guid: 0x%016" PRIx64
+				", port %d\n",
+				p_item->guid, p_item->portnum);
 			valid_entry = FALSE;
 		} else if (osm_db_neighbor_get(p_subn->p_neighbor,
 					       guid, port, &guid, &port) ||
 			guid != p_item->guid || port != p_item->portnum) {
 			OSM_LOG(&(p_subn->p_osm->log), OSM_LOG_ERROR,
 				"ERR 7518: neighbor does not point "
-				"back at us\n");
+				"back at us (guid: 0x%016" PRIx64
+				", port %d)\n",
+				p_item->guid, p_item->portnum);
 			valid_entry = FALSE;
 		}
 
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
