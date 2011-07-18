From: Hal Rosenstock <hal-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] OpenSM: Add infrastructure for "full" SM PortInfo and SA
 PortInfoRecord attributes
Date: Mon, 18 Jul 2011 07:45:28 -0400
Message-ID: <4E241CD8.4000104@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Alex Netes <alexne-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
Cc: "linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org" <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org


to accomodate IBA extended link speeds

Also, some other cosmetic changes (formatting, etc.)

Signed-off-by: Hal Rosenstock <hal-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
diff --git a/include/iba/ib_types.h b/include/iba/ib_types.h
index b713f33..ea08f51 100644
--- a/include/iba/ib_types.h
+++ b/include/iba/ib_types.h
@@ -1,6 +1,6 @@
 /*
  * Copyright (c) 2004-2009 Voltaire, Inc. All rights reserved.
- * Copyright (c) 2002-2009 Mellanox Technologies LTD. All rights reserved.
+ * Copyright (c) 2002-2011 Mellanox Technologies LTD. All rights reserved.
  * Copyright (c) 1996-2003 Intel Corporation. All rights reserved.
  * Copyright (c) 2009 HNR Consulting. All rights reserved.
  *
@@ -2669,7 +2669,7 @@ typedef struct _ib_path_rec {
 /* Port Info Record Component Masks */
 #define IB_PIR_COMPMASK_LID              (CL_HTON64(((uint64_t)1)<<0))
 #define IB_PIR_COMPMASK_PORTNUM          (CL_HTON64(((uint64_t)1)<<1))
-#define IB_PIR_COMPMASK_RESV1            (CL_HTON64(((uint64_t)1)<<2))
+#define IB_PIR_COMPMASK_OPTIONS		 (CL_HTON64(((uint64_t)1)<<2))
 #define IB_PIR_COMPMASK_MKEY             (CL_HTON64(((uint64_t)1)<<3))
 #define IB_PIR_COMPMASK_GIDPRE           (CL_HTON64(((uint64_t)1)<<4))
 #define IB_PIR_COMPMASK_BASELID          (CL_HTON64(((uint64_t)1)<<5))
@@ -3172,6 +3172,14 @@ ib_path_rec_rate(IN const ib_path_rec_t * const p_rec)
 *		8: 60 Gb/sec.
 *		9: 80 Gb/sec.
 *		10: 120 Gb/sec.
+*		11: 14 Gb/sec.
+*		12: 56 Gb/sec.
+*		13: 112 Gb/sec.
+*		14: 168 Gb/sec.
+*		15: 25 Gb/sec.
+*		16: 100 Gb/sec.
+*		17: 200 Gb/sec.
+*		18: 300 Gb/sec.
 *		others: reserved
 *
 * NOTES
