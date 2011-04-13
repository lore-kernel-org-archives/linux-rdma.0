From: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Subject: [PATCH] opensm: fixed segfault when enable qos on fabric with no
 switches
Date: Wed, 13 Apr 2011 10:52:00 +0300
Message-ID: <20110413075200.GC1529@calypso.voltaire.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Content-Disposition: inline
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

Signed-off-by: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_qos.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/opensm/osm_qos.c b/opensm/osm_qos.c
index afea7bb..f353275 100644
--- a/opensm/osm_qos.c
+++ b/opensm/osm_qos.c
@@ -292,7 +292,7 @@ static int qos_endport_setup(osm_sm_t * sm, osm_physp_t * p,
 	if (!(p->port_info.capability_mask & IB_PORT_CAP_HAS_SL_MAP))
 		return 0;
 
-	if (re->update_sl2vl) {
+	if (re && re->update_sl2vl) {
 		routing_sl2vl = *port_sl2vl;
 		re->update_sl2vl(re->context, p, 0, 0, &routing_sl2vl);
 		port_sl2vl = &routing_sl2vl;
-- 
1.7.4.4

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
