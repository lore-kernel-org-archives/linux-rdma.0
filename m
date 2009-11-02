From: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
Subject: [PATCH] opensm/include/iba/ib_types.h: adding Congestion Control
 definitions
Date: Mon, 02 Nov 2009 15:48:35 +0200
Message-ID: <4AEEE333.8020904@dev.mellanox.co.il>
Reply-To: kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: Sasha Khapyorsky <sashak-smomgflXvOZWk0Htik3J/w@public.gmane.org>
Cc: Linux RDMA <linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-rdma@vger.kernel.org

Adding Congestion Control (Annex 10) definitions to ib_types.h

Signed-off-by: Yevgeny Kliteynik <kliteyn-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org>
---
 opensm/include/iba/ib_types.h |  776 +++++++++++++++++++++++++++++++++++++++++
 1 files changed, 776 insertions(+), 0 deletions(-)

diff --git a/opensm/include/iba/ib_types.h b/opensm/include/iba/ib_types.h
index 677166b..6bde17a 100644
--- a/opensm/include/iba/ib_types.h
+++ b/opensm/include/iba/ib_types.h
@@ -532,6 +532,17 @@ BEGIN_C_DECLS
 */
 #define IB_MCLASS_BIS 0x12
 /**********/
+/****d* IBA Base: Constants/IB_MCLASS_CC
+* NAME
+*	IB_MCLASS_CC
+*
+* DESCRIPTION
+*	Management Class, Congestion Control (A10.4.1)
+*
+* SOURCE
+*/
+#define IB_MCLASS_CC 0x21
+/**********/
 /****d* IBA Base: Constants/IB_MCLASS_VENDOR_HIGH_RANGE_MIN
 * NAME
 *	IB_MCLASS_VENDOR_HIGH_RANGE_MIN
@@ -1521,6 +1532,102 @@ static inline boolean_t OSM_API ib_class_is_rmpp(IN const uint8_t class_code)
 #define IB_MAD_ATTR_SVC_ASSOCIATION_RECORD	(CL_HTON16(0x003B))
 /**********/

+/****d* IBA Base: Constants/IB_MAD_ATTR_CONG_INFO
+* NAME
+*	IB_MAD_ATTR_CONG_INFO
+*
+* DESCRIPTION
+*	CongestionInfo attribute (A10.4.3)
+*
+* SOURCE
+*/
+#define IB_MAD_ATTR_CONG_INFO				(CL_HTON16(0x0011))
+/**********/
+
+/****d* IBA Base: Constants/IB_MAD_ATTR_CONG_KEY_INFO
+* NAME
+*	IB_MAD_ATTR_CONG_KEY_INFO
+*
+* DESCRIPTION
+*	CongestionKeyInfo attribute (A10.4.3)
+*
+* SOURCE
+*/
+#define IB_MAD_ATTR_CONG_KEY_INFO			(CL_HTON16(0x0012))
+/**********/
+
+/****d* IBA Base: Constants/IB_MAD_ATTR_CONG_LOG
+* NAME
+*	IB_MAD_ATTR_CONG_LOG
+*
+* DESCRIPTION
+*	CongestionLog attribute (A10.4.3)
+*
+* SOURCE
+*/
+#define IB_MAD_ATTR_CONG_LOG				(CL_HTON16(0x0013))
+/**********/
+
+/****d* IBA Base: Constants/IB_MAD_ATTR_SW_CONG_SETTING
+* NAME
+*	IB_MAD_ATTR_SW_CONG_SETTING
+*
+* DESCRIPTION
+*	SwitchCongestionSetting attribute (A10.4.3)
+*
+* SOURCE
+*/
+#define IB_MAD_ATTR_SW_CONG_SETTING			(CL_HTON16(0x0014))
+/**********/
+
+/****d* IBA Base: Constants/IB_MAD_ATTR_SW_PORT_CONG_SETTING
+* NAME
+*	IB_MAD_ATTR_SW_PORT_CONG_SETTING
+*
+* DESCRIPTION
+*	SwitchPortCongestionSetting attribute (A10.4.3)
+*
+* SOURCE
+*/
+#define IB_MAD_ATTR_SW_PORT_CONG_SETTING		(CL_HTON16(0x0015))
+/**********/
+
+/****d* IBA Base: Constants/IB_MAD_ATTR_CA_CONG_SETTING
+* NAME
+*	IB_MAD_ATTR_CA_CONG_SETTING
+*
+* DESCRIPTION
+*	CACongestionSetting attribute (A10.4.3)
+*
+* SOURCE
+*/
+#define IB_MAD_ATTR_CA_CONG_SETTING			(CL_HTON16(0x0016))
+/**********/
+
+/****d* IBA Base: Constants/IB_MAD_ATTR_CC_TBL
+* NAME
+*	IB_MAD_ATTR_CC_TBL
+*
+* DESCRIPTION
+*	CongestionControlTable attribute (A10.4.3)
+*
+* SOURCE
+*/
+#define IB_MAD_ATTR_CC_TBL				(CL_HTON16(0x0017))
+/**********/
+
+/****d* IBA Base: Constants/IB_MAD_ATTR_TIME_STAMP
+* NAME
+*	IB_MAD_ATTR_TIME_STAMP
+*
+* DESCRIPTION
+*	TimeStamp attribute (A10.4.3)
+*
+* SOURCE
+*/
+#define IB_MAD_ATTR_TIME_STAMP				(CL_HTON16(0x0018))
+/**********/
+
 /****d* IBA Base: Constants/IB_NODE_TYPE_CA
 * NAME
 *	IB_NODE_TYPE_CA
@@ -3258,6 +3365,23 @@ ib_path_rec_hop_limit(IN const ib_path_rec_t * const p_rec)
 #define IB_CLASS_CAP_GETSET					0x0002
 /*********/

