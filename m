From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH 1v2] opensm: fixed port order configuration in torus routing
 engine
Date: Wed, 1 Jun 2011 18:40:46 +0300
Message-ID: <20110601154046.GA1098@calypso.voltaire.com>
References: <20110530132345.GB20342@calypso.voltaire.com>
 <4DE50C21.7020305@sandia.gov>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
In-Reply-To: <4DE50C21.7020305-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
Cc: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Commit 1c2a298b295eba7e24205519abc24e47106d15df broke port order
configuration for torus routing engine. order was incorrectly initiated,
causing setting LFTs to fail.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v1:
1. Defined order[] as uint8_t
2. Removed error message while parsing port_order. It gives false alarms, 
   because strtok() returns NULL when no tokens left.

--
 opensm/osm_torus.c |   10 ++++------
 1 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/opensm/osm_torus.c b/opensm/osm_torus.c
index cd3d490..29c1bb4 100644
--- a/opensm/osm_torus.c
+++ b/opensm/osm_torus.c
@@ -868,11 +868,9 @@ bool parse_port_order(struct torus *t, const char *parse_sep)
 	unsigned i, j, k, n;
 
 	for (i = 0; i < ARRAY_SIZE(t->port_order); i++) {
-		if (!parse_port(&(t->port_order[i]), parse_sep)) {
-			OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
-				"Error: cannot parse port_order");
+		if (!parse_port(&(t->port_order[i]), parse_sep))
 			break;
-		}
+
 		for (j = 0; j < i; j++) {
 			if (t->port_order[j] == t->port_order[i]) {
 				OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
@@ -8484,7 +8482,7 @@ bool torus_lft(struct torus *t, struct t_switch *sw)
 	struct port_grp *pgrp;
 	struct t_switch *dsw;
 	osm_switch_t *osm_sw;
-	unsigned order[IB_NODE_NUM_PORTS_MAX+1];
+	uint8_t order[IB_NODE_NUM_PORTS_MAX+1];
 
 	if (!(sw->osm_switch && sw->osm_switch->priv == sw)) {
 		OSM_LOG(&t->osm->log, OSM_LOG_ERROR,
@@ -8506,7 +8504,7 @@ bool torus_lft(struct torus *t, struct t_switch *sw)
 
 		for (p = 0; p < ARRAY_SIZE(order); p++) {
 
-			unsigned px = order[t->port_order[p]];
+			uint8_t px = order[t->port_order[p]];
 
 			if (px == IB_INVALID_PORT_NUM)
 				continue;
-- 
1.7.5.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
