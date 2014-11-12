From: danby-LDSdmyG8hGV8YrgS2mwiifqBs+8SCbDb@public.gmane.org
Subject: [PATCHv3] libibmad: Add new fields for SM:PortInfoExtended and for PM:PortExtendedSpeedsCounters
Date: Wed, 12 Nov 2014 15:10:32 +0200
Message-ID: <1415797832-29112-1-git-send-email-danby@mellanox.com>
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: ira.weiny-ral2JQCrhuEAvxtiuMwx3w@public.gmane.org
Cc: danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
List-Id: linux-rdma@vger.kernel.org

This change includes:
1. Adding new AttributeID and fields for MAD SM:PortInfoExtended.
2. Adding new fields to support PM:PortExtendedSpeedsCounters when
RSFEC mode is active.

Signed-off-by: Dan Ben Yosef <danby-VPRAkNaXOzVWk0Htik3J/w@public.gmane.org>
---
Changes since v1:
    Add full subject

Changes since v2:
    Add IB_PESC_RSFEC_PORT_SELECT_F to PortExtendedSpeedCounters enum fields
    Changed printing of PortInfoExtended fields from decimal into hexa
    

 include/infiniband/mad.h |   42 ++++++++++++++++++++++++++++++++++++++++--
 libibmad.ver             |    2 +-
 src/dump.c               |   13 +++++++++++++
 src/fields.c             |   36 +++++++++++++++++++++++++++++++++++-
 src/libibmad.map         |    2 ++
 5 files changed, 91 insertions(+), 4 deletions(-)

diff --git a/include/infiniband/mad.h b/include/infiniband/mad.h
index cefcc54..77858c3 100644
--- a/include/infiniband/mad.h
+++ b/include/infiniband/mad.h
@@ -145,7 +145,7 @@ enum SMI_ATTR_ID {
 	IB_ATTR_LINKSPEEDWIDTHPAIRSTBL = 0x1c,
 	IB_ATTR_VENDORMADSTBL = 0x1d,
 	IB_ATTR_SMINFO = 0x20,
-
+	IB_ATTR_PORT_INFO_EXT = 0x33,
 	IB_ATTR_LAST,
 
 	IB_ATTR_MLNX_EXT_PORT_INFO = 0xff90,
@@ -1253,6 +1253,43 @@ enum MAD_FIELDS {
 	IB_PSR_COUNTER14_F,
 	IB_PSR_LAST_F,
 
+	/*
+	 * PortInfoExtended fields
+	 */
+	IB_PORT_EXT_FIRST_F,
+	IB_PORT_EXT_CAPMASK_F = IB_PORT_EXT_FIRST_F,
+	IB_PORT_EXT_FEC_MODE_ACTIVE_F,
+	IB_PORT_EXT_FDR_FEC_MODE_SUPPORTED_F,
+	IB_PORT_EXT_FDR_FEC_MODE_ENABLED_F,
+	IB_PORT_EXT_EDR_FEC_MODE_SUPPORTED_F,
+	IB_PORT_EXT_EDR_FEC_MODE_ENABLED_F,
+	IB_PORT_EXT_LAST_F,
+
+	/*
+	 * PortExtendedSpeedsCounters RSFEC active fields
+	 */
+	IB_PESC_RSFEC_FIRST_F,
+	IB_PESC_RSFEC_PORT_SELECT_F = IB_PESC_RSFEC_FIRST_F,
+	IB_PESC_RSFEC_COUNTER_SELECT_F,
+	IB_PESC_RSFEC_SYNC_HDR_ERR_CTR_F,
+	IB_PESC_RSFEC_UNK_BLOCK_CTR_F,
+	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE0_F,
+	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE1_F,
+	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE2_F,
+	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE3_F,
+	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE4_F,
+	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE5_F,
+	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE6_F,
+	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE7_F,
+	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE8_F,
+	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE9_F,
+	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE10_F,
+	IB_PESC_RSFEC_FEC_CORR_SYMBOL_CTR_LANE11_F,
+	IB_PESC_PORT_FEC_CORR_BLOCK_CTR_F,
+	IB_PESC_PORT_FEC_UNCORR_BLOCK_CTR_F,
+	IB_PESC_PORT_FEC_CORR_SYMBOL_CTR_F,
+	IB_PESC_RSFEC_LAST_F,
+
 	IB_FIELD_LAST_		/* must be last */
 };
 
@@ -1615,7 +1652,8 @@ MAD_EXPORT ib_mad_dump_fn
     mad_dump_cc_switchportcongestionsettingelement, mad_dump_cc_cacongestionsetting,
     mad_dump_cc_cacongestionentry, mad_dump_cc_congestioncontroltable,
     mad_dump_cc_congestioncontroltableentry, mad_dump_cc_timestamp,
-    mad_dump_classportinfo, mad_dump_portsamples_result;
+    mad_dump_classportinfo, mad_dump_portsamples_result,
+    mad_dump_portinfo_ext, mad_dump_port_ext_speeds_counters_rsfec_active;
 
 MAD_EXPORT void mad_dump_fields(char *buf, int bufsz, void *val, int valsz,
 				int start, int end);
diff --git a/libibmad.ver b/libibmad.ver
index 11698ff..4578eaf 100644
--- a/libibmad.ver
+++ b/libibmad.ver
@@ -6,4 +6,4 @@
 # API_REV - advance on any added API
 # RUNNING_REV - advance any change to the vendor files
 # AGE - number of backward versions the API still supports
-LIBVERSION=9:0:4
+LIBVERSION=10:0:5
diff --git a/src/dump.c b/src/dump.c
index efe4bc4..b7ad381 100644
--- a/src/dump.c
+++ b/src/dump.c
@@ -857,6 +857,13 @@ void mad_dump_portsamples_result(char *buf, int bufsz, void *val, int valsz)
 	_dump_fields(buf, bufsz, val, IB_PSR_TAG_F, IB_PSR_LAST_F);
 }
 
