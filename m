From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 1/2] opensm: Track minimum value in the fabric for data VLs
 supported on switch external ports
Date: Wed, 10 Oct 2012 19:40:09 -0400
Message-ID: <50760759.7080406@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma (linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org)" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>, Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Reviewed-by: Jim Schutt <jaschut-4OHPYypu0djtX7QSmKvirg@public.gmane.org>
---
 include/opensm/osm_subnet.h |    1 +
 opensm/osm_port_info_rcv.c  |   13 +++++++++++++
 opensm/osm_state_mgr.c      |    1 +
 opensm/osm_subnet.c         |    1 +
 4 files changed, 16 insertions(+), 0 deletions(-)

diff --git a/include/opensm/osm_subnet.h b/include/opensm/osm_subnet.h
index 86aba47..566145b 100644
--- a/include/opensm/osm_subnet.h
+++ b/include/opensm/osm_subnet.h
@@ -747,6 +747,7 @@ typedef struct osm_subn {
 	uint8_t min_ca_mtu;
 	uint8_t min_ca_rate;
 	uint8_t min_data_vls;
+	uint8_t min_sw_data_vls;
 	boolean_t ignore_existing_lfts;
 	boolean_t subnet_initialization_error;
 	boolean_t force_heavy_sweep;
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index c3bc66c..d5b6aac 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -193,6 +193,7 @@ static void pi_rcv_process_switch_port(IN osm_sm_t * sm, IN osm_node_t * p_node,
 	osm_madw_context_t context;
 	osm_physp_t *p_remote_physp;
 	osm_node_t *p_remote_node;
+	unsigned data_vls;
 	uint8_t port_num;
 	uint8_t remote_port_num;
 	osm_dr_path_t path;
@@ -321,6 +322,18 @@ static void pi_rcv_process_switch_port(IN osm_sm_t * sm, IN osm_node_t * p_node,
 			/* PortState is not used on BSP0 but just in case it is DOWN */
 			p_physp->port_info = *p_pi;
 		pi_rcv_process_endport(sm, p_physp, p_pi);
+	} else {
+		data_vls = 1U << (ib_port_info_get_op_vls(p_pi) - 1);
+		if (data_vls >= IB_MAX_NUM_VLS)
+			data_vls = IB_MAX_NUM_VLS - 1;
+		if ((uint8_t)data_vls < sm->p_subn->min_sw_data_vls) {
+			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
+				"Setting switch port minimal data VLs to:%u defined by node:0x%"
+				PRIx64 ", port:%u\n", data_vls,
+				cl_ntoh64(osm_node_get_node_guid(p_node)),
+				port_num);
+			sm->p_subn->min_sw_data_vls = data_vls;
+		}
 	}
 
 	OSM_LOG_EXIT(sm->p_log);
diff --git a/opensm/osm_state_mgr.c b/opensm/osm_state_mgr.c
index bc61136..7abbc91 100644
--- a/opensm/osm_state_mgr.c
+++ b/opensm/osm_state_mgr.c
@@ -1209,6 +1209,7 @@ repeat_discovery:
 	sm->p_subn->min_ca_mtu = IB_MAX_MTU;
 	sm->p_subn->min_ca_rate = IB_MAX_RATE;
 	sm->p_subn->min_data_vls = IB_MAX_NUM_VLS - 1;
+	sm->p_subn->min_sw_data_vls = IB_MAX_NUM_VLS - 1;
 
 	/* rescan configuration updates */
 	if (!config_parsed && osm_subn_rescan_conf_files(sm->p_subn) < 0)
diff --git a/opensm/osm_subnet.c b/opensm/osm_subnet.c
index 9f05e8a..44d5b1a 100644
--- a/opensm/osm_subnet.c
+++ b/opensm/osm_subnet.c
@@ -1199,6 +1199,7 @@ ib_api_status_t osm_subn_init(IN osm_subn_t * p_subn, IN osm_opensm_t * p_osm,
 	p_subn->min_ca_mtu = IB_MAX_MTU;
 	p_subn->min_ca_rate = IB_MAX_RATE;
 	p_subn->min_data_vls = IB_MAX_NUM_VLS - 1;
+	p_subn->min_sw_data_vls = IB_MAX_NUM_VLS - 1;
 	p_subn->ignore_existing_lfts = TRUE;
 
 	/* we assume master by default - so we only need to set it true if STANDBY */
-- 
1.7.8.2

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