+/****s* IBA Base: Constants/IB_CLASS_ENH_PORT0_CC_MASK
+* NAME
+*	IB_CLASS_ENH_PORT0_CC_MASK
+*
+* DESCRIPTION
+*	ClassPortInfo CapabilityMask bits.
+*	Switch only: This bit will be set if the EnhacedPort0
+*	supports CA Congestion Control (A10.4.3.1).
+*
+* SEE ALSO
+*	ib_class_port_info_t
+*
+* SOURCE
+*/
+#define IB_CLASS_ENH_PORT0_CC_MASK			0x0100
+/*********/
+
 /****s* IBA Base: Constants/IB_CLASS_RESP_TIME_MASK
 * NAME
 *	IB_CLASS_RESP_TIME_MASK
@@ -7291,6 +7415,19 @@ typedef struct _ib_mad_notice_attr	// Total Size calc  Accumulated
 			ib_net64_t bkey;
 			ib_gid_t gid;
 		} PACK_SUFFIX ntc_bkey_259;
+		struct _ntc_cckey_0	// CC key violation
+		{
+			ib_net16_t slid;     // source LID from offending packet LRH
+			uint8_t method;      // method, from common MAD header
+			uint8_t resv0;
+			ib_net16_t attribute_id; // Attribute ID, from common MAD header
+			ib_net16_t resv1;
+			ib_net32_t attribute_modifier; // Attribute Modif, from common MAD header
+			ib_net32_t qp;       // 8b pad, 24b dest QP from BTH
+			ib_net64_t cc_key;   // CC key of the offending packet
+			ib_gid_t source_gid; // GID from GRH of the offending packet
+			uint8_t padding[14]; // Padding - ignored on read
+		} PACK_SUFFIX ntc_cckey_0;
 	} data_details;
 	ib_gid_t issuer_gid;	// 16          80
 } PACK_SUFFIX ib_mad_notice_attr_t;
@@ -10696,6 +10833,645 @@ typedef struct _ib_ci_op {
 *	on the structure command field or the usage context.
 *****/