+void mad_dump_port_ext_speeds_counters_rsfec_active(char *buf, int bufsz,
+						    void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_PESC_RSFEC_FIRST_F,
+		     IB_PESC_RSFEC_LAST_F);
+}
+
 void mad_dump_port_ext_speeds_counters(char *buf, int bufsz, void *val, int valsz)
 {
 	_dump_fields(buf, bufsz, val, IB_PESC_PORT_SELECT_F, IB_PESC_LAST_F);
@@ -1115,6 +1122,12 @@ void mad_dump_classportinfo(char *buf, int bufsz, void *val, int valsz)
 	_dump_fields(buf, bufsz, val, IB_CPI_BASEVER_F, IB_CPI_TRAP_QKEY_F + 1);
 }
 
+void mad_dump_portinfo_ext(char *buf, int bufsz, void *val, int valsz)
+{
+	_dump_fields(buf, bufsz, val, IB_PORT_EXT_FIRST_F,
+		     IB_PORT_EXT_LAST_F);
+}
+
 void xdump(FILE * file, char *msg, void *p, int size)
 {
 #define HEX(x)  ((x) < 10 ? '0' + (x) : 'a' + ((x) -10))
diff --git a/src/fields.c b/src/fields.c
index 33a6364..507cff0 100644
--- a/src/fields.c
+++ b/src/fields.c
@@ -949,8 +949,42 @@ static const ib_field_t ib_mad_f[] = {
 	{480, 32, "Counter14", mad_dump_uint},
 	{0, 0},			/* IB_PSR_LAST_F */
 
-	{0, 0}			/* IB_FIELD_LAST_ */
+	/*
+	 * PortInfoExtended fields
+	 */
+	{0, 32, "CapMask", mad_dump_hex},
+	{BITSOFFS(32, 16), "FECModeActive", mad_dump_uint},
+	{BITSOFFS(48, 16), "FDRFECModeSupported", mad_dump_hex},
+	{BITSOFFS(64, 16), "FDRFECModeEnabled", mad_dump_hex},
+	{BITSOFFS(80, 16), "EDRFECModeSupported", mad_dump_hex},
+	{BITSOFFS(96, 16), "EDRFECModeEnabled", mad_dump_hex},
+	{0, 0},			/* IB_PORT_EXT_LAST_F */
 
+	/*
+	 * PortExtendedSpeedsCounters RSFEC Active fields
+	 */
+	{BITSOFFS(8, 8), "PortSelect", mad_dump_uint},
+	{64, 64, "CounterSelect", mad_dump_hex},
+	{BITSOFFS(128, 16), "SyncHeaderErrorCounter", mad_dump_uint},
+	{BITSOFFS(144, 16), "UnknownBlockCounter", mad_dump_uint},
+	{352, 32, "FECCorrectableSymbolCtrLane0", mad_dump_uint},
+	{384, 32, "FECCorrectableSymbolCtrLane1", mad_dump_uint},
+	{416, 32, "FECCorrectableSymbolCtrLane2", mad_dump_uint},
+	{448, 32, "FECCorrectableSymbolCtrLane3", mad_dump_uint},
+	{480, 32, "FECCorrectableSymbolCtrLane4", mad_dump_uint},
+	{512, 32, "FECCorrectableSymbolCtrLane5", mad_dump_uint},
+	{544, 32, "FECCorrectableSymbolCtrLane6", mad_dump_uint},
+	{576, 32, "FECCorrectableSymbolCtrLane7", mad_dump_uint},
+	{608, 32, "FECCorrectableSymbolCtrLane8", mad_dump_uint},
+	{640, 32, "FECCorrectableSymbolCtrLane9", mad_dump_uint},
+	{672, 32, "FECCorrectableSymbolCtrLane10", mad_dump_uint},
+	{704, 32, "FECCorrectableSymbolCtrLane11", mad_dump_uint},
+	{1120, 32, "PortFECCorrectableBlockCtr", mad_dump_uint},
+	{1152, 32, "PortFECUncorrectableBlockCtr", mad_dump_uint},
+	{1184, 32, "PortFECCorrectedSymbolCtr", mad_dump_uint},
+	{0, 0},			/* IB_PESC_RSFEC_LAST_F */
+
+	{0, 0}			/* IB_FIELD_LAST_ */
 };
 
 static void _set_field64(void *buf, int base_offs, const ib_field_t * f,
diff --git a/src/libibmad.map b/src/libibmad.map
index 3f3aeef..3240a7b 100644
--- a/src/libibmad.map
+++ b/src/libibmad.map
@@ -19,6 +19,7 @@ IBMAD_1.3 {
 		mad_dump_linkwidthen;
 		mad_dump_linkwidthsup;
 		mad_dump_mlnx_ext_port_info;
+		mad_dump_portinfo_ext;
 		mad_dump_mtu;
 		mad_dump_node_type;
 		mad_dump_nodedesc;
@@ -145,6 +146,7 @@ IBMAD_1.3 {
 		mad_field_name;
 		bm_call_via;
 		mad_dump_port_ext_speeds_counters;
+		mad_dump_port_ext_speeds_counters_rsfec_active;
 		cc_query_status_via;
 		cc_config_status_via;
 		smp_mkey_get;
-- 
1.7.1

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" in
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
