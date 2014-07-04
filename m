From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/2 opensm] Eliminate redundant calls to ib_port_info_compute_rate
Date: Fri, 04 Jul 2014 11:24:54 -0400
Message-ID: <53B6C746.6070302@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Cc: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

From: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>

Signed-off-by: Shlomi Nimrodi <shlomin-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 opensm/osm_sa_multipath_record.c |   23 ++++++++++-------------
 opensm/osm_sa_path_record.c      |   23 ++++++++++-------------
 2 files changed, 20 insertions(+), 26 deletions(-)

diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index 1804943..e63a489 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -152,7 +152,7 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 	ib_slvl_table_t *p_slvl_tbl;
 	ib_api_status_t status = IB_SUCCESS;
 	uint8_t mtu;
-	uint8_t rate;
+	uint8_t rate, p0_extended_rate, dest_rate;
 	uint8_t pkt_life;
 	uint8_t required_mtu;
 	uint8_t required_rate;
@@ -355,10 +355,9 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		p_physp0 = osm_node_get_physp_ptr((osm_node_t *)p_node, 0);
 		p_pi0 = &p_physp0->port_info;
 		p0_extended = p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
-		if (ib_path_compare_rates(rate,
-					  ib_port_info_compute_rate(p_pi,
-								    p0_extended)) > 0)
-			rate = ib_port_info_compute_rate(p_pi, p0_extended);
+		p0_extended_rate = ib_port_info_compute_rate(p_pi, p0_extended);
+		if (ib_path_compare_rates(rate, p0_extended_rate) > 0)
+			rate = p0_extended_rate;
 
 		/*
 		   Continue with the egress port on this switch.
@@ -383,10 +382,9 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		p_physp0 = osm_node_get_physp_ptr((osm_node_t *)p_node, 0);
 		p_pi0 = &p_physp0->port_info;
 		p0_extended = p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
-		if (ib_path_compare_rates(rate,
-					  ib_port_info_compute_rate(p_pi,
-								    p0_extended)) > 0)
-			rate = ib_port_info_compute_rate(p_pi, p0_extended);
+		p0_extended_rate = ib_port_info_compute_rate(p_pi, p0_extended);
+		if (ib_path_compare_rates(rate, p0_extended_rate) > 0)
+			rate = p0_extended_rate;
 
 		if (sa->p_subn->opt.qos) {
 			/*
@@ -419,10 +417,9 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		mtu = ib_port_info_get_mtu_cap(p_pi);
 
 	extended = p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
-	if (ib_path_compare_rates(rate,
-				  ib_port_info_compute_rate(p_pi,
-							    extended)) > 0)
-		rate = ib_port_info_compute_rate(p_pi, extended);
+	dest_rate = ib_port_info_compute_rate(p_pi, extended);
+	if (ib_path_compare_rates(rate, dest_rate) > 0)
+		rate = dest_rate;
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"Path min MTU = %u, min rate = %u\n", mtu, rate);
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 42af2b9..499ed8d 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -162,7 +162,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	ib_api_status_t status = IB_SUCCESS;
 	ib_net16_t pkey;
 	uint8_t mtu;
-	uint8_t rate;
+	uint8_t rate, p0_extended_rate, dest_rate;
 	uint8_t pkt_life;
 	uint8_t required_mtu;
 	uint8_t required_rate;
@@ -349,10 +349,9 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		p_physp0 = osm_node_get_physp_ptr((osm_node_t *)p_node, 0);
 		p_pi0 = &p_physp0->port_info;
 		p0_extended = p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
-		if (ib_path_compare_rates(rate,
-					  ib_port_info_compute_rate(p_pi,
-								    p0_extended)) > 0)
-			rate = ib_port_info_compute_rate(p_pi, p0_extended);
+		p0_extended_rate = ib_port_info_compute_rate(p_pi, p0_extended);
+		if (ib_path_compare_rates(rate, p0_extended_rate) > 0)
+			rate = p0_extended_rate;
 
 		/*
 		   Continue with the egress port on this switch.
@@ -377,10 +376,9 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		p_physp0 = osm_node_get_physp_ptr((osm_node_t *)p_node, 0);
 		p_pi0 = &p_physp0->port_info;
 		p0_extended = p_pi0->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
-		if (ib_path_compare_rates(rate,
-					  ib_port_info_compute_rate(p_pi,
-								    p0_extended)) > 0)
-			rate = ib_port_info_compute_rate(p_pi, p0_extended);
+		p0_extended_rate = ib_port_info_compute_rate(p_pi, p0_extended);
+		if (ib_path_compare_rates(rate, p0_extended_rate) > 0)
+			rate = p0_extended_rate;
 
 		if (sa->p_subn->opt.qos) {
 			/*
@@ -433,10 +431,9 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		mtu = ib_port_info_get_mtu_cap(p_pi);
 
 	extended = p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS;
-	if (ib_path_compare_rates(rate,
-				  ib_port_info_compute_rate(p_pi,
-							    extended)) > 0)
-		rate = ib_port_info_compute_rate(p_pi, extended);
+	dest_rate = ib_port_info_compute_rate(p_pi, extended);
+	if (ib_path_compare_rates(rate, dest_rate) > 0)
+		rate = dest_rate;
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"Path min MTU = %u, min rate = %u\n", mtu, rate);
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