+/****s* IBA Base: Types/ib_cc_mad_t
+* NAME
+*	ib_cc_mad_t
+*
+* DESCRIPTION
+*	IBA defined Congestion Control MAD format. (A10.4.1)
+*
+* SYNOPSIS
+*/
+#define IB_CC_LOG_DATA_SIZE 32
+#define IB_CC_MGT_DATA_SIZE 192
+#define IB_CC_MAD_HDR_SIZE (sizeof(ib_sa_mad_t) - IB_CC_LOG_DATA_SIZE \
+						- IB_CC_MGT_DATA_SIZE)
+
+#include <complib/cl_packon.h>
+typedef struct _ib_cc_mad {
+	ib_mad_t header;
+	ib_net64_t cc_key;
+	uint8_t log_data[IB_CC_LOG_DATA_SIZE];
+	uint8_t mgt_data[IB_CC_MGT_DATA_SIZE];
+} PACK_SUFFIX ib_cc_mad_t;
+#include <complib/cl_packoff.h>
+/*
+* FIELDS
+*	header
+*		Common MAD header.
+*
+*	cc_key
+*		CC_Key of the Congestion Control MAD.
+*
+*	log_data
+*		Congestion Control log data of the CC MAD.
+*
+*	mgt_data
+*		Congestion Control management data of the CC MAD.
+*
+* SEE ALSO
+* ib_mad_t
+*********/
+
+/****f* IBA Base: Types/ib_cc_mad_get_cc_key
+* NAME
+*	ib_cc_mad_get_cc_key
+*
+* DESCRIPTION
+*	Gets a CC_Key of the CC MAD.
+*
+* SYNOPSIS
+*/
+static inline ib_net64_t OSM_API
+ib_cc_mad_get_cc_key(IN const ib_cc_mad_t * const p_cc_mad)
+{
+	return p_cc_mad->cc_key;
+}
+/*
+* PARAMETERS
+*	p_cc_mad
+*		[in] Pointer to the CC MAD packet.
+*
+* RETURN VALUES
+*	CC_Key of the provided CC MAD packet.
+*
+* NOTES
+*
+* SEE ALSO
+*	ib_cc_mad_t
+*********/
+
+/****f* IBA Base: Types/ib_cc_mad_get_log_data_ptr
+* NAME
+*	ib_cc_mad_get_mgt_data_ptr
+*
+* DESCRIPTION
+*	Gets a pointer to the CC MAD's log data area.
+*
+* SYNOPSIS
+*/
+static inline void * OSM_API
+ib_cc_mad_get_log_data_ptr(IN const ib_cc_mad_t * const p_cc_mad)
+{
+	return ((void *)p_cc_mad->log_data);
+}
+/*
+* PARAMETERS
+*	p_cc_mad
+*		[in] Pointer to the CC MAD packet.
+*
+* RETURN VALUES
+*	Pointer to CC MAD log data area.
+*
+* NOTES
+*
+* SEE ALSO
+*	ib_cc_mad_t
+*********/
+
+/****f* IBA Base: Types/ib_cc_mad_get_mgt_data_ptr
+* NAME
+*	ib_cc_mad_get_mgt_data_ptr
+*
+* DESCRIPTION
+*	Gets a pointer to the CC MAD's management data area.
+*
+* SYNOPSIS
+*/
+static inline void * OSM_API
+ib_cc_mad_get_mgt_data_ptr(IN const ib_cc_mad_t * const p_cc_mad)
+{
+	return ((void *)p_cc_mad->mgt_data);
+}
+/*
+* PARAMETERS
+*	p_cc_mad
+*		[in] Pointer to the CC MAD packet.
+*
+* RETURN VALUES
+*	Pointer to CC MAD management data area.
+*
+* NOTES
+*
+* SEE ALSO
+*	ib_cc_mad_t
+*********/
+
+/****s* IBA Base: Types/ib_cong_info_t
+* NAME
+*	ib_cong_info_t
+*
+* DESCRIPTION
+*	IBA defined CongestionInfo attribute (A10.4.3.3)
+*
+* SYNOPSIS
+*/
+#include <complib/cl_packon.h>
+typedef struct _ib_cong_info {
+	uint8_t cong_info;
+	uint8_t resv;
+	uint8_t ctrl_table_cap;
+} PACK_SUFFIX ib_cong_info_t;
+#include <complib/cl_packoff.h>
+/*
+* FIELDS
+*	cong_info
+*		Congestion control capabilities of the node.
+*
+*	ctrl_table_cap
+*		Number of 64 entry blocks in the CongestionControlTable.
+*
+* SEE ALSO
+*	ib_cc_mad_t
+*********/
+
+/****s* IBA Base: Types/ib_cong_key_info_t
+* NAME
+*	ib_cong_key_info_t
+*
+* DESCRIPTION
+*	IBA defined CongestionKeyInfo attribute (A10.4.3.4)
+*
+* SYNOPSIS
+*/
+#include <complib/cl_packon.h>
+typedef struct _ib_cong_key_info {
+	ib_net64_t cc_key;
+	ib_net16_t protect_bit;
+	ib_net16_t lease_period;
+	ib_net16_t violations;
+} PACK_SUFFIX ib_cong_key_info_t;
+#include <complib/cl_packoff.h>
+/*
+* FIELDS
+*	cc_key
+*		8-byte CC Key.
+*
+*	protect_bit
+*		Bit 0 is a CC Key Protect Bit, other 15 bits are reserved.
+*
+*	lease_period
+*		How long the CC Key protect bit is to remain non-zero.
+*
+*	violations
+*		Number of received MADs that violated CC Key.
+*
+* SEE ALSO
+*	ib_cc_mad_t
+*********/
+
+/****s* IBA Base: Types/ib_cong_log_event_sw_t
+* NAME
+*	ib_cong_log_event_sw_t
+*
+* DESCRIPTION
+*	IBA defined CongestionLogEvent (SW) entry (A10.4.3.5)
+*
+* SYNOPSIS
+*/
+#include <complib/cl_packon.h>
+typedef struct _ib_cong_log_event_sw {
+	ib_net16_t slid;
+	ib_net16_t dlid;
+	ib_net32_t sl;
+	ib_net32_t time_stamp;
+} PACK_SUFFIX ib_cong_log_event_sw_t;
+#include <complib/cl_packoff.h>
+/*
+* FIELDS
+*	slid
+*		Source LID of congestion event.
+*
+*	dlid
+*		Destination LID of congestion event.
+*
+*	sl
+*		4 bits - SL of congestion event.
+*		rest of the bits are reserved.
+*
+*	time_stamp
+*		Timestamp of congestion event.
+*
+* SEE ALSO
+*	ib_cc_mad_t, ib_cong_log_t
+*********/
+
+/****s* IBA Base: Types/ib_cong_log_event_ca_t
+* NAME
+*	ib_cong_log_event_ca_t
+*
+* DESCRIPTION
+*	IBA defined CongestionLogEvent (CA) entry (A10.4.3.5)
+*
+* SYNOPSIS
+*/
+#include <complib/cl_packon.h>
+typedef struct _ib_cong_log_event_ca {
+	ib_net32_t local_qp_resv0;
+	ib_net32_t remote_qp_sl_service_type;
+	ib_net16_t remote_lid;
+	ib_net16_t resv1;
+	ib_net32_t time_stamp;
+} PACK_SUFFIX ib_cong_log_event_ca_t;
+#include <complib/cl_packoff.h>
+/*
+* FIELDS
+*	resv0_local_qp
+*		bits [31:8] local QP that reached CN threshold.
+*		bits [7:0] reserved.
+*
+*	remote_qp_sl_service_type
+*		bits [31:8] remote QP that is connected to local QP.
+*		bits [7:4] SL of the local QP.
+*		bits [3:0] Service Type of the local QP.
+*
+*	remote_lid
+*		LID of the remote port that is connected to local QP.
+*
+*	time_stamp
+*		Timestamp when threshold reached.
+*
+* SEE ALSO
+*	ib_cc_mad_t, ib_cong_log_t
+*********/
+
+/****s* IBA Base: Types/ib_cong_log_t
+* NAME
+*	ib_cong_log_t
+*
+* DESCRIPTION
+*	IBA defined CongestionLog attribute (A10.4.3.5)
+*
+* SYNOPSIS
+*/
+#include <complib/cl_packon.h>
+typedef struct _ib_cong_log {
+	uint8_t log_type;
+	union _log_details
+	{
+		struct _log_sw {
+			uint8_t cong_flags;
+			ib_net16_t event_counter;
+			ib_net32_t time_stamp;
+			uint8_t port_map[32];
+			ib_cong_log_event_sw_t entry_list[15];
+		} PACK_SUFFIX log_sw;
+
+		struct _log_ca {
+			uint8_t cong_flags;
+			ib_net16_t event_counter;
+			ib_net16_t event_map;
+			ib_net16_t resv;
+			ib_net32_t time_stamp;
+			ib_cong_log_event_ca_t log_event[13];
+		} PACK_SUFFIX log_ca;
+
+	} log_details;
+} PACK_SUFFIX ib_cong_log_t;
+#include <complib/cl_packoff.h>
+/*
+* FIELDS
+*
+*	log_{sw,ca}.log_type
+*		Log type: 0x1 is for Switch, 0x2 is for CA
+*
+*	log_{sw,ca}.cong_flags
+*		Congestion Flags.
+*
+*	log_{sw,ca}.event_counter
+*		Number of events since log last sent.
+*
+*	log_{sw,ca}.time_stamp
+*		Timestamp when log sent.
+*
+*	log_sw.port_map
+*		If a bit set to 1, then the corresponding port
+*		has marked packets with a FECN.
+*		bits 0 and 255 - reserved
+*		bits [254..1] - ports [254..1].
+*
+*	log_sw.entry_list
+*		Array of 13 most recent congestion log events.
+*
+*	log_ca.event_map
+*		array 16 bits, one for each SL.
+*
+*	log_ca.log_event
+*		Array of 13 most recent congestion log events.
+*
+* SEE ALSO
+*	ib_cc_mad_t, ib_cong_log_event_sw_t, ib_cong_log_event_ca_t
+*********/
+
+/****s* IBA Base: Types/ib_sw_cong_setting_t
+* NAME
+*	ib_sw_cong_setting_t
+*
+* DESCRIPTION
+*	IBA defined SwitchCongestionSetting attribute (A10.4.3.6)
+*
+* SYNOPSIS
+*/
+#include <complib/cl_packon.h>
+typedef struct _ib_sw_cong_setting {
+	ib_net32_t control_map;
+	uint8_t victim_mask[32];
+	uint8_t credit_mask[32];
+	uint8_t threshold_resv;
+	uint8_t packet_size;
+	ib_net16_t cs_threshold_resv;
+	ib_net16_t cs_return_delay;
+	ib_net16_t marking_rate;
+} PACK_SUFFIX ib_sw_cong_setting_t;
+#include <complib/cl_packoff.h>
+/*
+* FIELDS
+*
+*	control_map
+*		Indicates which components of this attribute are valid
+*
+*	victim_mask
+*		If the bit set to 1, then the port corresponding to
+*		that bit shall mark packets that encounter congestion
+*		with a FECN, whether they are the source or victim
+*		of congestion. (See A10.2.1.1.1)
+*		  bit 0: port 0 (enhanced port 0 only)
+*		  bits [254..1]: ports [254..1]
+*		  bit 255: reserved
+*
+*	credit_mask
+*		If the bit set to 1, then the port corresponding
+*		to that bit shall apply Credit Starvation.
+*		  bit 0: port 0 (enhanced port 0 only)
+*		  bits [254..1]: ports [254..1]
+*		  bit 255: reserved
+*
+*	threshold
+*		bits [15..12] Indicates how agressive cong. marking should be
+*		bits [11..0] Reserved
+*
+*	packet_size
+*		Any packet less than this size won't be marked with FECN
+*
+*	cs_threshold
+*		bits [7..4] How agressive Credit Starvation should be
+*		bits [3..0] Reserved
+*
+*	cs_return_delay
+*		Value that controls credit return rate.
+*
+*	marking_rate
+*		The value that provides the mean number of packets
+*		between marking eligible packets with FECN.
+*
+* SEE ALSO
+*	ib_cc_mad_t
+*********/
+
+/****s* IBA Base: Types/ib_sw_port_cong_setting_element_t
+* NAME
+*	ib_sw_port_cong_setting_element_t
+*
+* DESCRIPTION
+*	IBA defined SwitchPortCongestionSettingElement (A10.4.3.7)
+*
+* SYNOPSIS
+*/
+#include <complib/cl_packon.h>
+typedef struct _ib_sw_port_cong_setting_element {
+	uint8_t valid_ctrl_type_res_threshold;
+	uint8_t packet_size;
+	ib_net16_t cong_param;
+} PACK_SUFFIX ib_sw_port_cong_setting_element_t;
+#include <complib/cl_packoff.h>
+/*
+* FIELDS
+*
+*	valid_ctrl_type_res_threshold
+*		bit 7: "Valid"
+*			when set to 1, indicates this switch
+*			port congestion setting element is valid.
+*		bit 6: "Control Type"
+*			Indicates which type of attribute is being set:
+*			0b = Congestion Control parameters are being set.
+*			1b = Credit Starvation parameters are being set.
+*		bits [5..4]: reserved
+*		bits [3..0]: "Threshold"
+*			When Control Type is 0, contains the congestion
+*			threshold value (Threshold) for this port.
+*			When Control Type is 1, contains the credit
+*			starvation threshold (CS_Threshold) value for
+*			this port.
+*
+*	packet_size
+*		When Control Type is 0, this field contains the minimum
+*		size of packets that may be marked with a FECN.
+*		When Control Type is 1, this field is reserved.
+*
+*	cong_parm
+*		When Control Type is 0, this field contains the port
+*		marking_rate.
+*		When Control Type is 1, this field is reserved.
+*
+* SEE ALSO
+*	ib_cc_mad_t, ib_sw_port_cong_setting_t
+*********/
+
+/****d* IBA Base: Types/ib_sw_port_cong_setting_block_t
+* NAME
+*	ib_sw_port_cong_setting_block_t
+*
+* DESCRIPTION
+*	Defines the SwitchPortCongestionSetting Block (A10.4.3.7).
+*
+* SOURCE
+*/
+typedef ib_sw_port_cong_setting_element_t ib_sw_port_cong_setting_block_t[32];
+/**********/
+
+/****s* IBA Base: Types/ib_sw_port_cong_setting_t
+* NAME
+*	ib_sw_port_cong_setting_t
+*
+* DESCRIPTION
+*	IBA defined SwitchPortCongestionSetting attribute (A10.4.3.7)
+*
+* SYNOPSIS
+*/
+
+#include <complib/cl_packon.h>
+typedef struct _ib_sw_port_cong_setting {
+	ib_sw_port_cong_setting_block_t block;
+} PACK_SUFFIX ib_sw_port_cong_setting_t;
+#include <complib/cl_packoff.h>
+/*
+* FIELDS
+*
+*	block
+*		SwitchPortCongestionSetting block.
+*
+* SEE ALSO
+*	ib_cc_mad_t, ib_sw_port_cong_setting_element_t
+*********/
+
+/****s* IBA Base: Types/ib_ca_cong_entry_t
+* NAME
+*	ib_ca_cong_entry_t
+*
+* DESCRIPTION
+*	IBA defined CACongestionEntry (A10.4.3.8)
+*
+* SYNOPSIS
+*/
+#include <complib/cl_packon.h>
+typedef struct _ib_ca_cong_entry {
+	ib_net16_t ccti_timer;
+	uint8_t ccti_increase;
+	uint8_t trigger_threshold;
+	uint8_t ccti_min;
+	uint8_t resv0;
+	ib_net16_t resv1;
+} PACK_SUFFIX ib_ca_cong_entry_t;
+#include <complib/cl_packoff.h>
+/*
+* FIELDS
+*
+*	ccti_timer
+*		When the timer expires it will be reset to its specified
+*		value, and 1 will be decremented from the CCTI.
+*
+*	ccti_increase
+*		The number to be added to the table Index (CCTI)
+*		on the receipt of a BECN.
+*
+*	trigger_threshold
+*		When the CCTI is equal to this value, an event
+*		is logged in the CAs cyclic event log.
+*
+*	ccti_min
+*		The minimum value permitted for the CCTI.
+*
+* SEE ALSO
+*	ib_cc_mad_t
+*********/
+
+/****s* IBA Base: Types/ib_ca_cong_setting_t
+* NAME
+*	ib_ca_cong_setting_t
+*
+* DESCRIPTION
+*	IBA defined CACongestionSetting attribute (A10.4.3.8)
+*
+* SYNOPSIS
+*/
+#include <complib/cl_packon.h>
+typedef struct _ib_ca_cong_setting {
+	ib_net16_t port_control;
+	ib_net16_t control_map;
+	ib_ca_cong_entry_t entry_list[16];
+} PACK_SUFFIX ib_ca_cong_setting_t;
+#include <complib/cl_packoff.h>
+/*
+* FIELDS
+*
+*	port_control
+*		Congestion attributes for this port:
+*		  bit0 = 0: QP based CC
+*		  bit0 = 1: SL/Port based CC
+*		All other bits are reserved
+*
+*	control_map
+*		An array of sixteen bits, one for each SL. Each bit indicates
+*		whether or not the corresponding entry is to be modified.
+*
+*	entry_list
+*		List of 16 CACongestionEntries, one per SL.
+*
+* SEE ALSO
+*	ib_cc_mad_t
+*********/
+
+/****s* IBA Base: Types/ib_cc_tbl_entry_t
+* NAME
+*	ib_cc_tbl_entry_t
+*
+* DESCRIPTION
+*	IBA defined CongestionControlTableEntry (A10.4.3.9)
+*
+* SYNOPSIS
+*/
+#include <complib/cl_packon.h>
+typedef struct _ib_cc_tbl_entry {
+	ib_net16_t shift_multiplier;
+} PACK_SUFFIX ib_cc_tbl_entry_t;
+#include <complib/cl_packoff.h>
+/*
+* FIELDS
+*
+*	shift_multiplier
+*		bits [15..14] - CCT Shift
+*		  used when calculating the injection rate delay
+*		bits [13..0] - CCT Multiplier
+*		  used when calculating the injection rate delay
+*
+* SEE ALSO
+*	ib_cc_mad_t
+*********/
+
+/****s* IBA Base: Types/ib_cc_tbl_t
+* NAME
+*	ib_cc_tbl_t
+*
+* DESCRIPTION
+*	IBA defined CongestionControlTable attribute (A10.4.3.9)
+*
+* SYNOPSIS
+*/
+#include <complib/cl_packon.h>
+typedef struct _ib_cc_tbl {
+	ib_net16_t ccti_limit;
+	ib_net16_t resv;
+	ib_cc_tbl_entry_t entry_list[64];
+} PACK_SUFFIX ib_cc_tbl_t;
+#include <complib/cl_packoff.h>
+/*
+* FIELDS
+*
+*	ccti_limit
+*		Maximum valid CCTI for this table.
+*
+*	entry_list
+*		List of up to 64 CongestionControlTableEntries.
+*
+* SEE ALSO
+*	ib_cc_mad_t
+*********/
+
+/****s* IBA Base: Types/ib_time_stamp_t
+* NAME
+*	ib_time_stamp_t
+*
+* DESCRIPTION
+*	IBA defined TimeStamp attribute (A10.4.3.10)
+*
+* SOURCE
+*/
+#include <complib/cl_packon.h>
+typedef struct _ib_time_stamp {
+	ib_net32_t value;
+} PACK_SUFFIX ib_time_stamp_t;
+#include <complib/cl_packoff.h>
+/*
+* FIELDS
+*
+*	value
+*		Free running clock that provides relative time info
+*		for a device. Time is kept in 1.024 usec units.
+*
+* SEE ALSO
+*	ib_cc_mad_t
+*********/
+
 END_C_DECLS
 #endif				/* ndef WIN32 */
 #if defined( __WIN__ )
-- 
1.5.1.4


--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
