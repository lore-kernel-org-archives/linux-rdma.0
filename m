From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/osm_sa.c: don't ignore failure in osm_mgrp_add_port()
Date: Wed, 28 Oct 2009 11:54:43 +0200
Message-ID: <4AE814E3.4090405@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Hi Sasha,

Small fix in loading SA DB: don't ignore failure
in osm_mgrp_add_port() - require clients re-registration.

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/opensm/osm_sa.c |    7 ++++---
 1 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/opensm/opensm/osm_sa.c b/opensm/opensm/osm_sa.c
index a124a45..7b9340d 100644
--- a/opensm/opensm/osm_sa.c
+++ b/opensm/opensm/osm_sa.c
@@ -1002,9 +1002,10 @@ int osm_sa_db_file_load(osm_opensm_t * p_osm)
 			port = osm_get_port_by_guid(&p_osm->subn, guid);
 			if (port &&
 			    cl_qmap_get(&p_mgrp->mcm_port_tbl, guid) ==
-			    cl_qmap_end(&p_mgrp->mcm_port_tbl))
-				osm_mgrp_add_port(&p_osm->subn, &p_osm->log,
-						  p_mgrp, port, &mcmr, proxy);
+			    cl_qmap_end(&p_mgrp->mcm_port_tbl) &&
+			    !osm_mgrp_add_port(&p_osm->subn, &p_osm->log,
+						p_mgrp, port, &mcmr, proxy))
+				rereg_clients = 1;
 		} else if (!strncmp(p, "Service Record:", 15)) {
 			ib_service_record_t s_rec;
 			uint32_t modified_time, lease_period;
-- 
1.5.1.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