@@ -4543,7 +4551,7 @@ typedef struct _ib_port_info {
 	uint8_t link_width_active;
 	uint8_t state_info1;	/* LinkSpeedSupported and PortState */
 	uint8_t state_info2;	/* PortPhysState and LinkDownDefaultState */
-	uint8_t mkey_lmc;
+	uint8_t mkey_lmc;	/* M_KeyProtectBits and LMC */
 	uint8_t link_speed;	/* LinkSpeedEnabled and LinkSpeedActive */
 	uint8_t mtu_smsl;
 	uint8_t vl_cap;		/* VLCap and InitType */
@@ -4557,11 +4565,14 @@ typedef struct _ib_port_info {
 	ib_net16_t p_key_violations;
 	ib_net16_t q_key_violations;
 	uint8_t guid_cap;
-	uint8_t subnet_timeout;	/* cli_rereg(1b), mcast_pkey_trap_suppr(1b), resrv(1b), timeout(5b) */
-	uint8_t resp_time_value;
+	uint8_t subnet_timeout;	/* cli_rereg(1b), mcast_pkey_trap_suppr(1b), reserv(1b), timeout(5b) */
+	uint8_t resp_time_value; /* reserv(3b), rtv(5b) */
 	uint8_t error_threshold; /* local phy errors(4b), overrun errors(4b) */
 	ib_net16_t max_credit_hint;
 	ib_net32_t link_rt_latency; /* reserv(8b), link round trip lat(24b) */
+	uint16_t resvd;
+	uint8_t link_speed_ext;	/* LinkSpeedExtActive and LinkSpeedExtSupported */
+	uint8_t link_speed_ext_enabled; /* reserv(3b), LinkSpeedExtEnabled(5b) */
 } PACK_SUFFIX ib_port_info_t;
 #include <complib/cl_packoff.h>
 /************/
@@ -4601,7 +4612,7 @@ typedef struct _ib_port_info {
 #define IB_PORT_CAP_HAS_SYS_IMG_GUID  (CL_HTON32(0x00000800))
 #define IB_PORT_CAP_HAS_PKEY_SW_EXT_PORT_TRAP (CL_HTON32(0x00001000))
 #define IB_PORT_CAP_RESV13        (CL_HTON32(0x00002000))
-#define IB_PORT_CAP_RESV14        (CL_HTON32(0x00004000))
+#define IB_PORT_CAP_HAS_EXT_SPEEDS  (CL_HTON32(0x00004000))
 #define IB_PORT_CAP_RESV15        (CL_HTON32(0x00008000))
 #define IB_PORT_CAP_HAS_COM_MGT   (CL_HTON32(0x00010000))
 #define IB_PORT_CAP_HAS_SNMP      (CL_HTON32(0x00020000))
@@ -5055,6 +5066,9 @@ ib_port_info_get_link_speed_active(IN const ib_port_info_t * const p_pi)
 #define IB_LINK_SPEED_ACTIVE_2_5		1
 #define IB_LINK_SPEED_ACTIVE_5			2
 #define IB_LINK_SPEED_ACTIVE_10			4
+#define IB_LINK_SPEED_EXT_ACTIVE_NONE		0
+#define IB_LINK_SPEED_EXT_ACTIVE_14		1
+#define IB_LINK_SPEED_EXT_ACTIVE_25		2
 
 /* following v1 ver1.2 p901 */
 #define IB_PATH_RECORD_RATE_2_5_GBS		2
@@ -5066,9 +5080,20 @@ ib_port_info_get_link_speed_active(IN const ib_port_info_t * const p_pi)
 #define IB_PATH_RECORD_RATE_60_GBS		8
 #define IB_PATH_RECORD_RATE_80_GBS		9
 #define IB_PATH_RECORD_RATE_120_GBS		10
+#define IB_PATH_RECORD_RATE_14_GBS		11
+#define IB_PATH_RECORD_RATE_56_GBS		12
+#define IB_PATH_RECORD_RATE_112_GBS		13
+#define IB_PATH_RECORD_RATE_168_GBS		14
+#define IB_PATH_RECORD_RATE_25_GBS		15
+#define IB_PATH_RECORD_RATE_100_GBS		16
+#define IB_PATH_RECORD_RATE_200_GBS		17
+#define IB_PATH_RECORD_RATE_300_GBS		18
 
 #define IB_MIN_RATE    IB_PATH_RECORD_RATE_2_5_GBS
-#define IB_MAX_RATE    IB_PATH_RECORD_RATE_120_GBS
+#define IB_MAX_RATE    IB_PATH_RECORD_RATE_300_GBS
+
+static inline uint8_t OSM_API
+ib_port_info_get_link_speed_ext_active(IN const ib_port_info_t * const p_pi);
 
 /****f* IBA Base: Types/ib_port_info_compute_rate
 * NAME
@@ -5080,10 +5105,67 @@ ib_port_info_get_link_speed_active(IN const ib_port_info_t * const p_pi)
 * SYNOPSIS
 */
 static inline uint8_t OSM_API
-ib_port_info_compute_rate(IN const ib_port_info_t * const p_pi)
+ib_port_info_compute_rate(IN const ib_port_info_t * const p_pi,
+			  IN const int extended)
 {
 	uint8_t rate = 0;
 
+	if (extended) {
+		switch (ib_port_info_get_link_speed_ext_active(p_pi)) {
+		case IB_LINK_SPEED_EXT_ACTIVE_14:
+			switch (p_pi->link_width_active) {
+			case IB_LINK_WIDTH_ACTIVE_1X:
+				rate = IB_PATH_RECORD_RATE_14_GBS;
+				break;
+
+			case IB_LINK_WIDTH_ACTIVE_4X:
+				rate = IB_PATH_RECORD_RATE_56_GBS;
+				break;
+
+			case IB_LINK_WIDTH_ACTIVE_8X:
+				rate = IB_PATH_RECORD_RATE_112_GBS;
+				break;
+
+			case IB_LINK_WIDTH_ACTIVE_12X:
+				rate = IB_PATH_RECORD_RATE_168_GBS;
+				break;
+
+			default:
+				rate = IB_PATH_RECORD_RATE_14_GBS;
+				break;
+			}
+			break;
+		case IB_LINK_SPEED_EXT_ACTIVE_25:
+			switch (p_pi->link_width_active) {
+			case IB_LINK_WIDTH_ACTIVE_1X:
+				rate = IB_PATH_RECORD_RATE_25_GBS;
+				break;
+
+			case IB_LINK_WIDTH_ACTIVE_4X:
+				rate = IB_PATH_RECORD_RATE_100_GBS;
+				break;
+
+			case IB_LINK_WIDTH_ACTIVE_8X:
+				rate = IB_PATH_RECORD_RATE_200_GBS;
+				break;
+
+			case IB_LINK_WIDTH_ACTIVE_12X:
+				rate = IB_PATH_RECORD_RATE_300_GBS;
+				break;
+
+			default:
+				rate = IB_PATH_RECORD_RATE_25_GBS;
+				break;
+			}
+			break;
+		/* IB_LINK_SPEED_EXT_ACTIVE_NONE and any others */
+		default:
+			break;
+		}
+		if (rate)
+			return rate;
+	}
+
 	switch (ib_port_info_get_link_speed_active(p_pi)) {
 	case IB_LINK_SPEED_ACTIVE_2_5:
 		switch (p_pi->link_width_active) {
@@ -5167,6 +5249,9 @@ ib_port_info_compute_rate(IN const ib_port_info_t * const p_pi)
 *	p_pi
 *		[in] Pointer to a PortInfo attribute.
 *
+*	extended
+*		[in] Indicates whether or not to use extended link speeds.
+*
 * RETURN VALUES
 *	Returns the encoded value for the link speed supported.
 *
@@ -5524,6 +5609,151 @@ ib_port_info_get_timeout(IN ib_port_info_t const *p_pi)
 * SEE ALSO
 *********/
 
+/****f* IBA Base: Types/ib_port_info_get_link_speed_ext_active
+* NAME
+*	ib_port_info_get_link_speed_ext_active
+*
+* DESCRIPTION
+*	Gets the encoded LinkSpeedExtActive value in the PortInfo attribute.
+*
+* SYNOPSIS
+*/
+static inline uint8_t OSM_API
+ib_port_info_get_link_speed_ext_active(IN const ib_port_info_t * const p_pi)
+{
+	return ((p_pi->link_speed_ext & 0xF0) >> 4);
+}
+
+/*
+* PARAMETERS
+*	p_pi
+*		[in] Pointer to a PortInfo attribute.
+*
+* RETURN VALUES
+*	The encoded LinkSpeedExtActive value
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
+/****f* IBA Base: Types/ib_port_info_get_link_speed_ext_sup
+* NAME
+*	ib_port_info_get_link_speed_ext_sup
+*
+* DESCRIPTION
+*	Returns the encoded value for the link speed extended supported.
+*
+* SYNOPSIS
+*/
+static inline uint8_t OSM_API
+ib_port_info_get_link_speed_ext_sup(IN const ib_port_info_t * const p_pi)
+{
+	return (p_pi->link_speed_ext & 0x0F);
+}
+
+/*
+* PARAMETERS
+*	p_pi
+*		[in] Pointer to a PortInfo attribute.
+*
+* RETURN VALUES
+*	The encoded LinkSpeedExtSupported value
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
+/****f* IBA Base: Types/ib_port_info_get_link_speed_ext_enabled
+* NAME
+*	ib_port_info_get_link_speed_ext_enabled
+*
+* DESCRIPTION
+*	Gets the encoded LinkSpeedExtEnabled value in the PortInfo attribute.
+*
+* SYNOPSIS
+*/
+static inline uint8_t OSM_API
+ib_port_info_get_link_speed_ext_enabled(IN const ib_port_info_t * const p_pi)
+{
+        return (p_pi->link_speed_ext_enabled & 0x1F);
+}
+
+/*
+* PARAMETERS
+*	p_pi
+*		[in] Pointer to a PortInfo attribute.
+*
+* RETURN VALUES
+*	The encoded LinkSpeedExtEnabled value
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
+/****f* IBA Base: Types/ib_port_info_set_link_speed_ext_enabled
+* NAME
+*	ib_port_info_set_link_speed_ext_enabled
+*
+* DESCRIPTION
+*	Sets the link speed extended enabled value in the PortInfo attribute.
+*
+* SYNOPSIS
+*/
+static inline void OSM_API
+ib_port_info_set_link_speed_ext_enabled(IN ib_port_info_t * const p_pi,
+					IN const uint8_t link_speed_ext_enabled)
+{
+	CL_ASSERT(link_speed_ext_enabled <= 0x1F);
+	p_pi->link_speed_ext_enabled = link_speed_ext_enabled & 0x1F;
+}
+
+/*
+* PARAMETERS
+*	p_pi
+*		[in] Pointer to a PortInfo attribute.
+*
+*	link_speed_ext_enabled
+*		[in] link speed extehded enabled value to set.
+*
+* RETURN VALUES
+*	The encoded LinkSpeedExtEnabled value
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
+/****f* IBA Base: Types/ib_port_info_get_resp_time_value
+* NAME
+*	ib_port_info_get_resp_time_value
+*
+* DESCRIPTION
+*	Gets the encoded resp time value in the PortInfo attribute.
+*
+* SYNOPSIS
+*/
+static inline uint8_t OSM_API
+ib_port_info_get_resp_time_value(IN const ib_port_info_t * const p_pi)
+{
+	return (p_pi->resp_time_value & 0x1F);
+}
+
+/*
+* PARAMETERS
+*	p_pi
+*		[in] Pointer to a PortInfo attribute.
+*
+* RETURN VALUES
+*	The encoded resp time value
+*
+* NOTES
+*
+* SEE ALSO
+*********/
+
 /****f* IBA Base: Types/ib_port_info_get_client_rereg
 * NAME
 *	ib_port_info_get_client_rereg
@@ -6004,8 +6234,9 @@ typedef struct _ib_service_record {
 typedef struct _ib_portinfo_record {
 	ib_net16_t lid;
 	uint8_t port_num;
-	uint8_t resv;
+	uint8_t options;
 	ib_port_info_t port_info;
+	uint8_t pad[4];
 } PACK_SUFFIX ib_portinfo_record_t;
 #include <complib/cl_packoff.h>
 
@@ -6533,10 +6764,10 @@ ib_multipath_rec_mtu_sel(IN const ib_multipath_rec_t * const p_rec)
 
 /****f* IBA Base: Types/ib_multipath_rec_rate
 * NAME
-*       ib_multipath_rec_rate
+*	ib_multipath_rec_rate
 *
 * DESCRIPTION
-*       Get encoded multipath rate.
+*	Get encoded multipath rate.
 *
 * SYNOPSIS
 */
@@ -6548,14 +6779,28 @@ ib_multipath_rec_rate(IN const ib_multipath_rec_t * const p_rec)
 
 /*
 * PARAMETERS
-*       p_rec
-*               [in] Pointer to the multipath record object.
+*	p_rec
+*		[in] Pointer to the multipath record object.
 *
 * RETURN VALUES
-*       Encoded multipath rate.
-*               2: 2.5 Gb/sec.
-*               3: 10 Gb/sec.
-*               4: 30 Gb/sec.
+*	Encoded multipath rate.
+*		2: 2.5 Gb/sec.
+*		3: 10 Gb/sec.
+*		4: 30 Gb/sec.
+*		5: 5 Gb/sec.
+*		6: 20 Gb/sec.
+*		7: 40 Gb/sec.
+*		8: 60 Gb/sec.
+*		9: 80 Gb/sec.
+*		10: 120 Gb/sec.
+*		11: 14 Gb/sec.
+*		12: 56 Gb/sec.
+*		13: 112 Gb/sec.
+*		14: 168 Gb/sec.
+*		15: 25 Gb/sec.
+*		16: 100 Gb/sec.
+*		17: 200 Gb/sec.
+*		18: 300 Gb/sec.
 *               others: reserved
 *
 * NOTES
@@ -7361,7 +7606,7 @@ typedef struct _ib_mad_notice_attr	// Total Size calc  Accumulated
 			uint8_t    pad2;            // reserved
 			uint8_t    local_changes;   // 7b reserved 1b local changes
 			ib_net32_t new_cap_mask;    // new capability mask
-			ib_net16_t change_flgs;     // 13b reserved 3b change flags
+			ib_net16_t change_flgs;     // 10b reserved 6b change flags
 		} PACK_SUFFIX ntc_144;
 		struct _ntc_145 {
 			ib_net16_t pad1;
@@ -7445,6 +7690,8 @@ typedef struct _ib_mad_notice_attr	// Total Size calc  Accumulated
  * Trap 144 masks
  */
 #define TRAP_144_MASK_OTHER_LOCAL_CHANGES      0x01
+#define TRAP_144_MASK_LINK_SPEED_EXT_ENABLE_CHG (CL_HTON16(0x0020))
+#define TRAP_144_MASK_HIERARCHY_INFO_CHANGE    (CL_HTON16(0x0010))
 #define TRAP_144_MASK_SM_PRIORITY_CHANGE       (CL_HTON16(0x0008))
 #define TRAP_144_MASK_LINK_SPEED_ENABLE_CHANGE (CL_HTON16(0x0004))
 #define TRAP_144_MASK_LINK_WIDTH_ENABLE_CHANGE (CL_HTON16(0x0002))
diff --git a/include/opensm/osm_base.h b/include/opensm/osm_base.h
index c1a52b5..9a20890 100644
--- a/include/opensm/osm_base.h
+++ b/include/opensm/osm_base.h
@@ -831,6 +831,18 @@ typedef enum _osm_thread_state {
 #define OSM_CAP2_IS_HIERARCHY_SUPPORTED (1 << 4)
 /***********/
 
+/****d* OpenSM: Base/OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED
+* Name
+*	OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED
+*
+* DESCRIPTION
+*	Full PortInfoRecords supported
+*
+* SYNOPSIS
+*/
+#define OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED (1 << 6)
+/***********/
+
 /****d* OpenSM: Base/osm_signal_t
 * NAME
 *	osm_signal_t
diff --git a/opensm/osm_helper.c b/opensm/osm_helper.c
index 0b0580a..ec1099c 100644
--- a/opensm/osm_helper.c
+++ b/opensm/osm_helper.c
@@ -654,9 +654,9 @@ static void dbg_get_capabilities_str(IN char *p_buf, IN uint32_t buf_size,
 				&total_len) != IB_SUCCESS)
 			return;
 	}
-	if (p_pi->capability_mask & IB_PORT_CAP_RESV14) {
+	if (p_pi->capability_mask & IB_PORT_CAP_HAS_EXT_SPEEDS) {
 		if (dbg_do_line(&p_local, buf_size, p_prefix_str,
-				"IB_PORT_CAP_RESV14\n",
+				"IB_PORT_CAP_HAS_EXT_SPEEDS\n",
 				&total_len) != IB_SUCCESS)
 			return;
 	}
@@ -812,7 +812,10 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
 			"\t\t\t\tresp_time_value.........0x%X\n"
 			"\t\t\t\terror_threshold.........0x%X\n"
 			"\t\t\t\tmax_credit_hint.........0x%X\n"
-			"\t\t\t\tlink_round_trip_latency.0x%X\n",
+			"\t\t\t\tlink_round_trip_latency.0x%X\n"
+			"\t\t\t\tlink_speed_ext_active....0x%X\n"
+			"\t\t\t\tlink_speed_ext_supported.0x%X\n"
+			"\t\t\t\tlink_speed_ext_enabled...0x%X\n",
 			port_num, cl_ntoh64(node_guid), cl_ntoh64(port_guid),
 			cl_ntoh64(p_pi->m_key), cl_ntoh64(p_pi->subnet_prefix),
 			cl_ntoh16(p_pi->base_lid),
@@ -837,7 +840,10 @@ void osm_dump_port_info(IN osm_log_t * p_log, IN ib_net64_t node_guid,
 			ib_port_info_get_mcast_pkey_trap_suppress(p_pi),
 			ib_port_info_get_timeout(p_pi), p_pi->resp_time_value,
 			p_pi->error_threshold, cl_ntoh16(p_pi->max_credit_hint),
-			cl_ntoh32(p_pi->link_rt_latency));
+			cl_ntoh32(p_pi->link_rt_latency),
+			ib_port_info_get_link_speed_ext_active(p_pi),
+			ib_port_info_get_link_speed_ext_sup(p_pi),
+			p_pi->link_speed_ext_enabled);
 
 		/*  show the capabilities mask */
 		if (p_pi->capability_mask) {
@@ -861,7 +867,7 @@ void osm_dump_portinfo_record(IN osm_log_t * p_log,
 			"\t\t\t\tRID\n"
 			"\t\t\t\tEndPortLid..............%u\n"
 			"\t\t\t\tPortNum.................%u\n"
-			"\t\t\t\tReserved................0x%X\n"
+			"\t\t\t\tOptions.................0x%X\n"
 			"\t\t\t\tPortInfo dump:\n"
 			"\t\t\t\tm_key...................0x%016" PRIx64 "\n"
 			"\t\t\t\tsubnet_prefix...........0x%016" PRIx64 "\n"
@@ -898,8 +904,11 @@ void osm_dump_portinfo_record(IN osm_log_t * p_log,
 			"\t\t\t\tresp_time_value.........0x%X\n"
 			"\t\t\t\terror_threshold.........0x%X\n"
 			"\t\t\t\tmax_credit_hint.........0x%X\n"
-			"\t\t\t\tlink_round_trip_latency.0x%X\n",
-			cl_ntoh16(p_pir->lid), p_pir->port_num, p_pir->resv,
+			"\t\t\t\tlink_round_trip_latency.0x%X\n"
+			"\t\t\t\tlink_speed_ext_active....0x%X\n"
+			"\t\t\t\tlink_speed_ext_supported.0x%X\n"
+			"\t\t\t\tlink_speed_ext_enabled...0x%X\n",
+			cl_ntoh16(p_pir->lid), p_pir->port_num, p_pir->options,
 			cl_ntoh64(p_pi->m_key), cl_ntoh64(p_pi->subnet_prefix),
 			cl_ntoh16(p_pi->base_lid),
 			cl_ntoh16(p_pi->master_sm_base_lid),
@@ -923,7 +932,10 @@ void osm_dump_portinfo_record(IN osm_log_t * p_log,
 			ib_port_info_get_mcast_pkey_trap_suppress(p_pi),
 			ib_port_info_get_timeout(p_pi), p_pi->resp_time_value,
 			p_pi->error_threshold, cl_ntoh16(p_pi->max_credit_hint),
-			cl_ntoh32(p_pi->link_rt_latency));
+			cl_ntoh32(p_pi->link_rt_latency),
+			ib_port_info_get_link_speed_ext_active(p_pi),
+			ib_port_info_get_link_speed_ext_sup(p_pi),
+			p_pi->link_speed_ext_enabled);
 
 		/*  show the capabilities mask */
 		if (p_pi->capability_mask) {
diff --git a/opensm/osm_port_info_rcv.c b/opensm/osm_port_info_rcv.c
index c05301e..b4f64d5 100644
--- a/opensm/osm_port_info_rcv.c
+++ b/opensm/osm_port_info_rcv.c
@@ -102,7 +102,7 @@ static void pi_rcv_process_endport(IN osm_sm_t * sm, IN osm_physp_t * p_physp,
 			sm->p_subn->min_ca_mtu = mtu;
 		}
 
-		rate = ib_port_info_compute_rate(p_pi);
+		rate = ib_port_info_compute_rate(p_pi, 0);
 		if (rate < sm->p_subn->min_ca_rate) {
 			OSM_LOG(sm->p_log, OSM_LOG_VERBOSE,
 				"Setting endport minimal rate to:%u defined by port:0x%"
diff --git a/opensm/osm_sa_class_port_info.c b/opensm/osm_sa_class_port_info.c
index 02dab82..743258d 100644
--- a/opensm/osm_sa_class_port_info.c
+++ b/opensm/osm_sa_class_port_info.c
@@ -158,9 +158,11 @@ static void cpi_rcv_respond(IN osm_sa_t * sa, IN const osm_madw_t * p_madw)
 #endif
 	if (sa->p_subn->opt.qos)
 		ib_class_set_cap_mask2(p_resp_cpi, OSM_CAP2_IS_QOS_SUPPORTED |
-						   OSM_CAP2_IS_MCAST_TOP_SUPPORTED);
+						   OSM_CAP2_IS_MCAST_TOP_SUPPORTED |
+						   OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED);
 	else
-		ib_class_set_cap_mask2(p_resp_cpi, OSM_CAP2_IS_MCAST_TOP_SUPPORTED);
+		ib_class_set_cap_mask2(p_resp_cpi, OSM_CAP2_IS_MCAST_TOP_SUPPORTED |
+						   OSM_CAP2_IS_FULL_PORTINFO_REC_SUPPORTED);
 
 	if (!sa->p_subn->opt.disable_multicast)
 		p_resp_cpi->cap_mask |= OSM_CAP_IS_UD_MCAST_SUP;
diff --git a/opensm/osm_sa_mcmember_record.c b/opensm/osm_sa_mcmember_record.c
index 0f79e69..61d3e34 100644
--- a/opensm/osm_sa_mcmember_record.c
+++ b/opensm/osm_sa_mcmember_record.c
@@ -341,7 +341,7 @@ static boolean_t validate_port_caps(osm_log_t * p_log,
 		return FALSE;
 	}
 
-	rate_required = ib_port_info_compute_rate(&p_physp->port_info);
+	rate_required = ib_port_info_compute_rate(&p_physp->port_info, 0);
 	rate_mgrp = (uint8_t) (p_mgrp->mcmember_rec.rate & 0x3F);
 	if (rate_required < rate_mgrp) {
 		OSM_LOG(p_log, OSM_LOG_VERBOSE,
@@ -699,7 +699,7 @@ static boolean_t mgrp_request_is_realizable(IN osm_sa_t * sa,
 	p_mcm_rec->mtu = (mtu_sel << 6) | mtu;
 
 	port_rate =
-	    p_physp ? ib_port_info_compute_rate(&p_physp->port_info) : 0;
+	    p_physp ? ib_port_info_compute_rate(&p_physp->port_info, 0) : 0;
 	if (!(comp_mask & IB_MCR_COMPMASK_RATE)
 	    || !(comp_mask & IB_MCR_COMPMASK_RATE_SEL)
 	    || (rate_sel = (p_mcm_rec->rate >> 6)) == 3)
diff --git a/opensm/osm_sa_multipath_record.c b/opensm/osm_sa_multipath_record.c
index 208dc31..c45ca06 100644
--- a/opensm/osm_sa_multipath_record.c
+++ b/opensm/osm_sa_multipath_record.c
@@ -189,7 +189,7 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 	p_pi = &p_physp->port_info;
 
 	mtu = ib_port_info_get_mtu_cap(p_pi);
-	rate = ib_port_info_compute_rate(p_pi);
+	rate = ib_port_info_compute_rate(p_pi, 0);
 
 	/*
 	   Mellanox Tavor device performance is better using 1K MTU.
@@ -361,8 +361,8 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		if (mtu > ib_port_info_get_mtu_cap(p_pi))
 			mtu = ib_port_info_get_mtu_cap(p_pi);
 
-		if (rate > ib_port_info_compute_rate(p_pi))
-			rate = ib_port_info_compute_rate(p_pi);
+		if (rate > ib_port_info_compute_rate(p_pi, 0))
+			rate = ib_port_info_compute_rate(p_pi, 0);
 
 		/*
 		   Continue with the egress port on this switch.
@@ -384,8 +384,8 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 		if (mtu > ib_port_info_get_mtu_cap(p_pi))
 			mtu = ib_port_info_get_mtu_cap(p_pi);
 
-		if (rate > ib_port_info_compute_rate(p_pi))
-			rate = ib_port_info_compute_rate(p_pi);
+		if (rate > ib_port_info_compute_rate(p_pi, 0))
+			rate = ib_port_info_compute_rate(p_pi, 0);
 
 		if (sa->p_subn->opt.qos) {
 			/*
@@ -417,8 +417,8 @@ static ib_api_status_t mpr_rcv_get_path_parms(IN osm_sa_t * sa,
 	if (mtu > ib_port_info_get_mtu_cap(p_pi))
 		mtu = ib_port_info_get_mtu_cap(p_pi);
 
-	if (rate > ib_port_info_compute_rate(p_pi))
-		rate = ib_port_info_compute_rate(p_pi);
+	if (rate > ib_port_info_compute_rate(p_pi, 0))
+		rate = ib_port_info_compute_rate(p_pi, 0);
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"Path min MTU = %u, min rate = %u\n", mtu, rate);
diff --git a/opensm/osm_sa_path_record.c b/opensm/osm_sa_path_record.c
index 04ddf96..20818ee 100644
--- a/opensm/osm_sa_path_record.c
+++ b/opensm/osm_sa_path_record.c
@@ -195,7 +195,7 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	p_re = p_osm->routing_engine_used;
 
 	mtu = ib_port_info_get_mtu_cap(p_pi);
-	rate = ib_port_info_compute_rate(p_pi);
+	rate = ib_port_info_compute_rate(p_pi, 0);
 
 	/*
 	   Mellanox Tavor device performance is better using 1K MTU.
@@ -349,8 +349,8 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		if (mtu > ib_port_info_get_mtu_cap(p_pi))
 			mtu = ib_port_info_get_mtu_cap(p_pi);
 
-		if (rate > ib_port_info_compute_rate(p_pi))
-			rate = ib_port_info_compute_rate(p_pi);
+		if (rate > ib_port_info_compute_rate(p_pi, 0))
+			rate = ib_port_info_compute_rate(p_pi, 0);
 
 		/*
 		   Continue with the egress port on this switch.
@@ -372,8 +372,8 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 		if (mtu > ib_port_info_get_mtu_cap(p_pi))
 			mtu = ib_port_info_get_mtu_cap(p_pi);
 
-		if (rate > ib_port_info_compute_rate(p_pi))
-			rate = ib_port_info_compute_rate(p_pi);
+		if (rate > ib_port_info_compute_rate(p_pi, 0))
+			rate = ib_port_info_compute_rate(p_pi, 0);
 
 		if (sa->p_subn->opt.qos) {
 			/*
@@ -425,8 +425,8 @@ static ib_api_status_t pr_rcv_get_path_parms(IN osm_sa_t * sa,
 	if (mtu > ib_port_info_get_mtu_cap(p_pi))
 		mtu = ib_port_info_get_mtu_cap(p_pi);
 
-	if (rate > ib_port_info_compute_rate(p_pi))
-		rate = ib_port_info_compute_rate(p_pi);
+	if (rate > ib_port_info_compute_rate(p_pi, 0))
+		rate = ib_port_info_compute_rate(p_pi, 0);
 
 	OSM_LOG(sa->p_log, OSM_LOG_DEBUG,
 		"Path min MTU = %u, min rate = %u\n", mtu, rate);
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
