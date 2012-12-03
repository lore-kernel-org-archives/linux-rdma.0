From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: opensm/osm_torus.c: Fix crash in torus_update_osm_vlarb
Date: Mon, 03 Dec 2012 16:24:09 -0500
Message-ID: <50BD1879.2080309@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Change since v1:
Fixed NULL pointer check on sw->port[port_num]
Pointed out by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>

 opensm/osm_torus.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index c06f8d4..075f84a 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -8089,7 +8089,7 @@ void torus_update_osm_vlarb(void *context, osm_physp_t *osm_phys_port,
 	 * So, leave VL 0 alone, remap VL 4 to VL 1, zero out the rest,
 	 * and compress out the zero entries to the end.
 	 */
-	if (!sw || !port_num ||
+	if (!sw || !port_num || !sw->port[port_num] ||
 	    sw->port[port_num]->pgrp->port_grp != 2 * TORUS_MAX_DIM)
 		return;
  
-- 
1.7.8.2


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
