From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] osm_dump.c: Fix typo in dump_lid_matrix
Date: Wed, 20 Feb 2013 14:02:23 -0500
Message-ID: <51251DBF.4090704@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Ilya Nelkenbaum <ilyan-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_dump.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_dump.c b/opensm/osm_dump.c
index cfdb8ef..b9bd6ed 100644
--- a/opensm/osm_dump.c
+++ b/opensm/osm_dump.c
@@ -320,7 +320,7 @@ static void dump_lid_matrix(cl_map_item_t * item, FILE * file, void *cxt)
 				osm_switch_get_hop_count(p_sw, lid, port));
 		p_port = osm_get_port_by_lid_ho(&p_osm->subn, lid);
 		if (p_port)
-			fprintf(file, " # portguid 0x016%" PRIx64,
+			fprintf(file, " # portguid 0x%016" PRIx64,
 				cl_ntoh64(osm_port_get_guid(p_port)));
 		fprintf(file, "\n");
 	}
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
