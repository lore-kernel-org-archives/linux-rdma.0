From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH 2/3] opensm: Add infrastructure support for CapabilityMask2
 field in PortInfo
Date: Wed, 17 Aug 2011 14:40:07 -0400
Message-ID: <4E4C0B07.7030309@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
 include/iba/ib_types.h |    6 +++---
 opensm/osm_helper.c    |    8 ++++++--
 2 files changed, 9 insertions(+), 5 deletions(-)

diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index c6a09e2..5d92a2c 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -2720,7 +2720,7 @@ typedef struct _ib_path_rec {
 #define IB_PIR_COMPMASK_MAXCREDHINT	 (CL_HTON64(((uint64_t)1)<<50))
 #define IB_PIR_COMPMASK_RESV5		 (CL_HTON64(((uint64_t)1)<<51))
 #define IB_PIR_COMPMASK_LINKRTLAT	 (CL_HTON64(((uint64_t)1)<<52))
-#define IB_PIR_COMPMASK_RESV6		 (CL_HTON64(((uint64_t)1)<<53))
+#define IB_PIR_COMPMASK_CAPMASK2	 (CL_HTON64(((uint64_t)1)<<53))
 #define IB_PIR_COMPMASK_LINKSPDEXTACT	 (CL_HTON64(((uint64_t)1)<<54))
 #define IB_PIR_COMPMASK_LINKSPDEXTSUPP	 (CL_HTON64(((uint64_t)1)<<55))
 #define IB_PIR_COMPMASK_RESV7		 (CL_HTON64(((uint64_t)1)<<56))
@@ -4579,7 +4579,7 @@ typedef struct _ib_port_info {
 	uint8_t error_threshold; /* local phy errors(4b), overrun errors(4b) */
 	ib_net16_t max_credit_hint;
 	ib_net32_t link_rt_latency; /* reserv(8b), link round trip lat(24b) */
-	uint16_t resvd;
+	ib_net16_t capability_mask2;
 	uint8_t link_speed_ext;	/* LinkSpeedExtActive and LinkSpeedExtSupported */
 	uint8_t link_speed_ext_enabled; /* reserv(3b), LinkSpeedExtEnabled(5b) */
 } PACK_SUFFIX ib_port_info_t;
@@ -4622,7 +4622,7 @@ typedef struct _ib_port_info {
 #define IB_PORT_CAP_HAS_PKEY_SW_EXT_PORT_TRAP (CL_HTON32(0x00001000))
 #define IB_PORT_CAP_RESV13        (CL_HTON32(0x00002000))
 #define IB_PORT_CAP_HAS_EXT_SPEEDS  (CL_HTON32(0x00004000))
-#define IB_PORT_CAP_RESV15        (CL_HTON32(0x00008000))
+#define IB_PORT_CAP_HAS_CAP_MASK2 (CL_HTON32(0x00008000))
 #define IB_PORT_CAP_HAS_COM_MGT   (CL_HTON32(0x00010000))
 #define IB_PORT_CAP_HAS_SNMP      (CL_HTON32(0x00020000))
 #define IB_PORT_CAP_REINIT        (CL_HTON32(0x00040000))
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index c754ca0..e7f0a65 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -681,9 +681,9 @@ static void dbg_get_capabilities_str(IN char *p_buf, IN uint32_t buf_size,
 				&total_len) != IB_SUCCESS)
 			return;
 	}
-	if (p_pi->capability_mask & IB_PORT_CAP_RESV15) {
+	if (p_pi->capability_mask & IB_PORT_CAP_HAS_CAP_MASK2) {
 		if (dbg_do_line(&p_local, buf_size, p_prefix_str,
-				"IB_PORT_CAP_RESV15\n",
+				"IB_PORT_CAP_HAS_CAP_MASK2\n",
 				&total_len) != IB_SUCCESS)
 			return;
 	}
@@ -834,6 +834,7 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
 			"\t\t\t\terror_threshold..........0x%X\n"
 			"\t\t\t\tmax_credit_hint..........0x%X\n"
 			"\t\t\t\tlink_round_trip_latency..0x%X\n"
+			"\t\t\t\tcapability_mask2.........0x%X\n"
 			"\t\t\t\tlink_speed_ext_active....0x%X\n"
 			"\t\t\t\tlink_speed_ext_supported.0x%X\n"
 			"\t\t\t\tlink_speed_ext_enabled...0x%X\n",
@@ -863,6 +864,7 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
 			ib_port_info_get_resp_time_value(p_pi),
 			p_pi->error_threshold, cl_ntoh16(p_pi->max_credit_hint),
 			cl_ntoh32(p_pi->link_rt_latency),
+			cl_ntoh16(p_pi->capability_mask2),
 			ib_port_info_get_link_speed_ext_active(p_pi),
 			ib_port_info_get_link_speed_ext_sup(p_pi),
 			p_pi->link_speed_ext_enabled);
@@ -927,6 +929,7 @@ void osm_dump_portinfo_record(IN osm_log_t * p_log,
 			"\t\t\t\terror_threshold..........0x%X\n"
 			"\t\t\t\tmax_credit_hint..........0x%X\n"
 			"\t\t\t\tlink_round_trip_latency..0x%X\n"
+			"\t\t\t\tcapability_mask2.........0x%X\n"
 			"\t\t\t\tlink_speed_ext_active....0x%X\n"
 			"\t\t\t\tlink_speed_ext_supported.0x%X\n"
 			"\t\t\t\tlink_speed_ext_enabled...0x%X\n",
@@ -956,6 +959,7 @@ void osm_dump_portinfo_record(IN osm_log_t * p_log,
 			ib_port_info_get_resp_time_value(p_pi),
 			p_pi->error_threshold, cl_ntoh16(p_pi->max_credit_hint),
 			cl_ntoh32(p_pi->link_rt_latency),
+			cl_ntoh16(p_pi->capability_mask2),
 			ib_port_info_get_link_speed_ext_active(p_pi),
 			ib_port_info_get_link_speed_ext_sup(p_pi),
 			p_pi->link_speed_ext_enabled);
-- 
1.5.3

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
