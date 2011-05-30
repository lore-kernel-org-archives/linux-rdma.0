From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: opensm: fixed port order configuration in torus routing engine
Date: Mon, 30 May 2011 16:23:45 +0300
Message-ID: <20110530132345.GB20342@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 1c2a298b295eba7e24205519abc24e47106d15df broke port order
configuration for torus routing engine. order was incorrectly initiated,
causing setting LFTs to fail.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_torus.c |    4 ++--
 1 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index cd3d490..75724d2 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -8484,7 +8484,7 @@ bool torus_lft(struct torus *t, struct t_switch *sw)
 	struct port_grp *pgrp;
 	struct t_switch *dsw;
 	osm_switch_t *osm_sw;
-	unsigned order[IB_NODE_NUM_PORTS_MAX+1];
+	unsigned char order[IB_NODE_NUM_PORTS_MAX+1];
 
 	if (!(sw->osm_switch && sw->osm_switch->priv == sw)) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
@@ -8506,7 +8506,7 @@ bool torus_lft(struct torus *t, struct t_switch *sw)
 
 		for (p = 0; p < ARRAY_SIZE(order); p++) {
 
-			unsigned px = order[t->port_order[p]];
+			unsigned char px = order[t->port_order[p]];
 
 			if (px == IB_INVALID_PORT_NUM)
 				continue;
-- 
1.7.5.2

-- 

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
