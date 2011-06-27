From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: don't set switch hops to lid 0
Date: Mon, 27 Jun 2011 20:08:03 +0300
Message-ID: <20110627170803.GB17645@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Some faulty switches, may retuen port_info.base_lid=0.
This patch fixes a crash in a multicast engine, caused by lid matrix
with hops values for lid 0.

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_switch.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_switch.c b/opensm/osm_switch.c
index fbb8292..a625b2c 100644
--- a/opensm/osm_switch.c
+++ b/opensm/osm_switch.c
@@ -54,7 +54,7 @@
 cl_status_t osm_switch_set_hops(IN osm_switch_t * p_sw, IN uint16_t lid_ho,
 				IN uint8_t port_num, IN uint8_t num_hops)
 {
-	if (lid_ho > p_sw->max_lid_ho)
+	if (!lid_ho || lid_ho > p_sw->max_lid_ho)
 		return -1;
 	if (!p_sw->hops[lid_ho]) {
 		p_sw->hops[lid_ho] = malloc(p_sw->num_ports);
-- 
1.7.5.4

-- Alex
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
